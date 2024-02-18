vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.g.colors_name = "hugo"

local palette = {
    white = "#DCD7BA",
    tanWhite = "#867462";
    dark = "#000000",
    dark1 = "#24211E",
    dark2 = "#3A3631",
    gray = "#616059",
    gray1 = "#88877D",
    orange = "#DE9300",
    orange1 = "#EBC06D",
    magenta = "#CF9BC2",
    green = "#85B695",
    green1 = "#98BB6C"
}

local highlight_groups = {
    Normal = { fg = palette.white, bg = palette.dark },
    NormalFloat = { fg = palette.white, bg = palette.dark1 },

    ColorColumn = { bg = palette.dark1 },
    CursoColumn = "ColorColumn",
    CursorLine = "ColorColumn",
    VertSplit = { fg = palette.tanWhite },

    LineNr = { fg = palette.tanWhite },
    CursorLineNr = { fg = palette.white },

    Folded = { fg = palette.white, bg = palette.dark },
    FoldColumn = "LineNr",
    SignColumn = "LineNr",

    Pmenu = "NormalFloat",
    PmenuSel = { bg = palette.dark2 },
    PmenuSbar = "Pmenu",
    PmenuThumb = "PmenuSel",

    StatusLine = { fg = palette.white, bg = palette.dark1 },
    StatusLineNC = { fg = palette.tanWhite, bg = palette.dark1 },
    WildMenu = "NormalFloat",

    TabLine = { fg = palette.tanWhite, bg = palette.dark1 },
    TabLineFill = { bg = palette.dark1 },
    TabLineSel = { bg = palette.dark1 },

    MatchParen = { fg = "#ffffff", bg = palette.dark2 },
    Visual = { bg = palette.dark2 },

    Whitespace = { fg = palette.tanWhite },
    NonText = 'Whitespace',
    SpecialKey = 'Whitespace',

    ModeMsg = { fg = palette.tanWhite },

    Identifier = { fg = palette.white },
    Function = { fg = palette.orange1 },
    Statement = { fg = palette.orange },
    Type = { fg = palette.white },
    PreProc = { fg = palette.white, bold = true },
    Constant = { fg = palette.magenta },
    String = { fg = palette.green1 },
    Comment = { fg = palette.gray },

    ["@keyword.function"] = { fg = palette.green },
    ["@punctuation.bracket"] = { fg = palette.white },
    ["@punctuation.special"] = { fg = palette.white },
    ["@punctuation.delimeter"] = { fg = palette.white },
    ["@tag"] = { fg = palette.orange1 },
    ["@tag.attribute"] = { fg = palette.white },
}
 
for name, attrs in pairs (highlight_groups) do
    if type(attrs) == "table" then
        vim.api.nvim_set_hl(0, name, attrs)
    elseif type(attrs) == "string" then
        vim.api.nvim_set_hl(0, name, { link = attrs })
    end
end

