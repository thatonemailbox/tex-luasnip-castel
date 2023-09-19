-- A port of Gilles Castel's LaTeX UltiSnip snippets to Luasnip.
-- You can find his original tex.snippets file at https://github.com/gillescastel/latex-snippets/blob/master/tex.snippets
-- Much inspiration is taken from the following tutorials:
-- 1. https://www.ejmastnak.com/tutorials/vim-latex/luasnip/ 
-- 2. https://evesdropper.dev/files/luasnip/ultisnips-to-luasnip/

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end


local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function comment()
    return vim.api.nvim_eval('vimtex#syntax#in_comment()') == 1
end

-- source: https://evesdropper.dev/files/luasnip/ultisnips-to-luasnip/#conditionscontext-dependent-snippets
local function env(name)
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

return {
    s({trig = "template", dscr="Basic Template"},
	fmta(
	[[
	    \documentclass[a4paper]{article}

	    \usepackage[utf8]{inputenc}
	    \usepackage[T1]{fontenc}
	    \usepackage{textcomp}
	    \usepackage[dutch]{babel}
	    \usepackage{amsmath, amssymb}


	    % figure support
	    \usepackage{import}
	    \usepackage{xifthen}
	    \pdfminorversion=7
	    \usepackage{pdfpages}
	    \usepackage{transparent}
	    \newcommand{\incfig}[1]{%
		    \def\svgwidth{\columnwidth}
		    \import{./figures/}{#1.pdf_tex}
	    }

	    \pdfsuppresswarningpagegroup=1

	    \begin{document}
		<>
	    \end{document}
	]],
		{ i(1) }
	),
	{condition = line_begin}
    ),

    s({trig="beg", "begin{} / end{}", snippetType="autosnippet"},
      fmta(
	[[
	\begin{<>}
	    <>
	\end{<>}
	]],
	{
	  i(1),
	  d(2, get_visual),
	  rep(1),  -- this node repeats insert node i(1)
	}
      ),
      {condition = line_begin}
    ),

    s({trig="...", dscr="dots", snippetType="autosnippet"},
	{t("\\ldots")}
    ),

    s({trig="table", dscr="Table Environment"},
	fmta(
	    [[
	    \begin{table}[<>]
		    \centering
		    \caption{<>}
		    \label{tab:<>}
		    \begin{tabular}{<>}
			<>
		    \end{tabular}
	    \end{table}	    
	    ]],
	    {
		i(1, "htpb"),
		i(2, "caption"),
		i(3, "label"),
		i(4, "c"),
		i(5, "Actual table")
	    }
	),
	{condition = line_begin}
    ),

    s({trig="fig", dscr="Figure environment"},
	fmta(
	    [[
		\begin{figure}[<>]
		    \centering
			\includegraphics[width=0.8\textwidth]{<>}
		    \caption{<>}
		    \label{fig:<>}
		\end{figure}
	    ]],
	    {
		i(1, "htpb"),
		i(2),
		i(3),
		i(4)
	    },
	    {condition = line_begin}
	)
    ),

    s({trig="enum", dscr="Enumerate", snippetType="autosnippet"},
	fmta(
	[[
	\begin{enumerate}
	    \item <>
	\end{enumerate}
	]],
	{ i(1) }
	),
	{condition = line_begin}
    ),

    s({trig="item", dscr="Itemize", snippetType="autosnippet"},
	fmta(
	[[
	\begin{itemize}
	    \item <>
	\end{itemize}
	]],
	{ i(1) }
	),
	{condition = line_begin}
    ),

    s({trig="desc", dscr="Description"},
	fmta(
	[[
	\begin{description}
	    \item[<>] <>
	\end{description}
	]],
	{ i(1), i(2)}
	),
	{condition = line_begin}
    ),

    s({trig="pac", dscr="Package"},
	fmta("\\usepackage[<>]{<>}", { i(1), i(2, "package") }),
	{condition = line_begin}
    ),

    s({trig="=>", dscr="implies"},
	{ t("\\implies") }
    ),
    s({trig="=<", dscr="implied by"},
	{ t("\\implies") }
    ),

    s({trig="iff", dscr="iff", snippetType="autosnippet"},
	{ t("\\iff") },
	{ condition=math, show_condition=math}
    ),

    -- mk snippet placeholder, right now it is not the exact same as Castel's "smart" version
    s({trig = "mk", dscr="Math", wordTrig = false, snippetType="autosnippet"},
      fmta(
	"$<>$",
	{ i(1) }
      )
    ),

    s({trig="dm", dscr="Math", wordTrig = false, snippetType="autosnippet"},
	fmta(
	    [[
	    \[
	    <>
	    .\] <>
	    ]],
	    {
		i(1),
		i(0)
	    }
	)
    ),

    s({trig="ali", dscr="Align", snippetType="autosnippet"},
	fmta(
	[[
	    \begin{align*}
		<>
	    .\end{align*}
	]],
	{ d(1, get_visual) }
	),
	{condition = line_begin}
    ),

    s({trig="//", dscr="Fraction", wordTrig=false, snippetType="autosnippet"},
	fmta("\\frac{<>}{<>}", { i(1), i(2) }),
	{condition = math}
    ),

    s({trig="/", dscr="Fraction", wordTrig=false},
	fmta("\\frac{<>}{<>}", { d(1, get_visual), i(2) })
    ),

    -- regex fraction snippets go here (can't translate them yet)

    -- auto-subscript goes here
    s({trig="(%a)(%d)", dscr="auto subscript", regTrig=true, wordTrig=false, snippetType="autosnippet"},
	fmta("<>_<>", 
	{
	    f( function(_, snip) return snip.captures[1] end),
	    f( function(_, snip) return snip.captures[2] end)
	}
	),
	{ condition=math }
    ),

    s({trig="(%a)_(%d%d)", dscr="auto subscript2", regTrig=true, wordTrig=false, snippetType="autosnippet"},
	fmta("<>_{<>}", 
	{
	    f( function(_, snip) return snip.captures[1] end),
	    f( function(_, snip) return snip.captures[2] end)
	}
	),
	{ condition=math }
    ),

    -- snippets in between this relating to sympy and mathematica, ignored for now

    s({trig="==", dscr="equals", wordTrig=false, snippetType="autosnippet"},
	{ t("&= "), i(1), t("\\\\") }
    ),

    s({trig="!=", dscr="equals", wordTrig=false, snippetType="autosnippet"},
	{ t("\\neq") }
    ),

    s({trig="ceil", dscr="ceil", wordTrig=false, snippetType="autosnippet"},
	fmta("\\left\\lceil <> \\right\\rceil", { i(1) }),
	{condition=math}
    ),

    s({trig="floor", dscr="floor", wordTrig=false, snippetType="autosnippet"},
	fmta("\\left\\lfloor <> \\right\\rfloor", { i(1) }),
	{condition=math}
    ),


    s({trig="pmat", dscr="pmat", wordTrig=false, snippetType="autosnippet"},
	fmta("\\begin{pmatrix} <> \\end{pmatrix}", { i(1) })
    ),

    s({trig="bmat", dscr="bmat", wordTrig=false, snippetType="autosnippet"},
	fmta("\\begin{bmatrix} <> \\end{bmatrix}", { i(1) })
    ),

    s({trig="()", dscr="left( right)", wordTrig=false, snippetType="autosnippet"},
	fmta("\\left( <> \\right) <>", { d(1, get_visual), i(0) }),
	{ condition=math }
    ),

    s({trig="lr", dscr="left( right)", wordTrig=false},
	fmta("\\left( <> \\right) <>", { d(1, get_visual), i(0) })
    ),

    s({trig="lr(", dscr="left( right)", wordTrig=false},
	fmta("\\left( <> \\right) <>", { d(1, get_visual), i(0) })
    ),

    s({trig="lr|", dscr="left| right|", wordTrig=false},
	fmta("\\left| <> \\right| <>", { d(1, get_visual), i(0) })
    ),

    s({trig="lr{", dscr="left{ right}", wordTrig=false},
	fmta("\\left\\{ <> \\right\\} <>",
	{ f(function(args, snip)
	    local res, env = {}, snip.env
	    for _, val in ipairs(env.LS_SELECT_RAW) do
		table.insert(res, val)
	    end
	    return res
	end, {}) , i(0) }
	),
	{ condition=math }
    ),

    s({trig="lrb", dscr="left{ right}", wordTrig=false},
	fmta("\\left\\{ <> \\right\\} <>", { d(1, get_visual), i(0) })
    ),

    s({trig="lr[", dscr="left[ right]", wordTrig=false},
	fmta("\\left[ <> \\right] <>", { d(1, get_visual), i(0) })
    ),

    s({trig="lra", dscr="leftangle rightangle>", wordTrig=false},
	fmta("\\left<< <> \\right>> <>", { d(1, get_visual), i(0) })
    ),

    s({trig="conj", dscr="conjugate", wordTrig=false, snippetType="autosnippet"},
	fmta("\\overline{<>}<>", { i(1), i(0) }),
	{ condition=math }
    ),

    s({trig="sum", dscr="sum", wordTrig=false, snippetType="autosnippet"},
	fmta("\\sum_{<>=<>}^{<>} <>",
	    {
		i(1, "n"),
		i(2, "1"),
		i(3, "\\infty"),
		i(4, "<exp>")
	    }
	),
	{ condition=math }
    ),

    s({trig="taylor", dscr="taylor", wordTrig=false, snippetType="autosnippet"},
	fmta("\\sum_{<>=<>}^{<>} <> (x-a)^<> <>",
	    {
		i(1, "k"),
		i(2, "0"),
		i(3, "\\infty"),
		i(4, "c_k", rep(1)),
		rep(1),
		i(0)
	    }
	)
    ),

    s({trig="lim", dscr="limit", wordTrig=false},
	fmta("\\lim_{<> \\to <>}", {i(1, "n"), i(2, "\\infty")})
    ),

    s({trig="limsup", dscr="limsup", wordTrig=false},
	fmta("\\limsup_{<> \\to <>}", {i(1, "n"), i(2, "\\infty")})
    ),

    s({trig="prod", dscr="product", wordTrig=false},
	fmta("\\prod_{<>=<>}^{<>} <> <>", 
	    {
		i(1, "n"),
		i(2, "1"),
		i(3, "\\infty"),
		d(4, get_visual),
		i(0)
	    }
	)
    ),

    s({trig="part", dscr="d/dx", wordTrig=false},
	fmta("\\frac{\\partial <>}{\\partial <>} <>", 
	    {
		i(1, "V"),
		i(2, "x"),
		i(0)
	    }
	)
    ),

    s({trig="sq", dscr="\\sqrt{}", wordTrig=true, snippetType="autosnippet"},
	fmta("\\sqrt{<>} <>", { d(1, get_visual), i(0) }),
	{ condition=math }
    ),

    s({trig="sr", dscr="^2", wordTrig=true, snippetType="autosnippet"},
	{ t("^2") },
	{ condition=math }
    ),

    s({trig="cb", dscr="^3", wordTrig=true, snippetType="autosnippet"},
	{ t("^3") },
	{ condition=math }
    ),

    s({trig="td", dscr="to the ... power", wordTrig=true, snippetType="autosnippet"},
	fmta("^{<>}<>", { i(1), i(0)}),
	{ condition=math }
    ),

    s({trig="rd", dscr="to the ... power", wordTrig=true, snippetType="autosnippet"},
	fmta("^{<>}<>", { i(1), i(0)}),
	{ condition=math }
    ),

    s({trig="__", dscr="subscript", wordTrig=false, snippetType="autosnippet"},
	fmta("_{<>}<>", { i(1), i(0) })
    ),

    s({trig="ooo", dscr="\\infty", wordTrig=true, snippetType="autosnippet"},
	{ t("\\infty") }
    ),

 --    s({trig="rij", dscr="mij", wordTrig=true},
	-- fmta("(<>_<>)_{<>\\in<>}<>",
	--     {
	-- 	i(1, "x"),
	-- 	i(2, "n"),
	-- 	rep(2),
	-- 	i(3, "\\N"),
	-- 	i(0)
	--     }
	-- )
 --    ),

    s({trig="<=", dscr="leq", wordTrig=true, snippetType="autosnippet"},
	{ t("\\le") }
    ),

    s({trig=">=", dscr="geq", wordTrig=true, snippetType="autosnippet"},
	{ t("\\ge") }
    ),

    s({trig="EE", dscr="geq", wordTrig=true, snippetType="autosnippet"},
	{ t("\\exists") },
	{ condition=math }
    ),

    s({trig="AA", dscr="forall", wordTrig=true, snippetType="autosnippet"},
	{ t("\\forall") },
	{ condition=math }
    ),

    s({trig="xnn", dscr="xn", wordTrig=true, snippetType="autosnippet"},
	{ t("x_{n}") },
	{ condition=math }
    ),

    s({trig="ynn", dscr="yn", wordTrig=true, snippetType="autosnippet"},
	{ t("y_{n}") },
	{ condition=math }
    ),

    s({trig="xii", dscr="xi", wordTrig=true, snippetType="autosnippet"},
	{ t("x_{i}") },
	{ condition=math }
    ),

    s({trig="yii", dscr="yi", wordTrig=true, snippetType="autosnippet"},
	{ t("y_{i}") },
	{ condition=math }
    ),

    s({trig="xjj", dscr="xn", wordTrig=true, snippetType="autosnippet"},
	{ t("x_{j}") },
	{ condition=math }
    ),

    s({trig="yjj", dscr="yj", wordTrig=true, snippetType="autosnippet"},
	{ t("y_{j}") },
	{ condition=math }
    ),

    s({trig="xp1", dscr="x", wordTrig=true, snippetType="autosnippet"},
	{ t("x_{n+1}") },
	{ condition=math }
    ),

    s({trig="xmm", dscr="xm", wordTrig=true, snippetType="autosnippet"},
	{ t("x_{m}") },
	{ condition=math }
    ),

 --    s({trig="R0+", dscr="R0+", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\R_0^+") }
 --    ),

    s({trig="plot", dscr="plot", wordTrig=false},
	fmta([[
	    \begin{figure}[<>]
		    \centering
		    \begin{tikzpicture}
			    \begin{axis}[
				    xmin= <>, xmax= <>,
				    ymin= <>, ymax = <>,
				    axis lines = middle,
			    ]
				    \addplot[domain=<>:<>, samples=<>]{<>};
			    \end{axis}
		    \end{tikzpicture}
		    \caption{<>}
		    \label{<>}
	    \end{figure}
	]],
	{
	    i(1),
	    i(2, "-10"),
	    i(3, "10"),
	    i(4, "-10"),
	    i(5, "10"),
	    rep(2), rep(3),
	    i(6, "100"),
	    i(7),
	    i(8),
	    rep(8)
	}
	)
    ),

    -- I don't get this one
    -- s({trig="nn", dscr="Tikz node", wordTrig=false},
    --     fmta([[
    -- 	\node[<>] ($1/[^0-9a-zA-z]//g)<>) <>{$<>$};
    -- 	<>
    --     ]],
    --     {
    -- 	i(5),
    --
    --     }
    --     )
    -- )

    s({trig="mcal", dscr="mathcal", wordTrig=true, snippetType="autosnippet"},
	fmta("\\mathcal{<>}<>", { i(1), i(0) }),
	{ condition=math }
    ),

    s({trig="lll", dscr="l", wordTrig=true, snippetType="autosnippet"},
	{ t("\\ell") }
    ),

    s({trig="nabl", dscr="nabla", wordTrig=true, snippetType="autosnippet"},
	{ t("\\nabla") },
	{ condition=math }
    ),

    s({trig="xx", dscr="cross", wordTrig=true, snippetType="autosnippet"},
	{ t("\\times"), },
	{ condition=math }
    ),

    s({trig="**", dscr="cdot", wordTrig=true, snippetType="autosnippet"},
	{ t("\\cdot"), },
	{ condition=math }
    ),

    s({trig="norm", dscr="norm", wordTrig=true, snippetType="autosnippet"},
	fmta("\\|<>\\|<>", { i(1), i(0) }),
	{ condition=math }
    ),

    s({trig="dint", dscr="norm", worgTrig=false, snippetType="autosnippet"},
	fmta("\\int_{<>}^{<>} <> \\mathrm{d}<> <>",
	{
	    i(1, "-\\infty"),
	    i(2, "\\infty"),
	    d(3, get_visual),
	    i(4, "x"),
	    i(0)
	}),
	{ condition=math }
    ),

    -- others, including snippets for elementary functions

    s({trig="->", dscr="to", wordTrig=true, snippetType="autosnippet"},
	{ t("\\to") },
	{ condition=math }
    ),

    s({trig="<->", dscr="leftrightarrow", wordTrig=true, snippetType="autosnippet"},
	{ t("\\leftrightarrow") },
	{ condition=math }
    ),

    s({trig="!>", dscr="mapsto", wordTrig=true, snippetType="autosnippet"},
	{ t("\\mapsto") },
	{ condition=math }
    ),

    s({trig="invs", dscr="inverse", wordTrig=true, snippetType="autosnippet"},
	{ t("^{-1}") },
	{ condition=math }
    ),

    s({trig="compl", dscr="compliment", wordTrig=true, snippetType="autosnippet"},
	{ t("^{c}") },
	{ condition=math }
    ),

    s({trig="\\\\\\", dscr="setminus", wordTrig=true, snippetType="autosnippet"},
	{ t("\\setminus") },
	{ condition=math }
    ),

    s({trig=">>", dscr=">>", wordTrig=true, snippetType="autosnippet"},
	{ t("\\gg") }
    ),

    s({trig="<<", dscr="<<", wordTrig=true, snippetType="autosnippet"},
	{ t("\\ll") }
    ),

    s({trig="~~", dscr="~", wordTrig=true, snippetType="autosnippet"},
	{ t("\\sim") }
    ),

    s({trig="set", dscr="set", wordTrig=true, snippetType="autosnippet"},
	fmta("\\{<>\\} <>", { i(1), i(0) }),
	{ condition=math, show_condition=math }
    ),

    s({trig="||", dscr="mid", wordTrig=false, snippetType="autosnippet"},
	{ t("\\mid") }
    ),

    s({trig="cc", dscr="subset", wordTrig=false, snippetType="autosnippet"},
	{ t("\\subset") },
	{ condition=math }
    ),

    s({trig="notin", dscr="not in", wordTrig=false, snippetType="autosnippet"},
	{ t("\\not\\in") }
    ),

    s({trig="inn", dscr="in", wordTrig=false, snippetType="autosnippet"},
	{ t("\\in") }
    ),

 --    s({trig="NN", dscr="n", wordTrig=false, snippetType="autosnippet"},
	-- { t("\\N") }
 --    ),

    s({trig="Nn", dscr="cap", wordTrig=false, snippetType="autosnippet"},
	{ t("\\cap") }
    ),

    s({trig="UU", dscr="cup", wordTrig=false, snippetType="autosnippet"},
	{ t("\\cup") }
    ),

    s({trig="uuu", dscr="bigcup", wordTrig=true, snippetType="autosnippet"},
	fmta("\\bigcup_{<> \\in <>} <>", {
	    i(1, "i"),
	    i(2, "I"),
	    i(0)
	})
    ),

    s({trig="nnn", dscr="bigcap", wordTrig=true, snippetType="autosnippet"},
	fmta("\\bigcap_{<> \\in <>} <>", {
	    i(1, "i"),
	    i(2, "I"),
	    i(0)
	})
    ),

 --    s({trig="OO", dscr="emptyset", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\O") }
 --    ),

 --    s({trig="RR", dscr="real", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\R") }
 --    ),
	--
 --    s({trig="QQ", dscr="Q", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\Q") }
 --    ),
	--
 --    s({trig="ZZ", dscr="Z", wordTrig=true, snippetType="autosnippet"},
	-- { t("\\Z") }
 --    ),

    s({trig="<!", dscr="normal", wordTrig=true, snippetType="autosnippet"},
	{ t("\\triangleleft") }
    ),

    s({trig="<>", dscr="hokje", wordTrig=true, snippetType="autosnippet"},
	{ t("\\diamond") }
    ),

    -- can't translate regex yet for text subscript :(

    s({trig="tt", dscr="text", wordTrig=true, snippetType="autosnippet"},
	fmta("\\text{<>}<>", { i(1), i(0) }),
	{ condition=math }
    ),

    s({trig="case", dscr="cases", wordTrig=false, snippetType="autosnippet"},
	fmta([[
	    \begin{cases}
		<>
	    \end{cases}
	]], { i(1) }),
	{ condition=math }
    ),

    s({trig="SI", dscr="SI", wordTrig=true, snippetType="autosnippet"},
	fmta("\\SI{<>}<>", { i(1), i(2) })
    ),

    s({trig="bigfun", dscr="Big function", wordTrig=true, snippetType="autosnippet"},
	fmta([[
	    \begin{align*}
		<>: <> &\longrightarrow <> \\
		<>: &\longrightarrow <>(<>) = <>
	    \end{align*}
	]],
	{
	    i(1),
	    i(2),
	    i(3),
	    i(4),
	    rep(1),
	    rep(4),
	    i(0)
	})
    ),

    s({trig="cvec", dscr="column vector", wordTrig=true, snippetType="autosnippet"},
	fmta("\\begin{pmatrix} <>_<> \\\\ \\vdots\\\\ <>_<> \\end{pmatrix}",
	{
	    i(1, "x"), i(2, "1"),
	    rep(1), rep(2, "n")
	})
    ),

    s({trig="bar", dscr="bar", regTrig=true, wordTrig=true, snippetType="autosnippet"},
	fmta("\\overline{<>}<>", { i(1), i(0) })
    ),

    s({trig="(%a)bar", dscr="bar", regTrig=true, wordTrig=true, snippetType="autosnippet"},
	fmta("\\overline{<>}", { f(function(_, snip) return snip.captures[1] end) })
    ),

    s({trig="hat", dscr="hat", regTrig=true, wordTrig=false, snippetType="autosnippet"},
	fmta("\\hat{<>}<>", { i(1), i(0) }),
	{ condition=math }
    ),

    s({trig="(%a)hat", dscr="hat", regTrig=true, wordTrig=false, snippetType="autosnippet"},
	fmta("\\hat{<>}", { f(function(_, snip) return snip.captures[1] end) }),
	{ condition=math }
    ),

    s({trig="letw", dscr="let omega", wordTrig=true, snippetType="autosnippet"},
	{ t("Let $\\Omega \\subset \\C$ be open.") }
    ),

}
