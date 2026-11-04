---
title: "Prova de 05/11 — guia de treino"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Guia da prova de séries temporais
---

# Prova de 05/11/2026: guia de treino

> [!IMPORTANT]
> **O professor anunciou o formato (04/11)**
> **4 questões de 2,5.** AIC e BIC para interpretar; uma questão de previsão; Yule-Walker não cai. A folha [o que cai](o_que_cai.md) organiza o quadro em quatro questões prováveis, e o [Simulado 05](simulado_05.md) treina esse formato em 1 hora.

> [!TIP]
> **Se for ler uma coisa só**
> O [básico da P1](basico.md), em duas páginas: as seis definições, as contas de uma linha e as três derivações-molde. É o que precisa sair sem pensar.
> Depois, o [guia "não posso errar"](nao_posso_errar.md): as nove questões básicas resolvidas linha a linha, com o sentido de cada passo. É onde se aprende **a fazer**.

O que se sabe da prova: **5 ou 6 questões, de 1h50 a 2h, sem consulta, tiradas da lista** "Processos ARMA, ARIMA e SARIMA" (`LST`). A aposta é **uma questão por bloco da lista**, com números e torções novos. Este guia junta quatro coisas:
1. o mapa de cada bloco para a resolução, a demonstração e o livro;
2. a estratégia de tempo;
3. as lições da P1 de Econometria I, traduzidas para séries temporais;
4. o plano dos 8 dias até a prova.

| Arquivo | Para quê |
|---|---|
| volume único da P1 | **o PDF para imprimir**, `caderno_p1_completo.pdf`, na pasta `caderno/pdf/`: os seis blocos (apostila, folha à mão, comentadas, banco), os simulados e os gabaritos, o log e o formulário |
| [apostila](../apostila/README.md) | **um capítulo por bloco da lista**: teoria com página do slide, demonstrações linha a linha, exemplo em R, perguntas em cadeia, diálogo e imagens; leia o capítulo antes de fazer as questões do bloco |
| [lista comentada](../lista_comentada/README.md) | **as 16 questões da lista, passo a passo, na notação dos slides**, com o caderno corrigido: comece por aqui |
| [Q2 e Q6 à mão](../lista_comentada/a_mao_q02_q06.md) | as duas questões escolhidas para treinar no papel, linha a linha, no formato de caderno |
| [banco.md](banco.md) | as 16 questões da lista em **variações** curtas com resposta: o treino diário |
| [simulado_01.md](simulado_01.md) · [gabarito](simulado_01_gabarito.md) | próximo da lista, para calibrar o tempo |
| [simulado_02.md](simulado_02.md) · [gabarito](simulado_02_gabarito.md) | **as nove questões-tipo** do [guia "não posso errar"](nao_posso_errar.md), com números novos |
| [simulado_03.md](simulado_03.md) · [gabarito](simulado_03_gabarito.md) | integrador: V ou F, previsão numérica de SARIMA, identificação |
| [simulado_04.md](simulado_04.md) · [gabarito](simulado_04_gabarito.md) | opcional, as torções: sinal positivo, AR(2), sazonal trimestral |
| [simulado_05.md](simulado_05.md) · [gabarito](simulado_05_gabarito.md) | **o formato anunciado em 04/11**: 4 questões de 2,5, em 1 hora |
| [o_que_cai.md](o_que_cai.md) | o quadro do professor (04/11): as quatro questões prováveis, montar e desenhar a FAC, previsão, ciclo e interpretação de critérios |
| [log_erros.md](log_erros.md) | registro dos erros com revisão em +1, +3 e +7 dias |
| [prova.R](prova.R) | todos os números dos simulados e do banco (id `pv`) |
| [formulário](../formulario/formulario.md) | todas as fórmulas |

## 1. O mapa da prova

| Bloco (questões da lista) | O que pode cair | Resolução e demonstrações | Livros |
|---|---|---|---|
| 1. Processos e momentos (Q1–Q4) | momentos de passeio com drift e com tendência; soma de processos e FAC; Wold | [01_lista](../01_processos_estacionariedade/01_lista.md), D01.1–D01.4 | ENDERS cap. 4; HAMILTON cap. 3–4; MAT |
| 2. AR, MA e ARMA (Q5–Q8) | raízes, fator comum, $\psi_j$ e $\pi_j$; $\gamma_k$ do ARMA(1,1); Yule-Walker; V ou F | [02_lista](../02_arma/02_lista.md), D02.1–D02.5 | ENDERS cap. 2; HAMILTON cap. 3; BJRL cap. 3 |
| 3. Integrados, ARIMA e SARIMA (Q9–Q12) | sobrediferenciação; DS × TS; SAR e AR restrito; previsão de SARIMA | [03_lista](../03_arima_sarima/03_lista.md), D03.1–D03.4 | ENDERS cap. 2 e 4; BJRL cap. 4 e 9; MAT |
| 4. Estimação e seleção (Q13–Q14) | MV condicional = MQO; AIC e BIC com $k$ incluindo $\sigma^2$ | [04_lista](../04_estimacao_selecao/04_lista.md), D04.1 | HAMILTON cap. 5; AU02 |
| 5. Previsão (Q15) | previsor ótimo; erro MA($h-1$); intervalo; SES | [05_lista](../05_previsao/05_lista.md), D05.1 | HAMILTON cap. 4; BJRL cap. 5 |
| 6. Aplicação (Q16) | escrever o SARIMA, contar parâmetros, FAC de $w_t$, escolher entre modelos | [06_lista](../06_aplicacao_sarima/06_lista.md) | BJRL cap. 9; AU03 |

> [!IMPORTANT]
> **Notação: a do professor, que é a da lista**
> - Operador $B$; $a_t$, $\varepsilon_t$, $u_t\sim RB(0,\sigma^2)$; $\gamma_k$, $\rho_k$, $\phi_{kk}$; $\psi_j$, $\pi_j$; $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$.
> - **MA de Box-Jenkins**, $\theta(B)=1-\theta_1B-\cdots$, em quase toda a lista.
> - **Sinal positivo**, $1+\theta_1L+\cdots$, na Q8 e nos slides (AU02).
>
> Primeira linha de toda resposta com MA: "convenção: BJ" ou "convenção: sinal positivo". Ver [CONVENCOES](../CONVENCOES.md) §2.

## 2. Estratégia no dia

Com 110 minutos e 10 pontos, cada ponto vale **11 minutos**: uma questão de 1,5 merece até 16 minutos, e uma de 2,0, até 22.

1. **Leitura (3 min).** Percorra a prova e marque, em cada questão, a convenção do MA, o $T$, o $s$ e os valores críticos dados.
2. **Contas curtas primeiro (≈25 min).** AIC e BIC, observações perdidas, raízes, $\psi_1$ a $\psi_3$, $\gamma_0$ de fórmula pronta, previsões de 1 a 3 passos. São os pontos mais baratos, e foi justamente o que ficou em branco na P1 de Econometria I.
3. **Derivações (≈70 min), da mais curta para a mais longa.** Momentos do passeio → FAC de soma → ARMA(1,1) → previsor ótimo → previsão de SARIMA.
4. **Revisão (10 min).** Sinal do MA, $\psi_0=1$, $k$ com $\sigma^2$, a frase de conclusão de cada item.
5. **Se faltar tempo:** escreva a fórmula geral e a estrutura da conta. A rubrica dá ponto por passo.

### O que cada verbo pede

| Verbo | O que precisa aparecer |
|---|---|
| **Calcule** | fórmula geral → números → resultado com unidade ou interpretação |
| **Mostre / demonstre** | hipóteses usadas, uma justificativa por linha ([RB], estacionariedade, causalidade, LEI) e **a frase final com o que se pediu** |
| **Verifique** (estacionariedade, invertibilidade) | raízes ou desigualdades → "estão fora do círculo" → **"logo, é estacionário"** |
| **Discuta / compare** | duas ou três consequências concretas: estimação, previsão, inferência |
| **Julgue (V ou F)** | a conta que decide; "V" sem conta vale zero |
| **Identifique / proponha** | o padrão da FAC e da FACP que leva ao modelo e quantos parâmetros ele tem |

## 3. Os erros da P1 de Econometria I e o equivalente aqui

Na P1 de Econometria I (09/10/2026), os pontos se perderam na **execução**, não no conceito. Ver o log em `econometria/provas/log_erros.md` e o mapa da prova em `econometria/provas/p1_2026_2/README.md`. Cerca de 2,5 pontos ficaram em contas de uma linha deixadas em branco, e mais pontos em demonstrações que pararam antes da conclusão. Cada erro tem um gêmeo nesta prova:

| Erro na P1 de Econometria I | Causa | Onde reaparece aqui | Regra para 05/11 |
|---|---|---|---|
| Q1, Q3c e Q4b em branco: matriz diagonal, $F$ de uma linha, $340/85$ | **T** tempo | AIC e BIC (Q14), observações perdidas $d+sD$ (Q12, Q16), raízes de $\phi(z)$ e $\theta(z)$, $\psi_1$ a $\psi_3$, $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$ | **fazer primeiro** todo item de 1 a 3 linhas de conta |
| Q2d: efeito marginal 4,5% sem o termo $2\beta_3EXP$ | **A** número sem fórmula | $\rho_1$ do MA(1) com o sinal da convenção errada; $\gamma_0$ do ARMA(1,1) sem o termo $-2\phi\theta$; $\operatorname{Var}(e_T(h))$ sem $\psi_0=1$; $k$ sem $\sigma^2$; $a^2$ em vez de $a$ em $\gamma_{az}$ | **escrever a fórmula geral e a convenção** antes de pôr números |
| Q3c: rejeitou $H_0$ sem calcular $F$ | **E** passo pulado | Ljung-Box sem $\nu=K-p-q-P-Q$; LR sem $2(\ell_1-\ell_0)$ | todo teste em quatro linhas: $H_0$, estatística e distribuição, decisão, conclusão |
| Q5: Gauss-Markov parou em $\sigma^2\mathbf C\mathbf C'$ | **E** sem conclusão | "verifique se é estacionário" sem a frase final; Wold sem $\sum\psi_j^2\lt\infty$; previsor ótimo sem "logo, $g=E(\cdot\mid\mathcal F_T)$"; sobrediferenciação sem "raiz no círculo ⇒ não invertível ⇒ sem AR($\infty$)" | **reler o verbo** do enunciado e fechar com a frase que ele pede |
| Q4a: plim em branco por esquecimento | **E** resultado esquecido | ARMA(1,1): os momentos auxiliares $E(z_ta_t)$ e $E(z_ta_{t-1})$ | refazer de cabeça D02.2 e Q6 até sair em 8 minutos |
| (banco B12) covariância zerada sem citar a hipótese | **H** hipótese | FAC da soma sem "não correlacionados"; $E(a_ty_{t-k})=0$ sem "causalidade"; série geométrica sem $\lvert\phi\rvert\lt1$ | uma justificativa entre colchetes por linha |

> [!CAUTION]
> **As três armadilhas próprias desta prova**
> 1. **Trocar de convenção no meio da prova.** A lista faz isso na Q8. Na BJ, $\psi_1=\phi-\theta$; no sinal positivo, $\psi_1=\phi+\theta$.
> 2. **Confundir FAC e FACP.** No AR(2), $\phi_{22}=\phi_2$, mas $\rho_2\ne\phi_2$. No SAR(1)$_s$, a FAC decai em $s,2s,\dots$, e a FACP tem um pico só.
> 3. **Contar errado o que se perde e o que se estima.** Perdem-se $d+sD$ observações. Os parâmetros são $p+q+P+Q+1$ (o $\sigma^2$), mais a constante só se $d=D=0$ e houver média.

## 4. O mínimo para saber de cor

Tudo o mais se deriva disto em poucas linhas. Formulário completo em [formulario.md](../formulario/formulario.md).

| # | Resultado |
|---|---|
| 1 | Passeio com drift: $E=y_0+ct$, $\operatorname{Var}=t\sigma^2$, $\operatorname{Cov}=(t-k)\sigma^2$ |
| 2 | $\sum_{s=1}^ts=t(t+1)/2$ (drift com tendência; Q2 e Q8) |
| 3 | Processo linear: $\gamma_k=\sigma^2\sum_j\psi_j\psi_{j+k}$ |
| 4 | Estacionário ⇔ raízes de $\phi(z)$ fora do círculo; invertível ⇔ raízes de $\theta(z)$ fora |
| 5 | AR(2): $\phi_1+\phi_2\lt1$, $\phi_2-\phi_1\lt1$, $\lvert\phi_2\rvert\lt1$ |
| 6 | MA(1), BJ: $\rho_1=-\theta/(1+\theta^2)$; com sinal positivo, troque o sinal |
| 7 | ARMA(1,1), BJ: $\gamma_0=\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\sigma^2$, $\rho_1=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}$, $\rho_k=\phi\rho_{k-1}$ |
| 8 | Pesos do ARMA(1,1), BJ: $\psi_j=(\phi-\theta)\phi^{j-1}$, $\pi_j=(\phi-\theta)\theta^{j-1}$ |
| 9 | Yule-Walker: $\rho_k=\sum\phi_i\rho_{k-i}$; $\gamma_0=\sigma^2/(1-\sum\phi_i\rho_i)$; $\phi_{22}=\frac{\rho_2-\rho_1^2}{1-\rho_1^2}$ |
| 10 | Sobrediferenciação: $\phi(B)\Delta y=(1-B)\theta(B)\varepsilon$; RB diferenciado tem $\rho_1=-\frac12$; AR(1) diferenciado tem $\rho_1=-\frac{1-\phi}{2}$ |
| 11 | SAR(1)$_s$: $\rho_{ms}=\Phi^m$, zero fora dos múltiplos; $(1-\phi B)(1-\Phi B^s)$ tem o termo $+\phi\Phi B^{s+1}$ |
| 12 | Modelo das companhias aéreas: $\rho_1=\frac{-\theta}{1+\theta^2}$, $\rho_s=\frac{-\Theta}{1+\Theta^2}$, $\rho_{s\pm1}=\frac{\theta\Theta}{(1+\theta^2)(1+\Theta^2)}$ |
| 13 | MV condicional do AR(1) = MQO: $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$ |
| 14 | $AIC=-2\ln L+2k$, $BIC=-2\ln L+k\ln T$ (a AU02 divide por $T$); $LR=2(\ell_1-\ell_0)\sim\chi^2(r)$ |
| 15 | Previsão: $e_T(h)=\sum_{j=0}^{h-1}\psi_ja_{T+h-j}$, $\operatorname{Var}=\sigma^2\sum_{j=0}^{h-1}\psi_j^2$, IC: $y_{T+h\mid T}\pm1{,}96\sqrt{\operatorname{Var}}$ |
| 16 | ARIMA(0,1,1) = SES com $\alpha=1-\theta$ |
| 17 | Ljung-Box: $\nu=K-p-q-P-Q$ |

## 5. Plano até a prova

### Como atacar a lista

1. **Não comece pela Q1. Comece pelo bloco 2 (Q5–Q8).** É o que mais pesa e é a base dos outros: raízes, $\psi$ e $\pi$, $\gamma_k$, Yule-Walker. A ordem é bloco 2 → 1 → 3 → 5 → 4 → 6, a mesma da [apostila](../apostila/README.md).
2. **Por questão, um ciclo de quatro passos**, sem ler a resolução antes:
   1. **Ler e marcar:** a convenção do MA (BJ ou sinal positivo), $s$, $T$ e o verbo de cada item.
   2. **Tentar sozinho, de 10 a 15 minutos, no papel,** mesmo travando. Pergunte-se qual ferramenta resolve (F1–F9).
   3. **Comparar com a folha à mão, linha a linha.** Ache a **primeira linha** em que você divergiu e anote no [log](log_erros.md), com o código.
   4. **No dia seguinte, refazer sem olhar**, usando só a "Versão para a prova" da folha como roteiro.
3. **A apostila serve para destravar, não para ler antes.** Quando travar, leia só a pergunta de abertura e a imagem do capítulo. Faça a cadeia socrática **cobrindo as respostas**. A teoria e as demonstrações gerais ficam para depois da tentativa.
4. **Treine os cinco moldes, não as 16 questões.** Se o molde sai de cabeça, a questão sai.

   | Molde | Questões |
   |---|---|
   | (a) somar de 1 a $t$ (telescópica), depois $E$ e $\operatorname{Var}$ da soma | Q1, Q2, Q8 (II), Q10 (c, d) |
   | (b) multiplicar pelo passado e tirar a esperança | Q3, Q6, Q7, Q8 (I), Q11 |
   | (c) raízes por Bhaskara e pesos por igualdade de coeficientes | Q5, Q6 (c), Q9, Q10 (b), Q11 (c) |
   | (d) esperança condicional com as três regras [F9] | Q12 (c), Q15 |
   | (e) contas de critério: AIC/BIC, LR, Ljung-Box, $d+sD$, parâmetros | Q14, Q16, Q12 (b) |

5. **Q2 e Q6, as questões escolhidas para fazer à mão:** copie a folha completa **uma vez**, depois refaça de cabeça em +1 e +3 dias, cronometrando. Metas: Q2 em até 12 minutos e Q6 em até 15.
6. **O mínimo de cor** (§4): escreva numa folha A4, de memória, a cada dois dias. O que faltar entra no log.
7. **No dia, as lições da P1 de Econometria I** (§3):
   - contas curtas primeiro;
   - fórmula geral e convenção antes dos números;
   - uma justificativa por linha;
   - fechar com a frase que o verbo pede.

### O ciclo de 29/10 a 05/11

Cerca de 2h30 a 3h por dia; os simulados levam 1h50 mais 40 minutos de correção. Revisões do log em +1 e +3 dias. No papel, tudo está no volume único `caderno_p1_completo.pdf`, e o mapa das questões na abertura dá as páginas.

| Dia | Foco | Tarefas |
|---|---|---|
| qui 29/10 | bloco 2 (Q5–Q8) | ciclo dos quatro passos em Q5, Q7 e Q8; **copiar a folha completa da Q6**; cadeia socrática do cap. 2 |
| sex 30/10 | bloco 1 (Q1–Q4) | ciclo em Q1, Q3 e Q4; **copiar a folha completa da Q2**; Q6 de cabeça, cronometrada (+1) |
| sáb 31/10 | blocos 3 e 5 (Q9–Q12, Q15) | ciclo nas cinco questões; Q2 de cabeça (+1); refazer os erros do log de 29/10 (+1) |
| dom 01/11 | diagnóstico | **Simulado 01** cronometrado, correção pela rubrica e log; blocos 4 e 6 (Q13, Q14, Q16) pelo molde (e) |
| seg 02/11 | guia, à noite | questões-tipo 4, 7, 8 e 9 do [guia](nao_posso_errar.md); ver a reta final, hora a hora, abaixo |
| ter 03/11 | o dia todo | **Simulado 02 às 10h**, no horário da prova; correção pelo guia; ver abaixo |
| qua 04/11 | aula e noite | dúvidas ao professor às 10h; à noite, só consolidação; ver abaixo |
| **qui 05/11** | **prova às 10h** | ver abaixo |

O Simulado 01 foi feito em 01/11, e a [correção](correcao_simulado_01.md) mostra onde os pontos foram embora. O Simulado 03 completo saiu do plano: não há tempo, e cansaria na véspera. Dele, ficam só as contas, na terça.

Se sobrar tempo num dia, use o [banco](banco.md) do bloco do dia: cada questão tem uma variação curta com resposta.

### A reta final, hora a hora (02/11 a 05/11)

A versão de uma página, para imprimir e deixar à vista, é `caderno_plano_reta_final.pdf`, na pasta `caderno/pdf/`.

A lógica é **aprender pelo [guia](nao_posso_errar.md), testar no [Simulado 02](simulado_02.md) no mesmo horário da prova, corrigir pelo guia e consolidar sem matéria nova**. Em cada questão-tipo, o método é sempre o mesmo:
1. ler o enunciado-tipo e o "Antes de escrever";
2. **cobrir o resto e tentar no papel**;
3. conferir linha a linha e, na primeira linha diferente, ler o sentido dela.

**Segunda, 02/11, das 20h30 às 23h: as quatro questões-tipo que mais valem.**

| Hora | O quê |
|---|---|
| 20h30–20h45 | [básico](basico.md), camadas 1 e 2, só leitura |
| 20h45–21h30 | **questão-tipo 4, ARMA(1,1)**, a que travou no S1 |
| 21h30–21h40 | pausa |
| 21h40–22h10 | questões-tipo 7 (AIC, BIC e MQO) e 8 (previsão) |
| 22h10–22h30 | questão-tipo 9 (SARIMA) |
| 22h30–22h50 | **questão-tipo 4 de novo, em folha branca, em até 15 minutos** |
| 22h50–23h | o que errou vai para o [log](log_erros.md); dormir. **Não abrir o S2** |

**Terça, 03/11: aprender, testar e corrigir.**

| Hora | O quê |
|---|---|
| 8h30–8h50 | camadas 1 e 2 do básico **de memória**, numa folha; conferir |
| 8h50–9h50 | questões-tipo 6, 2 e 3, cobrindo e tentando |
| 9h50–10h | pausa |
| **10h–11h50** | **Simulado 02 em modo prova**: 3 min de leitura; 25 min de contas curtas; derivações; frase de fecho em cada item |
| 12h–13h30 | almoço e descanso |
| 13h30–14h30 | correção pelo [gabarito](simulado_02_gabarito.md), por passo; log; coluna S2 do placar |
| 14h30–16h | **cada item com perda**: a questão-tipo de mesmo número no guia, o sentido das linhas que faltaram, e o item refeito em folha branca |
| 16h–16h15 | pausa |
| 16h15–17h15 | questões-tipo 5 e 1, cobrindo e tentando |
| 17h15–18h | [Simulado 03](simulado_03.md), **só as contas**: Q3 c), Q4 b)–c) e Q5 a)–b) |
| 18h–19h30 | jantar e descanso |
| 19h30–20h30 | **questão-tipo 4 de cabeça** (+1 dia) e S1 Q2 de cabeça; conferir |
| 20h30–21h | as **9 frases de fecho** de memória; conferir no guia |
| 21h–21h30 | a lista de dúvidas para o professor (abaixo), com as que o S2 levantou |
| 21h30 | parar |

**Quarta, 04/11: aula, professor e a última consolidação.** Revisto depois do quadro do professor; a versão completa está na [folha do que cai](o_que_cai.md#7-a-noite-de-quarta-e-a-manhã-de-quinta).

| Hora | O quê |
|---|---|
| 10h, aula | o professor anunciou o formato: 4 × 2,5 (ver o topo) |
| 18h–19h | chegar, comer, descansar; nada de matéria |
| 19h–19h20 | ler a [folha do que cai](o_que_cai.md) |
| 19h20–20h20 | **[Simulado 05](simulado_05.md)**, 4 × 2,5, em 1 hora |
| 20h20–20h40 | correção pelo [gabarito](simulado_05_gabarito.md) |
| 20h40–21h20 | refazer cada item com perda, pelo guia e pela folha |
| 21h20–21h50 | desenhar de memória FAC e FACP dos seis padrões; as frases de fecho |
| **até 22h30** | **parar e dormir** |

**Fica de fora a partir de agora:** Yule-Walker (riscado no quadro), o Simulado 04, a verossimilhança exata, os testes de raiz unitária, Beveridge-Nelson, a avaliação de previsões e o trabalho do INPC.

**Quinta, 05/11, prova às 10h.**
- Acordar às 7h. Às 8h, 15 minutos: o básico, os quatro movimentos do ARMA e a ordem da prova.
- **Na prova:**
  1. 3 minutos de leitura, marcando a convenção do MA, o $T$ e o $s$;
  2. cerca de 25 minutos só de contas curtas;
  3. as derivações, da mais curta para a mais longa;
  4. a frase de fecho em cada item.

### Dúvidas para o professor (quarta, 04/11)

1. **Sinal do MA:** a prova usa o $1-\theta B$ da lista ou o $1+\theta_1L$ dos slides? Basta declarar a convenção na primeira linha?
2. **AIC e BIC:** na forma do R ($-2\ln L+2k$) ou na da AU02, dividida por $T$? O $k$ inclui o $\sigma^2$?
3. **"Mostre que":** os momentos do ARMA(1,1) precisam ser derivados pelos momentos auxiliares, ou pode-se partir da fórmula de $\gamma_0$?
4. **SARIMA:** pode cair o cálculo da FAC multiplicativa (pico e satélites), ou basta escrever o modelo e contar parâmetros?
5. **Consulta:** a prova é sem consulta? Os valores de $\chi^2$ e da normal vêm no enunciado?
6. As dúvidas que o Simulado 02 levantar na terça.

## Os simulados

O **Simulado 02** é diferente dos outros: tem **9 questões, uma por questão-tipo** do [guia "não posso errar"](nao_posso_errar.md), na mesma ordem, e testa só o básico que não se pode errar. Cada item travado manda de volta à questão-tipo de mesmo número.

Os Simulados 01, 03 e 04 têm 6 questões (uma por bloco). Todos somam 10,0 pontos e cabem em 1h50 com 10 minutos de revisão. Os números não se repetem entre simulados, nem com o banco, nem com o guia.

| Bloco | Simulado 01 | Simulado 03 | Simulado 04 (opcional) |
|---|---|---|---|
| 1. Processos | passeio sem drift e soma de processos | TS × DS | processo harmônico; MA(1) com par não invertível |
| 2. ARMA | ARMA(1,1), BJ | V ou F do ARMA(1,1) com sinal positivo | AR(2) completo |
| 3. ARIMA e SARIMA | AR(1) sobrediferenciado | previsão numérica do SARIMA$(1,1,0)(0,1,1)_4$ | SAR(1)$_4$, AR(5) restrito, ARIMA(1,1,1) |
| 4. Estimação | AIC/BIC com $T=200$; MV condicional | AIC, BIC e LR entre SARIMA | AIC/BIC da AU02, LR, MV exata |
| 5. Previsão | AR(1) com média e o previsor ótimo | MA(2): previsão e memória | ARMA(1,1) com sinal positivo; SES |
| 6. Aplicação | modelo das companhias aéreas | identificação pela FAC amostral | SARIMA$(1,0,0)(0,1,1)_{12}$ e Ljung-Box |
