#include "compiler/build_tables/lex_conflict_manager.h"
#include <utility>
#include "compiler/parse_table.h"
#include "compiler/rules/built_in_symbols.h"

namespace tree_sitter {
namespace build_tables {

bool LexConflictManager::resolve(const AdvanceAction &new_action,
                                 const AcceptTokenAction &old_action) {
  if (!old_action.is_present())
    return true;
  return new_action.precedence_range.max >= old_action.precedence;
}

bool LexConflictManager::resolve(const AcceptTokenAction &new_action,
                                 const AcceptTokenAction &old_action) {
  if (!old_action.is_present())
    return true;

  int old_precedence = old_action.precedence;
  int new_precedence = new_action.precedence;

  bool result;
  if (new_precedence > old_precedence)
    result = true;
  else if (new_precedence < old_precedence)
    result = false;
  else if (new_action.is_string && !old_action.is_string)
    result = true;
  else if (old_action.is_string && !new_action.is_string)
    result = false;
  else if (new_action.symbol.index < old_action.symbol.index)
    result = true;
  else
    result = false;

  if (result)
    fragile_tokens.insert(old_action.symbol);
  else
    fragile_tokens.insert(new_action.symbol);

  return result;
}

}  // namespace build_tables
}  // namespace tree_sitter
