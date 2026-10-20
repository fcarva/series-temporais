---
title: "Módulo 03 — Processos integrados, ARIMA e SARIMA (teoria)"
modulo: "03"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
aulas: "AU01, AU02, MAT §1–2"
lista: [9, 10, 11, 12]
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - ARIMA e SARIMA — teoria
---

# Módulo 03 — Processos integrados, ARIMA e SARIMA

> [!NOTE]
> **Mapa do módulo**
> Processo integrado e raiz unitária → TS × DS → sobrediferenciação → testes de raiz unitária (ADF, KPSS) → sazonalidade: SAR, SMA, multiplicativo, $(1-B^s)$ → previsão de SARIMA. Cai como Q9–Q12. No [INPC](../trabalho_inpc/relatorio.md), decide que o log do índice é I(1) e a variação mensal é I(0).

## 1. Integração

$y_t\sim I(d)$ quando $\Delta^dy_t$ é estacionário e invertível, mas $\Delta^{d-1}y_t$ não é. O ARIMA($p,d,q$) escreve-se

$$
\phi(B)(1-B)^dy_t=c+\theta(B)a_t .
$$

O polinômio AR completo, $\phi(B)(1-B)^d$, tem $d$ raízes **sobre** o círculo unitário, em $z=1$.

### D03.1 · Raiz unitária ⇔ choques permanentes

> [!NOTE]
> **O que se quer provar**
> Se $\Delta y_t=\psi(B)\varepsilon_t$, com $\sum\lvert\psi_j\rvert\lt\infty$, então um choque $\varepsilon_t$ muda $\lim_{h\to\infty}E(y_{t+h}\mid\mathcal F_t)$ em $\psi(1)=\sum_j\psi_j$. Num processo estacionário, essa mudança é zero.

**Passo a passo.**

1. $y_{t+h}=y_{t-1}+\sum_{i=0}^{h}\Delta y_{t+i}$. O efeito de $\varepsilon_t$ sobre $\Delta y_{t+i}$ é $\psi_i$.

2. Logo $\partial y_{t+h}/\partial\varepsilon_t=\sum_{i=0}^{h}\psi_i\to\psi(1)$.

3. Num processo estacionário $y_t=\psi(B)\varepsilon_t$, o efeito é $\psi_h\to0$.

$$\boxed{\text{efeito de longo prazo}=\psi(1)\ \text{(DS)}\quad\text{vs.}\quad 0\ \text{(TS)}}$$

$\psi(1)$ é a "persistência" e é a base da decomposição de Beveridge e Nelson (MAT §1.6).

### D03.2 · Sobrediferenciação cria raiz unitária no MA

> [!NOTE]
> **O que se quer provar**
> Se $\phi(B)y_t=\theta(B)\varepsilon_t$ é estacionário, então $w_t=\Delta y_t$ satisfaz $\phi(B)w_t=(1-B)\theta(B)\varepsilon_t$, que é não invertível.

**Passo a passo.**

1. Aplique $(1-B)$ dos dois lados. Os polinômios em $B$ comutam: $\phi(B)(1-B)y_t=(1-B)\theta(B)\varepsilon_t$.

2. O novo polinômio MA, $(1-B)\theta(B)$, tem raiz $z=1$, logo não tem inversa somável.

3. Consequência: $\rho_1(w)\lt0$. No caso $y\sim$ RB, $\rho_1(w)=-1/2$.

$$\boxed{\phi(B)\,\Delta y_t=(1-B)\,\theta(B)\,\varepsilon_t}$$

## 2. Testes de raiz unitária

Regressão de Dickey-Fuller aumentada:

$$
\Delta y_t=\alpha+\beta t+\gamma y_{t-1}+\sum_{i=1}^{k}\delta_i\Delta y_{t-i}+e_t .
$$

O teste é $H_0:\gamma=0$ (raiz unitária) vs. $H_1:\gamma\lt0$, pela estatística $\tau=\widehat\gamma/ep(\widehat\gamma)$.

> [!WARNING]
> **Os críticos não são os da $t$ de Student**
> Sob $H_0$, $\tau$ tem a distribuição de Dickey-Fuller, que é assimétrica e depende de haver constante e/ou tendência. Os críticos de 5% são −1,95 (sem determinísticos), −2,86 (constante) e −3,41 (constante e tendência), com pequenas variações por $T$.
>
> A especificação certa importa. Use **tendência** se a série tem tendência sob a alternativa; caso contrário, o teste perde poder.

**KPSS:** as hipóteses são invertidas, com $H_0$ = estacionária (em nível ou em tendência). A leitura padrão é cruzar os dois: ADF não rejeita e KPSS rejeita aponta I(1); ADF rejeita e KPSS não rejeita aponta I(0).

## 3. Sazonalidade

| Componente | Polinômio | Quem cuida |
|---|---|---|
| AR sazonal | $\Phi(B^s)=1-\Phi_1B^s-\dots-\Phi_PB^{Ps}$ | estacionariedade sazonal |
| MA sazonal | $\Theta(B^s)=1-\Theta_1B^s-\dots-\Theta_QB^{Qs}$ | invertibilidade sazonal |
| Diferença sazonal | $(1-B^s)^D$ | raiz unitária sazonal |

O SARIMA$(p,d,q)(P,D,Q)_s$ é

$$
\phi(B)\Phi(B^s)(1-B)^d(1-B^s)^Dy_t=\theta(B)\Theta(B^s)a_t .
$$

O modelo é **multiplicativo**: o produto dos polinômios gera termos cruzados com coeficientes restritos. Um exemplo é $\phi\Phi$ em $B^{s+1}$ (Q11c).

> [!TIP]
> **Sazonalidade determinística vs. estocástica**
> $(1-B^s)$ supõe raiz unitária sazonal: o padrão sazonal muda de forma permanente com os choques. Se o padrão é fixo, as dummies sazonais são o modelo certo.
>
> O sintoma de ter diferenciado sem precisar é $\widehat\Theta_1\approx1$. O sintoma de um SARMA estar imitando dummies é $\widehat\Phi_1$ perto de 1 com $\widehat\Theta_1\approx-\widehat\Phi_1$. É o que aparece no INPC (relatório, §3).

![SAR(1)4](figuras/m03_q11_sar4.png)

## 4. Checklist

- [ ] Explico TS × DS por memória dos choques, variância e previsão.
- [ ] Mostro que diferenciar uma série estacionária cria raiz unitária no MA.
- [ ] Escrevo a regressão ADF, as hipóteses e por que os críticos não são os da $t$.
- [ ] Calculo $\gamma_k$ de um SAR(1)$_s$ e reconheço a FAC/FACP.
- [ ] Expando um SARIMA e escrevo $\widehat y(h)$ para $h$ dentro e fora do alcance do MA.
