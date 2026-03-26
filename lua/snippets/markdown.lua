local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

local HW = 18  -- half width (each side of center bar)
local TW = 37  -- total width (HW + | + HW)

local VBAR = string.rep(" ", HW) .. "|"
local HBAR = string.rep("-", HW) .. "●" .. string.rep("-", HW)

-- Leading spaces to center text in width w
local function cl(w, n)
  return f(function(args)
    local text = args[1][1] or ""
    return string.rep(" ", math.max(0, math.floor((w - #text) / 2)))
  end, { n })
end

-- Trailing spaces to center text in width w
local function ct(w, n)
  return f(function(args)
    local text = args[1][1] or ""
    local lead = math.floor((w - #text) / 2)
    return string.rep(" ", math.max(0, w - #text - lead))
  end, { n })
end

-- Trailing spaces to left-justify text in HW
local function rp(n)
  return f(function(args)
    local text = args[1][1] or ""
    return string.rep(" ", math.max(0, HW - #text))
  end, { n })
end

-- Leading spaces to right-justify text in HW
local function lp(n)
  return f(function(args)
    local text = args[1][1] or ""
    return string.rep(" ", math.max(0, HW - #text))
  end, { n })
end

local function matrix_nodes()
  return {
    -- Top axis label (tab stop 1)
    cl(TW, 1), i(1, "TOP AXIS"), ct(TW, 1),
    t({ "", VBAR, VBAR, "" }),
    -- Top quadrant names (TL=5, TR=7)
    cl(HW, 5), i(5, "TL NAME"), ct(HW, 5), t("|"),
    cl(HW, 7), i(7, "TR NAME"), ct(HW, 7),
    t({ "", "" }),
    -- Top quadrant descriptions (TL=6, TR=8)
    cl(HW, 6), i(6, "(TL DESC)"), ct(HW, 6), t("|"),
    cl(HW, 8), i(8, "(TR DESC)"), ct(HW, 8),
    t({ "", VBAR, HBAR, "" }),
    -- Axis labels (left=3, right=4)
    i(3, "LEFT AXIS"), rp(3), t("|"), lp(4), i(4, "RIGHT AXIS"),
    t({ "", VBAR, "" }),
    -- Bottom quadrant names (BL=11, BR=9)
    cl(HW, 11), i(11, "BL NAME"), ct(HW, 11), t("|"),
    cl(HW, 9), i(9, "BR NAME"), ct(HW, 9),
    t({ "", "" }),
    -- Bottom quadrant descriptions (BL=12, BR=10)
    cl(HW, 12), i(12, "(BL DESC)"), ct(HW, 12), t("|"),
    cl(HW, 10), i(10, "(BR DESC)"), ct(HW, 10),
    t({ "", VBAR, "" }),
    -- Bottom axis label (tab stop 2)
    cl(TW, 2), i(2, "BOTTOM AXIS"), ct(TW, 2),
  }
end

return {
  s("4x4Matrix", matrix_nodes()),
  s("matrix4x4", matrix_nodes()),
}
