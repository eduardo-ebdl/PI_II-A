library(plotly)
library(shiny)
library(RColorBrewer)

# Gerar cores para até 22 culturas
cores <- colorRampPalette(brewer.pal(8, "Set2"))(22)

# Interface do usuário
ui <- fluidPage(
  titlePanel("Análise de Culturas"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("var_x", "Eixo X (scatter):", choices = names(df)[1:8]),
      selectInput("var_y", "Eixo Y (scatter):", choices = names(df)[1:8]),
      selectInput("var_linha", "Variável (linha por rótulo):", 
                  choices = c("temperatura", "umidade", "precipitacao", "N", "P", "K", "indice_sucesso"))
    ),
    
    mainPanel(
      plotlyOutput("grafico_scatter"),
      br(),
      plotlyOutput("grafico_linha")
    )
  )
)

# Servidor
server <- function(input, output) {
  
  # Scatter
  output$grafico_scatter <- renderPlotly({
    plot_ly(data = df, 
            x = ~get(input$var_x), 
            y = ~get(input$var_y), 
            color = ~rotulo,
            colors = cores,
            type = "scatter", 
            mode = "markers") %>%
      layout(title = "Gráfico de Dispersão",
             xaxis = list(title = input$var_x), 
             yaxis = list(title = input$var_y))
  })
  
  # Linha por rótulo (média por rótulo)
  output$grafico_linha <- renderPlotly({
    dados_media <- df %>%
      group_by(rotulo) %>%
      summarise(media = mean(get(input$var_linha), na.rm = TRUE)) %>%
      arrange(desc(media))
    
    # Reordena os níveis do fator para manter a ordem no eixo X
    dados_media$rotulo <- factor(dados_media$rotulo, levels = dados_media$rotulo)
    
    plot_ly(dados_media, 
            x = ~rotulo, 
            y = ~media, 
            type = "scatter", 
            mode = "lines+markers") %>%
      layout(title = paste("Média de", input$var_linha, "por Cultura"),
             xaxis = list(title = "Cultura"),
             yaxis = list(title = paste("Média de", input$var_linha)))
})
}
  

# Rodar app
shinyApp(ui, server)
