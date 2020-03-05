preparacion<-fluidRow(
  box(
    title = HTML("Preparaci&oacute;n de datos"),
    checkboxGroupInput(
      inputId = "data_clean",
      label = "Limpieza de datos",
      c(
        "Elimiar datos anomalos" = "da",
        "Reemplazar NAs con datos de media" = "rd"
        )
    )
  ),
  box(
    width = 12,
    title = "Datos a filtrar",
    div(
      class="table-responsive",
      tableOutput("data_filtered")
    )
  ),
)