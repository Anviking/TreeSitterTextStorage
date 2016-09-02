#ifndef RUNTIME_NODE_H_
#define RUNTIME_NODE_H_

#include "tparser.h"
#include "tree.h"

TSNode ts_node_make(const TSTree *, size_t character, size_t byte, size_t row);

#endif
