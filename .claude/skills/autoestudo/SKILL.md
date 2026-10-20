---
name: autoestudo
description: Loop de melhoria do material de estudo no estilo autoresearch. Escolhe a lacuna de maior peso medida por autoestudo/avaliar.R, escreve uma seção substantiva (demonstração ou exercício com números conferidos em R), roda o build e mantém a mudança só se a cobertura subir. Use quando o usuário pedir para melhorar, completar ou "rodar o autoestudo" no material de séries temporais.
---

# autoestudo

Leia e siga `autoestudo/program.md` na raiz deste repositório. Ele define o que é fixo (topicos.tsv, avaliar.R, scripts/), o que pode ser editado, o formato de um experimento e os critérios de parada.

Resumo do ciclo:

1. `Rscript autoestudo/avaliar.R` → pegue a lacuna de maior peso.
2. Leia a aula em `materiais/_txt/` e o módulo-alvo; escreva uma seção substantiva, parafraseada.
3. Commit → build (`scripts\build.ps1` no Windows) → `avaliar.R`.
4. Keep se o build passar e a cobertura subir; senão `git reset --hard HEAD~1`.
5. Registre em `autoestudo/resultados.tsv` (não versionado).
