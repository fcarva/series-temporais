---
title: "Autoestudo — programa do agente"
tags:
  - series-temporais
  - meta
aliases:
  - Autoestudo — programa
---

# Autoestudo

Adaptação do [autoresearch](https://github.com/karpathy/autoresearch) ao material de estudo. No original, um agente altera `train.py`, treina por 5 minutos e só mantém a mudança se a métrica melhorar. Aqui, o agente melhora **uma nota por vez**, roda o build e o avaliador, e só mantém a mudança se a cobertura das aulas subir sem quebrar nada. Este arquivo é editado pelo humano. O agente edita as notas.

## O que é fixo (não editar durante o loop)

| Arquivo | Papel | Equivale a |
|---|---|---|
| `autoestudo/topicos.tsv` | os tópicos das aulas, com peso e onde devem estar | `prepare.py` (constantes) |
| `autoestudo/avaliar.R` | a métrica: cobertura em seções substantivas | `evaluate_bpb` |
| `scripts/` (build, lint, check_numbers) | o portão de qualidade | — |
| `materiais/` | a fonte; nunca copiar dela | os dados |

Mudar a régua para "melhorar" o resultado invalida o experimento. Se um tópico estiver mal especificado (regex frouxa, módulo errado), pare e proponha a correção ao humano, fora do loop.

## O que o agente pode editar

- As notas `NN_tema/*.md` e `trabalho_inpc/*.md`.
- Os scripts dos módulos `NN_tema/*.R`, para registrar números novos.
- `R/series.R` e `tests/testthat/`, se a nova seção precisar de um helper ou de uma identidade testada.
- `formulario/formulario.md`, para manter o resumo coerente.

## Setup

1. Combinar uma etiqueta com o humano, por exemplo `out20`, e criar `autoestudo/<etiqueta>` a partir do branch atual.
2. Ler `README.md`, `CONVENCOES.md`, `MATERIAIS_INDEX.md` e o módulo-alvo inteiro.
3. Rodar o build e o avaliador para obter a linha de base. Criar `autoestudo/resultados.tsv` só com o cabeçalho. Ele fica fora do git.

## Um experimento

1. **Escolher a lacuna.** Rode `Rscript autoestudo/avaliar.R` e pegue a lacuna de maior peso que ainda não foi tentada. Leia a parte da aula correspondente em `materiais/_txt/<id>.txt` (ids em `MATERIAIS_INDEX.md`).
2. **Escrever uma seção substantiva** no módulo indicado, com um destes formatos:
   - uma demonstração `### DNN.k · Título`, no formato de `CONVENCOES.md` §5;
   - um exercício resolvido, com **Solução.** e números registrados no script do módulo e conferidos numa tabela `chave_R | nota`.

   Parafraseie. O lint recusa 12 palavras seguidas iguais às do material.
3. **Commitar** a mudança.
4. **Rodar o portão:** `powershell -ExecutionPolicy Bypass -File scripts\build.ps1` (no Linux, `bash scripts/build.sh`) e depois `Rscript autoestudo/avaliar.R`.
5. **Decidir:**
   - build falhou: corrija se for bobagem (sinal, arredondamento, link); se a ideia não se sustenta, descarte;
   - build passou e a cobertura subiu: **keep**;
   - build passou e a cobertura não subiu: **discard** (`git reset --hard HEAD~1`), a menos que a mudança simplifique algo sem perder conteúdo.
6. **Registrar** em `autoestudo/resultados.tsv`: `commit	cobertura	numeros_R	status	descrição`.

## Critérios de qualidade

- **Correção acima de cobertura.** Uma seção com erro de sinal ou de hipótese é pior que nenhuma. Todo número vem do R.
- **Simplicidade.** Entre duas seções que cobrem o mesmo tópico, fica a mais curta. Apagar texto redundante e manter a cobertura é uma vitória.
- **Ligação com o que já existe.** Uma seção nova deve citar a aula pelo id e, quando couber, ligar com a lista (Q1–Q16), com o INPC ou com outro módulo.
- **Nada de palavra-chave solta.** Se o tópico aparece numa seção só para fazer a métrica contar, o experimento é descartado na revisão humana.

## Parada

O loop do autoresearch não para. Aqui, ele para quando:
- não há mais lacunas;
- três experimentos seguidos são descartados;
- ou o humano interrompe.

No fim, o agente resume o que entrou, o que foi descartado e por quê, e o humano revisa o diff antes de levar para o branch principal.
