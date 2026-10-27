---
title: "Lista 01 — referências para modelar o INPC"
disciplina: Econometria II (PPGEco/UFES)
periodo: 2026
lista: LST01
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Referências do INPC
---

# Referências para modelar o INPC: índice de preços à moda do Mattos

Esta nota reúne a literatura que trata do mesmo problema da Lista 01, a modelagem de um **índice de preços mensal**, e mostra que a abordagem adotada é a usual. O ponto de partida é o texto de Mattos (2019). No exemplo 3, ele pega um número-índice (o quantum das exportações brasileiras), passa para log e usa o ADF com a versão escolhida pelo gráfico para decidir entre tendência estocástica e determinística. Fazemos o mesmo com o INPC.

## A pergunta de fundo: o log do índice é I(1) ou I(2)?

Para um índice de preços, a questão de integração tem uma forma própria:

- se o **log do índice é I(1)**, a inflação ($\Delta y$) é **estacionária**: choques mudam o *nível* de preços para sempre, mas a inflação volta para a média;
- se o **log do índice é I(2)**, a **própria inflação tem raiz unitária**: um choque de inflação ficaria para sempre na taxa, e o modelo teria $d = 2$.

A Lista 01 fica com a primeira: no nível, $\tau_3 = -2{,}36$ não rejeita; na diferença, $\tau_2 = -5{,}16$ rejeita com folga. A literatura mostra que as duas respostas já foram defendidas:

| Posição | Referência | O que mostra |
|---|---|---|
| inflação com raiz unitária (preços I(2)) | Johansen (1992) | na demanda por moeda do Reino Unido, trabalha com a ordem de integração dos preços e é citado na literatura da raiz unitária na inflação (por exemplo, em Basher e Westerlund, 2006) como evidência de preços I(2) |
| inflação estacionária (preços I(1)) | Culver e Papell (1997) | testes de raiz unitária série a série muitas vezes não rejeitam na inflação; testes de painel, mais potentes, rejeitam, e a inflação é estacionária |
| idem, robustez | Basher e Westerlund (2006) | a estacionariedade da inflação continua mesmo controlando dependência entre países e quebras |
| nível de preços com raiz unitária, inflação persistente | Cecchetti (1992) | trata o log do CPI mensal como tendo raiz unitária no nível e prevê a inflação com modelos ARMA de ordem baixa, que implicam persistência |
| Brasil pós-Real | Maia e Cribari-Neto (2006) | a dinâmica da inflação brasileira depois de 1994 é globalmente estacionária, com não estacionariedade só na cauda superior |
| Brasil, persistência | Ramalho (2017) e a literatura ARFIMA que ele revisa | a persistência da inflação brasileira é de memória longa, e não de raiz unitária |

**Por que isso importa para a Lista 01.** O $\widehat\rho = 0{,}972$ da regressão do ADF e a não rejeição do KPSS no nível ("dados pouco informativos") são exatamente o que essa literatura descreve: a inflação é muito persistente, e os testes univariados têm pouco poder perto da raiz unitária. A conclusão $d = 1$ (preços I(1), inflação I(0)) é a mesma dos estudos com testes mais potentes e a da evidência para o Brasil sob metas de inflação.

## Mattos, exemplo 3, e o INPC lado a lado

| Etapa | Mattos, exemplo 3 (quantum das exportações) | Lista 01 (INPC) |
|---|---|---|
| série | índice anual, 1950–2007 | índice mensal, jan/2013 a set/2026 |
| transformação | log, porque a variância cresce muito com o nível | log, porque a diferença do log é a inflação |
| versão do ADF | pelo gráfico: o log sobe, então constante e tendência | pelo gráfico: o log sobe, então constante e tendência |
| resultado | rejeita $H_0$: a série é **TS** | não rejeita $H_0$: a série é **DS** |
| o que fazer | modelar com tendência determinística | diferenciar ($d = 1$) e manter o drift |

Em nota de rodapé, Mattos observa que o crescimento quase explosivo do índice original poderia sugerir duas raízes unitárias, mas que o log resolve o problema, porque o que crescia era a variância. É o mesmo cuidado da Lista 01: o log do INPC não pede $d = 2$, e a Q6 mostra o que acontece quando se diferencia demais.

## O roteiro simples, à moda do Mattos e do Box-Jenkins

1. **Gráfico do índice.** Tendência, sazonalidade, choques.
2. **Log.** $y_t = 100 \ln P_t$, para que $\Delta y_t$ seja a inflação em % ao mês.
3. **Versão do ADF pelo gráfico** (Mattos, seção 2.2.5). Se o log sobe, usa-se constante e tendência, e a leitura é DS contra TS.
4. **$d$ e $D$.** ADF, PP e KPSS no nível e na diferença; ADF com dummies sazonais centradas e FAC nos múltiplos de 12 para $D$ (Mattos, seção 2.6).
5. **FAC e FACP de $\Delta y$.** A FACP indica a parte regular, e a FAC nos múltiplos de 12 indica a sazonal. Saem dois ou três candidatos.
6. **Estimação e diagnóstico.** MV exata, AIC e BIC, raízes, Ljung-Box com os graus de liberdade corrigidos, sobreajuste.
7. **Previsão.** Fora da amostra, contra o passeio aleatório e o sazonal ingênuo.

Os passos 5 a 7 são o ciclo de Box, Jenkins, Reinsel e Ljung (2015, cap. 9) para séries sazonais. As notas da Penn State (STAT 510, lição 4) e o FPP3 de Hyndman e Athanasopoulos (seções 9.7 e 9.9) dão a mesma receita, com exemplos em R.

## Duas decisões que as referências confirmam

**O drift.** Com $d = 1$, uma constante no modelo de $\Delta y$ vira uma tendência linear em $y$ (Hyndman e Athanasopoulos, seção 9.7). Para um índice de preços, essa tendência é a inflação média. Com $d + D = 2$, a constante geraria uma tendência quadrática e costuma ser omitida.

**Por que não o *airline model*.** A resposta "de livro" para uma série mensal com tendência e sazonalidade é o SARIMA(0,1,1)(0,1,1)$_{12}$, com $D = 1$. Ele pressupõe uma sazonalidade forte e estocástica. A regra prática da STAT 510 é diferenciar sazonalmente só quando a FAC nos múltiplos de 12 começa perto de 1 e decai devagar. Enders (2014, cap. 2) faz a mesma ressalva para dados *fortemente* sazonais. No INPC, a FAC de $\Delta y$ vale $0{,}216$ em 12, $-0{,}031$ em 24 e $0{,}018$ em 36, e 3 das 11 dummies sazonais são significativas. A sazonalidade é fraca e determinística, então $D = 0$. Aplicar $1 - B^{12}$ criaria um MA sazonal com raiz unitária, o análogo sazonal da sobrediferenciação da Q6.

## O ARIMA da inflação no Brasil

Modelos ARIMA para a inflação mensal brasileira são prática corrente:
- o TD 117 do IPEA já projetava o IPCA com modelos ARIMA e modelos estruturais;
- a dissertação de Lorthiois (2009, FGV) mostra que um ARIMA do IPCA projeta a inflação de 6 meses melhor que as expectativas de mercado.

Servem para dizer, no relatório, que a abordagem não é só um exercício: é o benchmark usado na previsão de inflação no Brasil.

## O que citar no relatório

As referências que mais rendem, em ordem:
1. **Mattos (2019)**, pela escolha da versão do ADF e pela leitura DS × TS;
2. **Culver e Papell (1997)**, para justificar $d = 1$ (preços I(1), inflação estacionária) e não $d = 2$;
3. **Maia e Cribari-Neto (2006)**, para a estacionariedade da inflação brasileira depois do Real;
4. **Box, Jenkins, Reinsel e Ljung (2015)**, pelo ciclo de modelagem sazonal.

## Referências

- BASHER, S. A.; WESTERLUND, J. *Is there really a unit root in the inflation rate? More evidence from panel data models*. MPRA Paper 136, University Library of Munich, 2006. Versão publicada: *Applied Economics Letters*, v. 15, n. 3, p. 161–164. [IDEAS/RePEc](https://ideas.repec.org/p/pra/mprapa/136.html)
- BOX, G. E. P.; JENKINS, G. M.; REINSEL, G. C.; LJUNG, G. M. *Time Series Analysis: Forecasting and Control*. 5. ed. Hoboken: Wiley, 2015. Cap. 9.
- CECCHETTI, S. G. Prices during the Great Depression: was the deflation of 1930–1932 really unanticipated? *American Economic Review*, v. 82, n. 1, p. 141–156, 1992.
- CULVER, S. E.; PAPELL, D. H. Is there a unit root in the inflation rate? Evidence from sequential break and panel data models. *Journal of Applied Econometrics*, v. 12, n. 4, p. 435–444, 1997. [IDEAS/RePEc](https://ideas.repec.org/a/jae/japmet/v12y1997i4p435-44.html)
- ENDERS, W. *Applied Econometric Time Series*. 4. ed. Hoboken: Wiley, 2014. Cap. 2.
- HYNDMAN, R. J.; ATHANASOPOULOS, G. *Forecasting: Principles and Practice*. 3. ed. OTexts, 2021. Seções 9.7 e 9.9. [otexts.com/fpp3](https://otexts.com/fpp3/)
- JOHANSEN, S. Testing weak exogeneity and the order of cointegration in UK money demand data. *Journal of Policy Modeling*, v. 14, n. 3, p. 313–334, 1992.
- LORTHIOIS, A. *Modelo de previsão de inflação no Brasil*. Dissertação (Mestrado), Fundação Getulio Vargas, 2009. [Repositório FGV](https://repositorio.fgv.br/items/19ee09be-d079-409f-9832-1cf85de0f7c8)
- MAIA, A. L. S.; CRIBARI-NETO, F. Dinâmica inflacionária brasileira: resultados de auto-regressão quantílica. *Revista Brasileira de Economia*, v. 60, n. 2, 2006. [Periódicos FGV](https://periodicos.fgv.br/rbe/article/view/903)
- MATTOS, R. S. *Tendências e raízes unitárias*. Texto didático, Departamento de Economia, Universidade Federal de Juiz de Fora, 2019. Exemplo 3 e seções 2.2 e 2.6.
- PENN STATE. *STAT 510: Applied Time Series Analysis*, lição 4 (Seasonal Models). [online.stat.psu.edu/stat510](https://online.stat.psu.edu/stat510/Lesson04.html)
- RAMALHO, B. B. *Inércia inflacionária: o caso da cidade de Uberlândia*. Monografia, Instituto de Economia, Universidade Federal de Uberlândia, 2017. [Repositório UFU](https://repositorio.ufu.br/bitstream/123456789/20648/3/InerciaInflacionariaCaso.pdf)
- IPEA. *Projeções do IPCA*. Texto para Discussão Interna n. 117. [Repositório IPEA](https://repositorio.ipea.gov.br/entities/publication/d319deb2-37f2-4622-bd8d-a83c09ff8320)

<!-- conferência numérica
| chave_R | nota |
|---|---|
| l01_adf_tau3 | -2,36 |
| l01_adf_dy | -5,16 |
| l01_adf_rho | 0,972 |
| l01_fac12 | 0,216 |
| l01_fac24 | -0,031 |
| l01_fac36 | 0,018 |
| l01_saz_dum_dy | 3 |
-->
