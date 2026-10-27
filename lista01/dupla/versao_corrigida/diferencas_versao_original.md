---
title: "O que mudou em relação à versão original"
subtitle: "Lista Avaliativa Econometria II — Patrick Beraldo Torezani e Felipe Carvalho Souza Santos"
lang: pt
format:
  pdf:
    toc: false
    geometry: margin=2.5cm
---

**Não mudou:** o modelo escolhido (SARIMA$(1,0,0)\times(1,0,0)_{12}$, $d = D = 0$), os três candidatos, a base `inpc_13_a_26.xlsx`, as funções usadas em cada teste (`ur.df`, `ur.pp`, `ur.kpss`, `ur.ers`, `arima`, `Arima`, `Box.test`, `accuracy` etc.), a forma das saídas (`summary()`, `print()`, `cat()`), as estimativas e a ordem das questões. A maior parte do texto é a de vocês.

# Diagramação e código

- Cada questão começa em página nova.
- Fonte de 11 pt e margens de 2,5 cm.
- Saiu a numeração duplicada dos títulos ("1 1. Preparação" virou "1 Preparação").
- As linhas longas de código agora quebram, em vez de serem cortadas na margem.
- Saíram os `@` (`df_trend@teststat`, `@cval`, `teste_urca@lag`). Os valores já aparecem no `summary()` de cada teste.
- Pacotes: saíram `seasonal` (não usado e dependente do X-13), `flextable` (não usado) e o `forecast` duplicado. Entrou `lmtest`, para o `coeftest()`.
- O `ts()` ganhou `start = c(2013, 1)`, e os gráficos e as tabelas passaram a mostrar as datas corretas.
- Raízes da Q4(f): um `autoplot()` por modelo, lado a lado. Antes eram dois `plot()` por modelo, com títulos trocados.
- Resíduos da Q5(a): a grade passou de 2×2 para 2×3, para incluir a FACP e caber na mesma página do código.
- O código termina com `sessionInfo()` (versões do R e dos pacotes), exigido pelas normas de entrega.

# Questão 1

- **Sazonalidade.** "Não é possível identificar um padrão sazonal" virou "sazonalidade fraca": fevereiro, março e dezembro ficam acima da média e agosto abaixo. O texto antigo contradizia a Q3 e a Q7. No código, entrou uma linha com a média de cada mês e de cada ano.
- **Mudanças de nível.** Entrou uma frase sobre mudanças temporárias de patamar: a média anual vai de 0,17% a 0,90% a.m.

# Questão 2

- **(a)** Entraram os p-valores de MacKinnon (`punitroot`) do ADF e do PP, que o enunciado pede. Antes, o texto só dizia "$p < 0{,}01$".
- **(a)** Entrou a observação de que o `ur.df` só compara de 1 a 12 defasagens, então "o BIC escolheu 1" é o mínimo possível da função.
- **(a)** O DF-I (sem constante) deixou de ser usado como evidência: não é adequado para uma série com média positiva.
- **(a)** Foram explicitados os termos determinísticos do PP (constante e tendência).
- **(a)** Saíram "confirmando com total segurança", "valida de vez" e "confirma de forma definitiva".
- **(b)** Saiu o bloco de código, que só repetia os testes do item (a) e imprimia os `@`. O texto passou a citar as saídas do item (a).
- **(b)** O texto agora começa pelo gráfico, explica que o $t$ da tendência só vale porque o $\tau$ rejeitou e cita as estatísticas $\phi$.
- **(c)** Entraram o ADF, o PP e o KPSS na série diferenciada, que o enunciado pede. Antes só havia `ndiffs`.
- **(c)** "Estritamente estacionária" virou "estacionária (no sentido fraco)".
- **(d)** Corrigida a explicação do DF-GLS. Antes: "confunde a alta persistência". Agora: com `lag.max = 12`, o `urca` fixa 12 defasagens. O mesmo teste com 1, 2 e 4 defasagens rejeita a raiz unitária.
- **(d)** Agora a resposta diz explicitamente "nem diferença-estacionária nem tendência-estacionária".

# Questão 3

- **(a)** Entrou a impressão da FAC até 36 defasagens.
- **(b)** Entrou a resposta sobre $2s$, $3s$ e $s \pm 1$, que faltava.
- **(c)** Saiu "pico… nas suas vizinhanças", que a FAC não sustenta.

# Questão 4

- **(a)** "Intercepto" virou "Média (intercept)" na tabela.
- **(a)** Entrou a observação de que, no M3, SAR e SMA não são significativos e são redundantes.
- **(b)** Entrou "máxima verossimilhança exata".
- **(d)** **Correção de conteúdo.** Antes: "a variância não é contada em $k$". Errado: o próprio AIC do trabalho implica $k = 4$ (3 coeficientes mais a variância). Entraram a conta no código, o `logLik()` (`df = 4`) e a comparação com a convenção da aula 02.
- **(e)** Saiu "unificando perfeitamente". Entrou a diferença pequena para o M2 (0,46 no AIC).
- **(f)** Entrou a conclusão, que faltava: raízes inversas dentro do círculo, modelos estacionários e invertíveis.

# Questão 5

- **(a)** Entrou a FACP dos resíduos, que o enunciado pede. A legenda "estabilidade e invertibilidade dos modelos candidatos" virou "Diagnóstico dos resíduos do Modelo 1".
- **(b)** Entrou uma frase com os graus de liberdade ($K - 2$) e a conclusão.
- **(c)** Entrou uma frase de leitura dos testes.
- **(d)** Entraram os choques que explicam a não normalidade (jun/2018, jul/2022 e fev/2025) e o motivo de descarte de cada modelo. Saiu "máxima parcimônia e rigor estatístico".
- **(e)** `coef()` virou `coeftest()`, com erro-padrão e p-valor ($p = 0{,}107$ e $p = 0{,}163$). Antes, "não significativos" não tinha prova.

# Questão 6

- **(a)** **Correção de conteúdo.** A raiz do MA saía $-1$ por erro de sinal: `polyroot(c(1, -theta_est))` virou `polyroot(c(1, theta_est))`. No R, o MA é $1 + \theta B$, e a raiz é $+1$.
- **(a)** Entrou que o erro-padrão na fronteira não tem a interpretação usual. Saiu "comprova empiricamente".
- **(b)** Entrou o modelo sobrediferenciado sem MA, cuja variância residual sobe 17%, com o AR mudando de sinal, e uma frase de interpretação.
- **(c)** Entrou a FAC da série diferenciada, onde aparece a autocorrelação negativa ($-0{,}34$). Antes, só os resíduos eram comparados.
- **(d)** O item da variância passou a dizer "quando não há MA que compense". Também foi corrigido o "\*\*" que sobrou.

# Questão 7

- **(a)** A divisão usa as datas (`window(..., end = c(2024, 9))`), e as tabelas de treino e validação mostram os meses corretos.
- **(b)** Entrou uma frase explicando por que a previsão fica plana: ela converge para a média.
- **(d)** Entrou a explicação do MAPE infinito: há um mês com variação zero.
- **(e)** A tabela, que só tinha RMSE, agora tem RMSE e MAE nos dois esquemas e o MASE no Esquema 1, todos tirados do `accuracy()`. O `snaive(..., h = 141)` virou `h = 24`. Entrou o teste de Diebold-Mariano (`dm.test`).
- **(f)** **Correção de conteúdo.** O texto, que estava no condicional, virou uma resposta direta. Saiu a frase de que o passeio aleatório era uma "barreira elevada" no Esquema 2, onde ele é o pior previsor. Entraram os p-valores do Diebold-Mariano e as causas: a queda da média na validação e o choque transitório de fev/2025.
- **(g)** Entraram o teste de Christoffersen ($p = 0{,}85$), a resposta à pergunta e a observação que ficou fora do intervalo.
