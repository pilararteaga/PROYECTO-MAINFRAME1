#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

#Carga de Scripts======================
source("www/Autoload.R")
#source("www/Css.R")
#======================================
#Variable Global
d.data.load<-NULL
d.data.use<-NULL
#======================================

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title="Poryecto Final"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Inicio", tabName = "index", icon = icon("home")),
            menuItem("Recolección de los Datos", tabName = "recoleccion", selected = T),
            menuItem("Modelado de datos estructurados", tabName = "modelado"),
            menuItem("Transformacióny consultas exploratorias", tabName = "transformacion"),
            menuItem("Preparación de los datos", tabName = "preparacion"),
            menuItem("Exploración Visual de datos", tabName = "exploracion"),
            menuItem("Modelo", tabName = "modelo"),
            menuItem("Exportación y Comunicación", tabName = "exportacion"),
            menuItem(HTML("Otros &#128008;"), tabName = "index")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "index", index),
            tabItem(tabName = "recoleccion", recoleccion),
            tabItem(tabName = "modelado", modelado),
            tabItem(tabName = "transformacion", transformacion),
            tabItem(tabName = "preparacion", preparacion),
            tabItem(tabName = "exploracion", exploracion),
            tabItem(tabName = "modelo", modelo),
            tabItem(tabName = "exportacion", exportacion),
            tabItem(tabName = "otros", exportacion)
        )
    )
)
    

library("readxl")
library("tools")
library("dplyr")
library("ggplot2")
library("rio")
library("xlsx")
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    data__ <- eventReactive(input$btnURLData,{
        if(is.null(input$url_data)){
            return()
        }
        xx = rio::import(input$url_data)
    })
    
    data_<-reactive({
        d.data.load<-input$file_data
        if(is.null(d.data.load))
            return (NULL)
        ext<-tools::file_ext(d.data.load)
        if(ext=='csv'){
            x = read.csv(d.data.load$datapath,header=T, sep=",")
        }else if(ext=='xls'){
            x = read_xls(d.data.load$datapath)
        }else{
            x = read_xlsx(d.data.load$datapath)
        }
        return (x)
    })
    
    iData<-reactive({
        type<-input$radio_data
        #View(type)
        if("url" %in% type){
            return (data__())
        }
        d.data.load<-input$file_data
        if(is.null(d.data.load))
            return (NULL)
        ext<-tools::file_ext(d.data.load)
        if(ext=='csv'){
            x = read.csv(d.data.load$datapath,header=T, sep=",")
        }else if(ext=='xls'){
            x = read_xls(d.data.load$datapath)
        }else{
            x = read_xlsx(d.data.load$datapath)
        }
        x<-(as.data.frame(x))
        
        return (x)
    })
    
    data_use<-reactive({
        x<-iData()
        
        cols<-x[, 1]
        rows<-colnames(x)[2:NROW(colnames(x))]
        #View(cols)
        #View(rows)
        t<-t(x)
        #View(t)
        
        #x<-data.frame(t[2:NROW(t),]) #limpio
        #colnames(x) <- cols
        #rownames(x) <- rows #rows no se muestran
        
        ############################
        colnames(x)<-c()
        rownames(x)<-c()
        x<-data.frame(cbind(rows,t[2:NROW(t),]))
        x[,1]<-(as.character(x[,1])) #convertirmos a character para comparar con input$data_range
        colnames(x) <- c("anios",cols)
        
        
        ####FILTRADO POR RANGO DE FECHA
        range<-input$data_range
        x<-x %>% filter(anios>=range[1])
        x<-x %>% filter(anios<=range[2])
        ############################
        
        
        #View(x)
        return (as.data.frame(x))
    })
    
    data_filtered<-reactive({
        
        x<-data_use()
        
        
        ####PREPARACION - FILTRADO DE DATOS ANOMALOS
        d_clean<-input$data_clean
        #View(d_clean)
        
        acceptedData<-function(r){
            return (regexpr("[a-zA-Z0-9]+",r))
        }
        cleaner<-function(d){
            r<-acceptedData(d)
            if(r==-1 || is.na(r)){
                return (NA)
            }
            return (d)
        }
        if("da" %in% d_clean){
            
            #r<-x[60,]
            #e<-c()
            #for(i in 1:(NCOL(r))){
            #    m<-as.character(x[60,i])
            #    e[i]<-sprintf("[%s]=%s (%s) > %s",i,m,acceptedData(m),cleaner(m))
            #}
            #View(e)
            
            for(i in 1:(NROW(x))){
                for(j in 2:(NCOL(x))){
                    m<-as.character(x[i,j])
                    x[i,j]<-cleaner(m)
                }
            }
        }
        ############################
        
        
        ####PREPARACION - REEMPLAZAR CON DATOS DE MEDIA
        checkColNA<-function(col){
            return (1 %in% as.numeric(is.na(col)))
        }
        replaceMeanCol<-function(col){
            #View(col)
            n<-NROW(col)
            nas<-0
            sum<-0
            for(i in 1:(n)){
                if(is.na(col[i])){
                    nas<-nas+1
                }else{
                    sum<-sum+as.numeric(as.character(col[i]))
                }
            }
            mean<-sum/(n-nas)
            
            g<-c()
            for(i in 1:(n)){
                if(is.na(col[i])){
                    g[i]<-mean
                }else{
                    g[i]<-as.numeric(as.character(col[i]))
                }
            }
            #View(g)
            return (g)
        }
        if("rd" %in% d_clean){
            #n<-NCOL(x)-1
            #View(n)
            #r<-x[,50]
            
            for(i in 1:(NCOL(x))){
                r<-x[,i]
                if(checkColNA(r)){
                    x[,i]<-replaceMeanCol(r)
                }
            }
        }
        ############################
        
        
        #View(x)
        return (as.data.frame(x))
    })

    output$data_file<-renderTable({
        iData()
    })
    
    output$data_use<-renderTable({
        data_use()
    })
    
    output$data_filtered<-renderTable({
        data_filtered()
    })
    
    plot_<-reactive({
        f<-as.data.frame(data_filtered())
        d<-f
        d[,1]<-(as.integer(d[,1])) #Conversion de anios a integer
        
        nc<-s_colnames_idX()
        colnames(d)<-nc
        
        return(as.data.frame(d))
    })
    
    output$data_plot_reg<-renderPlot({
        
        d<-plot_()
        
        selected<-input$select_indicator
        ggplot(d) +
            ylab("")+
            xlab("Years")+
            geom_point(aes_string(x="years", y=selected),color="red", alpha=0.7,position='identity') + 
            geom_line(aes_string(x="years", y=selected))+
            abline(lm(years~selected), col="purple",)
    })
    
    output$data_plot<-renderPlot({
        
        d<-plot_()
        
        selected<-input$select_indicator
        ggplot(d) +
            ylab("")+
            xlab("Years")+
            geom_point(aes_string(x="years", y=selected),color="red", alpha=0.7,position='identity') + 
            geom_line(aes_string(x="years", y=selected))
    })
    
    
    s_colnames_idX<-reactive({
        x<-iData()
        cols<-x[, 1]
        
        f<-c()
        f["Years"]<-"years"
        for(i in 1:(length(cols))){
            f[i+1]=sprintf("d_%s",i)
        }
        return(f)
    })
    
    s_colnames_id<-reactive({
        x<-iData()
        cols<-x[, 1]
        
        f<-c()
        for(i in 1:(length(cols))){
            f[i]=sprintf("d_%s",i)
        }
        return(f)
    })
    s_vars<-reactive({
        
        names<-s_colnames_id()
        
        x<-iData()
        cols<-x[, 1]
        
        names(names)<-cols
        #View(names)
        
        return (names)
    })
    
    output$downloadDataX<-downloadHandler(
        filename = function(){
            sprintf("data-%s.csv","guardado")
        },
        content = function(fname){
            write.csv(data_filtered(), fname)
        }
    )
    
    observe({
        updateSelectInput(session, "select_indicator",
                          choices = s_vars()
    )})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
