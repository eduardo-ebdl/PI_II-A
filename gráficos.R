library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

# Gráficos para visualização

# Matrix para avaliação do modelo

conf_mat <- confusionMatrix(predicoes, testdata$rotulo)
df_conf <- as.data.frame(conf_mat$table)

ggplot(df_conf, aes(x=Reference, y=Prediction, fill=Freq)) +
  geom_tile() +
  scale_fill_gradient(low="white", high="blue") +
  labs(title="Matriz de Confusão", x="Rótulo Real", y="Rótulo Previsto") +
  theme(axis.text.x = element_text(angle=45, hjust=1))

# Gráfico para visualizar variáveis que mais afetam o modelo. (Quanto mais importante, mais a direita)

varImpPlot(modelo, main="Importância das Variáveis")

# Gráfico interativo para visualizar a distribuição dos rótulos tendo em vista umidade e temperatura.

fig <- plot_ly(data = df, 
               x = ~precipitacao, 
               y = ~umidade, 
               color = ~rotulo, 
               type = "scatter", 
               mode = "markers",
               marker = list(size = 8, opacity = 1))  # Aumentar a visibilidade

fig

# Gráfico média de K, N, P e PH por Tipo de solo

df_solo <- df %>%
  group_by(tipo_solo) %>%
  summarise(across(c(K, N, P, ph), mean, na.rm = TRUE)) %>%
  pivot_longer(cols = c(K, N, P, ph), names_to = "Nutriente", values_to = "Media")

ggplot(df_solo, aes(x = tipo_solo, y = Media, fill = Nutriente)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
  geom_text(aes(label = round(Media, 1)), 
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 3) +
  labs(title = "Média de K, N, P e pH por Tipo de Solo", 
       x = "Tipo de Solo", y = "Média") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Gráfico de contagem de rótulo por categoria

df_cat <- df %>%
  select(rotulo, tipo_cultura, tipo_solo, solo_nutrientes, tipo_temperatura) %>%
  pivot_longer(cols = -rotulo, names_to = "Variavel", values_to = "Categoria")

ggplot(df_cat, aes(x = Categoria)) +
  geom_bar(fill = "#4682B4", stat = "count") +
  geom_text(aes(label = after_stat(count)), stat = "count", vjust = -0.5, size = 3) +
  facet_wrap(~Variavel, scales = "free_x") +
  labs(title = "Contagem de Rótulos por Categoria",
       x = "Categoria", y = "Contagem de Rótulos") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


