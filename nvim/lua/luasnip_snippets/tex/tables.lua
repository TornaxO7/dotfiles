local ls = require "luasnip"
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

local function table_gen(args, snip)
    local amount_columns = snip.captures[1]
    print(amount_columns)
    local return_string = { "{", }
    local column_pattern = string.format("\t| >{\\raggedright\\arraybackslash}m{%f\\textwidth}", 1.0 / amount_columns)
    for column_index=1,amount_columns do
        table.insert(return_string, column_pattern)
    end

    table.insert(return_string, "\t|}")
    table.insert(return_string, "")

    return return_string
end

return {
    s(
        {
            trig = "tab(%d)",
            regTrig = true,
        },
        {
            t([[\begin{tabular}]]),
            f(table_gen, {}),
            t([[\end{tabular}]])
        }
    ),
    s(
        {
            trig = "r(%d)",
            regTrig = true,
        },
        {
            f(function(args, snip)
                local return_string = {}
                local amount_columns = snip.captures[1]

                for index=2,amount_columns do
                    table.insert(return_string, "&")
                end
                table.insert(return_string, "% -----")
                table.insert(return_string, "")
                return return_string
            end)
        }
    )
}
