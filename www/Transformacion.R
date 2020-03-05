transformacion<-fluidRow(
  
  box(
    title = HTML("Filtrado basado en a&ntilde;os"),
    sliderInput(
      inputId = "data_range",
      label = HTML("Rango de a&ntilde;os"),
      value = c(1960,2019),
      min = 1960,
      max = 2019,
      step = 1
    )
  ),
  box(
    width = 12,
    title = "Datos a trabajar",
    div(
      class="table-responsive",
      tableOutput("data_use")
    )
  ),
)