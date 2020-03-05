exploracion<-fluidRow(
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
      plotOutput("data_plot")
    )
  )
)