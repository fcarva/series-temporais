---
title: "O que mudou em relação à versão original"
subtitle: "Lista Avaliativa Econometria II — Patrick Beraldo Torezani e Felipe Carvalho Souza Santos"
lang: pt
format:
  pdf:
    toc: false
---

O modelo, a série (variação mensal do INPC, 01/2013 a 09/2026), a estrutura das questões e a maior parte do texto e do código são os do PDF original. Abaixo está tudo o que foi alterado, questão por questão. Cada item diz o que estava antes, o que ficou e por quê.

# Geral

- **Pacotes.** Saíram `library(seasonal)` (não era usado e exige o X-13 instalado), o segundo `library(forecast)` e `library(flextable)` (não era usado). Entrou `library(lmtest)`, para o `coeftest()` da Q5(e).
- **Série temporal com data.** O `ts()` agora tem `start = c(2013, 1)`. Antes, os gráficos mostravam "5, 10, 15" no eixo e as tabelas da Q7 rotulavam out/2024 como "Jan".
- **Títulos.** Antes: "1 1. Preparação…". A numeração manual saiu, e fica só a automática.
- **Código no PDF.** As linhas longas eram cortadas na margem (p. 13, 14, 22, 27, 31). Agora quebram a linha.
- **Reprodutibilidade.** Entrou o `sessionInfo()` no final, exigido pelas normas de entrega.
- **Redação.** Saíram expressões que afirmavam mais do que os testes permitem: "confirmando com total segurança", "valida de vez", "confirma de forma definitiva", "unificando perfeitamente", "máxima parcimônia e rigor estatístico", "comprova empiricamente".

# Questão 1

- **Sazonalidade.** Antes: "não é possível identificar um padrão sazonal". Agora: há sazonalidade fraca (fevereiro, março e dezembro acima da média, agosto abaixo), confirmada pela FAC no lag 12. Motivo: o texto original contradizia a Q3 (pico em 12) e a Q7 (o sazonal ingênuo vence).
- **Mudanças de nível.** Acrescentada uma frase: não há mudança permanente, mas há mudanças temporárias de patamar (média anual de 0,17% a 0,90% a.m.).

# Questão 2

- **(a) p-valores.** O enunciado pede p-valor, e o original só escrevia "$p < 0{,}01$". Entrou o cálculo dos p-valores de MacKinnon (`punitroot`) para o ADF e o PP. No KPSS, foi dito que $p > 0{,}10$.
- **(a) Defasagens.** Acrescentada a observação de que o `ur.df` só compara de 1 a 12 defasagens, então "o BIC escolheu 1" é o mínimo possível da função.
- **(a) DF-I.** Antes, era usado como evidência a favor da estacionariedade. Agora, fica registrado que essa especificação não é adequada para uma série com média positiva.
- **(a) PP.** Foram explicitados os termos determinísticos (constante e tendência).
- **(b)** O critério do gráfico (Mattos, 2019) vem primeiro. Também se explica que o teste $t$ da tendência só vale porque o $\tau$ já rejeitou, e as estatísticas $\phi$, que apareciam na saída sem leitura, são citadas.
- **(c) Série diferenciada.** O enunciado pede para repetir os testes na série diferenciada, e o original só rodava `ndiffs`. Entrou um bloco com ADF, PP e KPSS em $\Delta y$.
- **(c)** "estritamente estacionária" virou "estacionária (no sentido fraco)". Os testes não tratam de estacionariedade estrita.
- **(d) DF-GLS.** Antes: "o DF-GLS pode confundir a alta persistência… por isso divergiu". O argumento estava invertido: o DF-GLS tem mais poder que o ADF. A não rejeição vem de `lag.max = 12`, que no `urca` fixa 12 defasagens. Entrou um bloco mostrando que, com 1 a 4 defasagens, o DF-GLS rejeita.
- **(d)** Agora a resposta diz explicitamente que a série não é nem diferença-estacionária nem tendência-estacionária: é estacionária em torno de uma média.

# Questão 3

- **(a)** Entrou uma linha que imprime a FAC nos lags 11, 12, 13, 24 e 36.
- **(b)** O enunciado pergunta sobre $2s$, $3s$ e $s \pm 1$, e o original não respondia. Agora: pico em 12, nada em 24 e 36 e nada forte em 13.
- **(c)** Saiu "pico… nas suas vizinhanças", que a FAC não sustenta.

# Questão 4

- **(a) Tabela.** Antes, os valores estavam digitados à mão dentro do código. Agora, a tabela é montada pelo código, com os mesmos números. "Intercepto" virou "Média (intercept)", porque no `arima()` é a média da série e não a constante da equação.
- **(a)** Acrescentado que, no Modelo 3, SAR e SMA não são significativos e são redundantes.
- **(b)** Acrescentado que a estimação é por máxima verossimilhança exata.
- **(d) Contagem de parâmetros.** Antes: "a variância dos resíduos não é contada". **Isso estava errado**: o próprio AIC do original ($128{,}65$ com $\ln L = -60{,}33$) implica $k = 4$, isto é, 3 coeficientes mais a variância. A resposta agora mostra a conta, o código do `arima()` e o `logLik()` (`df = 4`), e compara com a convenção da aula 02.
- **(e)** Acrescentado que a diferença entre o Modelo 1 e o Modelo 2 é pequena (0,46 no AIC).
- **(f) Raízes.** Antes: dois `plot()` por modelo, com títulos "AR Roots" e "MA Roots" trocados ou repetidos, e sem conclusão. Agora: um gráfico por modelo e a conclusão (raízes inversas dentro do círculo; modelos estacionários e invertíveis).

# Questão 5

- **(a)** Entrou a FACP dos resíduos, que o enunciado pede. A legenda da figura, que falava de "estabilidade e invertibilidade dos modelos candidatos", virou "Diagnóstico dos resíduos do Modelo 1".
- **(b) e (c)** Uma frase de leitura após cada teste.
- **(d)** Os choques que causam a não normalidade foram identificados (jun/2018, jul/2022 e fev/2025). Também se explica que a normalidade importa para os intervalos, não para o modelo, e se lista o motivo de descarte de cada modelo.
- **(e)** Antes: só `coef()`, sem erro-padrão, e a afirmação de "não significativos" sem prova. Agora: `coeftest()`, com $p = 0{,}107$ e $p = 0{,}163$.

# Questão 6

- **(a) Raiz do MA.** Antes: `polyroot(c(1, -theta_est))`, com raiz $-1$. **Erro de sinal**: no R, o MA é $1 + \theta B$, então o polinômio é $1 - 0{,}9999997\,z$ e a raiz é $+1$, que é o fator $(1 - B)$ da diferença em excesso. Acrescentado que o erro-padrão na fronteira não tem a interpretação usual.
- **(b)** Entrou a interpretação do aumento de 0,6% e o modelo sobrediferenciado sem MA, cuja variância residual sobe cerca de 17%, com o AR mudando de sinal.
- **(c)** A pergunta é sobre a série sobrediferenciada, e o original só comparava resíduos. Entrou a FAC de $\Delta y$, que mostra a autocorrelação negativa no lag 1 ($-0{,}34$).
- **(d)** O item da variância passou a dizer "quando o modelo não tem um MA que compense", porque o próprio resultado da (b) foi de só 0,6%. Também foi corrigido o "\*\*" que sobrou no último item.

# Questão 7

- **(a)** Os índices fixos (141, 165) viraram `T0` e `H`, e as datas aparecem certas.
- **(b)** Uma frase explicando por que a previsão fica plana: converge para a média, como em toda série estacionária.
- **(d) MAPE.** Antes: "Inf", sem comentário. Agora: explicação (há um mês com variação zero, jan/2025, e vários perto de zero) e a indicação do MASE.
- **(e) Tabela.** Antes: só o RMSE. Agora: RMSE, MAE e MASE, com os esquemas nas colunas e os modelos nas linhas. Também entrou o teste de Diebold-Mariano (aula 03). Foi corrigido `snaive(treino, h = 141)` para `h = 24`.
- **(f) Resposta.** Antes, o texto estava no condicional ("Caso o modelo não tenha superado…") e dizia que o passeio aleatório era uma "barreira elevada" no Esquema 2, quando ele é o **pior** previsor nesse esquema (RMSE de 0,516). Agora a resposta é direta: o M1 bate o passeio aleatório e perde para o sazonal ingênuo nos dois esquemas, sem diferença significativa no Diebold-Mariano. As causas citadas são a queda da média da inflação na validação e o choque transitório de fev/2025.
- **(g)** Antes: só os números (23 de 24, 95,83%). Agora: a resposta, o teste de cobertura de Christoffersen ($p = 0{,}85$) e a observação que caiu fora do intervalo.

# O que não mudou

- O modelo escolhido: SARIMA$(1,0,0)\times(1,0,0)_{12}$, com $d = D = 0$.
- Os três candidatos, todos os testes originais e todas as estimativas.
- A base de dados (`inpc_13_a_26.xlsx`) e a forma de lê-la.
- A ordem das questões e a maior parte do texto da dupla.
