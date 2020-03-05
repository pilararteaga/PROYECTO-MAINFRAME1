modelo<-fluidRow(
  box(
    title = HTML("Modelo"),
    HTML("Regresion lineal: Basado en nuestro trabajo se requiere realizar una regresion lineal que permita determinar las proyecciones para los siguientes a&ntilde;os")
  ),
  box(
    width = 12,
    title = HTML("Exploraci&oacute;n visual"),
    selectInput(
      inputId = "select_indicator",
      label = "Seleccione el indicador",
      choices = c("asa","asdasd")
    ),
    div(
      class="table-responsive",
      plotOutput("data_plot_reg")
    )
  )
)