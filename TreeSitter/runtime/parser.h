#ifndef RUNTIME_PARSER_H_
#define RUNTIME_PARSER_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "stack.h"
#include "array.h"
#include "reduce_action.h"

typedef struct {
  TSTree *tree;
  size_t char_index;
} ReusableNode;

typedef struct {
  TSLexer lexer;
  Stack *stack;
  const TSLanguage *language;
  ReduceActionSet reduce_actions;
  TSTree *finished_tree;
  bool is_split;
  bool print_debugging_graphs;
  TSTree scratch_tree;
  TSTree *cached_token;
  size_t cached_token_char_index;
  ReusableNode reusable_node;
} Parser;

bool parser_init(Parser *);
void parser_destroy(Parser *);
TSTree *parser_parse(Parser *, TSInput, TSTree *);

#ifdef __cplusplus
}
#endif

#endif  // RUNTIME_PARSER_H_
