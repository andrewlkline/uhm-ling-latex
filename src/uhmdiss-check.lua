-- uhmdiss-check.lua
-- Draft checks for uhmdiss (option "check", LuaLaTeX only).
-- At every shipout, inspects the finished page for:
--   * hyphenated line ends: more than 3 per page, or more than 2 in a row,
--     violate the eTD guide [2.9];
--   * glyphs set below 10pt (ignoring raised/lowered material such as
--     footnote marks and superscripts) [4.2].
-- Problems are written to the log and terminal as they occur, and a
-- summary is printed at the end of the run.
-- Licence: LPPL 1.3c or later.

uhmdiss_check = uhmdiss_check or {}
local M = uhmdiss_check

local HLIST   = node.id("hlist")
local VLIST   = node.id("vlist")
local DISC    = node.id("disc")
local GLYPH   = node.id("glyph")
local GLUE    = node.id("glue")
local PENALTY = node.id("penalty")
local KERN    = node.id("kern")
local WHATSIT = node.id("whatsit")
local MARK    = node.id("mark")
local INS     = node.id("ins")
local LINE_SUBTYPE = 1           -- hlist subtype "line"
local TENPT   = 10 * 65536 - 1   -- allow rounding

M.problems = {}

local function page_label()
  local ok, v = pcall(function() return tex.count["c@page"] end)
  return ok and tostring(v) or "?"
end

-- Does this line (hlist of subtype line) end in a hyphen?
local function ends_with_hyphen(line)
  local n = node.tail(line.head)
  while n do
    local id = n.id
    if id == DISC then
      return true
    elseif id == GLYPH then
      -- explicit hyphen typed in the source, e.g. "word-final"
      return n.char == 0x2D or n.char == 0x2010
    elseif id == GLUE or id == PENALTY or id == KERN
        or id == WHATSIT or id == MARK or id == INS then
      n = n.prev
    elseif id == HLIST or id == VLIST then
      -- e.g. a box at the end of the line: look no further
      return false
    else
      n = n.prev
    end
  end
  return false
end

local small = {}

-- Walk a list, collecting line boxes in order and small glyphs.
local function walk(head, lines, shifted)
  for n in node.traverse(head) do
    local id = n.id
    if id == HLIST then
      if n.subtype == LINE_SUBTYPE then lines[#lines + 1] = n end
      walk(n.head, lines, shifted or (n.shift ~= 0))
    elseif id == VLIST then
      walk(n.head, lines, shifted or (n.shift ~= 0))
    elseif id == GLYPH and not shifted then
      local f = font.getfont(n.font)
      if f and f.size and f.size < TENPT then
        local key = string.format("%.1fpt", f.size / 65536)
        small[key] = (small[key] or 0) + 1
      end
    end
  end
end

local function check_page(box)
  local lines = {}
  small = {}
  walk(box.head, lines, false)
  local total, run, maxrun = 0, 0, 0
  for _, l in ipairs(lines) do
    if ends_with_hyphen(l) then
      total = total + 1
      run = run + 1
      if run > maxrun then maxrun = run end
    else
      run = 0
    end
  end
  local page = page_label()
  local msgs = {}
  if total > 3 then
    msgs[#msgs + 1] = string.format("%d hyphenated line ends (max 3)", total)
  end
  if maxrun > 2 then
    msgs[#msgs + 1] = string.format("%d consecutive hyphenated lines (max 2)", maxrun)
  end
  for size, count in pairs(small) do
    msgs[#msgs + 1] = string.format("%d glyph(s) at %s (min 10pt)", count, size)
  end
  if #msgs > 0 then
    local text = "page " .. page .. ": " .. table.concat(msgs, "; ")
    M.problems[#M.problems + 1] = text
    texio.write_nl("term and log", "uhmdiss check: " .. text)
    texio.write_nl("term and log", "")
  end
end

luatexbase.add_to_callback("pre_shipout_filter", function(box)
  check_page(box)
  return true
end, "uhmdiss.check")

function M.report()
  texio.write_nl("term and log", "")
  if #M.problems == 0 then
    texio.write_nl("term and log",
      "uhmdiss check: no hyphenation or type-size problems found.")
  else
    texio.write_nl("term and log", string.format(
      "uhmdiss check: %d page(s) with problems:", #M.problems))
    for _, p in ipairs(M.problems) do
      texio.write_nl("term and log", "  " .. p)
    end
  end
  texio.write_nl("term and log", "")
end
