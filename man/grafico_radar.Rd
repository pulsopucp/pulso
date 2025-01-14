% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grafico_radar.R
\name{grafico_radar}
\alias{grafico_radar}
\title{Funcion para realizar un grafico radar}
\usage{
grafico_radar(
  data,
  ...,
  order = everything(),
  base.size = 20,
  webtype = "mini",
  axis.labels = "",
  grid.min = 0,
  grid.max = 1,
  centre.y = grid.min - ((1/9) * (grid.max - grid.min)),
  label.centre.y = FALSE,
  grid.line.width = 0.5,
  grid.line.trend = "classic",
  gridline.min.linetype = "longdash",
  gridline.mid.linetype = "longdash",
  gridline.max.linetype = "longdash",
  gridline.min.colour = "grey",
  gridline.mid.colour = "#007A87",
  gridline.max.colour = "grey",
  grid.label.size = 3,
  gridline.label.offset = -0.1 * (grid.max - centre.y),
  label.gridline.min = TRUE,
  label.gridline.mid = TRUE,
  label.gridline.max = TRUE,
  gridline.label = NULL,
  axis.label.offset = 1.15,
  axis.label.size = 3,
  axis.line.colour = "grey",
  group.line.width = 1,
  group.point.size = 3,
  group.colours = NULL,
  group.fill.colours = NULL,
  background.circle.colour = "#D7D6D1",
  background.circle.transparency = 0.2,
  legend.title = "",
  plot.legend = TRUE,
  plot.title = "",
  legend.text.size = 14,
  radarshape = "round",
  polygonfill = FALSE,
  polygonfill.transparency = 0.2,
  multiplots = FALSE,
  stripbackground = TRUE,
  fullscore = fullscore
)
}
\arguments{
\item{data}{Base de datos para la funcion}
}
\value{
Un grafico radar
}
\description{
Funcion para realizar un grafico radar
}
\examples{

# data_prueba_ruta <- system.file("data_prueba.sav", package = "pulso")
# data_prueba <- haven::read_sav(data_prueba_ruta)
# 
# radar<-
#   data_prueba \%>\% 
#   select(starts_with("q0008_")) \%>\% 
#   sjlabelled::label_to_colnames() \%>\%
#   pivot_longer(everything(), names_to = "pregunta", values_to = "numero") \%>\%
#   mutate(nombres=sjlabelled::as_label(numero)) \%>\% 
#   group_by(pregunta, numero, nombres) \%>\%
#   dplyr::summarize(Freq = n()) \%>\% 
#   group_by(pregunta) \%>\% 
#   dplyr::mutate(prop = round_half_up(Freq/sum(Freq), digits = 2),
#                 numero = as.character(numero),
#                 nombres = as.character(nombres)) \%>\% 
#   separate(pregunta, c("Servicio","group", NA),  sep=" - ") \%>\% 
#   filter(nombres!="No") \%>\%
#   select(-c(numero, nombres, Freq)) \%>\%
#   group_by(group) \%>\% 
#   pivot_wider(names_from = Servicio, values_from = prop) \%>\% 
#   mutate(
#    group=case_when(
#     group \%in\% "Conoce este servicio de bienestar que brinda la universidad" ~ "Lo conoce",
#     TRUE ~ group)
#   ) \%>\% 
#   ungroup()
# 
# radar.tag<-
#   data_prueba \%>\% 
#   select(starts_with("q0008_")) \%>\% 
#   nrow()
# 
# radar \%>\% 
#   select(group, `Servicio de Salud`, `Servicio de actividad fisica y deportes`, `Bienestar psicologico`, `Servicios Culturales`) \%>\% 
#   grafico_radar(polygonfill = FALSE,
#          grid.label.size = 3,
#          axis.label.size = 3,
#          group.line.width = 1,
#          fullscore = as.numeric(rep(1,ncol(.)-1))
#          ) + 
#   
#   labs(caption = "Elaborado por Pulso PUCP",
#        tag = glue("N=",radar.tag)) +
#   
#   theme(legend.title = element_blank(),legend.position = "bottom",legend.text = element_text(size=10, face = "bold",family="sans"),legend.key.height = unit(.2, "cm"),
#         plot.caption = element_text(face = "italic",family="sans"),plot.margin = unit(c(0,0,1,0),"cm"),plot.tag = element_text(size = 8, color="grey40"),plot.tag.position = "bottomleft",
#         
#         text = element_text(size = 9, color="#002060",family="sans"),
#         ) +
#   guides(color=guide_legend(nrow = 2, byrow = TRUE)) +
#   coord_equal(clip="off")


}
