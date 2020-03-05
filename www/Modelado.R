modelado<-fluidRow(
  box(
    width = 12,
    title = "Datos Cargados",
    div(
      class="table-responsive",
      tableOutput("data_file")
    )
  )
)