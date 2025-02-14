local default_options = require("brackets_highlighter.default_options")
local gutter = require("brackets_highlighter.gutter")
local node_details_finder = require("brackets_highlighter.node_details_finder")

local brackets_highlighter = {}

brackets_highlighter.setup = function(opt)
  local options = vim.tbl_deep_extend('force', default_options, opt or {})

  local api = vim.api
  local group = api.nvim_create_augroup('BracketsHighlighterBuffer', { clear = true })

  local extensions = options['extensions']
  for extension, settings in pairs(extensions) do
    api.nvim_create_autocmd({ 'CursorMoved' }, {

      group = group,
      pattern = extension,
      callback = function(data)
        local extension = extension:gsub("[*.]", "")

        local bracketOpenIcon = settings['bracketOpenIcon']
        if bracketOpenIcon ~= 'auto' then
          gutter.createBracketOpenIconForExtension(extension, bracketOpenIcon)
        else
          gutter.createBracketOpenIconForExtension(extension, '')
        end

        local bracketCloseIcon = settings['bracketCloseIcon']
        if bracketCloseIcon ~= 'auto' then
          gutter.createBracketCloseIconForExtension(extension, bracketCloseIcon)
        else
          gutter.createBracketCloseIconForExtension(extension, '')
        end

        local bracketsOpenAndCloseIcon = settings['bracketsOpenAndCloseIcon']
        if bracketsOpenAndCloseIcon ~= 'auto' then
          gutter.createBracketsOpenAndCloseIconForExtension(extension, bracketsOpenAndCloseIcon)
        else
          gutter.createBracketsOpenAndCloseIconForExtension(extension, '')
        end

        local buf = data.buf
        brackets_highlighter.onCursorMove(buf, extension, settings)
      end
    })
  end
end

brackets_highlighter.onCursorMove = function(buf, extension, settings)
  local targetNode = node_details_finder.get_node_at_cursor()
  if targetNode == nil then return end

  local nodesForBracketsHighlihgt = settings['nodesForBracketsHighlight']
  local node = node_details_finder.findNodeForBracketsHighlight(targetNode, nodesForBracketsHighlihgt)
  if node == nil then
    local bracketOpenIcon = settings['bracketOpenIcon']
    if bracketOpenIcon == 'auto' then
      local bracketOpenIcon = '{'
      gutter.createBracketOpenIconForExtension(extension, bracketOpenIcon)
    end

    local bracketCloseIcon = settings['bracketCloseIcon']
    if bracketCloseIcon == 'auto' then
      local bracketCloseIcon = '}'
      gutter.createBracketCloseIconForExtension(extension, bracketCloseIcon)
    end

    local bracketsOpenAndCloseIcon = settings['bracketsOpenAndCloseIcon']
    if bracketsOpenAndCloseIcon == 'auto' then
      local bracketsOpenAndCloseIcon = '{}'
      gutter.createBracketsOpenAndCloseIconForExtension(extension, bracketsOpenAndCloseIcon)
    end

    gutter.hideBrackets(extension)
    return
  end;

  local beginNodeLine, endNodeLine = node_details_finder.findBeginAndEndNodeLines(node)
  if beginNodeLine == endNodeLine then
    gutter.hideBrackets(extension)
    gutter.showOpenAndCloseBracketsOnLine(extension, buf, beginNodeLine)
    return
  end

  gutter.hideBrackets(extension)
  gutter.showOpenBracketOnLine(extension, buf, beginNodeLine)
  gutter.showCloseBracketOnLine(extension, buf, endNodeLine)
end

return brackets_highlighter
