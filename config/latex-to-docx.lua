-- config/latex-to-docx.lua
-- Convierte constructos LaTeX raw a AST de Pandoc para output DOCX
-- Se ejecuta solo para formatos NO-LaTeX (docx, html, etc.)

local function is_latex_output()
  return FORMAT:match('latex') or FORMAT:match('tex')
      or FORMAT:match('context') or FORMAT:match('beamer')
end

-- Extrae el contenido dentro de un grupo de llaves { ... } comenzando en start
local function extract_braces(text, start)
  if text:sub(start, start) ~= '{' then return nil, start end
  local depth = 1
  local i = start + 1
  while i <= #text and depth > 0 do
    local c = text:sub(i, i)
    if c == '\\' then i = i + 2
    elseif c == '{' then depth = depth + 1; i = i + 1
    elseif c == '}' then depth = depth - 1; i = i + 1
    else i = i + 1 end
  end
  if depth == 0 then
    return text:sub(start + 1, i - 2), i - 1
  end
  return nil, start
end

-- Convierte texto inline LaTeX a inlines de Pandoc
local function parse_inlines(text)
  local inlines, i, n = {}, 1, #text
  while i <= n do
    local c = text:sub(i, i)
    if c == '\\' then
      local rest = text:sub(i)
      if rest:match('^\\\\') then
        table.insert(inlines, pandoc.Str('\\'))
        i = i + 2
      elseif rest:match('^\\newline') then
        table.insert(inlines, pandoc.LineBreak())
        i = i + 7
      elseif rest:match('^\\textbf{') then
        local content, endpos = extract_braces(text, i + 7)
        if content then
          table.insert(inlines, pandoc.Strong(parse_inlines(content)))
          i = endpos + 1
        else i = i + 8 end
      elseif rest:match('^\\text{') then
        local content, endpos = extract_braces(text, i + 5)
        if content then
          table.insert(inlines, pandoc.Str(content))
          i = endpos + 1
        else i = i + 6 end
      elseif rest:match('^\\multirow') then
        local _, endpos = text:find('\\multirow%b[]*%b{}%b{}%b{}', i)
        if endpos then i = endpos + 1 else i = i + 8 end
      elseif rest:match('^\\rowcolor') then
        local _, endpos = text:find('\\rowcolor%b[]', i)
        if endpos then i = endpos + 1 else i = i + 9 end
      elseif rest:match('^\\hline') then
        i = i + 5
      elseif rest:match('^\\cline') then
        local _, endpos = text:find('\\cline{%d+%-%d+}', i)
        if endpos then i = endpos + 1 else i = i + 6 end
      elseif rest:match('^\\endhead') then
        i = i + 7
      elseif rest:match('^\\vspace') then
        local _, endpos = text:find('\\vspace%*?{[^}]*}', i)
        i = endpos and endpos + 1 or i + 7
      elseif rest:match('^\\footnotesize') then
        i = i + 11
      elseif rest:match('^\\normalsize') then
        i = i + 10
      elseif rest:match('^\\newpage') then
        i = i + 6
      elseif rest:match('^\\clearpage') then
        i = i + 8
      elseif rest:match('^\\hfill') then
        i = i + 5
      elseif rest:match('^\\nopagebreak') then
        local _, endpos = text:find('\\nopagebreak%*?', i)
        i = endpos and endpos + 1 or i + 11
      elseif rest:match('^\\includegraphics') then
        -- Includegraphics: \includegraphics[opts]{path}
        local _, endpos = text:find('\\includegraphics%b[]*%b{}', i)
        if not endpos then
          _, endpos = text:find('\\includegraphics%b{}', i)
        end
        if endpos then
          local path = text:match('\\includegraphics%b[]*{([^}]+)}', i)
          if path then
            table.insert(inlines, pandoc.Image({}, path))
          end
          i = endpos + 1
        else i = i + 15 end
      elseif rest:match('^\\begin{') then
        local env_name = rest:match('^\\begin{([^}]+)}')
        -- Skip entire environment for inline contexts
        local _, endpos = text:find('^\\begin{[^}]+}', i)
        if endpos then i = endpos + 1 else i = i + 1 end
      elseif rest:match('^\\end{') then
        local _, endpos = text:find('^\\end{[^}]+}', i)
        if endpos then i = endpos + 1 else i = i + 1 end
      else
        local _, endpos = text:find('^\\[a-zA-Z]+%*?', i)
        i = endpos and endpos + 1 or i + 1
      end
    elseif c == '~' or c == '─' or c == '—' then
      local j = i
      while j <= n and text:sub(j, j):match('[~─—]') do j = j + 1 end
      table.insert(inlines, pandoc.Str(text:sub(i, j - 1)))
      i = j
    elseif c == '\n' or c == '\r' then
      local j = i
      while j <= n and text:sub(j, j):match('[\n\r]') do j = j + 1 end
      if #inlines > 0 then
        local last = inlines[#inlines]
        if not (last.t == 'LineBreak' or last.t == 'Space') then
          table.insert(inlines, pandoc.Space())
        end
      end
      i = j
    elseif c == ' ' then
      local j = i
      while j <= n and text:sub(j, j) == ' ' do j = j + 1 end
      if #inlines > 0 then
        local last = inlines[#inlines]
        if not (last.t == 'Space' or last.t == 'LineBreak') then
          table.insert(inlines, pandoc.Space())
        end
      end
      i = j
    else
      local j = i
      while j <= n and not text:sub(j, j):match('[\\~─—\n\r ]') do j = j + 1 end
      local word = text:sub(i, j - 1)
      if #word > 0 then table.insert(inlines, pandoc.Str(word)) end
      i = j
    end
  end
  return inlines
end

-- Convierte texto de celda a bloques de Pandoc
local function cell_to_blocks(text)
  text = text:gsub('^[\n\r%s]+', '')
  text = text:gsub('[\n\r%s]+$', '')
  if #text == 0 then return {pandoc.Para({pandoc.Str(' ')})} end
  return {pandoc.Para(parse_inlines(text))}
end

-- Parsea \multirow[t]{n}{=}{content} extrayendo content y el número de filas
local function parse_multirow(text, pos)
  local _, endpos = text:find('\\multirow', pos)
  if not endpos then return nil end
  pos = endpos + 1
  -- Skip optional [t] or similar
  if text:sub(pos, pos) == '[' then
    local _, bep = text:find('%b[]', pos)
    if bep then pos = bep + 1 end
  end
  -- Extract {n}
  local n_str, ep = extract_braces(text, pos)
  if not n_str then return nil end
  local n_rows = tonumber(n_str) or 1
  pos = ep + 1
  -- Extract {=} or similar
  local _, ep2 = extract_braces(text, pos)
  if ep2 then pos = ep2 + 1 end
  -- Extract {content}
  local content, ep3 = extract_braces(text, pos)
  if not content then return nil end
  return {rows = n_rows, content = content, endpos = ep3}
end

-- Parsea una tabla longtable LaTeX y devuelve un pandoc.Table
local function parse_longtable(latex_text)
  -- Extraer colspec
  local colspec = latex_text:match('\\begin{longtable}{([^}]+)}')
  if not colspec then return nil end
  local num_cols = 0
  for _ in colspec:gmatch('p{([^}]+)}') do num_cols = num_cols + 1 end
  if num_cols == 0 then num_cols = 3 end

  -- Dividir header / body por \endhead
  local header_end = latex_text:find('\\endhead')
  if not header_end then return nil end
  local header_raw = latex_text:sub(1, header_end - 1)
  local body_raw = latex_text:sub(header_end + 8)
  body_raw = body_raw:gsub('\\end{longtable}', '')
  body_raw = body_raw:gsub('%[H%]', '')

  -- Parsear header: extraer fila entre \hline y \\
  local header_text = header_raw:gsub('\\rowcolor%b[]', '')
  header_text = header_text:gsub('\\hline', ''):gsub('[\n\r]', ' ')
  local hdr_cells = {}
  for cell in header_text:gmatch('([^&]+)') do
    cell = cell:gsub('^%s+', ''):gsub('%s+$', '')
    if #cell > 0 then
      table.insert(hdr_cells, pandoc.TableCell(cell_to_blocks(cell)))
    end
  end

  -- Parsear body: split por \\\\ (row separator) solo fuera de llaves
  local rows_raw = {}
  local current = {}
  local depth = 0
  local i = 1
  while i <= #body_raw do
    local c = body_raw:sub(i, i)
    if c == '{' then depth = depth + 1; table.insert(current, c); i = i + 1
    elseif c == '}' then depth = math.max(depth - 1, 0); table.insert(current, c); i = i + 1
    elseif c == '\\' and depth == 0 then
      local ahead = body_raw:sub(i, i + 3)
      if ahead:match('^\\\\') then
        table.insert(rows_raw, table.concat(current))
        current = {}
        i = i + 2
        while i <= #body_raw and body_raw:sub(i, i):match('%s') do i = i + 1 end
        local r = body_raw:sub(i)
        if r:match('^\\hline') then
          i = i + 5
        elseif r:match('^\\cline{%d+%-%d+}') then
          local _, ep = body_raw:find('\\cline{%d+%-%d+}', i)
          i = ep and ep + 1 or i + 6
        end
      else
        table.insert(current, c); i = i + 1
      end
    else table.insert(current, c); i = i + 1 end
  end
  if #current > 0 then table.insert(rows_raw, table.concat(current)) end

  -- Parsear cada fila en celdas (split por & fuera de llaves)
  local parsed_rows = {}
  for _, row_text in ipairs(rows_raw) do
    local row_text = row_text:gsub('^%s+', ''):gsub('%s+$', '')
    row_text = row_text:gsub('\\rowcolor%b[]', ''):gsub('\\hline', '')
    row_text = row_text:gsub('\\cline{%d+%-%d+}', '')
    row_text = row_text:gsub('\\endhead', '')
    if #row_text > 0 then
      local cells = {}
      local cell_buf = {}
      local cd = 0
      for j = 1, #row_text do
        local ch = row_text:sub(j, j)
        if ch == '{' then cd = cd + 1; table.insert(cell_buf, ch)
        elseif ch == '}' then cd = math.max(cd - 1, 0); table.insert(cell_buf, ch)
        elseif ch == '&' and cd == 0 then
          table.insert(cells, table.concat(cell_buf))
          cell_buf = {}
        else table.insert(cell_buf, ch) end
      end
      table.insert(cells, table.concat(cell_buf))
      table.insert(parsed_rows, cells)
    end
  end

  -- Procesar multirows
  local table_rows = {}
  local rowspan_state = {}  -- col_idx -> {remaining, blocks}
  local function get_rowspan(col)
    return rowspan_state[col] and rowspan_state[col].remaining or 0
  end

  for ri, row_cells in ipairs(parsed_rows) do
    local pandoc_cells = {}
    local col = 1
    while col <= num_cols do
      local rs = get_rowspan(col)
      if rs > 0 then
        rowspan_state[col].remaining = rs - 1
        table.insert(pandoc_cells, pandoc.TableCell(
          {pandoc.Para({pandoc.Str('')})}, 1, 1
        ))
        col = col + 1
      else
        local cell_text = row_cells[col] or ''
        local mw = parse_multirow(cell_text, 1)
        if mw then
          local rest = cell_text:gsub('\\multirow%b[]*%b{}%b{}%b{}', '')
          local full_text = mw.content .. ' ' .. rest
          local blocks = cell_to_blocks(full_text)
          table.insert(pandoc_cells, pandoc.TableCell(
            blocks, mw.rows, 1
          ))
          if mw.rows > 1 then
            rowspan_state[col] = {remaining = mw.rows - 1}
          end
          col = col + 1
        else
          table.insert(pandoc_cells, pandoc.TableCell(
            cell_to_blocks(cell_text), 1, 1
          ))
          col = col + 1
        end
      end
    end
    table.insert(table_rows, pandoc.TableRow(pandoc_cells))
  end

  -- Armar pandoc.Table (API Pandoc 2.10+ y 3.x)
  local aligns = {pandoc.AlignDefault, pandoc.AlignDefault, pandoc.AlignDefault}
  local widths = {0.22, 0.53, 0.20}
  local head = pandoc.TableHead({pandoc.TableRow(hdr_cells)})
  local bodies = {pandoc.TableBody({}, {}, table_rows, {})}
  local foot = pandoc.TableFoot({})

  return pandoc.Table({}, {}, aligns, widths, head, bodies, foot)
end

-- Convierte texto LaTeX raw a bloque de Pandoc (o nil para omitir)
local function raw_tex_to_block(text)
  text = text:gsub('^%s+', ''):gsub('%s+$', '')
  if #text == 0 then return nil end

  if text:match('^\\vspace') or text:match('^\\newpage') or text:match('^\\clearpage')
     or text:match('^\\footnotesize') or text:match('^\\normalsize')
     or text:match('^\\hfill') or text:match('^\\nopagebreak') then
    return nil
  end

  if text:match('^\\includegraphics') then
    local path = text:match('{([^}]+)}')
    if path then
      return pandoc.Para({pandoc.Image({}, path)})
    end
    return nil
  end

  if text:match('^{\\[a-zA-Z]+') then
    text = text:gsub('^{\\[a-zA-Z]+%s*', '')
    text = text:gsub('(})%s*}%s*\\\\', '%1')
    text = text:gsub('}%s*\\\\', '')
  end

  text = text:gsub('\\\\%s*$', '')

  text = text:gsub('^%s+', ''):gsub('%s+$', '')
  if #text == 0 then return nil end

  local inlines = parse_inlines(text)
  if #inlines > 0 then
    return pandoc.Para(inlines)
  end
  return nil
end

-- Divide el contenido de un center por líneas en blanco y convierte cada parte
local function raw_center_to_blocks(center_text)
  local result, buf = {}, {}
  for line in center_text:gmatch('([^\n]*)\n?') do
    if line:match('^%s*$') then
      if #buf > 0 then
        local b = raw_tex_to_block(table.concat(buf, ' '))
        if b then table.insert(result, b) end
        buf = {}
      end
    else
      table.insert(buf, line)
    end
  end
  if #buf > 0 then
    local b = raw_tex_to_block(table.concat(buf, ' '))
    if b then table.insert(result, b) end
  end
  return result
end

-- Procesa un RawBlock que contiene múltiples comandos LaTeX simples separados por \n
local function process_simple_commands(text, out)
  for line in text:gmatch('([^\n]+)') do
    line = line:gsub('^%s+', ''):gsub('%s+$', '')
    if #line == 0 then
      -- skip
    elseif line:match('^\\newpage') or line:match('^\\clearpage') then
      table.insert(out, pandoc.RawBlock('openxml', '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'))
    elseif line:match('^\\tableofcontents') then
      -- skip (TOC is generated by toc: true)
    elseif line:match('^\\vspace') then
      -- skip
    elseif line:match('^\\footnotesize') or line:match('^\\normalsize') then
      -- skip
    elseif line:match('^\\hfill') then
      -- skip
    elseif line:match('^\\nopagebreak') then
      -- skip
    end
  end
end

function Pandoc(doc)
  if is_latex_output() then return doc end

  local new_blocks, i = {}, 1
  local blocks = doc.blocks

  while i <= #blocks do
    local block = blocks[i]

    if block.t == 'RawBlock' and block.format == 'tex' then
      local text = block.text

      if text:match('^\\newpage') or text:match('^\\clearpage') then
        table.insert(new_blocks, pandoc.RawBlock(
          'openxml',
          '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'
        ))
        i = i + 1

      elseif text:match('^\\tableofcontents') then
        i = i + 1

      elseif text:match('^\\vspace%*?{') then
        i = i + 1

      elseif text:match('^\\footnotesize') or text:match('^\\normalsize') then
        i = i + 1

      elseif text:match('\\begin{center}') then
        local inner = text:match('\\begin{center}(.-)\\end{center}')
        if inner then
          inner = inner:gsub('^%s+', ''):gsub('%s+$', '')
          local blocks = raw_center_to_blocks(inner)
          table.insert(new_blocks, pandoc.Div(blocks, {align = 'center'}))
        end
        i = i + 1

      elseif text:match('\\begin{minipage}') then
        local inner = text:match('\\begin{minipage}%b{}%s*(.-)%s*\\end{minipage}')
        if inner then
          local blocks = raw_center_to_blocks(inner)
          for _, b in ipairs(blocks) do
            table.insert(new_blocks, b)
          end
        end
        i = i + 1

      elseif text:match('^\\begin{longtable}') then
        local tbl = parse_longtable(text)
        if tbl then table.insert(new_blocks, tbl) end
        i = i + 1

      else
        process_simple_commands(text, new_blocks)
        i = i + 1
      end

    else
      table.insert(new_blocks, block)
      i = i + 1
    end
  end

  doc.blocks = new_blocks
  return doc
end
