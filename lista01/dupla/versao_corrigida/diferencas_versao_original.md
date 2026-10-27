---
title: "O que mudou em relação à versão original"
subtitle: "Lista Avaliativa Econometria II — Patrick Beraldo Torezani e Felipe Carvalho Souza Santos"
lang: pt
format:
  pdf:
    toc: false
    geometry: margin=2.5cm
---

**Não mudou:** o modelo escolhido (SARIMA$(1,0,0)\times(1,0,0)_{12}$, $d = D = 0$), os três candidatos, a base `inpc_13_a_26.xlsx`, as funções usadas em cada teste, as estimativas e a ordem das questões. A maior parte do texto é a de vocês.

# Diagramação e código

- Cada questão começa em página nova, e figuras e tabelas ficam junto do código que as gera.
- Fonte de 11 pt, margens de 2,5 cm e tamanho padrão para os gráficos.
- Saiu a numeração duplicada dos títulos ("1 1. Preparação" virou "1 Preparação").
- As linhas longas de código agora quebram, em vez de serem cortadas na margem.
- As saídas brutas no console (`summary()` dos testes, `@teststat`, `@cval`, `@lag`, `print()` e `cat()`) viraram tabelas com título.
- Os `@` do pacote `urca` ficaram concentrados em três funções auxiliares no início da Questão 2 (`estatistica`, `critico_5` e `defasagens`).
- Saiu a impressão da série de treino e de validação inteiras na Q7(a). No lugar, entrou uma tabela com início, fim e número de observações.
- Raízes da Q4(f): um gráfico por modelo, lado a lado, com `autoplot()`. Antes eram dois `plot()` por modelo, com títulos trocados.
- Resíduos da Q5(a): a grade passou de 2×2 para 2×3, para incluir a FACP e caber na mesma página do código.
- Pacotes: saíram `seasonal` (não usado e dependente do X-13), `flextable` (não usado) e o `forecast` duplicado; entrou `lmtest`, para o `coeftest()`.
- O `ts()` ganhou `start = c(2013, 1)`, e os gráficos e tabelas passaram a mostrar as datas corretas.
- O código termina com `sessionInfo()` (versões do R e dos pacotes), exigido pelas normas de entrega.

# Questão 1

- **Sazonalidade.** "Não é possível identificar um padrão sazonal" virou "sazonalidade fraca": fevereiro, março e dezembro ficam acima da média e agosto abaixo. O texto antigo contradizia a Q3 e a Q7.
- **Mudanças de nível.** Entrou uma frase sobre mudanças temporárias de patamar: a média anual vai de 0,17% a 0,90% a.m.

# Questão 2

- **(a)** Os cinco testes foram reunidos em uma tabela com estatística, crítico de 5%, p-valor, defasagens, critério e termos determinísticos, como pede o enunciado.
- **(a)** Entraram os p-valores de MacKinnon (`punitroot`). Antes, o texto só dizia "$p < 0{,}01$".
- **(a)** Entrou a observação de que o `ur.df` só compara de 1 a 12 defasagens, então "o BIC escolheu 1" é o mínimo possível da função.
- **(a)** O DF-I (sem constante) deixou de ser usado como evidência: não é adequado para uma série com média positiva.
- **(a)** Saíram "confirmando com total segurança", "valida de vez" e "confirma de forma definitiva".
- **(b)** Entrou uma tabela com $\tau$ e $\phi$ do DF-III e do DF-II.
- **(b)** O texto agora começa pelo gráfico e explica que o $t$ da tendência só vale porque o $\tau$ rejeitou.
- **(c)** Entrou a tabela com ADF, PP e KPSS na série diferenciada, que o enunciado pede. Antes só havia `ndiffs`.
- **(c)** "Estritamente estacionária" virou "estacionária (no sentido fraco)".
- **(d)** Corrigida a explicação do DF-GLS. Antes: "confunde a alta persistência". Agora: com `lag.max = 12`, o `urca` fixa 12 defasagens; com 1 a 4 defasagens, o teste rejeita. Entrou uma tabela com essa sensibilidade.
- **(d)** Agora a resposta diz explicitamente "nem diferença-estacionária nem tendência-estacionária".

# Questão 3

- **(a)** Entrou uma linha com a FAC nos lags 11, 12, 13, 24 e 36.
- **(b)** Entrou a resposta sobre $2s$, $3s$ e $s \pm 1$, que faltava.
- **(c)** Saiu "pico… nas suas vizinhanças", que a FAC não sustenta.

# Questão 4

- **(a)** A tabela, antes digitada à mão no código, agora é montada pelo código, com os mesmos números.
- **(a)** "Intercepto" virou "Média (intercept)".
- **(a)** Entrou a observação de que, no M3, SAR e SMA não são significativos e são redundantes.
- **(b)** Entrou "máxima verossimilhança exata".
- **(d)** **Correção de conteúdo.** Antes: "a variância não é contada em $k$". Errado: o próprio AIC do trabalho implica $k = 4$ (3 coeficientes mais a variância). Entrou a conta no código e a comparação com a convenção da aula 02.
- **(e)** Saiu "unificando perfeitamente". Entrou a diferença pequena para o M2 (0,46 no AIC).
- **(f)** Entrou a conclusão, que faltava: raízes inversas dentro do círculo, modelos estacionários e invertíveis.

# Questão 5

- **(a)** Entrou a FACP dos resíduos (o enunciado pede). A legenda "estabilidade e invertibilidade dos modelos candidatos" virou "Diagnóstico dos resíduos do Modelo 1".
- **(b)** Entrou uma frase com os graus de liberdade ($K - 2$) e a conclusão.
- **(c)** JB e ARCH-LM foram reunidos em uma tabela, com uma frase de leitura.
- **(d)** Entraram os choques que explicam a não normalidade (jun/2018, jul/2022 e fev/2025) e o motivo de descarte de cada modelo. Saiu "máxima parcimônia e rigor estatístico".
- **(e)** `coef()` virou `coeftest()`, com erro-padrão e p-valor ($p = 0{,}107$ e $p = 0{,}163$). Antes, "não significativos" não tinha prova.

# Questão 6

- **(a)** **Correção de conteúdo.** A raiz do MA saía $-1$ por erro de sinal no `polyroot`. No R, o MA é $1 + \theta B$, e a raiz é $+1$.
- **(a)** Entrou que o erro-padrão na fronteira não tem a interpretação usual. Saiu "comprova empiricamente".
- **(b)** Entrou uma tabela com as três variâncias: M1, sobrediferenciado com MA (+0,6%) e sobrediferenciado sem MA (+17%, com o AR mudando de sinal).
- **(c)** Entrou a FAC da série diferenciada, onde aparece a autocorrelação negativa ($-0{,}34$). Antes, só os resíduos eram comparados.
- **(d)** O item da variância passou a dizer "quando não há MA que compense". Também foi corrigido o "\*\*" que sobrou.

# Questão 7

- **(a)** Os números fixos (141, 165) viraram `T0` e `H`.
- **(b)** Entrou uma frase explicando por que a previsão fica plana: ela converge para a média.
- **(d)** Entrou a explicação do MAPE infinito: há um mês com variação zero.
- **(e)** A tabela, que só tinha RMSE, agora tem RMSE, MAE e MASE. Entrou o teste de Diebold-Mariano. O `snaive(..., h = 141)` virou `h = 24`.
- **(f)** **Correção de conteúdo.** O texto, que estava no condicional, virou uma resposta direta. Saiu a frase de que o passeio aleatório era uma "barreira elevada" no Esquema 2, onde ele é o pior previsor. Entraram as causas: a queda da média na validação e o choque transitório de fev/2025.
- **(g)** Entraram uma tabela com a cobertura e o teste de Christoffersen ($p = 0{,}85$), a resposta à pergunta e a observação que ficou fora do intervalo.
