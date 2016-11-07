#!/bin/sh

BASEDIR=$(dirname "$0")
cd $BASEDIR/..

carthage update --no-build

# clearing files
rm -rf languages/*

umbrella_header=./languages/languages.h
echo "#include \"../tree-sitter/include/tree_sitter/parser.h\"" >> $umbrella_header

for language in Carthage/Checkouts/*
do
	name=${language##*-}
	echo "Processing $name"

	new=./languages/$name.c

	# replace import
	new_import="#include \"parser.h\""
    sed "1s/.*/$new_import/" $language/src/parser.c >> $new

    # save swift file
    enum_name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
    enum_decl="public enum $enum_name: UInt16"
    awk '1;/}/{exit}' $new | sed '/^#/ d' | sed -e "s/^enum/$enum_decl/g" -e 's/    /    case /' -e 's/,//' -e 's/ts_builtin_sym_start/2/' >> languages/$name.swift

    # print line to umbrella header
    echo "TSLanguage *ts_language_$name();" >> $umbrella_header
done


