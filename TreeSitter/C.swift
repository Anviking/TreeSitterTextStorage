//
//  C.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-05-04.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

public enum C: UInt16, LanguageSymbolProtocol {
    
public static var languagePointer = ts_language_javascript()!
    
    case sym_translation_unit = 2
    case sym__preproc_statement
    case sym_preproc_include
    case sym_preproc_def
    case sym_preproc_function_def
    case sym_preproc_params
    case sym_preproc_call
    case sym_preproc_ifdef
    case sym_preproc_else
    case sym_function_definition
    case sym_declaration
    case sym__declaration_specifiers
    case sym__declarator
    case sym__abstract_declarator
    case sym_pointer_declarator
    case sym_abstract_pointer_declarator
    case sym_function_declarator
    case sym_abstract_function_declarator
    case sym_array_declarator
    case sym_abstract_array_declarator
    case sym_init_declarator
    case sym_compound_statement
    case sym_storage_class_specifier
    case sym_type_qualifier
    case sym__type_specifier
    case sym_sized_type_specifier
    case sym_enum_specifier
    case sym__enum_specifier_contents
    case sym_struct_specifier
    case sym_union_specifier
    case sym_struct_declaration
    case sym_enumerator
    case sym_parameter_type_list
    case sym_parameter_declaration
    case sym__statement
    case sym_labeled_statement
    case sym_expression_statement
    case sym_if_statement
    case sym_switch_statement
    case sym_case_statement
    case sym_while_statement
    case sym_do_statement
    case sym_for_statement
    case sym_return_statement
    case sym_break_statement
    case sym_continue_statement
    case sym_goto_statement
    case sym__expression
    case sym_conditional_expression
    case sym_assignment_expression
    case sym_pointer_expression
    case sym_logical_expression
    case sym_bitwise_expression
    case sym_equality_expression
    case sym_relational_expression
    case sym_shift_expression
    case sym_math_expression
    case sym_cast_expression
    case sym_sizeof_expression
    case sym_subscript_expression
    case sym_call_expression
    case sym_field_expression
    case sym_compound_literal_expression
    case sym_type_name
    case sym_initializer_list
    case sym__initializer_list_contents
    case sym_designator
    case sym__empty_declaration
    case sym_macro_type_specifier
    case aux_sym_translation_unit_repeat1
    case aux_sym_preproc_params_repeat1
    case aux_sym_preproc_ifdef_repeat1
    case aux_sym_declaration_repeat1
    case aux_sym__declaration_specifiers_repeat1
    case aux_sym_array_declarator_repeat1
    case aux_sym_compound_statement_repeat1
    case aux_sym_sized_type_specifier_repeat1
    case aux_sym_struct_specifier_repeat1
    case aux_sym_struct_declaration_repeat1
    case aux_sym_parameter_type_list_repeat1
    case aux_sym_for_statement_repeat1
    case aux_sym__initializer_list_contents_repeat1
    case anon_sym_POUNDinclude
    case anon_sym_POUNDdefine
    case anon_sym_LF
    case anon_sym_LPAREN
    case anon_sym_DOT_DOT_DOT
    case anon_sym_COMMA
    case anon_sym_RPAREN
    case sym_preproc_arg
    case anon_sym_POUNDifdef
    case anon_sym_POUNDifndef
    case anon_sym_POUNDendif
    case anon_sym_POUNDelse
    case sym_preproc_directive
    case anon_sym_SEMI
    case anon_sym_STAR
    case anon_sym_LBRACK
    case anon_sym_static
    case anon_sym_RBRACK
    case anon_sym_EQ
    case anon_sym_LBRACE
    case anon_sym_RBRACE
    case anon_sym_typedef
    case anon_sym_extern
    case anon_sym_auto
    case anon_sym_register
    case anon_sym_const
    case anon_sym_restrict
    case anon_sym_volatile
    case sym_function_specifier
    case anon_sym_unsigned
    case anon_sym_long
    case anon_sym_short
    case anon_sym_enum
    case anon_sym_struct
    case anon_sym_union
    case anon_sym_COLON
    case anon_sym_if
    case anon_sym_else
    case anon_sym_switch
    case anon_sym_case
    case anon_sym_default
    case anon_sym_while
    case anon_sym_do
    case anon_sym_for
    case anon_sym_return
    case anon_sym_break
    case anon_sym_continue
    case anon_sym_goto
    case anon_sym_QMARK
    case anon_sym_STAR_EQ
    case anon_sym_SLASH_EQ
    case anon_sym_PERCENT_EQ
    case anon_sym_PLUS_EQ
    case anon_sym_DASH_EQ
    case anon_sym_LT_LT_EQ
    case anon_sym_GT_GT_EQ
    case anon_sym_AMP_EQ
    case anon_sym_CARET_EQ
    case anon_sym_PIPE_EQ
    case anon_sym_AMP
    case anon_sym_PIPE_PIPE
    case anon_sym_AMP_AMP
    case anon_sym_BANG
    case anon_sym_PIPE
    case anon_sym_CARET
    case anon_sym_TILDE
    case anon_sym_EQ_EQ
    case anon_sym_BANG_EQ
    case anon_sym_LT
    case anon_sym_GT
    case anon_sym_LT_EQ
    case anon_sym_GT_EQ
    case anon_sym_LT_LT
    case anon_sym_GT_GT
    case anon_sym_PLUS
    case anon_sym_DASH
    case anon_sym_SLASH
    case anon_sym_PERCENT
    case anon_sym_DASH_DASH
    case anon_sym_PLUS_PLUS
    case anon_sym_sizeof
    case anon_sym_DOT
    case anon_sym_DASH_GT
    case sym_number_literal
    case sym_char_literal
    case sym_string_literal
    case sym_system_lib_string
    case sym_identifier
    case sym_comment
    
    public var tokenType: TokenType? {
        switch self {
        case .sym_string_literal, .sym_system_lib_string:
            return .string
        case .sym_char_literal:
            return .character
        case .anon_sym_POUNDinclude, .sym_preproc_ifdef, .sym_preproc_directive, .sym_preproc_def:
            return .preprocessor
        case .sym_comment:
            return .comment
        case .sym_number_literal:
            return .number
        case .anon_sym_return, .anon_sym_while, .anon_sym_static, .anon_sym_const, .anon_sym_volatile, .sym_function_specifier, .anon_sym_if, .anon_sym_else, .sym_type_qualifier, .anon_sym_enum, .anon_sym_struct, .anon_sym_case, .anon_sym_for, .anon_sym_auto, .anon_sym_default, .anon_sym_typedef, .anon_sym_goto:
            return .keyword
        case .sym_type_name, .anon_sym_sizeof:
            return .otherMethodNames
            
        default:
            return nil // Important to return nil to continue search in nested nodes
        }
    }
    
    public var isOpaque: Bool {
        return true
    }
    
}


