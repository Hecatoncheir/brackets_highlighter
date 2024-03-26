local api = vim.api
local ts_get_node_text = vim.treesitter.get_node_text or vim.treesitter.query.get_node_text

local ts_utils = require('nvim-treesitter.ts_utils')
local parsers = require('nvim-treesitter.parsers')

local M = {}

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
                -- 'identifier',
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
                'initialized_variable_definition',
                'local_variable_declaration',
                'if_statement',
                'switch_expression',
                'table_constructor',
                'string',
                'string_content',
                'list_literal',
                'program',
            },
        },
    },
}


M.setup = function(opt)
    local options = vim.tbl_deep_extend('force', defaultOptions, opt or {})

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
                    M.createBracketOpenIconForExtension(extension, bracketOpenIcon)
                else
                    M.createBracketOpenIconForExtension(extension, '')
                end

                local bracketCloseIcon = settings['bracketCloseIcon']
                if bracketCloseIcon ~= 'auto' then
                    M.createBracketCloseIconForExtension(extension, bracketCloseIcon)
                else
                    M.createBracketCloseIconForExtension(extension, '')
                end

                local bracketsOpenAndCloseIcon = settings['bracketsOpenAndCloseIcon']
                if bracketsOpenAndCloseIcon ~= 'auto' then
                    M.createBracketsOpenAndCloseIconForExtension(extension, bracketsOpenAndCloseIcon)
                else
                    M.createBracketsOpenAndCloseIconForExtension(extension, '')
                end

                local buf = data.buf
                M.onCursorMove(buf, extension, settings)
            end
        })
    end
end

M.createBracketOpenIconForExtension = function(extension, icon)
    local signName = extension .. "_bracketOpen"

    -- local definedSign = vim.fn.sign_getdefined(signName)
    -- if definedSign ~= nil then
    --     vim.fn.sign_undefine({ signName })
    -- end

    vim.fn.sign_define(signName, { text = icon })
end

M.createBracketCloseIconForExtension = function(extension, icon)
    local signName = extension .. "_bracketClose"
    vim.fn.sign_define(signName, { text = icon })
end

M.createBracketsOpenAndCloseIconForExtension = function(extension, icon)
    local signName = extension .. "_bracketsOpenAndClose"
    vim.fn.sign_define(signName, { text = icon })
end

M.onCursorMove = function(buf, extension, settings)
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

M.hideBrackets = function(extension)
    vim.fn.sign_unplace(extension .. "_bracketOpen")
    vim.fn.sign_unplace(extension .. "_bracketClose")
    vim.fn.sign_unplace(extension .. "_bracketsOpenAndClose")
end

M.showOpenBracketOnLine = function(extension, buf, lineNumber)
    vim.fn.sign_place(
        0,
        extension .. "_bracketOpen",
        extension .. "_bracketOpen",
        buf,
        { lnum = lineNumber }
    )
end

M.showCloseBracketOnLine = function(extension, buf, lineNumber)
    vim.fn.sign_place(
        0,
        extension .. "_bracketClose",
        extension .. "_bracketClose",
        buf,
        { lnum = lineNumber }
    )
end

M.showOpenAndCloseBracketsOnLine = function(extension, buf, lineNumber)
    vim.fn.sign_place(
        0,
        extension .. "_bracketsOpenAndClose",
        extension .. "_bracketsOpenAndClose",
        buf,
        { lnum = lineNumber }
    )
end

M.isContains = function(tab, val)
    if tab == nil then return false end
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

M.findNodeForBracketsHighlight = function(node, nodesForBracketsHighlight)
    if (M.isContains(nodesForBracketsHighlight, node:type())) then
        return node
    end

    local parentNode = node:parent()
    if parentNode == nil then return end

    return M.findNodeForBracketsHighlight(parentNode)
end

M.findBeginAndEndNodeLines = function(node)
    local begin_node_line, _, end_node_line = node:range()
    begin_node_line = begin_node_line + 1
    end_node_line = end_node_line + 1
    return begin_node_line, end_node_line
end

return M
