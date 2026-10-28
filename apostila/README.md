---
title: "Apostila da P1 — séries temporais pela lista teórica (Q1–Q16)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila da P1
---

# Apostila da P1: entender a fundo, na notação do professor

A prova de 05/11 tem de 5 a 6 questões teóricas tiradas da lista "Processos ARMA, ARIMA e SARIMA". Esta apostila reúne, **um capítulo por bloco da lista**:
- a aula, com a página do slide;
- o livro, pelo capítulo;
- as demonstrações completas, linha a linha;
- um exemplo com números conferidos em R.

Ela acrescenta duas coisas que o material não tem: **perguntas em cadeia e um diálogo** (o lado socrático) e **imagens** (metáforas e analogias), cada uma com o ponto onde deixa de valer.

| Capítulo | Questões | Aulas | Ideia central |
|---|---|---|---|
| [1 · Processos e momentos](cap1_processos_momentos.md) | Q1–Q4 | AU01, MAT, EQD, AU02 p. 15–23 | o que é "estável" numa série: momentos, passeio, Wold |
| [2 · AR, MA e ARMA](cap2_ar_ma_arma.md) | Q5–Q8 | AU02 | memória (AR), eco (MA) e a reconstrução dos choques (invertibilidade) |
| [3 · Integrados, ARIMA e SARIMA](cap3_integrados_sarima.md) | Q9–Q12 | AU01 p. 28–30, MAT, AU05 | raiz unitária, diferença na dose certa, sazonalidade |
| [4 · Estimação e seleção](cap4_estimacao_selecao.md) | Q13–Q14 | AU02 p. 58–99 | verossimilhança, Yule-Walker, AIC e BIC |
| [5 · Previsão](cap5_previsao.md) | Q15 | AU02 p. 44–57 e 72–85, AU03 | a previsão como esperança condicional e o erro que cresce |
| [6 · Aplicação: SARIMA mensal](cap6_aplicacao.md) | Q16 | AU02 p. 96–99, AU03 | Box-Jenkins de ponta a ponta |

## Como estudar um capítulo

As nove seções têm sempre a mesma ordem, e a ordem é o método:

1. **Pergunta de abertura.** Responda de cabeça, mesmo errado. É o "não sei" que faz o resto grudar.
2. **A imagem.** A metáfora do tema e, numa caixa, **onde a analogia quebra**. Os limites da imagem ensinam tanto quanto ela.
3. **Teoria.** Os resultados, com a página da aula. É o que se cita na prova.
4. **Demonstrações.** Copie no papel, linha a linha, como na [folha à mão](../lista_comentada/a_mao_q02_q06.md). Depois refaça sem olhar.
5. **Exemplo.** Os números que dão corpo à fórmula, todos conferidos em R.
6. **Cadeia socrática.** Cubra a caixa de resposta e responda primeiro. Cada pergunta prepara a seguinte.
7. **Diálogo.** O erro mais comum do tema, encenado: o aluno erra, e o professor conduz por perguntas.
8. **Na prova.** As questões da lista, as armadilhas e um checklist de 30 segundos.
9. **No material do professor.** O roteiro de releitura dos slides, na ordem, e o livro.

**Ordem sugerida até 05/11**, pelo peso na prova: cap. 2, depois 1, 3, 5, 4 e 6. A cada capítulo, faça as questões correspondentes da [lista comentada](../lista_comentada/README.md) e, no fim, os [simulados](../prova/README.md).

## Notação

Tudo segue os **slides**: $L$, $\varepsilon_t\sim RB(0,\sigma^2)$, $\phi(L)=1-\phi_1L-\cdots$, $\theta(L)=1+\theta_1L+\cdots$ (sinal positivo), $\Omega_t$ e $\widehat y_{t+k/t}$. Cada capítulo termina a teoria com a **tradução para a lista**, que usa $B$ e o sinal de Box-Jenkins: $\theta_1=-\theta^{\text{lista}}$. A esperança vem com parênteses, $E(\cdot)$, como no resto do repositório; os slides usam colchetes.

As justificativas entre colchetes nas demonstrações:
- [RB]: ruído branco;
- [F4]: linearidade da esperança;
- [estac.]: estacionariedade;
- [caus.]: causalidade.

As ferramentas F1–F9 (Bhaskara, série geométrica, soma de Gauss…) estão demonstradas na [caixa de ferramentas](../lista_comentada/README.md#2-caixa-de-ferramentas).

## De onde vêm as imagens e as perguntas

A didática foi calibrada pelo melhor material aberto de séries temporais: Hyndman e Athanasopoulos, Penn State, Duke, Northwestern, MIT e as discussões clássicas do Cross Validated. O registro do que inspirou cada seção está em [fontes.md](fontes.md). **O conteúdo, a notação e as páginas citadas são sempre os do professor**: as fontes externas só ajudaram a escolher as imagens e a ordem das perguntas.

Os números estão em [apostila.R](apostila.R) (id `ap`) e são conferidos pelo build. O loop do [autoestudo](../autoestudo/program.md#modo-apostila-p1-de-0511) mede cada capítulo pela [régua da apostila](../autoestudo/apostila_rubrica.tsv).
