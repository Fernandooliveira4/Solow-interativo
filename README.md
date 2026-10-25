# Solow interativo

Simulador do modelo de crescimento de Solow, em HTML puro (basta abrir `solow.html` no navegador).

- **Três versões do modelo:** básico (Y = K^α L^(1−α)), com tecnologia (Y = K^α (AL)^(1−α)) e com capital humano acumulado como o capital físico (Y = K^α H^β (AL)^(1−α−β), como no Acemoglu, cap. 3).
- **Diagrama:** s·f(k) contra a reposição, ou diagrama de fases (k, h) na versão com capital humano, com o ponto de partida, o novo estado estacionário e a meia-vida da transição.
- **Regra de ouro:** consumo de estado estacionário para cada taxa de poupança.
- **Convergência:** dois países com a mesma tecnologia partindo de níveis de capital diferentes (convergência absoluta e condicional).
- **Teoria:** o seletor *Simulador | Teoria* no topo abre um resumo do modelo (ideia central, hipóteses, equações, as três versões, resultados, limitações e referências), com base no Acemoglu, caps. 2 e 3. O endereço terminado em `#teoria` abre direto nessa aba.

## Versões

Cada versão salva recebe um número (v1.0.0, v1.0.1, v1.1.0…) e fica registrada no [CHANGELOG](CHANGELOG.md) e na aba *Tags* do GitHub.

- **Salvar uma versão:** depois de alterar algum arquivo, dê dois cliques em `salvar-versao.bat`. Ele mostra o que mudou, pergunta o tipo de mudança e uma descrição, e envia tudo para o GitHub.
  - 1 = pequena correção → v1.0.**1**
  - 2 = novidade → v1.**1**.0
  - 3 = mudança grande → v**2**.0.0
- **Ver uma versão antiga:** dê dois cliques em `abrir-versao.bat` e escolha a versão. Ela é aberta na pasta `versoes-antigas`, sem mexer nos arquivos atuais. Para voltar a ela, copie os arquivos de lá por cima dos atuais e salve uma versão nova.
