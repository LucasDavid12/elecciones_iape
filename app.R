#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinydashboard)
library(leaflet)
library(sf)
library(stringr)
library(htmltools)
library(openxlsx)
library(shinyWidgets)
library(shinycustomloader)
# Define UI for application that draws a histogram

elec_2015 <- readRDS("elecciones 2015.RDS")
elec_2017 <- readRDS("elecciones 2017.RDS")
elec_2019 <- readRDS("elecciones 2019.RDS")
elec_2021 <- readRDS("elecciones 2021.RDS")
im_elec2015 <- readRDS("im_elec2015.RDS")
im_elec2017 <- readRDS("im_elec2017.RDS")
im_elec2019 <- readRDS("im_elec2019.RDS")
im_elec2021 <- readRDS("im_elec2021.RDS")




ui <- dashboardPage(
    skin = "blue", 
    dashboardHeader(title = "IAPE - Elecciones PBA", titleWidth = 250,
                    tags$li(class="dropdown", tags$a(href="https://twitter.com/IapeUcalp", icon("twitter"), "Twitter", target="_blanck")),
                    tags$li(class="dropdown", tags$a(href="https://www.instagram.com/iape.ucalp/?hl=es-la", icon("instagram"), "Instagram", target="_blanck")),
                    tags$li(class="dropdown", tags$a(href="https://github.com/LucasDavid12/covid_19", icon("github"), "Código", target="_blanck")),
                    tags$li(class="dropdown", tags$a(href="https://ucalp.edu.ar/IAPE", icon("chess-rook"), "IAPE"))),
    dashboardSidebar(selectInput("elecciones", 
                                  "Seleccione un cargo:", 
                                  choices = unique(elec_2015$Cargo)),
            h4(strong('Zoom automático por sección electoral'), align = "center"),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("primera", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh4.googleusercontent.com/Tr7B1-dSXpdlqKTpXTpcgE40a7sL3OHqzt9FHMsKVL5OApbm_qmm7gnNLUwoH_qDyVnR8laUX13IryI01iLqNO2kI1jav5OACO5iVionmg-ix9E5T8sisYGzKgmxVWO3SbxJWd6K');  background-size: cover; background-position: center;")),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("segunda", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh6.googleusercontent.com/Yk0lVa83nntPvoi-cPlI-OCaS66odzKraG_jvsPWcOZY5evd7G72FgswcJYv3utpwjA65S4KrMUAVqwekNVkkUYAMRmgZx7zxmTngTyIQ_EyNxi4Wj1cpNjWsQKPxjqxsK-eVfsF');  background-size: cover; background-position: center;")),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("tercera", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh5.googleusercontent.com/jafjvLkzdnUvvLrmkyBiBZVpQEY8Z8DqBeJeJXwU6Sde2iMKz7xFZ4DQtEpYLJ76W2TZFqwvCgsI7DgH-Pi5zz-Bjx7gwf3-jF0VGFYdzbCW31rFWJPKzwGncF9VhZ2u_nXv1EIA');  background-size: cover; background-position: center;")), 
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("cuarta", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh4.googleusercontent.com/iOJjeWEQ2PtCz70NK5OLlNor7gagtgDlPm_XgYMBV4x95KVuPcCO9sqit5z918YD9VPYDSQ1UzzHJJf0Vt2g2pbTHyzzxzHR1akecAlAVvVY811lTvHC9v_jFhDUIEME1rNgdVS7');  background-size: cover; background-position: center;")),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("quinta", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh3.googleusercontent.com/2tZAvdQnV5ASVoAopFnWXcyWmdIkqnvCHZ9GZ1Jo7htCp3Uf9h3pcWu7AhrkOfJKpgHpfwb6qUkPMJcLRHNHqohRoCRuiMO8mIzQglxLz_PGGWe3o8KRIYeh4OHb_ofYzm-sgBAE');  background-size: cover; background-position: center;")),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("sexta", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh3.googleusercontent.com/YCNgFCHTgMLmm-OBgDKdqpxaxBSJj5Pfmr6tggIVYCozHWGNQakRfgNC7vRat7kLteReX3O2ZHUNIwvfW-paFHips9iaEs4Dp5E7IjJo4LUdckCJzLU08rhRccFzts8GlWwa5qGB');  background-size: cover; background-position: center;")),
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("septima", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh6.googleusercontent.com/DAZ2TN2HP_DGPRO9n_RMTPI1tBj7-3sbIgxmgooeHmbkhFmNEfqdRlcaPwledCX5TMo8dxiCcqyjbqHmOrbclFCnxQduS8d6gj-wuqpQpWjLyr_Cwev9da4mrt3rNsocTI2YbEV1');  background-size: cover; background-position: center;")), 
        div(style="display:inline-block;width:32%;text-align: center;", actionButton("octava", label = NULL, style = "width: 60px; height: 60px;
background: url('https://lh4.googleusercontent.com/fFE11pix4EESJbWjTmGQeEbxKbpTye5GEBKUnovUbyLr1cbyKlc2YL5mdDNEqfjnewbgYTDYYgA0NYsDy7rD5nPGZB8JLWWjObUgNjGby0SuNrzp_bBsx4QsL_H-NR-esNPJCsyN');  background-size: cover; background-position: center;"))), 
    dashboardBody(
        tabsetPanel(
            tabPanel("Elecciones 2015", withLoader(leafletOutput("elecciones_2015"), type="html", loader="pacman"), withLoader(htmlOutput("img_15"), type="html", loader="pacman")),
            tabPanel("Elecciones 2017", withLoader(leafletOutput("elecciones_2017"), type="html", loader="pacman"), withLoader(htmlOutput("img_17"), type="html", loader="pacman")),
            tabPanel("Elecciones 2019", withLoader(leafletOutput("elecciones_2019"), type="html", loader="pacman"), withLoader(htmlOutput("img_19"), type="html", loader="pacman")),
            tabPanel("Elecciones 2021", withLoader(leafletOutput("elecciones_2021"), type="html", loader="pacman"), withLoader(htmlOutput("img_21"), type="html", loader="pacman"))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    elecciones2015 <- reactive({
        lv <- elec_2015 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    elecciones2017 <- reactive({
        lv <- elec_2017 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    elecciones2019 <- reactive({
        lv <- elec_2019 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    elecciones2021 <- reactive({
        lv <- elec_2021 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    im_elec_21 <- reactive({
        lv <- im_elec2021 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    im_elec_19 <- reactive({
        lv <- im_elec2019 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    im_elec_17 <- reactive({
        lv <- im_elec2017 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    im_elec_15 <- reactive({
        lv <- im_elec2015 %>% filter(Cargo == input$elecciones)
        return(lv)
    })
    
    output$elecciones_2021 <- renderLeaflet({
        
        poup_21 <- paste('<style> p, h1 {ffont-family: "Georgia";} .black {font-weight: bold;} .row {display: flex; flex-wrap: wrap; text-align: center; justify-content: center; align-items: center; border-bottom: 1px solid;} .header {font-weight: 600; font-size: 14px;} .row p {width: 30%;} img {height: 40px; width: 70px;} .blanco {font-weight: 600; font-size: 14px;} </style>',
                             '<div class="row">',
                             '<h2>', elecciones2021()$distrito, '</h2>',
                             '</div>',
                             '<div class="row header">',
                             '<p>Frente electoral</p>',
                             '<p>%</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/c/c0/Juntos_logo.png" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_Juntos, '</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Frente_de_Todos_logo.svg/1920px-Frente_de_Todos_logo.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_FdT,'</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Logo_Frente_de_Izquierda_y_de_Trabajadores-Unidad.svg/1024px-Logo_Frente_de_Izquierda_y_de_Trabajadores-Unidad.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_FIT, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/e/ed/Logo_Avanza_Libertad.png" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_AL, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Vamos_con_Vos.svg/1024px-Vamos_con_Vos.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_VcV, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://pbs.twimg.com/media/FG1F4BmX0Acto2i?format=png&name=900x900" alt=""> </p>',
                             '<p class="black">', elecciones2021()$Por_Veci, '</p>') %>% lapply(HTML)
        
        po <- popupOptions(maxWidth = 1000, maxHeight = 1000, minWidth = 300)
        
        
         pal_2021 <- colorFactor(c("#FFC125", "#6495ED", "#CD3333", "#FF7F24", "#BEBEBE"), domain = elec_2021$Ganador)
        
        leaflet() %>% 
            addTiles() %>% 
            addPolygons(data = elecciones2021(), weight = 1, color = "black", label = 
                            paste0(elecciones2021()$distrito,  " | Ganador: ", as.character(elecciones2021()$Ganador)), 
                        popup = poup_21,
                        popupOptions = po,
                        fillColor = ~pal_2021(elecciones2021()$Ganador), 
                        fillOpacity = 0.8, 
                        highlight = highlightOptions(weight = 3, 
                                                     color = "black", 
                                                     bringToFront = T)) %>% 
            addLegend(position = "bottomright", 
                      pal = pal_2021,
                      values = elec_2021$Ganador,
                      title = "Frentes Electorales")
    })
    output$elecciones_2019 <- renderLeaflet({
        
        
        poup_19 <- paste('<style> p, h1 {ffont-family: "Georgia";} .black {font-weight: bold;} .row {display: flex; flex-wrap: wrap; text-align: center; justify-content: center; align-items: center; border-bottom: 1px solid;} .header {font-weight: 600; font-size: 14px;} .row p {width: 30%;} img {height: 40px; width: 70px;} .blanco {font-weight: 600; font-size: 14px;} </style>',
                             '<div class="row">',
                             '<h2>', elecciones2019()$distrito, '</h2>',
                             '</div>',
                             '<div class="row header">',
                             '<p>Frente electoral</p>',
                             '<p>%</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Juntos-Por-El-Cambio-Logo.svg/1920px-Juntos-Por-El-Cambio-Logo.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2019()$Por_JxC, '</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Frente_de_Todos_logo.svg/1920px-Frente_de_Todos_logo.svg.png" alta=""> </p>',
                             '<p class="black">', elecciones2019()$Por_FdT,'</p>') %>% lapply(HTML)

        po <- popupOptions(maxWidth = 1500, maxHeight = 1500, minWidth = 340)
        
        pal_19 <- colorFactor(c("#FFC125", "#6495ED", "#A2CD5A", "#FF7F24"), elec_2019$Ganador)
        
        
        leaflet() %>% 
            addTiles() %>% 
            addPolygons(data = elecciones2019(), weight = 1, color = "black", label = 
                            paste0(elecciones2019()$distrito,  " | Ganador: ", as.character(elecciones2019()$Ganador)), 
                        popup = poup_19,
                        popupOptions = po,
                        fillColor = ~pal_19(elecciones2019()$Ganador), 
                        fillOpacity = 0.8, 
                        highlight = highlightOptions(weight = 3, 
                                                     color = "black", 
                                                     bringToFront = T)) %>% 
            addLegend(position = "bottomright", 
                      pal = pal_19,
                      values = elec_2019$Ganador,
                      title = "Frentes Electorales")
    })
    output$elecciones_2017 <- renderLeaflet({
        
        poup_17 <- paste('<style> p, h1 {ffont-family: "Georgia";} .black {font-weight: bold;} .row {display: flex; flex-wrap: wrap; text-align: center; justify-content: center; align-items: center; border-bottom: 1px solid;} .header {font-weight: 600; font-size: 14px;} .row p {width: 30%;} img {height: 40px; width: 70px;} .blanco {font-weight: 600; font-size: 14px;} </style>',
                             '<div class="row">',
                             '<h2>', elecciones2017()$distrito, '</h2>',
                             '</div>',
                             '<div class="row header">',
                             '<p>Frente electoral</p>',
                             '<p>%</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Cambiemos_logofinal.png/1920px-Cambiemos_logofinal.png" alt=""> </p>',
                             '<p class="black">', elecciones2017()$Por_Cam, '</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Unidad_Ciudadana.svg/220px-Unidad_Ciudadana.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2017()$Por_UC,'</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/d/db/1_paislogo.png" alt=""> </p>',
                             '<p class="black">', elecciones2017()$Por_1P, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://yt3.ggpht.com/ytc/AKedOLRUop1oR5eLU94ia5JGdaCL5agHklG4UDHwgNAq=s900-c-k-c0x00ffffff-no-rj" alt=""> </p>',
                             '<p class="black">', elecciones2017()$Por_PJ, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Logo_Frente_de_Izquierda_y_de_Trabajadores-Unidad.svg/1024px-Logo_Frente_de_Izquierda_y_de_Trabajadores-Unidad.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2017()$Por_FIT, '</p>') %>% lapply(HTML)
        
        po <- popupOptions(maxWidth = 1500, maxHeight = 1500, minWidth = 340)
        
        pal_2017 <- colorFactor(c("#FFC125", "#6495ED", "#104E8B", "#FF7F24", "#00CDCD"), elec_2017$Ganador) 
        
        leaflet() %>% 
            addTiles() %>% 
            addPolygons(data = elecciones2017(), weight = 1, color = "black", label = 
                            paste0(elecciones2017()$distrito,  " | Ganador: ", as.character(elecciones2017()$Ganador)), 
                        popup = poup_17,
                        popupOptions = po,
                        fillColor = ~pal_2017(elecciones2017()$Ganador), 
                        fillOpacity = 0.8, 
                        highlight = highlightOptions(weight = 3, 
                                                     color = "black", 
                                                     bringToFront = T)) %>% 
            addLegend(position = "bottomright", 
                      pal = pal_2017,
                      values = elec_2017$Ganador,
                      title = "Frentes Electorales")
        
    })
    output$elecciones_2015 <- renderLeaflet({
        
        poup_15 <- paste('<style> p, h1 {ffont-family: "Georgia";} .black {font-weight: bold;} .row {display: flex; flex-wrap: wrap; text-align: center; justify-content: center; align-items: center; border-bottom: 1px solid;} .header {font-weight: 600; font-size: 14px;} .row p {width: 30%;} img {height: 40px; width: 70px;} .blanco {font-weight: 600; font-size: 14px;} </style>',
                             '<div class="row">',
                             '<h2>', elecciones2015()$distrito, '</h2>',
                             '</div>',
                             '<div class="row header">',
                             '<p>Frente electoral</p>',
                             '<p>%</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Cambiemos_logofinal.png/1920px-Cambiemos_logofinal.png" alt=""> </p>',
                             '<p class="black">', elecciones2015()$Cambiemos, '</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Logo_Frente_para_la_Victoria.svg/1920px-Logo_Frente_para_la_Victoria.svg.png" alt=""> </p>',
                             '<p class="black">', elecciones2015()$FPV,'</p>',
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://upload.wikimedia.org/wikipedia/commons/9/99/Logo_del_Frente_Renovador_2018.png" alt=""> </p>',
                             '<p class="black">', elecciones2015()$FR, '</p>', 
                             '</div>',
                             '<div class="row">',
                             '<p><img src="https://pbs.twimg.com/media/FG1F4BmX0Acto2i?format=png&name=900x900" alt=""> </p>',
                             '<p class="black">', elecciones2015()$Otros, '</p>') %>% lapply(HTML)
        
        po <- popupOptions(maxWidth = 1500, maxHeight = 1500, minWidth = 340)
        
        pal_2015 <- colorFactor(c("#FFC125", "#6495ED", "#CD1076", "#FF7F24"), elec_2015$Ganador)
        
        leaflet() %>% 
            addTiles() %>% 
            addPolygons(data = elecciones2015(), weight = 1, color = "black", label = 
                            paste0(elecciones2015()$distrito,  " | Ganador: ", as.character(elecciones2015()$Ganador)), 
                        popup = poup_15,
                        popupOptions = po,
                        fillColor = ~pal_2015(elecciones2015()$Ganador), 
                        fillOpacity = 0.8, 
                        highlight = highlightOptions(weight = 3, 
                                                     color = "black", 
                                                     bringToFront = T)) %>% 
            addLegend(position = "bottomright", 
                      pal = pal_2015,
                      values = elec_2015$Ganador,
                      title = "Frentes Electorales")
        
    })
    output$img_21 <- renderUI({
        
        tags$html(HTML(paste('<style> img {height: 7%; width: 20%;} </style>',
                  '<p><img src=', im_elec_21()$Imagen, 'align=left', 'alt="</p>', 
                  '<div class="row">')))
        
    })
    output$img_19 <- renderUI({
        
        tags$html(HTML(paste('<style> img {height: 7%; width: 20%;} </style>',
                             '<p><img src=', im_elec_19()$Imagen, 'align=left', 'alt="</p>', 
                             '<div class="row">')))
        
    })
    output$img_17 <- renderUI({
        
        tags$html(HTML(paste('<style> img {height: 7%; width: 20%;} </style>',
                             '<p><img src=', im_elec_17()$Imagen, 'align=left', 'alt="</p>', 
                             '<div class="row">')))
        
    })
    output$img_15 <- renderUI({
        
        tags$html(HTML(paste('<style> img {height: 7%; width: 20%;} </style>',
                             '<p><img src=', im_elec_15()$Imagen, 'align=left', 'alt="</p>', 
                             '<div class="row">')))
        
    })
    observeEvent(input$primera, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -34.60838, lng =-58.95253, zoom = 9,5)
    })
    observeEvent(input$primera, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -34.60838, lng =-58.95253, zoom = 9,5)
    })
    observeEvent(input$primera, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -34.60838, lng =-58.95253, zoom = 9,5)
    })
    observeEvent(input$primera, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -34.60838, lng =-58.95253, zoom = 9,5)
    })
    observeEvent(input$segunda, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -34.0639, lng = -60.10357, zoom = 8)
    })
    observeEvent(input$segunda, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -34.0639, lng = -60.10357, zoom = 8)
    })
    observeEvent(input$segunda, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -34.0639, lng = -60.10357, zoom = 8)
    })
    observeEvent(input$segunda, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -34.0639, lng = -60.10357, zoom = 8)
    })
    observeEvent(input$tercera, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -35.0249, lng = -58.42409, zoom = 9,5)
    })
    observeEvent(input$tercera, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -35.0249, lng = -58.42409, zoom = 9,5)
    })
    observeEvent(input$tercera, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -35.0249, lng = -58.42409, zoom = 9,5)
    })
    observeEvent(input$tercera, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -35.0249, lng = -58.42409, zoom = 9,5)
    })
    observeEvent(input$cuarta, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -34.86649, lng = -61.5302, zoom = 8)
    })
    observeEvent(input$cuarta, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -34.86649, lng = -61.5302, zoom = 8)
    })
    observeEvent(input$cuarta, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -34.86649, lng = -61.5302, zoom = 8)
    })
    observeEvent(input$cuarta, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -34.86649, lng = -61.5302, zoom = 8)
    })
    observeEvent(input$quinta, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -37.15185, lng = -58.48691, zoom = 8)
    })
    observeEvent(input$quinta, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -37.15185, lng = -58.48691, zoom = 8)
    })
    observeEvent(input$quinta, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -37.15185, lng = -58.48691, zoom = 8)
    })
    observeEvent(input$quinta, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -37.15185, lng = -58.48691, zoom = 8)
    })
    observeEvent(input$sexta, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -37.45467, lng = -61.93343, zoom = 7,5)
    })
    observeEvent(input$sexta, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -37.45467, lng = -61.93343, zoom = 7,5)
    })
    observeEvent(input$sexta, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -37.45467, lng = -61.93343, zoom = 7,5)
    })
    observeEvent(input$sexta, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -37.45467, lng = -61.93343, zoom = 7,5)
    })
    observeEvent(input$septima, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -36.35493, lng = -60.0264, zoom = 8,5)
    })
    observeEvent(input$septima, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -36.35493, lng = -60.0264, zoom = 8,5)
    })
    observeEvent(input$septima, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -36.35493, lng = -60.0264, zoom = 8,5)
    })
    observeEvent(input$septima, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -36.35493, lng = -60.0264, zoom = 8,5)
    })
    observeEvent(input$octava, {
        
        leafletProxy("elecciones_2015") %>% 
            setView(lat = -34.92145, lng = -57.95453, zoom = 10)
    })
    observeEvent(input$octava, {
        
        leafletProxy("elecciones_2017") %>% 
            setView(lat = -34.92145, lng = -57.95453, zoom = 10)
    })
    observeEvent(input$octava, {
        
        leafletProxy("elecciones_2019") %>% 
            setView(lat = -34.92145, lng = -57.95453, zoom = 10)
    })
    observeEvent(input$octava, {
        
        leafletProxy("elecciones_2021") %>% 
            setView(lat = -34.92145, lng = -57.95453, zoom = 10)
    })    
    output$downloadData <- downloadHandler(
        filename = function() { 
            paste("dataset-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(mtcars, file)
        })
    
}    
# Run the application 
shinyApp(ui = ui, server = server)
