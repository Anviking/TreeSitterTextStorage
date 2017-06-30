const PREC = {
  ASSIGNMENT: -1,
  CONDITIONAL: -2,
  DEFAULT: 0,
  LOGICAL_OR: 1,
  LOGICAL_AND: 2,
  INCLUSIVE_OR: 3,
  EXCLUSIVE_OR: 4,
  BITWISE_AND: 5,
  EQUAL: 6,
  RELATIONAL: 7,
  SIZEOF: 8,
  SHIFT: 9,
  ADD: 10,
  MULTIPLY: 11,
  CALL: 12,
  CAST: 13,
  UNARY: 14,
  FIELD: 15,
  SUBSCRIPT: 16
};

module.exports = grammar({
  name: 'c',

  extras: $ => [
    /\s/,
    $.comment,
  ],

  conflicts: $ => [
    // Thing (
    //   ^
    // This could be:
    //   * a type name in a declaration with a parenthesized variable name:
    //       int (b) = 0;
    //   * a variable name in a function definition with no return type:
    //       main () {}
    //   * a function name in a function call:
    //       puts("hi");
    //   * the name of a macro that defines a type:
    //       Array(int) x;
    [$._declarator, $._expression],
    [$._declarator, $._expression, $._type_specifier],
    [$._declarator, $._expression, $._type_specifier, $.macro_type_specifier],
    [$._expression, $._type_specifier],
    [$._expression, $._type_specifier, $.macro_type_specifier],
    [$._type_specifier, $.macro_type_specifier],

    // unsigned x
    //    ^
    // This could be:
    //   * a modifier for the type that follows:
    //       unsigned int x = 5;
    //   * a type in itself:
    //       unsigned x = 5;
    [$.sized_type_specifier],

    // void foo(int (bar)
    //                ^
    // This could be:
    //   * the type of the first parameter to a callback function:
    //       void foo(int (int), bool);
    //   * a parenthesized name for the first parameter:
    //       void foo(int (some_int), bool);
    [$._declarator, $._type_specifier],
    [$._declarator, $._type_specifier, $.macro_type_specifier],
  ],

  rules: {
    translation_unit: $ => repeat($._top_level_item),

    _top_level_item: $ => choice(
      $._preproc_statement,
      $.function_definition,
      $.declaration,
      $._statement,
      $._empty_declaration,
      $.linkage_specification
    ),

    // Preprocesser

    _preproc_statement: $ => choice(
      $.preproc_if,
      $.preproc_ifdef,
      $.preproc_include,
      $.preproc_def,
      $.preproc_function_def,
      $.preproc_call
    ),

    preproc_include: $ => seq(
      /#[ \t]*include/,
      choice(
        $.string_literal,
        $.system_lib_string
      )
    ),

    preproc_def: $ => seq(
      /#[ \t]*define/,
      $.identifier,
      optional(seq(
        /[ \t]+/,
        $.preproc_arg
      )),
      '\n'
    ),

    preproc_function_def: $ => seq(
      /#[ \t]*define/,
      $.identifier,
      $.preproc_params,
      optional($.preproc_arg),
      '\n'
    ),

    preproc_params: $ => seq(
      '(', commaSep(choice($.identifier, '...')), ')'
    ),

    preproc_call: $ => seq(
      $.preproc_directive,
      $.preproc_arg
    ),

    preproc_arg: $ => token(prec(-1, repeat1(choice(/./, '\\\n')))),

    preproc_if: $ => seq(
      /#[ \t]*if/,
      $.preproc_arg,
      repeat($._top_level_item),
      optional($.preproc_else),
      /#[ \t]*endif/
    ),

    preproc_ifdef: $ => seq(
      choice(
        /#[ \t]*ifdef/,
        /#[ \t]*ifndef/
      ),
      $.identifier,
      repeat($._top_level_item),
      optional($.preproc_else),
      /#[ \t]*endif/
    ),

    preproc_else: $ => seq(
      /#[ \t]*else/,
      repeat($._top_level_item)
    ),

    preproc_directive: $ => /#[ \t]*\a\w*/,

    // Main Grammar

    function_definition: $ => seq(
      optional($._declaration_specifiers),
      $._declarator,
      $.compound_statement
    ),

    declaration: $ => seq(
      $._declaration_specifiers,
      commaSep1(choice(
        $._declarator,
        $.init_declarator
      )),
      ';'
    ),

    _declaration_specifiers: $ => seq(
      repeat(choice(
        $.storage_class_specifier,
        $.type_qualifier,
        $.function_specifier
      )),
      $._type_specifier,
      repeat(choice(
        $.storage_class_specifier,
        $.type_qualifier,
        $.function_specifier
      ))
    ),

    linkage_specification: $ => seq(
      'extern',
      $.string_literal,
      choice(
        $.function_definition,
        $.declaration,
        $.declaration_list
      )
    ),

    declaration_list: $ => seq(
      '{',
      repeat($._top_level_item),
      '}'
    ),

    _declarator: $ => choice(
      $.pointer_declarator,
      $.function_declarator,
      $.array_declarator,
      seq('(', $._declarator, ')'),
      $.identifier
    ),

    _abstract_declarator: $ => choice(
      $.abstract_pointer_declarator,
      $.abstract_function_declarator,
      $.abstract_array_declarator,
      prec(1, seq('(', $._abstract_declarator, ')'))
    ),

    pointer_declarator: $ => prec.right(seq(
      '*', $._declarator
    )),

    abstract_pointer_declarator: $ => prec.right(seq(
      '*',
      optional($._abstract_declarator)
    )),

    function_declarator: $ => prec(1, seq(
      $._declarator,
      '(',
      optional($.parameter_type_list),
      ')'
    )),

    abstract_function_declarator: $ => prec(1, seq(
      optional($._abstract_declarator),
      '(',
      optional($.parameter_type_list),
      ')'
    )),

    array_declarator: $ => prec(1, seq(
      $._declarator,
      '[',
      optional($._declaration_specifiers),
      optional($._expression),
      ']'
    )),

    abstract_array_declarator: $ => prec(1, seq(
      optional($._abstract_declarator),
      '[',
      optional($._declaration_specifiers),
      optional($._expression),
      ']'
    )),

    init_declarator: $ => seq(
      $._declarator,
      '=',
      choice($.initializer_list, $._expression)
    ),

    compound_statement: $ => seq(
      '{',
      repeat($._top_level_item),
      '}'
    ),

    storage_class_specifier: $ => choice(
      'typedef',
      'extern',
      'static' ,
      'auto',
      'register'
    ),

    type_qualifier: $ => choice(
      'const',
      'restrict',
      'volatile'
    ),

    function_specifier: $ => 'inline',

    _type_specifier: $ => choice(
      $.struct_specifier,
      $.union_specifier,
      $.enum_specifier,
      $.macro_type_specifier,
      $.sized_type_specifier,
      $.identifier
    ),

    sized_type_specifier: $ => seq(
      repeat1(choice(
        'unsigned',
        'long',
        'short'
      )),
      optional($.identifier)
    ),

    enum_specifier: $ => seq(
      'enum',
      choice(
        $.identifier,
        seq(
          optional($.identifier),
          '{',
          $._enum_specifier_contents,
          optional(','),
          '}'
        )
      )
    ),

    _enum_specifier_contents: $ => commaSepTrailing(
      $._enum_specifier_contents,
      $.enumerator
    ),

    struct_specifier: $ => seq(
      'struct',
      choice(
        $.identifier,
        seq(
          optional($.identifier),
          $.member_declaration_list
        )
      )
    ),

    union_specifier: $ => seq(
      'union',
      choice(
        $.identifier,
        seq(
          optional($.identifier),
          $.member_declaration_list
        )
      )
    ),

    member_declaration_list: $ => seq(
      '{',
      repeat($.member_declaration),
      '}'
    ),

    member_declaration: $ => seq(
      optional($._declaration_specifiers),
      commaSep($._declarator),
      optional(seq(':', $._expression)),
      ';'
    ),

    enumerator: $ => choice(
      $.identifier,
      seq($.identifier, '=', $._expression)
    ),

    parameter_type_list: $ => commaSep1(choice(
      $.parameter_declaration,
      '...'
    )),

    parameter_declaration: $ => seq(
      $._declaration_specifiers,
      optional(choice($._declarator, $._abstract_declarator))
    ),

    // Statements

    _statement: $ => choice(
      $.labeled_statement,
      $.compound_statement,
      $.expression_statement,
      $.if_statement,
      $.switch_statement,
      $.case_statement,
      $.do_statement,
      $.while_statement,
      $.for_statement,
      $.return_statement,
      $.break_statement,
      $.continue_statement,
      $.goto_statement
    ),

    labeled_statement: $ => seq(
      $.identifier,
      ':',
      $._statement
    ),

    expression_statement: $ => seq(
      optional(choice(
        $._expression,
        $.comma_expression
      )),
      ';'
    ),

    if_statement: $ => prec.right(seq(
      'if',
      '(', $._expression, ')',
      $._statement,
      optional(seq(
        'else',
        $._statement
      ))
    )),

    switch_statement: $ => seq(
      'switch',
      '(', $._expression, ')',
      $._statement
    ),

    case_statement: $ => seq(
      choice(
        seq('case', $._expression),
        'default'
      ),
      ':',
      choice(
        $._statement,
        $.declaration
      )
    ),

    while_statement: $ => seq(
      'while',
      '(', $._expression, ')',
      $._statement
    ),

    do_statement: $ => seq(
      'do',
      $._statement,
      'while',
      '(', $._expression, ')'
    ),

    for_statement: $ => seq(
      'for',
      '(',
      choice(
        $.declaration,
        seq(optional($._expression), ';')
      ),
      optional($._expression), ';',
      commaSep($._expression),
      ')',
      $._statement
    ),

    return_statement: $ => seq(
      'return',
      optional($._expression),
      ';'
    ),

    break_statement: $ => seq(
      'break', ';'
    ),

    continue_statement: $ => seq(
      'continue', ';'
    ),

    goto_statement: $ => seq(
      'goto', $.identifier, ';'
    ),

    // Expressions

    _expression: $ => choice(
      $.conditional_expression,
      $.assignment_expression,
      $.logical_expression,
      $.bitwise_expression,
      $.equality_expression,
      $.relational_expression,
      $.shift_expression,
      $.math_expression,
      $.cast_expression,
      $.pointer_expression,
      $.sizeof_expression,
      $.subscript_expression,
      $.call_expression,
      $.field_expression,
      $.compound_literal_expression,
      $.identifier,
      $.number_literal,
      $.string_literal,
      $.concatenated_string,
      $.char_literal,
      $.parenthesized_expression
    ),

    comma_expression: $ => seq(
      $._expression,
      ',',
      choice($._expression, $.comma_expression)
    ),

    conditional_expression: $ => prec.right(PREC.CONDITIONAL, seq(
      $._expression,
      '?',
      $._expression,
      ':',
      $._expression
    )),

    assignment_expression: $ => prec.right(PREC.ASSIGNMENT, seq(
      $._expression,
      choice(
        '=',
        '*=',
        '/=',
        '%=',
        '+=',
        '-=',
        '<<=',
        '>>=',
        '&=',
        '^=',
        '|='
      ),
      $._expression
    )),

    pointer_expression: $ => choice(
      prec.left(PREC.UNARY, seq('*', $._expression)),
      prec.left(PREC.UNARY, seq('&', $._expression))
    ),

    logical_expression: $ => choice(
      prec.left(PREC.LOGICAL_OR, seq($._expression, '||', $._expression)),
      prec.left(PREC.LOGICAL_AND, seq($._expression, '&&', $._expression)),
      prec.left(PREC.UNARY, seq('!', $._expression))
    ),

    bitwise_expression: $ => choice(
      prec.left(PREC.INCLUSIVE_OR, seq($._expression, '|', $._expression)),
      prec.left(PREC.EXCLUSIVE_OR, seq($._expression, '^', $._expression)),
      prec.left(PREC.BITWISE_AND, seq($._expression, '&', $._expression)),
      prec.left(PREC.UNARY, seq('~', $._expression))
    ),

    equality_expression: $ => prec.left(PREC.EQUAL, seq(
      $._expression, choice('==', '!='), $._expression
    )),

    relational_expression: $ => prec.left(PREC.RELATIONAL, seq(
      $._expression, choice('<', '>', '<=', '>='), $._expression
    )),

    shift_expression: $ => prec.left(PREC.SHIFT, seq(
      $._expression, choice('<<', '>>'), $._expression)
    ),

    math_expression: $ => choice(
      prec.left(PREC.ADD, seq($._expression, '+', $._expression)),
      prec.left(PREC.ADD, seq($._expression, '-', $._expression)),
      prec.left(PREC.MULTIPLY, seq($._expression, '*', $._expression)),
      prec.left(PREC.MULTIPLY, seq($._expression, '/', $._expression)),
      prec.left(PREC.MULTIPLY, seq($._expression, '%', $._expression)),
      prec.right(PREC.UNARY, seq('-', $._expression)),
      prec.right(PREC.UNARY, seq('+', $._expression)),
      prec.right(PREC.UNARY, seq(choice('--', '++'), $._expression)),
      prec.right(PREC.UNARY, seq($._expression, choice('++', '--')))
    ),

    cast_expression: $ => prec(PREC.CAST, seq(
      '(', $.type_name, ')', $._expression
    )),

    sizeof_expression: $ => choice(
      prec(PREC.SIZEOF, seq('sizeof', $._expression)),
      prec(PREC.SIZEOF, seq('sizeof', '(', $.type_name, ')'))
    ),

    subscript_expression: $ => prec(PREC.SUBSCRIPT, seq(
      $._expression, '[', $._expression, ']')
    ),

    call_expression: $ => prec(PREC.CALL, seq($._expression, $.argument_list)),

    argument_list: $ => seq('(', commaSep($._expression), ')'),

    field_expression: $ => seq(
      prec(PREC.FIELD, seq(
        $._expression,
        choice('.', '->')
      )),
      $.identifier
    ),

    compound_literal_expression: $ => seq(
      prec(PREC.CAST, seq('(', $.type_name, ')')),
      $.initializer_list
    ),

    parenthesized_expression: $ => seq(
      '(',
      choice($._expression, $.comma_expression),
      ')'
    ),

    type_name: $ => seq(
      repeat($.type_qualifier),
      $._type_specifier,
      optional($._abstract_declarator)
    ),

    initializer_list: $ => seq(
      '{',
      optional(seq(
        $._initializer_list_contents,
        optional(',')
      )),
      '}'
    ),

    _initializer_list_contents: $ => commaSepTrailing(
      $._initializer_list_contents,
      seq(
        optional(seq(repeat1($.designator), '=')),
        choice($._expression, $.initializer_list)
      )
    ),

    designator: $ => choice(
      seq('[', $._expression, ']'),
      seq('.', $.identifier)
    ),

    initializer: $ => choice(
      $._expression,
      $.initializer_list
    ),

    number_literal: $ => token(seq(
      choice(
        /\d+(\.\d+)?/,
        /\d+u/,
        seq('0x', /[0-9a-fA-f]+/),
        seq('0b', /[01]+/)
      ),
      repeat(choice('u', 'l', 'U', 'L'))
    )),

    char_literal: $ => token(seq(
      '\'',
      choice(
        seq(optional('\\'), /[^']/),
        seq('\\', '\'')
      ),
      '\''
    )),

    concatenated_string: $ => seq(
      $.string_literal,
      repeat1($.string_literal)
    ),

    string_literal: $ => token(seq(
      '"',
      repeat(choice(/[^\\"\n]/, /\\./)),
      '"')
    ),

    system_lib_string: $ => token(seq(
      '<',
      repeat(choice(/[^>]/, '\\>')),
      '>')
    ),

    identifier: $ => (/[\a_][\a\d_]*/),

    _empty_declaration: $ => seq(
      $._declaration_specifiers,
      ';'
    ),

    macro_type_specifier: $ => seq(
      $.identifier,
      '(',
      $.type_name,
      ')'
    ),

    comment: $ => token(choice(
      seq(
        '//',
        /.*/
      ),
      seq(
        '/*',
        repeat(choice(/[^\*]/, /\*[^/]/)),
        '*/'
      )
    ))
  }
});

module.exports.PREC = PREC

function commaSep (rule) {
  return optional(commaSep1(rule))
}

function commaSep1 (rule) {
  return seq(rule, repeat(seq(',', rule)))
}

function commaSepTrailing (recurSymbol, rule) {
  return choice(rule, seq(recurSymbol, ',', rule))
}
