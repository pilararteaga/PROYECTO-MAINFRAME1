#index<-mainPanel(
#  div("El presente trabajo es la presentacion final del proyecto para el curso de Mainframes I, el cual es un producto software que desarrolla el ciclo de vida de un proyecto de ciencia de datos.")
#)
index<-fluidRow(
  box(
    title = "Presentacion",
    div("El presente trabajo es la presentacion final del proyecto para el curso de Mainframes I, el cual es un producto software que desarrolla el ciclo de vida de un proyecto de ciencia de datos.")
  ),
  box(
    title = "Autores",
    tags$ul(
      tags$li("Reyna Costa, Renzo"),
      tags$li("Arteaga Argomedo, Pilar")
    )
  )
)

