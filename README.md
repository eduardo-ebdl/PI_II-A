# PI_II-A
Projeto Integrador II-A - PUCGO - Análise Preditiva para detecção de padrões em grande volume de dados

# Projeto de Recomendação de Culturas Agrícolas

## INTRODUÇÃO 

A crescente demanda global por alimentos exige métodos mais inteligentes e eficientes de cultivo. Nesse contexto, a agricultura de precisão se destaca por utilizar dados e tecnologias para otimizar a produção, considerando variáveis como solo, clima e umidade.  
Com o avanço na coleta e análise de dados, é possível integrar informações de sensores, clima e irrigação para gerar recomendações personalizadas aos agricultores. Isso melhora a produtividade, reduz custos operacionais e minimiza impactos ambientais.  
Este projeto propõe o uso de um modelo preditivo para recomendar as culturas mais adequadas com base nas condições do solo e clima. A análise é feita a partir do dataset **Crop Recommendation**, que contém dados como proporções de nitrogênio, fósforo e potássio no solo, pH, temperatura, umidade e precipitação — fatores essenciais na escolha e no sucesso das culturas agrícolas.

## JUSTIFICATIVA DO PROJETO

O crescimento populacional e a alta demanda por alimentos pressionam a agricultura a ser mais produtiva e sustentável. Diante desse cenário, é essencial adotar tecnologias que otimizem o uso de recursos naturais e reduzam impactos ambientais.  
A agricultura de precisão responde a essa necessidade ao integrar dados sobre solo, clima e precipitação, oferecendo uma base mais científica para a escolha de cultivos. No entanto, essa escolha ainda é muitas vezes feita com base em experiências locais, o que pode limitar a eficiência.  
Este projeto se justifica pela necessidade de apoiar agricultores com uma ferramenta baseada em dados e aprendizado de máquina, capaz de recomendar culturas ideais para cada tipo de solo e clima. Com isso, é possível antecipar problemas, otimizar recursos e aumentar a produtividade.  
Ao unir Big Data e inteligência artificial, o projeto promove uma agricultura mais eficiente, sustentável e alinhada aos desafios ambientais e produtivos do futuro.

## DESCRIÇÃO DO DATASET

O dataset utilizado neste projeto reúne dados sobre condições do solo e clima, com o objetivo de recomendar cultivos mais adequados para diferentes regiões. Os dados foram originalmente coletados na Índia e estavam em inglês; por isso, todos os nomes de variáveis e descrições foram traduzidos para o português, com o intuito de facilitar a compreensão e adaptação ao contexto local.

**Variáveis originais:**

- **N**: Proporção de Nitrogênio no solo (%). Essencial para o crescimento das plantas e produtividade agrícola.
- **P**: Proporção de Fósforo (%). Importante para raízes fortes e fotossíntese eficiente.
- **K**: Proporção de Potássio (%). Atua na regulação hídrica e resistência a estresses ambientais.
- **temperature**: Temperatura média (°C). Fator determinante no ciclo de vida das culturas.
- **humidity**: Umidade relativa do ar (%). Influencia a transpiração e saúde radicular das plantas.
- **ph**: pH do solo. Controla a disponibilidade de nutrientes às plantas.
- **rainfall**: Precipitação (mm). Indica a disponibilidade natural de água na região.
- **label**: Cultura recomendada com base nas variáveis acima (ex: arroz, milho, trigo etc.).

**Variáveis adicionais criadas:**

Além das variáveis originais, o dataset foi enriquecido com novas colunas criadas durante a análise:

- **indice_sucesso**: Estimativa de quão ideais são as condições para a cultura recomendada.
- **tipo_cultura**: Agrupa as culturas por categoria, facilitando análises por famílias agrícolas.
- **tipo_solo**: Tipo de solo predominante.
- **solo_nutrientes**: Classificação qualitativa do nível de nutrientes (NPK).
- **tipo_temperatura**: Faixa categorizada da temperatura.

## MÉTODOS E FERRAMENTAS APLICADAS PARA ANÁLISE

Este projeto foi desenvolvido em etapas bem definidas, com foco em garantir a eficácia do modelo preditivo. A abordagem abrange a construção de um pipeline ETL, o pré-processamento dos dados, a análise exploratória e a aplicação de modelos de aprendizado de máquina para recomendar cultivos com base nas condições do solo e do clima.

### Pipeline ETL

A primeira etapa consistiu na implementação de um pipeline ETL para carregar, transformar e armazenar os dados em um ambiente escalável. Os dados, originalmente em inglês, foram traduzidos e adaptados para o português, visando facilitar o uso e a análise.

- **Extração (Extract)**: Utilizamos Python para a extração dos dados e inseri-los em um banco de dados PostgreSQL hospedado na plataforma Railway.
- **Transformação (Transform)**: Realizamos limpeza, padronização, conversão de tipos, normalização de variáveis e criação de novas colunas, assegurando a integridade e qualidade dos dados.
- **Carregamento (Load)**: Os dados transformados foram carregados e armazenados de forma otimizada no PostgreSQL, prontos para análise no R e em outras ferramentas.

### Pré-processamento e Análise Exploratória

Após a estruturação dos dados, realizamos o pré-processamento e a análise exploratória para entender padrões e preparar os dados para o modelo.

- **Pré-processamento**: Utilizamos R para tratar valores nulos, substituir dados ausentes por médias ou medianas, e normalizar variáveis como temperatura, pH e umidade.
- **Análise Exploratória**: Realizada em R, utilizando bibliotecas como `ggplot2` e `corrplot`, com foco em identificar padrões, correlações e outliers. Destacam-se gráficos de dispersão e matrizes de correlação.

### Modelagem Preditiva

Com os dados preparados, partimos para o treinamento do modelo de aprendizado de máquina:

- **Algoritmo escolhido**: Random Forest, por sua robustez, capacidade de lidar com variáveis interdependentes e boa performance em tarefas de classificação.
- **Treinamento**: Utilizamos o pacote `randomForest` no R, com os seguintes atributos como entrada: Nitrogênio, Fósforo, Potássio, temperatura, umidade, pH e precipitação. A acurácia da previsão da cultura recomendada foi usada como métrica principal de avaliação.

### Visualizações e Interpretação

Para facilitar a interpretação dos resultados:

- **Visualização de Variáveis**: Criamos gráficos de dispersão, histogramas e boxplots que mostram a influência de variáveis como umidade e pH na recomendação dos cultivos.
- **Resultados do Modelo**: Foram gerados gráficos de importância das variáveis para entender os principais fatores que influenciam as decisões do modelo.
- **Dashboard Interativo**: Desenvolvido com o pacote `Shiny`, o painel permite ao usuário inserir eixos nos gráficos para uma visualização mais interativa em tempo real.

## RESULTADOS OBTIDOS

Após a construção do pipeline de dados, o pré-processamento e a aplicação do modelo de aprendizado de máquina, foram obtidos resultados expressivos na recomendação de culturas agrícolas com base nas condições do solo e do clima. A seguir, destacamos os principais resultados alcançados:

- **Acurácia do Modelo**  
  O modelo Random Forest atingiu uma acurácia superior a 97% na previsão da cultura ideal para cada conjunto de variáveis ambientais. Esse desempenho foi validado por meio de uma divisão estratificada entre dados de treino e teste, garantindo maior confiabilidade na capacidade de generalização do modelo.

- **Criação de Novas Métricas e Categorias**  
  Durante o processo de transformação dos dados, foram criadas novas colunas, e outras foram traduzidas para o português, com o objetivo de enriquecer a análise e permitir uma visão mais estratégica.

  **Novas colunas**:
  - **indice_sucesso**: Avalia o quão próximas as condições estão do ideal para determinada cultura, permitindo identificar regiões com alto potencial de produtividade.
  - **tipo_cultura**: Agrupa as culturas por categoria, facilitando análises por famílias agrícolas.
  - **tipo_solo**: Permite reconhecer padrões regionais de solo associados a diferentes cultivos.
  - **solo_nutrientes** e **tipo_temperatura**: Classificam as condições gerais de fertilidade e clima, auxiliando na segmentação das recomendações.

- **Visualizações e Insights Gerados**  
  Foram criadas algumas visualizações estatísticas que auxiliaram na interpretação dos dados e na identificação de padrões relevantes:
  - Gráficos de dispersão entre variáveis como N, P e K, comparando seus valores com as culturas recomendadas.
  - Histogramas simples para analisar a distribuição de variáveis como N, P, K e PH.
  - Gráficos de importância das variáveis gerados a partir do modelo Random Forest, destacando os fatores que mais influenciam na recomendação de culturas.
  - Gráfico de linha para observar tendências em variáveis contínuas, como variações de temperatura ou umidade em determinados contextos.

Essas visualizações forneceram insights úteis sobre a relação entre as condições ambientais e o cultivo ideal, mesmo sem a geração de análises visuais mais avançadas como mapas de calor ou boxplots.

## CONCLUSÕES

Este projeto demonstrou o potencial da aplicação de Big Data e aprendizado de máquina na agricultura de precisão. Com base em dados históricos de solo e clima, foi possível recomendar culturas ideais com alta acurácia, contribuindo para o uso racional dos recursos naturais e o aumento da produtividade agrícola.  
A construção de um pipeline ETL com PostgreSQL permite armazenar e organizar os dados de forma eficiente. O uso combinado de Python e R possibilitou um fluxo completo de tratamento, análise e visualização. O modelo Random Forest se destacou pela precisão nas previsões, mesmo diante de múltiplas variáveis interdependentes.  
A criação de colunas como o índice de sucesso agregou valor à interpretação dos dados, permitindo avaliar a adequação ambiental de cada região para determinada cultura. Além disso, foi desenvolvido um dashboard com Shiny para visualização interativa dos padrões encontrados no conjunto de dados. Embora não execute previsões em tempo real, a ferramenta se mostrou útil para análise exploratória.  
O projeto reforça que soluções baseadas em dados têm grande potencial para transformar o setor agrícola, tornando-o mais inteligente, sustentável e eficiente.

Desenvolvido por [Eduardo Batista de Lima](https://www.linkedin.com/in/eduardobdlima) e [Victor Castro Silva](https://www.linkedin.com/in/victorcsil)  
Curso [Big Data e Inteligência Artificial](https://www.pucgoias.edu.br/cursos/graduacao/big-data-e-inteligencia-artificial-ead/) - Projeto Integrador II-A  
[PUC Goiás - Pontifícia Universidade Católica de Goiás](https://www.pucgoias.edu.br/)  
Abril de 2025
