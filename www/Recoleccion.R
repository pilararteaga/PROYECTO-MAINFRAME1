recoleccion<-fluidRow(
  box(
    width = 12,
    title = "Extraccion de datos",
    textInput(
      inputId = "url_data",
      label = "URL de datos",
      value = "http://api.worldbank.org/v2/es/country/PER?downloadformat=excel"
    ),
    actionButton("btnURLData","Extraer",icon("download")),
    hr(),
    fileInput(
      inputId = "file_data",
      label = "Cargar datos"
    ),
    #hr(),
    #actionButton("btnFileData","Continuar",icon("arrow-right"), cli)
  )
)