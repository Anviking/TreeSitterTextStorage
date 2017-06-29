#!/bin/sh
BASEDIR=$(dirname "$0")
cd $BASEDIR/../Carthage/Checkouts/tree-sitter
mv project.gyp binding.gyp
node-gyp configure -- -f xcode