local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
    -- Examples of Greek letter snippets, autotriggered for efficiency
    s({trig=";a", snippetType="autosnippet"},
	{ t("\\alpha") }
    ),

    s({trig=";b", snippetType="autosnippet"},
	{ t("\\beta") }
    ),

    s({trig=";g", snippetType="autosnippet"},
	{ t("\\gamma") }
    ),

    s({trig="bb", wordTrig=false, snippetType="autosnippet"},
	 fmta("\\mathbb{<>}<>", { i(1), i(0) }),
	 { condition=math }
    ),

    -- attempt at replicating VSCode's auto-item
    s({trig="\n", snippetType="autosnippet"},
	{ t("\\item ") }
    ),

    s({trig="bm", dscr="bold math", snippetType="autosnippet"},
	fmta("\\bm{<>}<>", { d(1, get_visual), i(0) }),
	{ condition=math }
    )

}
