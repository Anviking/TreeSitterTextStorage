#!/bin/sh

BASEDIR=$(dirname "$0")
cd $BASEDIR/..

#carthage update --no-build

# clearing files
rm -rf TreeSitter/Languages/*

umbrella_header=./TreeSitter/Languages/languages.h
echo "#include \"../tree-sitter/include/tree_sitter/parser.h\"" >> $umbrella_header

for language in Carthage/Checkouts/*
do
	name=${language##*-}

    # If the folder is tree-sitter/tree-sitter, don't do anything
    # This is very hacky, and I'm not 100% sure why it works. Fixme, maybe.
    if [ "$name" == "sitter" ]
    then
        echo "Skipping $language"
        continue
    fi

	echo "Processing $name"

	new=./TreeSitter/Languages/$name.c

	# replace import
	new_import="#include \"parser.h\""
    sed "1s/.*/$new_import/" $language/src/parser.c >> $new

    # save swift file
    enum_name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
    enum_decl="public enum $enum_name: UInt16"
    awk '1;/}/{exit}' $new | sed '/^#/ d' | sed -e "s/^enum/$enum_decl/g" -e 's/  [ ]*/    case /' -e 's/,//' -e 's/ts_builtin_sym_start/2/' >> TreeSitter/Languages/$name.swift

    # print line to umbrella header
    echo "TSLanguage *tree_sitter_$name();" >> $umbrella_header
done


