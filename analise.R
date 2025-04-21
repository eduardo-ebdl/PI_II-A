# Importar packages

library(caret)
library(randomForest)
library(corrplot)
library(DBI)
library(RPostgres)
library(dplyr)

# Carregando dados

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "railway",
  host = "gondola.proxy.rlwy.net",
  port = 35131,
  user = "postgres",
  password = "nRNSIrpUhYULjDslKMJbkJrpFkgbjnSY"
)

df <- dbReadTable(con, "crops")
dbDisconnect(con)
rm(con)

# Checar por dados vazios

colSums(is.na(df))

# Checar tipo das colunas

str(df)

# Converter certas colunas para numérico

cols_para_converter <- c("temperatura", "umidade", "ph", "precipitacao", "indice_sucesso")
df[c("N", "P", "K")] <- lapply(df[c("N", "P", "K")], as.numeric)
df[cols_para_converter] <- lapply(df[cols_para_converter], function(x) as.numeric(gsub(",", ".", x)))
rm(cols_para_converter)

# Visão geral dos dados

summary(df)

# Checar as ocorrências de cada rótulo

table(df$rotulo)

# Calcular correlação numérica

cor_matrix <- cor(df[sapply(df, is.numeric)])
corrplot(cor_matrix, method="color", tl.cex=0.8)

# Preparando os dados para treinar o modelo

colunas_derivadas <- c("tipo_cultura", "tipo_temperatura", "tipo_solo", "solo_nutrientes", "indice_sucesso")
set.seed(0104)
splitI <- createDataPartition(df$rotulo, p=0.8, list=FALSE) # Particiona o dataset em uma escala 80/20
traindata <- df[splitI,  ] # 80% para treinamento
traindata$rotulo <- as.factor(traindata$rotulo)
testdata <- df[-splitI, ] # 20% para teste
testdata$rotulo <- as.factor(testdata$rotulo)

# Filtrar colunas desnecessárias

traindata <- traindata[, !(names(traindata) %in% colunas_derivadas)]
testdata  <- testdata[, !(names(testdata) %in% colunas_derivadas)]

# Treinar modelo

modelo <- randomForest(rotulo ~ ., data=traindata, ntree=100)

# Fazer previsões no conjunto de teste

predicoes <- predict(modelo, testdata)

# Ajustar as predições para que tenham os mesmos níveis de 'rotulo' do conjunto de teste

predicoes <- factor(predicoes, levels = levels(testdata$rotulo))

# Avaliar o modelo

confusionMatrix(predicoes, testdata$rotulo)

# Calculando médias para auxiliar a predição

variaveis_para_media <- c("temperatura", "umidade", "precipitacao", "N", "P", "K")

medias_por_rotulo <- df %>%
  group_by(rotulo) %>%
  summarise(across(all_of(variaveis_para_media), mean, na.rm = TRUE)) %>%
  as.data.frame()

# Deixa os nomes das linhas como o nome do rótulo, útil pra indexação depois
rownames(medias_por_rotulo) <- medias_por_rotulo$rotulo
medias_por_rotulo$rotulo <- NULL
