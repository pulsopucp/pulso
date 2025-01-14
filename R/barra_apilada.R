# WARNING - Generated by {fusen} from /dev/flat_minimal.Rmd: do not edit by hand


#' Funcion para realizar un grafico de barra apilada de 1 variable.
#' 
#' @param data Base de datos para la funcion
#' @param var Variable para el grafico de barra apilada
#' @import pkgload
#' @import pkgdown
#' @import testthat
#' @import glue
#' @import sjlabelled
#' @import testthat
#' @import tidyverse
#' @import janitor
#' @import glue
#' @import lubridate
#' @import scales
#' @import Hmisc
#' @import lazyeval
#' @import plotly
#' @import ggrepel
#' @import cowplot
#' @import grid
#' @import fmsb
#' @import haven
#' @import rio
#' @import officer
#' @import officedown
#' @import sjlabelled
#' @import flextable
#' @import knitr
#' @import kableExtra
#' @import DT
#' @import gtsummary
#' @import ggpubr
#' @import paletteer
#' @import RColorBrewer
#' @import grDevices
#' @import graphics
#' @import utils
#' @import ggpubr
#' @import scales
#' @return Un grafico de barra apilado
#' @examples
#' 
#' # data_prueba_ruta <- system.file("data_prueba.sav", package = "pulso")
#' # data_prueba <- haven::read_sav(data_prueba_ruta)
#' # 
#' # data_prueba %>% 
#' #   filter(q0002 %in% 1) %>% 
#' #   barra_apilada_1(q0003_0002)
#' 
#' 
#' @export

barra_apilada<-function(data, ..., filtrar=TRUE, ordenado=TRUE, porcentaje=TRUE, ext.label=42, base.posicion=0.35){
  
  switch<-
    data %>% 
    select(...) %>% 
    names() %>% 
    table() %>% 
    sum() %>% 
    as.numeric()
  
  if(switch %in% 1){   
    
    #Barra apilada de 1
    
    total<-
      data %>%
      filter({{filtrar}}) %>% # filtro y lógica
      select(...) %>%
      nrow() 
    
    tag<-
      data %>%
      filter({{filtrar}}) %>% # filtro y lógica
      select(...) %>%
      filter_all(all_vars(. != 0)) %>% #SIN INF
      nrow() 
    
    pop<-
      data %>% 
      select(...) %>% 
      names()
    
    labels<-
      tibble(
        numero=as.character(unlist(sjlabelled::get_values(data[,pop]), use.names = FALSE)),
        nombres=unlist(sjlabelled::get_labels(data[,pop]), use.names = FALSE),
      ) %>%
      filter(numero!=0)
    
    colores<-colorRampPalette(c("#F4B183","#FFD966", "#B0D597", "#8FC36B"))
    
    num_colores<-labels %>%
      nrow()
    
    tablon<-data %>%
      filter({{filtrar}}) %>% 
      select(...) %>% 
      rename(nombres=everything()) %>% 
      mutate(numero=nombres,
             nombres=sjlabelled::as_label(nombres)) %>% 
      drop_na(numero) %>%
      filter(numero!=0) %>%
      dplyr::group_by(numero, nombres) %>%
      dplyr::summarize(Freq = n()) %>%
      ungroup() %>%
      dplyr::mutate(prop = round_half_up(Freq/sum(Freq), digits = 2),
                    numero = as.character(numero),
                    nombres = as.character(nombres)) %>%
      
      full_join(labels) %>%
      mutate(across(where(is.numeric), ~replace(., is.na(.), 0))) %>%
      
      mutate(
        
        color=colores(num_colores)[as.numeric(numero)],
        
        total="total"
      ) %>%
      
      mutate(
        numero2=case_when(
          numero %in% as.character(num_colores-1) ~ as.character(num_colores),
          TRUE ~ numero),
        
        
      ) %>%
      group_by(total, numero2) %>%
      mutate(prop2=sum(prop)) %>%
      ungroup()
    
    tablon %>%
      
      #Gráfico
      ggplot(aes(total, prop, label = if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)}else{scales::number(prop, scale = 100, accuracy = 1)} )) +
      geom_col(aes(fill=factor(color, ordered = TRUE, levels = rev(colores(num_colores)) )), position = "fill", width = 0.4) +
      
      #Etiqueta max <7%
      geom_text(aes(y=1.05, label = ifelse((numero == (max(as.numeric(numero))) & prop < 0.07) & !(numero == (max(as.numeric(numero))) & prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #Etiqueta min <7%
      geom_text(aes(y=-0.05, label = ifelse((numero == (min(as.numeric(numero))) & prop < 0.07) & !(numero == (min(as.numeric(numero))) & prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #Etiqueta = El resto planeo usar ggrepel
      geom_text(aes(label = ifelse(!((numero == (max(as.numeric(numero))) & prop < 0.07) |
                                       (numero == (min(as.numeric(numero))) & prop < 0.07)) & !(prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                position = position_stack(vjust = 0.5),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #TOP2BOX
      geom_label(aes(y=1.2, label=ifelse(numero2 == (max(as.numeric(numero2))), if(isTRUE(porcentaje)){scales::percent(prop2, accuracy = 1)} else {scales::number(prop2, scale = 100, accuracy = 1)}, NA)),
                 size = 3.5,
                 fontface = "bold",
                 color = "#459847",
                 family="sans") +
      geom_text(y=1.2,
                label="TOP2BOX",
                size=3.5,
                nudge_x = 0.15, #hacia arriba
                fontface = "bold",
                color = "#459847",
                family="sans") +
      
      #N Base
      geom_text(y=1.00, 
                label=if(tag == total) {glue("N=",tag)} else {glue("N=",tag,"/",total)},
                size = 2.5, 
                
                hjust = 1, # a la izquierda del 100%
                nudge_x = 0.25, #hacia arriba
                # position = position_stack(vjust = 0.5),
                
                # vjust = 0, 
                # nudge_y = 0.5,
                
                color="grey40",
                family="sans") +
      
      #eje x y
      scale_y_continuous(labels = if(isTRUE(porcentaje)) {~scales::percent(.x, accuracy = 1)} else {~scales::number(.x, scale = 100, accuracy = 1)}, limits = c(-0.05, 1.3)) + #c(-0.05, 1.3)  c(-5, 130)) labels = scales::percent ACA PUEDE HABER PROBLEM
      scale_fill_identity(labels=str_wrap(levels(fct_reorder(tablon$nombres, tablon$numero, min)), width = 20), breaks= levels(droplevels(factor(tablon$color, ordered = TRUE, levels = colores(num_colores) ))), guide="legend") +
      coord_flip(clip="off", ylim = c(-0.05, 1.5)) +
      
      #temas
      ggpubr::theme_pubr() +
      labs(subtitle = if(isTRUE(porcentaje)){waiver()} else {"Resultados en porcentajes"},
           caption = "Elaborado por Pulso PUCP") +
      
      theme(text = element_text(size = 9, color="#002060",family="sans"),
            
            legend.title = element_blank(),
            legend.position = c(0.1, 0.2), #izq-der,top-down
            legend.justification = c("left"),
            legend.text = element_text(size = 7, face = "bold",family="sans"),
            legend.key.height = unit(.2, "cm"),
            legend.margin=margin(t=1, b=1), # legend.box.margin=margin(-10,-10,-10,-10),
            
            plot.subtitle = element_text(size = 10, color="#002060"),
            plot.title.position = "plot",
            
            plot.caption = element_text(face = "italic",family="sans"),
            plot.margin = unit(c(0,0,0,0),"cm"),#trbl
            
            axis.title = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            axis.line = element_blank() ) +
      
      guides(fill = guide_legend(reverse=FALSE,label.position = "right", nrow = 1))
    
  } else {
    
    #Barra apilada n 
    
    total<-
      data %>%
      filter({{filtrar}}) %>% # filtro y lógica
      select(...) %>%
      nrow() 
    
    nombres_orden<-
      data %>%
      select(...)%>%
      sjlabelled::label_to_colnames() %>%
      names()
    
    nombres_orden<-ordered(factor(nombres_orden))
    
    noms<-
      data %>%
      select(...) %>%
      names()
    
    pop<-as.character(noms)
    
    labels <- tibble(
      pregunta = sort(rep(as.character(unlist(sjlabelled::get_label(data[,pop]), use.names = FALSE)), 
                          sum(nchar(unique(as.numeric(unlist(sjlabelled::get_values(data[,pop]), use.names = FALSE))))))), 
      
      numero = as.character(unlist(sjlabelled::get_values(data[,pop]), use.names = FALSE)), 
      
      nombres = unlist(sjlabelled::get_labels(data[,pop]), use.names = FALSE), ) %>% 
      
      filter(numero != 0)
    
    colores<-colorRampPalette(c("#F4B183","#FFD966", "#B0D597", "#8FC36B"))
    
    num_colores<-
      labels %>%
      select(nombres) %>% 
      distinct() %>% 
      nrow()
    
    #Tabla sin_inf
    tablon_sininf<-
      data %>%
      filter({{filtrar}}) %>% 
      select(...)%>%
      sjlabelled::label_to_colnames() %>%
      pivot_longer(everything(), names_to = "pregunta", values_to = "numero") %>%
      mutate(nombres=sjlabelled::as_label(numero)) %>%
      group_by(pregunta, numero, nombres) %>%
      drop_na(numero) %>%
      filter(numero==0) %>%
      dplyr::summarize(sin_inf = n()) %>%
      ungroup() %>% 
      select(-c(numero, nombres))
    
    #Tabla
    tablon<-
      
      data %>%
      filter({{filtrar}}) %>%
      select(...)%>%
      sjlabelled::label_to_colnames() %>%
      pivot_longer(everything(), names_to = "pregunta", values_to = "numero") %>%
      mutate(nombres=sjlabelled::as_label(numero)) %>%
      group_by(pregunta, numero, nombres) %>%
      drop_na(numero) %>%
      filter(numero!=0) %>%
      dplyr::summarize(Freq = n()) %>%
      group_by(pregunta) %>%
      dplyr::mutate(prop = round_half_up(Freq/sum(Freq), digits = 2),
                    numero = as.character(numero),
                    nombres = as.character(nombres)) %>%
      
      full_join(labels) %>%
      mutate(across(where(is.numeric), ~replace(., is.na(.), 0))) %>%
      
      mutate(
        
        color=colores(num_colores)[as.numeric(numero)],
        
      ) %>%
      
      mutate(
        numero2=case_when(
          numero %in% as.character(num_colores-1) ~ as.character(num_colores),
          TRUE ~ numero),
        
        
      ) %>%
      group_by(pregunta, numero2) %>%
      mutate(prop2=sum(prop)) %>%
      ungroup() %>% 
      full_join(tablon_sininf) %>%
      mutate(across(where(is.numeric), ~replace(., is.na(.), 0))) %>% 
      mutate(base_total=case_when(
        sin_inf == 0 ~ glue("N={total}"),
        sin_inf != 0 ~ glue("N={total-sin_inf}/{total}"),
        TRUE ~ ""
        
      ))
    
    tablon %>%
      
      #Gráfico
      ggplot(aes(x=if(isTRUE(ordenado)){fct_reorder2(pregunta, numero, -prop2)}else{fct_rev(factor(pregunta, levels = nombres_orden))}, y=prop, label = if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)}else{scales::number(prop, scale = 100, accuracy = 1)} )) +
      geom_col(aes(fill=factor(color, ordered = TRUE, levels = rev(colores(num_colores)) )), position = "fill", width = 0.6) +
      
      #Etiqueta max <7%
      geom_text(aes(y=1.05, label = ifelse((numero == (max(as.numeric(numero))) & prop < 0.07) & !(numero == (max(as.numeric(numero))) & prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #Etiqueta min <7%
      geom_text(aes(y=-0.05, label = ifelse((numero == (min(as.numeric(numero))) & prop < 0.07) & !(numero == (min(as.numeric(numero))) & prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #Etiqueta = El resto planeo usar ggrepel
      geom_text(aes(label = ifelse(!((numero == (max(as.numeric(numero))) & prop < 0.07) |
                                       (numero == (min(as.numeric(numero))) & prop < 0.07)) & !(prop == 0), if(isTRUE(porcentaje)){scales::percent(prop, accuracy = 1)} else {scales::number(prop, scale = 100, accuracy = 1)}, "") ),
                position = position_stack(vjust = 0.5),
                size = 3.5,
                fontface = "bold",
                color = "#002060",
                family="sans") +
      
      #TOP2BOX
      geom_label(aes(y=1.2, label=ifelse(numero2 == (max(as.numeric(numero2))), if(isTRUE(porcentaje)){scales::percent(prop2, accuracy = 1)} else {scales::number(prop2, scale = 100, accuracy = 1)}, NA)),
                 size = 3.5,
                 fontface = "bold",
                 color = "#459847",
                 family="sans") +
      # annotate("text", label="TOP2BOX", x=as.numeric(count(as.data.frame(unique(tablon$pregunta)))), y = 1.2, vjust = -3,
      #          size = 3.5,
      #          fontface = "bold",
      #          color = "#459847",
      #          family="sans") +
      geom_text(x=as.numeric(count(as.data.frame(unique(tablon$pregunta)))),
                y=1.2,
                label="TOP2BOX",
                size=3.5,
                vjust = -3,
                #nudge_x = 0.3, #hacia arriba
                fontface = "bold",
                color = "#459847",
                family="sans") +
      
      #N Base
      geom_text(y=1.00, 
                aes(label=base_total),
                size = 2.5, 
                
                hjust = 1, # a la izquierda del 100%
                nudge_x = base.posicion, #hacia arriba
                # position = position_stack(vjust = 0.5),
                
                # vjust = 0, 
                # nudge_y = 0.5,
                
                color="grey40",
                family="sans") +
      
      #eje x y
      scale_x_discrete(labels = scales::wrap_format(ext.label)) +
      scale_y_continuous(labels = if(isTRUE(porcentaje)) {~scales::percent(.x, accuracy = 1)} else {~scales::number(.x, scale = 100, accuracy = 1)}, limits = c(-0.05, 1.3)) +
      scale_fill_identity(labels=str_wrap(levels(fct_reorder(tablon$nombres, tablon$numero, min)), width = 20), breaks= levels(droplevels(factor(tablon$color, ordered = TRUE, levels = colores(num_colores)))), guide="legend") +
      coord_flip(clip="off", ylim = c(-0.05, 1.3)) +
      
      #temas
      ggpubr::theme_pubr() +
      labs(subtitle = if(isTRUE(porcentaje)){waiver()} else {"Resultados en porcentajes"},
           caption = "Elaborado por Pulso PUCP" ) +
      
      theme(text = element_text(size = 9, color="#002060",family="sans"),
            
            legend.title = element_blank(),
            legend.position = c(0.1, -0.05), #izq-der,top-down,
            legend.text = element_text(size = 7, face = "bold",family="sans"),
            legend.key.height = unit(.2, "cm"),
            
            plot.subtitle = element_text(size = 10, color="#002060"),
            plot.title.position = "plot",
            
            plot.caption = element_text(face = "italic",family="sans"),
            plot.margin = unit(c(t=0,r=0,b=1,l=0),"cm"),
            
            axis.title = element_blank(),
            axis.text = element_text(color="#002060"),
            axis.text.y = element_text(hjust=0.5),
            axis.text.x = element_blank(),
            axis.ticks = element_blank(),
            axis.line = element_blank() ) +
      
      guides(fill = guide_legend(reverse=FALSE,label.position = "right", nrow = 1))
    
  }
  
}


