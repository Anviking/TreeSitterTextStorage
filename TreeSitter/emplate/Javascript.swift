//
//  Javascript.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

public enum JavaScript: UInt16, LanguageSymbolProtocol {
    
    public static var languagePointer = ts_language_javascript()!
    
    public var tokenType: TokenType? {
        switch self {
        case .sym_string:
            return .string
        case .sym_comment:
            return .comment
        case .sym_number:
            return .number
        case .anon_sym_return, .anon_sym_while, .anon_sym_static, .anon_sym_const, .anon_sym_if, .anon_sym_else, .sym_class, .anon_sym_function, .anon_sym_var, .sym_arrow_function:
            return .keyword
        case .sym_member_access:
            return .otherMethodNames
        default:
            return nil // Important to return nil to continue search in nested nodes
        }
    }
    
    case sym_program = 2
    case sym__statements
    case sym__statement
    case sym_expression_statement
    case sym_trailing_expression_statement
    case sym_var_declaration
    case sym_statement_block
    case sym_if_statement
    case sym_switch_statement
    case sym_for_statement
    case sym_for_in_statement
    case sym_for_of_statement
    case sym_while_statement
    case sym_do_statement
    case sym_try_statement
    case sym_break_statement
    case sym_trailing_break_statement
    case sym_return_statement
    case sym_trailing_return_statement
    case sym_yield_statement
    case sym_trailing_yield_statement
    case sym_throw_statement
    case sym_trailing_throw_statement
    case sym_case
    case sym_default
    case sym_catch
    case sym_finally
    case sym_var_assignment
    case sym__paren_expression
    case sym__expression
    case sym_object
    case sym_array
    case sym_class
    case sym_function
    case sym_arrow_function
    case sym_generator_function
    case sym_function_call
    case sym_new_expression
    case sym_member_access
    case sym_subscript_access
    case sym_assignment
    case sym_math_assignment
    case sym_ternary
    case sym_bool_op
    case sym_bitwise_op
    case sym_math_op
    case sym_delete_op
    case sym_void_op
    case sym_comma_op
    case sym_rel_op
    case sym_type_op
    case sym_arguments
    case sym_class_body
    case sym_formal_parameters
    case sym_method_definition
    case sym_pair
    case aux_sym_var_declaration_repeat1
    case aux_sym_switch_statement_repeat1
    case aux_sym_for_statement_repeat1
    case aux_sym_object_repeat1
    case aux_sym_array_repeat1
    case aux_sym_class_body_repeat1
    case aux_sym_formal_parameters_repeat1
    case anon_sym_SEMI
    case anon_sym_var
    case anon_sym_let
    case anon_sym_const
    case anon_sym_COMMA
    case anon_sym_LBRACE
    case anon_sym_RBRACE
    case anon_sym_if
    case anon_sym_else
    case anon_sym_switch
    case anon_sym_LPAREN
    case anon_sym_RPAREN
    case anon_sym_for
    case anon_sym_in
    case anon_sym_of
    case anon_sym_while
    case anon_sym_do
    case anon_sym_try
    case anon_sym_break
    case anon_sym_return
    case anon_sym_yield
    case anon_sym_throw
    case anon_sym_case
    case anon_sym_COLON
    case anon_sym_default
    case anon_sym_catch
    case anon_sym_finally
    case anon_sym_EQ
    case anon_sym_LBRACK
    case anon_sym_RBRACK
    case anon_sym_class
    case anon_sym_extends
    case anon_sym_function
    case anon_sym_EQ_GT
    case anon_sym_STAR
    case anon_sym_new
    case anon_sym_DOT
    case anon_sym_PLUS_EQ
    case anon_sym_DASH_EQ
    case anon_sym_STAR_EQ
    case anon_sym_SLASH_EQ
    case anon_sym_QMARK
    case anon_sym_BANG
    case anon_sym_AMP_AMP
    case anon_sym_PIPE_PIPE
    case anon_sym_TILDE
    case anon_sym_GT_GT
    case anon_sym_LT_LT
    case anon_sym_AMP
    case anon_sym_CARET
    case anon_sym_PIPE
    case anon_sym_DASH
    case anon_sym_PLUS
    case anon_sym_PLUS_PLUS
    case anon_sym_DASH_DASH
    case anon_sym_SLASH
    case anon_sym_PERCENT
    case anon_sym_delete
    case anon_sym_void
    case anon_sym_LT
    case anon_sym_LT_EQ
    case anon_sym_EQ_EQ
    case anon_sym_EQ_EQ_EQ
    case anon_sym_BANG_EQ
    case anon_sym_BANG_EQ_EQ
    case anon_sym_GT_EQ
    case anon_sym_GT
    case anon_sym_typeof
    case anon_sym_instanceof
    case sym_comment
    case sym_string
    case sym_template_string
    case sym_regex
    case sym_number
    case sym_identifier
    case sym_this_expression
    case sym_super
    case sym_true
    case sym_false
    case sym_null
    case sym_undefined
    case anon_sym_static
    case sym__line_break
};
