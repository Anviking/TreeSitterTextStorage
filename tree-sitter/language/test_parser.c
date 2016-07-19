// test_parser.c

#include <assert.h>
#include <string.h>
#include <stdio.h>
#include "tree_sitter/runtime.h"

// Declare the language function that was generated from your grammar.
TSLanguage *ts_language_arithmetic();

int main() {
  TSDocument *document = ts_document_make();
  ts_document_set_language(document, ts_language_arithmetic());
  ts_document_set_input_string(document, "a + b * 5");
  ts_document_parse(document);

  TSNode root_node = ts_document_root_node(document);
  assert(!strcmp(ts_node_name(root_node, document), "expression"));
  assert(ts_node_named_child_count(root_node) == 1);

  TSNode sum_node = ts_node_named_child(root_node, 0);
  assert(!strcmp(ts_node_name(sum_node, document), "sum"));
  assert(ts_node_named_child_count(sum_node) == 2);

  TSNode product_node = ts_node_child(ts_node_named_child(sum_node, 1), 0);
  assert(!strcmp(ts_node_name(product_node, document), "product"));
  assert(ts_node_named_child_count(product_node) == 2);

  printf("Syntax tree: %s\n", ts_node_string(root_node, document));
  ts_document_free(document);
  return 0;
}
