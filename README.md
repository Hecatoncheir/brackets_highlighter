##  brackets_highlighter

Highlight open and close brackets icons.

![Preview!](preview.png)


## Installation

Install the plugin with package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    'Hecatoncheir/brackets_highlighter',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require('brackets_highlighter').setup({
            ['extensions'] = {
                ['*.lua'] = {
                    ['bracketOpenIcon'] = '',
                    ['bracketCloseIcon'] = '',
                    ['bracketsOpenAndCloseIcon'] = '󱋷',
                    ['nodesForBracketsHighlight'] = {
                            'block',
                            'parenthesized_expression',
                            'class_definition',
                            'class_body',
                            'function_definition',
                            'arguments',
                            'formal_parameter_list',
                            'function_body',
                            'arguments',
                            'optional_formal_parameters',
                            'identifier',
                            'type_identifier',
                            'initialized_variable_definition',
                            'local_variable_declaration',
                            'if_statement',
                            'switch_expression',
                            'switch_expression_case',
                            'table_constructor',
                            'string',
                            'string_content',
                            'list_literal',
                            'program',
                            "class",
                            "^func",
                            "method",
                            "^if",
                            "else",
                            "while",
                            "for",
                            "with",
                            "try",
                            "except",
                            "match",
                            "arguments",
                            "argument_list",
                            "object",
                            "dictionary",
                            "element",
                            "table",
                            "tuple",
                            "do_block",
                            "return",
                    },
                },
                ['*.dart'] = {
                    ['bracketOpenIcon'] = '',
                    ['bracketCloseIcon'] = '',
                    ['bracketsOpenAndCloseIcon'] = '󱋷',
                    ['nodesForBracketsHighlight'] = {
                            'block',
                            'parenthesized_expression',
                            'class_definition',
                            'class_body',
                            'function_definition',
                            'arguments',
                            'formal_parameter_list',
                            'function_body',
                            'arguments',
                            'optional_formal_parameters',
                            'identifier',
                            'type_identifier',
                            'initialized_variable_definition',
                            'local_variable_declaration',
                            'if_statement',
                            'switch_expression',
                            'switch_expression_case',
                            'table_constructor',
                            'string',
                            'string_content',
                            'list_literal',
                            'program',
                            "class",
                            "^func",
                            "method",
                            "^if",
                            "else",
                            "while",
                            "for",
                            "with",
                            "try",
                            "except",
                            "match",
                            "arguments",
                            "argument_list",
                            "object",
                            "dictionary",
                            "element",
                            "table",
                            "tuple",
                            "do_block",
                            "return",
                    },
                },
            },
        })
    end
}
```

