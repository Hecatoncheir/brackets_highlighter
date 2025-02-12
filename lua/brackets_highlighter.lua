local brackets_highlighter = {}

local defaultOptions = {
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
      },
    },
    ['*.dart'] = {
      ['bracketOpenIcon'] = '',
      ['bracketCloseIcon'] = '',
      ['bracketsOpenAndCloseIcon'] = '󱋷',
      ['nodesForBracketsHighlight'] = {
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
}

brackets_highlighter.setup = function(opt)
  local options = vim.tbl_deep_extend('force', defaultOptions, opt or {})

  local api = vim.api
  local group = api.nvim_create_augroup('BracketsHighlighterBuffer', { clear = true })

  local icon_creator = require("brackets_highlighter.icon_creator")

  local extensions = options['extensions']
  for extension, settings in pairs(extensions) do
    api.nvim_create_autocmd({ 'CursorMoved' }, {

      group = group,
      pattern = extension,
      callback = function(data)
        local extension_tag = extension:gsub("[*.]", "")

        local bracketOpenIcon = settings['bracketOpenIcon']
        if bracketOpenIcon ~= 'auto' then
          icon_creator.createBracketOpenIconForExtension(extension_tag, bracketOpenIcon)
        else
          icon_creator.createBracketOpenIconForExtension(extension_tag, '')
        end

        local bracketCloseIcon = settings['bracketCloseIcon']
        if bracketCloseIcon ~= 'auto' then
          icon_creator.createBracketCloseIconForExtension(extension_tag, bracketCloseIcon)
        else
          icon_creator.createBracketCloseIconForExtension(extension_tag, '')
        end

        local bracketsOpenAndCloseIcon = settings['bracketsOpenAndCloseIcon']
        if bracketsOpenAndCloseIcon ~= 'auto' then
          icon_creator.createBracketsOpenAndCloseIconForExtension(extension_tag, bracketsOpenAndCloseIcon)
        else
          icon_creator.createBracketsOpenAndCloseIconForExtension(extension_tag, '')
        end

        local buf = data.buf
        M.onCursorMove(buf, extension_tag, settings)
      end
    })
  end
end

brackets_highlighter.onCursorMove = function(buf, extension, settings)
  local targetNode = ts_utils.get_node_at_cursor()
  if targetNode == nil then return end

  local nodesForBracketsHighlihgt = settings['nodesForBracketsHighlight']
  local node = M.findNodeForBracketsHighlight(targetNode, nodesForBracketsHighlihgt)
  if node == nil then
    local bracketOpenIcon = settings['bracketOpenIcon']
    if bracketOpenIcon == 'auto' then
      local bracketOpenIcon = '{'
      M.createBracketOpenIconForExtension(extension, bracketOpenIcon)
    end

    local bracketCloseIcon = settings['bracketCloseIcon']
    if bracketCloseIcon == 'auto' then
      local bracketCloseIcon = '}'
      M.createBracketCloseIconForExtension(extension, bracketCloseIcon)
    end

    local bracketsOpenAndCloseIcon = settings['bracketsOpenAndCloseIcon']
    if bracketsOpenAndCloseIcon == 'auto' then
      local bracketsOpenAndCloseIcon = '{}'
      M.createBracketsOpenAndCloseIconForExtension(extension, bracketsOpenAndCloseIcon)
    end

    M.hideBrackets(extension)
    return
  end;

  local beginNodeLine, endNodeLine = M.findBeginAndEndNodeLines(node)
  if beginNodeLine == endNodeLine then
    M.hideBrackets(extension)
    M.showOpenAndCloseBracketsOnLine(extension, buf, beginNodeLine)
    return
  end

  M.hideBrackets(extension)
  M.showOpenBracketOnLine(extension, buf, beginNodeLine)
  M.showCloseBracketOnLine(extension, buf, endNodeLine)
end

return brackets_highlighter
