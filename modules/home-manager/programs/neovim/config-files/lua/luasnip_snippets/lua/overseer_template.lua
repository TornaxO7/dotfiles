local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")

return {
	s("overseer_template", {
        t({
            "local overseer = require(\"overseer\")",
            "",
            "{",
            "\tname = \"Some Task\",",
            "\tbuilder = function(params)",
            "\t\treturn {",
            "\t\t\tcmd = { \"echo\" },",
            "\t\t\targs = { \"hello\", \"world\" },",
            "\t\t\tname = \"Greet\",",
            "\t\t\tcwd = \"/tmp\"",
            "\t\t\tenv = {",
            "\t\t\t\tVAR = \"FOO\",",
            "\t\t\t},",
            "\t\t\tcomponents = { \"my_custom_component\", \"default\" },",
            "\t\t\tmetadata = {",
            "\t\t\t\tfoo = \"bar\",",
            "\t\t\t},",
            "\t\t}",
            "\tend,",
            "\tdesc = \"Optional description of task\",",
            "\ttags = { overseer.TAG.BUILD },",
            "\tparams = {},",
            "\tpriority = 50,",
            "\tcondition = {",
            "\t\tfiletype = { \"c\", \"cpp\" },",
            "\t\tdir = \"/home/user/my_project\",",
            "\t\tcallback = function(search)",
            "\t\t\tprint(vim.inspect(search))",
            "\t\t\treturn true",
            "\t\tend,",
            "\t},",
            "}"
            }
        ),
    }),
}
