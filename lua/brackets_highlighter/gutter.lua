local api = vim.api

local gutter = {}

gutter.createBracketOpenIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketOpen"

  vim.fn.sign_define(signName, { text = icon })
end

gutter.createBracketCloseIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketClose"
  vim.fn.sign_define(signName, { text = icon })
end

gutter.createBracketsOpenAndCloseIconForExtension = function(extension, icon)
  local signName = extension .. "_bracketsOpenAndClose"
  vim.fn.sign_define(signName, { text = icon })
end


gutter.showOpenBracketOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketOpen",
    extension .. "_bracketOpen",
    buf,
    { lnum = lineNumber }
  )
end

gutter.showCloseBracketOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketClose",
    extension .. "_bracketClose",
    buf,
    { lnum = lineNumber }
  )
end

gutter.showOpenAndCloseBracketsOnLine = function(extension, buf, lineNumber)
  vim.fn.sign_place(
    0,
    extension .. "_bracketsOpenAndClose",
    extension .. "_bracketsOpenAndClose",
    buf,
    { lnum = lineNumber }
  )
end

gutter.hideBrackets = function(extension)
  vim.fn.sign_unplace(extension .. "_bracketOpen")
  vim.fn.sign_unplace(extension .. "_bracketClose")
  vim.fn.sign_unplace(extension .. "_bracketsOpenAndClose")
end

return gutter
