#include "compiler/lex_table.h"
#include "compiler/rules/symbol.h"
#include "compiler/rules/built_in_symbols.h"

namespace tree_sitter {

using std::function;
using std::string;
using std::to_string;
using std::map;
using std::set;
using rules::Symbol;
using rules::CharacterSet;

AdvanceAction::AdvanceAction() : state_index(-1) {}

AdvanceAction::AdvanceAction(size_t state_index,
                             PrecedenceRange precedence_range,
                             bool in_main_token)
    : state_index(state_index),
      precedence_range(precedence_range),
      in_main_token(in_main_token) {}

bool AdvanceAction::operator==(const AdvanceAction &other) const {
  return (state_index == other.state_index) &&
         (precedence_range == other.precedence_range);
}

AcceptTokenAction::AcceptTokenAction()
    : symbol(rules::NONE()), precedence(0), is_string(false) {}

AcceptTokenAction::AcceptTokenAction(Symbol symbol, int precedence,
                                     bool is_string)
    : symbol(symbol), precedence(precedence), is_string(is_string) {}

bool AcceptTokenAction::is_present() const {
  return symbol != rules::NONE();
}

bool AcceptTokenAction::operator==(const AcceptTokenAction &other) const {
  return (symbol == other.symbol) && (precedence == other.precedence) &&
         (is_string == other.is_string);
}

LexState::LexState() : is_token_start(false) {}

set<CharacterSet> LexState::expected_inputs() const {
  set<CharacterSet> result;
  for (auto &pair : advance_actions)
    result.insert(pair.first);
  return result;
}

bool LexState::operator==(const LexState &other) const {
  return advance_actions == other.advance_actions &&
         accept_action == other.accept_action &&
         is_token_start == other.is_token_start;
}

void LexState::each_referenced_state(function<void(LexStateId *)> fn) {
  for (auto &entry : advance_actions)
    fn(&entry.second.state_index);
}

LexStateId LexTable::add_state() {
  states.push_back(LexState());
  return states.size() - 1;
}

LexState &LexTable::state(LexStateId id) {
  return states[id];
}

bool LexTable::merge_state(size_t i, size_t j) {
  return states[i] == states[j];
}

}  // namespace tree_sitter
