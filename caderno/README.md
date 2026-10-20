---
title: "Caderno em PDF — o repositório no papel"
disciplina: Econometria II (PPGEco/UFES)
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Caderno em PDF — séries temporais
---

# Caderno em PDF

Esta pasta transforma as notas do repositório em livros para imprimir, no mesmo padrão do caderno de Econometria I. Os PDFs ficam em `caderno/pdf/`, **fora do git** como todo PDF: são gerados, não versionados.

| Arquivo gerado | Conteúdo | Para quê |
|---|---|---|
| `caderno_volume1_teoria.pdf` | formulário, convenções (o sinal do MA) e a teoria dos módulos 01–03 | estudar e anotar à mão |
| `caderno_volume2_lista.pdf` | a lista ARMA, ARIMA e SARIMA resolvida (Q1–Q16), com a teoria de estimação e previsão | conferir depois de resolver |
| `caderno_volume3_trabalho_inpc.pdf` | roteiro e relatório do trabalho em dupla do INPC, com as figuras | revisar o texto da dupla no papel |

## Gerar

```bash
Rscript caderno/montar_caderno.R                 # Linux/macOS
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts\r.ps1 caderno\montar_caderno.R
```

Para gerar só um volume, passe `teoria`, `lista` ou `trabalho` como argumento.

**Requisitos:** pandoc e LuaLaTeX (TeX Live ou MiKTeX), com as fontes Libertinus, que vêm no TeX Live (`texlive-fonts-extra`) e no MiKTeX. O preâmbulo usa Consolas e Segoe UI Symbol quando existem, como no Windows, e DejaVu nos outros sistemas.

## Como funciona

| Etapa | Arquivo | O que faz |
|---|---|---|
| 1. preparo | [montar_caderno.R](montar_caderno.R) | lê cada nota, tira o frontmatter, torna absolutos os caminhos das figuras e troca emoji por símbolos que a fonte desenha |
| 2. conversão | [filtros.lua](filtros.lua) | filtro do pandoc: callouts viram caixas coloridas; links para outras notas viram texto; tabelas `chave_R` viram uma linha discreta de conferência |
| 3. tipografia | [preambulo.tex](preambulo.tex) | paleta Flexoki (a mesma das figuras), títulos em sans, código com quebra de linha |
| 4. compilação | LuaLaTeX | gera o PDF e avisa se algum símbolo ficou sem glifo |

A ordem dos capítulos está nas funções `volume_teoria()`, `volume_lista()` e `volume_trabalho()` do script. Uma nota nova entra editando essas listas.
