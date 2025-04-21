# APENAS EXECUTE ESSE CÓDIGO APÓS EXECUTAR "analise.R"

prever_exemplo_novo <- function(modelo, medias_por_rotulo,
                                N, P, K, temperatura, umidade, ph, precipitacao) {
  
  # Criar dataframe com novo exemplo
  novo_exemplo <- data.frame(
    N = as.integer(N),
    P = as.integer(P),
    K = as.integer(K),
    temperatura = as.numeric(temperatura),
    umidade = as.numeric(umidade),
    ph = as.numeric(ph),
    precipitacao = as.numeric(precipitacao)
  )
  
  # Fazer previsão
  previsao <- predict(modelo, novo_exemplo)
  rotulo_previsto <- as.character(previsao)
  
  # Calcular índice de sucesso com base nos valores médios do rótulo previsto
  variaveis <- c("temperatura", "umidade", "precipitacao", "N", "P", "K")
  medias_rotulo <- medias_por_rotulo[rotulo_previsto, ]
  
  desvios <- mapply(function(valor, media) abs((valor - media) / media) * 100,
                    novo_exemplo[variaveis], medias_rotulo[variaveis])
  
  indice_sucesso <- round(max(100 - mean(desvios), 0), 2)
  
  # Print resultado
  cat("Cultura prevista:", rotulo_previsto, "\n")
  cat("Índice de sucesso estimado:", indice_sucesso, "%\n")
}

# USE ESSE CÓDIGO PARA FAZER PREVISÕES

prever_exemplo_novo(modelo, medias_por_rotulo,
                    N = 60,              # Nitrogênio (em %)
                    P = 21,              # Fósforo (em %)
                    K = 28,              # Potássio (em %)
                    temperatura = 28,    # Temperatura em °C
                    umidade = 71,        # Umidade relativa em %
                    ph = 5.7,            # pH do solo
                    precipitacao = 97)   # Precipitação em mm
