local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s({trig="RR", dscr="R", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{R}") },
	{ condition = math }
    ),

    s({trig="CC", dscr="C", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{C}") },
	{ condition = math }
    ),

    s({trig="QQ", dscr="Q", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{Q}") },
	{ condition = math }
    ),

    s({trig="FF", dscr="F", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{F}") },
	{ condition = math }
    ),

    s({trig="ZZ", dscr="Z", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{Z}") },
	{ condition = math }
    ),

    s({trig="NN", dscr="N", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mathbb{N}") },
	{ condition = math }
    ),

 --    s({trig="HH", dscr="H", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\mathbb{H}") }
 --    ),
	--
 --    s({trig="DD", dscr="D", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\mathbb{D}") }
 --    )
}
