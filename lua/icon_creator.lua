local api = vim.api

local icon_creator = {}

icon_creator.createBracketOpenIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketOpen"

  -- local definedSign = vim.fn.sign_getdefined(signName)
  -- if definedSign ~= nil then
  --     vim.fn.sign_undefine({ signName })
  -- end

  vim.fn.sign_define(signName, { text = icon })
end

icon_creator.createBracketCloseIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketClose"
  vim.fn.sign_define(signName, { text = icon })
end

icon_creator.createBracketsOpenAndCloseIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketsOpenAndClose"
  vim.fn.sign_define(signName, { text = icon })
end


icon_creator.showOpenBracketOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketOpen",
    extension .. "_bracketOpen",
    buf,
    { lnum = lineNumber }
  )
end

icon_creator.showCloseBracketOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketClose",
    extension .. "_bracketClose",
    buf,
    { lnum = lineNumber }
  )
end

icon_creator.showOpenAndCloseBracketsOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketsOpenAndClose",
    extension .. "_bracketsOpenAndClose",
    buf,
    { lnum = lineNumber }
  )
end

return icon_creator
