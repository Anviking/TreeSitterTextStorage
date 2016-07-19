// arithmetic_grammar.cc

#include <stdio.h>
#include "tree_sitter/compiler.h"

int main() {
  TSCompileResult result = ts_compile_grammar(R"JSON(
    {
      "name": "arithmetic",

      // Things that can appear anywhere in the language, like comments
      // and whitespace, are expressed as 'extras'.
      "extras": [
        {"type": "PATTERN", "value": "\\s"},
        {"type": "SYMBOL", "name": "comment"}
      ],

      "rules": {

        // The first rule listed in the grammar becomes the 'start rule'.
        "expression": {
          "type": "CHOICE",
          "members": [
            {"type": "SYMBOL", "name": "sum"},
            {"type": "SYMBOL", "name": "product"},
            {"type": "SYMBOL", "name": "number"},
            {"type": "SYMBOL", "name": "variable"},
            {
              "type": "SEQ",
              "members": [
                {"type": "STRING", "value": "("},

                // Error recovery is controlled by wrapping rule subtrees
                // in an 'ERROR' rule.
                {
                  "type": "ERROR",
                  "content": {"type": "SYMBOL", "name": "expression"}
                },

                {"type": "STRING", "value": ")"}
              ]
            }
          ]
        },

        // Tokens like '+' and '*' are described directly within the
        // grammar's rules, as opposed to in a seperate lexer description.
        "sum": {
          "type": "PREC_LEFT",
          "value": 1,
          "content": {
            "type": "SEQ",
            "members": [
              {"type": "SYMBOL", "name": "expression"},
              {"type": "STRING", "value": "+"},
              {"type": "SYMBOL", "name": "expression"}
            ]
          }
        },

        // Ambiguities can be resolved at compile time by assigning precedence
        // values to rule subtrees.
        "product": {
          "type": "PREC_LEFT",
          "value": 2,
          "content": {
            "type": "SEQ",
            "members": [
              {"type": "SYMBOL", "name": "expression"},
              {"type": "STRING", "value": "*"},
              {"type": "SYMBOL", "name": "expression"}
            ]
          }
        },

        // Tokens can be specified using ECMAScript regexps.
        "number": {"type": "PATTERN", "value": "\\d+"},
        "comment": {"type": "PATTERN", "value": "#.*"},
        "variable": {"type": "PATTERN", "value": "[a-zA-Z]\\w*"},
      }
    }
  )JSON");

  if (result.error_type != TSCompileErrorTypeNone) {
    fprintf(stderr, "Compilation failed: %s\n", result.error_message);
    return 1;
  }

  puts(result.code);

  return 0;
}
