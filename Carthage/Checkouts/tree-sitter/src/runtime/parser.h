#ifndef RUNTIME_PARSER_H_
#define RUNTIME_PARSER_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "runtime/stack.h"
#include "runtime/array.h"
#include "runtime/lexer.h"
#include "runtime/reduce_action.h"

typedef struct {
  Tree *tree;
  uint32_t byte_index;
} ReusableNode;

typedef struct {
  Lexer lexer;
  Stack *stack;
  const TSLanguage *language;
  ReduceActionSet reduce_actions;
  Tree *finished_tree;
  bool is_split;
  bool print_debugging_graphs;
  Tree scratch_tree;
  Tree *cached_token;
  uint32_t cached_token_byte_index;
  ReusableNode reusable_node;
  TreePath tree_path1;
  TreePath tree_path2;
} Parser;

bool parser_init(Parser *);
void parser_destroy(Parser *);
Tree *parser_parse(Parser *, TSInput, Tree *);

#ifdef __cplusplus
}
#endif

#endif  // RUNTIME_PARSER_H_
