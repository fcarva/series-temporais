-- Filtros do caderno em PDF (pandoc -> LaTeX).
--   * callouts do GitHub/Obsidian ([!NOTE], [!tip]...) viram caixas coloridas;
--     tabelas dentro de um callout saem da caixa (longtable não cabe em caixa);
--   * links internos (outras notas, âncoras, wikilinks) viram texto; URLs ficam;
--   * tabelas "chave_R | nota" viram uma linha discreta de conferência;
--   * tabelas largas ganham larguras proporcionais ao conteúdo, para quebrar linha;
--   * figuras ocupam no máximo 88% da largura;
--   * ambientes align/gather dentro de $$ passam direto para o LaTeX.

local CORES = {
  note = "fxazul", info = "fxazul", todo = "fxazul", abstract = "fxazul", summary = "fxazul",
  tip = "fxteal", hint = "fxteal", question = "fxteal", faq = "fxteal", help = "fxteal",
  success = "fxverde", check = "fxverde", done = "fxverde",
  important = "fxroxo", example = "fxroxo", quote = "fxeixo", cite = "fxeixo",
  warning = "fxlaranja", attention = "fxlaranja",
  caution = "fxvermelho", danger = "fxvermelho", error = "fxvermelho", failure = "fxvermelho", bug = "fxvermelho",
}
local ROTULO = {
  note = "Nota", info = "Informação", todo = "A fazer", abstract = "Resumo", summary = "Resumo",
  tip = "Dica", hint = "Dica", question = "Pergunta", faq = "Pergunta", help = "Ajuda",
  success = "Certo", check = "Certo", done = "Feito", important = "Importante", example = "Exemplo",
  quote = "Citação", cite = "Citação", warning = "Atenção", attention = "Atenção",
  caution = "Cuidado", danger = "Perigo", error = "Erro", failure = "Falha", bug = "Erro",
}

local function para_latex(inlines)
  local s = pandoc.write(pandoc.Pandoc({ pandoc.Plain(inlines) }), "latex")
  return (s:gsub("%s+$", ""))
end

local function apara(lista)
  local l = pandoc.List(lista)
  while #l > 0 and (l[1].t == "Space" or l[1].t == "SoftBreak") do l:remove(1) end
  while #l > 0 and (l[#l].t == "Space" or l[#l].t == "SoftBreak") do l:remove(#l) end
  return l
end

-- ---------------------------------------------------------------- links
function Link(el)
  local t = el.target or ""
  if t:match("^https?://") or t:match("^mailto:") then return nil end
  return el.content
end

-- ---------------------------------------------------------------- figuras
function Image(el)
  if not el.attributes.width then el.attributes.width = "88%" end
  return el
end

-- ---------------------------------------------------------------- matemática
function Math(el)
  if el.mathtype == "DisplayMath" then
    local env = el.text:match("^%s*\\begin{([%a]+)%*?}")
    local de_bloco = { align = true, gather = true, equation = true, multline = true, flalign = true, alignat = true }
    if env and de_bloco[env] then
      return pandoc.RawInline("latex", el.text)
    end
  end
end

-- ---------------------------------------------------------------- tabelas
local function texto_celula(cell)
  return pandoc.utils.stringify(cell.contents or cell)
end

local function linhas(tbl)
  local out = {}
  for _, r in ipairs(tbl.head.rows) do table.insert(out, r) end
  for _, b in ipairs(tbl.bodies) do
    for _, r in ipairs(b.body) do table.insert(out, r) end
  end
  return out
end

function Table(tbl)
  local rows = linhas(tbl)
  if #rows == 0 then return nil end
  -- tabela de conferência numérica: vira uma linha discreta
  local cab = tbl.head.rows[1]
  if cab and #cab.cells >= 2 and texto_celula(cab.cells[1]) == "chave_R" then
    local ils = pandoc.List({ pandoc.Str("Conferido"), pandoc.Space(), pandoc.Str("em"), pandoc.Space(), pandoc.Str("R:"), pandoc.Space() })
    local primeiro = true
    for _, b in ipairs(tbl.bodies) do
      for _, r in ipairs(b.body) do
        if not primeiro then ils:insert(pandoc.Str(" · ")) end
        primeiro = false
        ils:insert(pandoc.Code(texto_celula(r.cells[1])))
        ils:insert(pandoc.Str(" = "))
        ils:insert(pandoc.Str(texto_celula(r.cells[2])))
      end
    end
    return {
      pandoc.RawBlock("latex", "{\\footnotesize\\color{fxeixo}\\raggedright"),
      pandoc.Para(ils),
      pandoc.RawBlock("latex", "\\par}"),
    }
  end
  -- larguras proporcionais ao conteúdo quando a tabela é larga
  local ncol = #tbl.colspecs
  local maxlen = {}
  for j = 1, ncol do maxlen[j] = 0 end
  for _, r in ipairs(rows) do
    for j, c in ipairs(r.cells) do
      if j <= ncol then
        local n = utf8.len(texto_celula(c)) or #texto_celula(c)
        if n > maxlen[j] then maxlen[j] = n end
      end
    end
  end
  local total = 0
  for j = 1, ncol do total = total + maxlen[j] end
  if total > 70 then
    local pesos, soma = {}, 0
    for j = 1, ncol do
      pesos[j] = math.min(maxlen[j], 60) + 6
      soma = soma + pesos[j]
    end
    local novas = {}
    for j = 1, ncol do
      novas[j] = { tbl.colspecs[j][1], 0.97 * pesos[j] / soma }
    end
    tbl.colspecs = novas
  end
  return tbl
end

-- ---------------------------------------------------------------- callouts
function BlockQuote(bq)
  local primeiro = bq.content[1]
  if not primeiro or (primeiro.t ~= "Para" and primeiro.t ~= "Plain") then return nil end
  local ils = primeiro.content
  if #ils == 0 or ils[1].t ~= "Str" then return nil end
  local tipo = ils[1].text:match("^%[!(%a+)%][+-]?$")
  if not tipo then return nil end
  tipo = tipo:lower()
  local cor = CORES[tipo] or "fxazul"

  -- título na mesma linha (estilo Obsidian) até a primeira quebra
  local titulo = pandoc.List()
  local i = 2
  while i <= #ils and ils[i].t ~= "SoftBreak" and ils[i].t ~= "LineBreak" do
    titulo:insert(ils[i]); i = i + 1
  end
  titulo = apara(titulo)
  local resto = pandoc.List()
  for j = i + 1, #ils do resto:insert(ils[j]) end
  -- estilo do repositório: marcador sozinho e **título** na linha seguinte
  if #titulo == 0 and #resto > 0 and resto[1].t == "Strong" then
    titulo = resto[1].content
    resto:remove(1)
    while #resto > 0 and (resto[1].t == "SoftBreak" or resto[1].t == "LineBreak" or resto[1].t == "Space") do
      resto:remove(1)
    end
  end
  if #titulo == 0 then titulo = pandoc.List({ pandoc.Str(ROTULO[tipo] or tipo) }) end

  local blocos = pandoc.List()
  resto = apara(resto)
  if #resto > 0 then blocos:insert(pandoc.Para(resto)) end
  for k = 2, #bq.content do blocos:insert(bq.content[k]) end

  local out = pandoc.List()
  local dentro = pandoc.List()
  local titulo_tex = para_latex(titulo)
  local ja_abriu = false
  local function despeja(forcar)
    if #dentro == 0 and not forcar then return end
    local t = ja_abriu and "" or titulo_tex
    if t == "" then
      out:insert(pandoc.RawBlock("latex", "\\begin{tcolorbox}[enhanced, breakable, colback=" .. cor ..
        "!5!white, colframe=" .. cor .. ", boxrule=0pt, leftrule=2.6pt, arc=1.5pt, left=7pt, right=7pt, top=5pt, bottom=5pt]"))
    else
      out:insert(pandoc.RawBlock("latex", "\\begin{callout}{" .. cor .. "}{" .. t .. "}"))
    end
    out:extend(dentro)
    out:insert(pandoc.RawBlock("latex", t == "" and "\\end{tcolorbox}" or "\\end{callout}"))
    ja_abriu = true
    dentro = pandoc.List()
  end
  for _, b in ipairs(blocos) do
    if b.t == "Table" then
      despeja(not ja_abriu)
      out:insert(b)
    else
      dentro:insert(b)
    end
  end
  despeja(not ja_abriu)
  return out
end
