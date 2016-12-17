# TreeSitterTextStorage
Hacky implementation of a `NSTextStorage` subclass powered by [tree-sitter](http://github.com/tree-sitter/tree-sitter).

## How it works
- Text storage is backed by a utf-16 representation of the string on which tree-sitter operates on. (Couldn't link the utf8 files)
- `attributes(at:, effectiveRange:)` traverses the node hiearchy directly to determine attributes.
- Results from `attributes(at:, effectiveRange:)` are cached in an array of `TokenType` enums (basically representing color).
- Text edits mutates the utf-16 data as appropiate.
- Cache is purged on each text edit.

Performance is in my experience okay most of the times, but i think there should be ways to improve it a lot.
