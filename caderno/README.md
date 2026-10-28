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
| `caderno_volume1_teoria.pdf` | formulário, convenções (o sinal do MA) e a teoria dos módulos 01–03 e o módulo 07 (AU06), com os exercícios | estudar e anotar à mão |
| `caderno_volume2_lista.pdf` | a lista ARMA, ARIMA e SARIMA resolvida (Q1–Q16), com a teoria de estimação e previsão | conferir depois de resolver |
| `caderno_volume3_trabalho_inpc.pdf` | roteiro e relatório do trabalho em dupla do INPC, com as figuras | revisar o texto da dupla no papel |
| `caderno_volume5_prova.pdf` | guia da prova de 05/11, banco de variações, três simulados, gabaritos com rubrica, log de erros e formulário | treinar para a prova (versionado, vai ao cofre) |
| `caderno_prova_simulados.pdf` | só os enunciados dos três simulados | imprimir e resolver sem ver o gabarito (versionado) |

## Gerar

```bash
Rscript caderno/montar_caderno.R                 # Linux/macOS
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts\r.ps1 caderno\montar_caderno.R
```

Para gerar só um volume, passe `teoria`, `lista`, `trabalho`, `lista01`, `guia`, `prova` ou `simulados` como argumento.

**Requisitos:** pandoc e LuaLaTeX (TeX Live ou MiKTeX), com as fontes Libertinus, que vêm no TeX Live (`texlive-fonts-extra`) e no MiKTeX. O preâmbulo usa Consolas e Segoe UI Symbol quando existem, como no Windows, e DejaVu nos outros sistemas.

## Versão para imprimir (volumes 5, 6, 7, simulados e "à mão")

Os cinco PDFs da prova saem no **modo de impressão** (`compilar(..., impressao = TRUE)` em [montar_caderno.R](montar_caderno.R), com o preâmbulo extra [preambulo_impressao.tex](preambulo_impressao.tex)):

- **frente e verso:** margem interna de 2,8 cm para encadernar, cabeçalho e número de página espelhados, blocos começando em página ímpar e, no PDF dos simulados, cada simulado em página ímpar para destacar;
- **preto e branco:** a paleta vira tons de cinza, links em preto, e o tipo de cada caixa ("Atenção", "Cuidado"…) vem escrito no título;
- **leitura:** sem linha órfã ou viúva, título nunca sozinho no pé da página, tabelas em corpo menor com largura mínima pela palavra mais longa de cada coluna;
- **formulários:** célula vazia de tabela ganha altura e linha-guia para escrever à mão (log de erros, placar);
- **sem ruído:** a linha "Conferido em R" fica só nas notas e no build.

O volume 7 (`Rscript caderno/montar_caderno.R apostila`) é a [apostila](../apostila/README.md), com um capítulo por bloco da lista. As folhas à mão dos seis blocos saem juntas em `caderno_a_mao_blocos.pdf` (`Rscript caderno/montar_caderno.R amao_blocos`), com a Q2/Q6 completa em apêndice. O PDF "à mão" original (`Rscript caderno/montar_caderno.R amao`) traz só a Q2 e a Q6 demonstradas linha a linha, no formato de caderno, para copiar e refazer no papel.

A meta de diagramação é **zero `Overfull \hbox`** nos logs de `caderno/_build/`: nenhuma linha sai da mancha.

## Como funciona

| Etapa | Arquivo | O que faz |
|---|---|---|
| 1. preparo | [montar_caderno.R](montar_caderno.R) | lê cada nota, tira o frontmatter, torna absolutos os caminhos das figuras e troca emoji por símbolos que a fonte desenha |
| 2. conversão | [filtros.lua](filtros.lua) | filtro do pandoc: callouts viram caixas coloridas; links para outras notas viram texto; tabelas `chave_R` viram uma linha discreta de conferência |
| 3. tipografia | [preambulo.tex](preambulo.tex) | paleta Flexoki (a mesma das figuras), títulos em sans, código com quebra de linha |
| 4. compilação | LuaLaTeX | gera o PDF e avisa se algum símbolo ficou sem glifo |

A ordem dos capítulos está nas funções `volume_teoria()`, `volume_lista()` e `volume_trabalho()` do script. Uma nota nova entra editando essas listas.
