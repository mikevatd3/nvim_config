require("luasnip.session.snippet_collection").clear_snippets("all")
require("luasnip.session.snippet_collection").clear_snippets("python")
require("luasnip.session.snippet_collection").clear_snippets("sql")

local ls = require "luasnip"
local extras = require "luasnip.extras"
local fmta = require"luasnip.extras.fmt".fmta

local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local rep = extras.rep
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node

local function date()
    return os.date("%Y-%m-%d") -- Adjust the format as needed
end

ls.add_snippets("all", {
    s("date", f(function() return date() end)),
    s("mv", t("Michael Vickers")),
    s("li", t("- [ ] "), i(0)),
})

ls.add_snippets("python", {
    s("pconf", {
        t({
            'with open("config.toml", "rb") as f:',
            '    config = tomli.load(f)',
        })
    }),
    s("logger", {
        t({'logger = logging.getLogger(config["app"]["name"])'})
    }),
    s("ti", {t("# type: ignore")}),
    s("pl", {i(1), t({".rename(columns={", "" , "}).assign(", "", ")[[", "", "]]"})}),
    s("al", fmta([["<col>": "__<alias>",]], {col=i(1), alias=rep(1)})),
    s("cl", fmta([[<col> = lambda df: clean_<alias>(df["__<alias>"]),]], {col=i(1), alias=rep(1)})),
})


local html_snips = {
    s("html", {
        t({
            '<!DOCTYPE html>',
            '<html lang="en">',
            '  <head>',
            '    <meta charset="UTF-8">',
            '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
            '    <meta http-equiv="X-UA-Compatible" content="ie=edge">',
            '    <title>{% block title %}Sophons{% endblock %}</title>',
            '    {% block extra_css %}{% endblock %}',
            '    {% block extra_js %}{% endblock %}',
            '  </head>',
            '  <body>',
            '    <main>',
            '        {% block content %}{% endblock %}',
            '    </main>',
            '  </body>',
            '</html>',
        })
    }),
    s("ext_html", {
        t({
            '{% extends "base.html" %}',
            '{% block extra_css %}',
            '<style>',
            '</style>',
            '{% endblock %}',
            '{% block extra_js %}',
            '<script src="https://unpkg.com/htmx.org@2.0.2"></script>',
            '{% endblock %}',
            '{% block content %}',
            '{% endblock %}',
        })
    }),
    s("dv", { t("{{ "), i(1), t(" }}") }),
    s("for", {
        t("{% for "), i(1), t(" in "), rep(1), t({"s %}",""}), i(2), t({"","{% endfor %}"})
    }),
    s("if", {
        t("{% if "), i(1), t({" %}",""}), i(2), t({"","{% endif %}"})
    }),
    s("t", {t("<"), i(1), t(">"), i(2), t("</"), rep(1), t(">")}),
    s("ct", {
        c(1, {
            sn(1, {t("<"), i(1), t(">"), i(2), t("</"), rep(1), t(">")}),
            sn(2, {t("<"), i(1), t({">", ""}), i(2), t({"", "</"}), rep(1), t(">")}),
            sn(3, {t("<"), i(1), t(' class="'), i(2),  t({'">', ""}), i(3), t({"", "</"}), rep(1), t(">")}),
            sn(4, {t("<"), i(1), t(' id="'), i(2),  t({'">', ""}), i(3), t({"", "</"}), rep(1), t(">")}),
            sn(5, {t("<"), i(1), t(' id="'), i(2), t('" class="'), i(3),  t({'">', ""}), i(4), t({"", "</"}), rep(1), t(">")}),
        })
    }),
    s("a", {t('<a href="'), i(1), t('">'), i(2), t("</a>")})
}


ls.add_snippets("html", html_snips)
ls.add_snippets("htmldjango", html_snips)


ls.add_snippets("sql", {
    s("vc", fmta([[
select <gc>, count(*)
from <table>
group by <gc_rep>
order by count desc;<finish>]], {
        gc=i(2),
        table=i(1),
        gc_rep=rep(1),
        finish=i(0)
    })),
    s("cte", c(1, {
        fmta([[
with <alias> as (
    <cte>
)
select * 
from <aliass>;<finish>
    ]], {
        alias=i(1),
        cte=i(2),
        finish=i(0),
        aliass=rep(1),
    }),
        fmta([[
with <alias> as (
    <cte> 
)
select * 
from <next>
    join <aliass>
        on <nextt>.<j1> = <aliass>.<j2>;<finish>
    ]], {
        alias=i(1),
        cte=i(2),
        aliass=rep(1),
        finish=i(0),
        next=i(3),
        nextt=rep(3),
        j1=i(4),
        j2=i(5),
    }),
})),
})


