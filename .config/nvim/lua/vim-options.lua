local o = vim.opt

o.wrap = true                     -- line wrapping

-- line numbers 
o.number = true
o.relativenumber = true

-- search options
o.ignorecase = true
o.smartcase = true
o.cursorline = true

-- tab and indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true

-- appearance
o.termguicolors = true
o.background = "dark"
o.signcolumn = "yes"

-- backspace key
o.backspace = "indent,eol,start"

-- clipboard
o.clipboard:append("unnamedplus")

-- slip window
o.splitright = true
o.splitbelow = true

o.iskeyword:append("-")           -- the dash(-) will be considered as part of the word
