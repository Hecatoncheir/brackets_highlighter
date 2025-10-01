-- local ts_utils = require('nvim-treesitter.ts_utils')

local node_details_finder = {}

node_details_finder.get_node_at_cursor = function()
  return vim.treesitter.get_node()
  -- return ts_utils.get_node_at_cursor()
end

node_details_finder.isContains = function(tab, val)
  if tab == nil then return false end
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

node_details_finder.findNodeForBracketsHighlight = function(node, nodesForBracketsHighlight)
  if (node_details_finder.isContains(nodesForBracketsHighlight, node:type())) then
    return node
  end

  local parentNode = node:parent()
  if parentNode == nil then return end

  return node_details_finder.findNodeForBracketsHighlight(parentNode)
end

node_details_finder.findBeginAndEndNodeLines = function(node)
  local begin_node_line, _, end_node_line = node:range()
  begin_node_line = begin_node_line + 1
  end_node_line = end_node_line + 1
  return begin_node_line, end_node_line
end

return node_details_finder
