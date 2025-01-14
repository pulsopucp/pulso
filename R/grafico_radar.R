# WARNING - Generated by {fusen} from /dev/flat_minimal.Rmd: do not edit by hand


#' Funcion para realizar un grafico radar
#' 
#' @param data Base de datos para la funcion
#' @import tidyverse
#' @import glue
#' @import sjlabelled
#' @import testthat
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
#' @return Un grafico radar
#' @examples
#' 
#' # data_prueba_ruta <- system.file("data_prueba.sav", package = "pulso")
#' # data_prueba <- haven::read_sav(data_prueba_ruta)
#' # 
#' # radar<-
#' #   data_prueba %>% 
#' #   select(starts_with("q0008_")) %>% 
#' #   sjlabelled::label_to_colnames() %>%
#' #   pivot_longer(everything(), names_to = "pregunta", values_to = "numero") %>%
#' #   mutate(nombres=sjlabelled::as_label(numero)) %>% 
#' #   group_by(pregunta, numero, nombres) %>%
#' #   dplyr::summarize(Freq = n()) %>% 
#' #   group_by(pregunta) %>% 
#' #   dplyr::mutate(prop = round_half_up(Freq/sum(Freq), digits = 2),
#' #                 numero = as.character(numero),
#' #                 nombres = as.character(nombres)) %>% 
#' #   separate(pregunta, c("Servicio","group", NA),  sep=" - ") %>% 
#' #   filter(nombres!="No") %>%
#' #   select(-c(numero, nombres, Freq)) %>%
#' #   group_by(group) %>% 
#' #   pivot_wider(names_from = Servicio, values_from = prop) %>% 
#' #   mutate(
#' #    group=case_when(
#' #     group %in% "Conoce este servicio de bienestar que brinda la universidad" ~ "Lo conoce",
#' #     TRUE ~ group)
#' #   ) %>% 
#' #   ungroup()
#' # 
#' # radar.tag<-
#' #   data_prueba %>% 
#' #   select(starts_with("q0008_")) %>% 
#' #   nrow()
#' # 
#' # radar %>% 
#' #   select(group, `Servicio de Salud`, `Servicio de actividad fisica y deportes`, `Bienestar psicologico`, `Servicios Culturales`) %>% 
#' #   grafico_radar(polygonfill = FALSE,
#' #          grid.label.size = 3,
#' #          axis.label.size = 3,
#' #          group.line.width = 1,
#' #          fullscore = as.numeric(rep(1,ncol(.)-1))
#' #          ) + 
#' #   
#' #   labs(caption = "Elaborado por Pulso PUCP",
#' #        tag = glue("N=",radar.tag)) +
#' #   
#' #   theme(legend.title = element_blank(),legend.position = "bottom",legend.text = element_text(size=10, face = "bold",family="sans"),legend.key.height = unit(.2, "cm"),
#' #         plot.caption = element_text(face = "italic",family="sans"),plot.margin = unit(c(0,0,1,0),"cm"),plot.tag = element_text(size = 8, color="grey40"),plot.tag.position = "bottomleft",
#' #         
#' #         text = element_text(size = 9, color="#002060",family="sans"),
#' #         ) +
#' #   guides(color=guide_legend(nrow = 2, byrow = TRUE)) +
#' #   coord_equal(clip="off")
#' 
#' 
#' @export

grafico_radar<- function (data, ..., order=everything(), base.size = 20, webtype = "mini",
                          axis.labels = "", grid.min = 0, grid.max = 1, centre.y = grid.min -
                            ((1/9) * (grid.max - grid.min)), label.centre.y = FALSE,
                          grid.line.width = 0.5, grid.line.trend = "classic",
                          gridline.min.linetype = "longdash", gridline.mid.linetype = "longdash",
                          gridline.max.linetype = "longdash", gridline.min.colour = "grey",
                          gridline.mid.colour = "#007A87", gridline.max.colour = "grey",
                          grid.label.size = 3, gridline.label.offset = -0.1 * (grid.max - centre.y), label.gridline.min = TRUE, label.gridline.mid = TRUE,
                          label.gridline.max = TRUE, gridline.label = NULL, axis.label.offset = 1.15,
                          axis.label.size = 3, axis.line.colour = "grey", group.line.width = 1,
                          group.point.size = 3, group.colours = NULL, group.fill.colours = NULL,
                          background.circle.colour = "#D7D6D1", background.circle.transparency = 0.2,
                          legend.title = "", plot.legend = TRUE, plot.title = "",
                          legend.text.size = 14, radarshape = "round", polygonfill = FALSE,
                          polygonfill.transparency = 0.2, multiplots = FALSE, stripbackground = TRUE,
                          fullscore = fullscore )
{

  plot.data<-
  data %>%
  select(...) %>%
  sjlabelled::label_to_colnames() %>%
  pivot_longer(everything(), names_to = "pregunta", values_to = "numero") %>%
  mutate(nombres=sjlabelled::as_label(numero)) %>%
  group_by(pregunta, numero, nombres) %>%
  dplyr::summarize(Freq = n()) %>%
  group_by(pregunta) %>%
  dplyr::mutate(prop = round_half_up(Freq/sum(Freq), digits = 2),
                numero = as.character(numero),
                nombres = as.character(nombres)) %>%
  separate(pregunta, c("enunciado","group", NA),  sep=" - ") %>%
  filter(nombres!="No") %>%
  select(-c(numero, nombres, Freq)) %>%
  group_by(group) %>%
  pivot_wider(names_from = enunciado, values_from = prop) %>%
  ungroup()
  
  plot.data<-
    plot.data %>% 
    select(order)

radar.tag<-
  data %>%
  select(...) %>%
  nrow()
  
 
  fullscore<-as.numeric(rep(1,ncol(plot.data)-1))

  #ggradar3
  plot.extent.x.sf = 1
  plot.extent.y.sf = 1.2
  x.centre.range = 0.02 * (grid.max - centre.y)
  if (multiplots) {
    if (length(which(colnames(plot.data) == "facet1")) ==
        0) {
      return("Error: no facet is applied.")
    }
    else {
      plot.data <- as.data.frame(plot.data)
      facet1ind <- which(colnames(plot.data) == "facet1")
      facet1df <- plot.data$facet1
      facet1df <- factor(facet1df, levels = as.vector(unique(facet1df)))
      plot.data <- plot.data[, -facet1ind]
    }
  }
  else if (multiplots == FALSE) {
    plot.data <- as.data.frame(plot.data)
  }
  else {
    return("Error: 'multiplots' can be either '1D' for facets plotting or 'none' for single plotting. ")
  }
  if (!is.null(plot.data$group)) {
    plot.data$group <- as.factor(as.character(plot.data$group))
  }
  else if (!is.null(rownames(plot.data))) {
    plot.data$group <- rownames(plot.data)
    print("Row names are chosen as the group names.")
  }
  else {
    groupcheck <- readline(" WARNING: 'group' column and row names are not detected. The first column will be chosen as the group name. Yes/no? (y/n)")
    if (groupcheck == "y") {
      plot.data[, 1] <- as.factor(as.character(plot.data[,
                                                         1]))
      names(plot.data)[1] <- "group"
    }
    else {
      print(" Abort! Data check failed! ")
      return(" Abort! Data check failed! ")
    }
  }
  col_group = which(colnames(plot.data) == "group")
  var.names <- colnames(plot.data)[-col_group]
  df_variables <- plot.data[, -col_group]
  if (!is.null(fullscore)) {
    if (length(fullscore) == ncol(df_variables)) {
      df_variables <- rbind(fullscore, df_variables)
    }
    else {
      return("Error: please provide the same length of 'fullscore' as of the variables.")
    }
  }
  df_variables <- data.frame(lapply(df_variables, function(x) scale(x,
                                                                    center = FALSE, scale = max(x, na.rm = TRUE)/grid.max)))
  if (!is.null(fullscore)) {
    df_variables <- df_variables[-1, ]
  }
  plot.data <- cbind(plot.data$group, df_variables)
  names(plot.data)[1] <- "group"
  if (length(axis.labels) == 1 && axis.labels == "") {
    axis.labels <- var.names
  }
  else {
    if (length(axis.labels) != ncol(plot.data) - 1)
      return("Error: 'axis.labels' contains the wrong number of axis labels")
  }
  plot.extent.x = (grid.max + abs(centre.y)) * plot.extent.x.sf
  plot.extent.y = (grid.max + abs(centre.y)) * plot.extent.y.sf
  if (grid.line.trend == "increase") {
    grid.line.width <- seq(from = grid.line.width, to = grid.line.width +
                             5 * 0.2, by = 0.2)
  }
  else if (grid.line.trend == "classic") {
    grid.line.width <- rep(grid.line.width, 6)
  }
  else if (grid.line.trend == "decrease") {
    grid.line.width <- rev(seq(from = grid.line.width, to = grid.line.width +
                                 5 * 0.2, by = 0.2))
  }
  else {
    return("Error: 'grid.line.trend' so far only contains two types, e.g. 'classic' and 'increase' ")
  }
  CalculateGroupPath <- function(df) {
    path <- df[, 1]
    path <- factor(path, levels = as.vector(path))
    angles = seq(from = 0, to = 2 * pi, by = (2 * pi)/(ncol(df) -
                                                         1))
    graphData = data.frame(seg = "", x = 0, y = 0)
    graphData = graphData[-1, ]
    for (i in levels(path)) {
      pathData = subset(df, df[, 1] == i)
      for (j in c(2:ncol(df))) {
        graphData = rbind(graphData, data.frame(group = i,
                                                x = pathData[, j] * sin(angles[j - 1]), y = pathData[,
                                                                                                     j] * cos(angles[j - 1])))
      }
      graphData = rbind(graphData, data.frame(group = i,
                                              x = pathData[, 2] * sin(angles[1]), y = pathData[,
                                                                                               2] * cos(angles[1])))
    }
    colnames(graphData)[1] <- colnames(df)[1]
    graphData
  }
  CaclulateAxisPath = function(var.names, min, max) {
    n.vars <- length(var.names)
    angles <- seq(from = 0, to = 2 * pi, by = (2 * pi)/n.vars)
    min.x <- min * sin(angles)
    min.y <- min * cos(angles)
    max.x <- max * sin(angles)
    max.y <- max * cos(angles)
    axisData <- NULL
    for (i in 1:n.vars) {
      a <- c(i, min.x[i], min.y[i])
      b <- c(i, max.x[i], max.y[i])
      axisData <- rbind(axisData, a, b)
    }
    colnames(axisData) <- c("axis.no", "x", "y")
    rownames(axisData) <- seq(1:nrow(axisData))
    as.data.frame(axisData)
  }
  funcCircleCoords <- function(center = c(0, 0), r = 1, npoints = 100) {
    tt <- seq(0, 2 * pi, length.out = npoints)
    xx <- center[1] + r * cos(tt)
    yy <- center[2] + r * sin(tt)
    return(data.frame(x = xx, y = yy))
  }
  plot.data.offset <- plot.data
  plot.data.offset[, 2:ncol(plot.data)] <- plot.data[, 2:ncol(plot.data)] +
    abs(centre.y)
  group <- NULL
  group$path <- CalculateGroupPath(plot.data.offset)
  axis <- NULL
  axis$path <- CaclulateAxisPath(var.names, grid.min + abs(centre.y),
                                 grid.max + abs(centre.y))
  axis$label <- data.frame(text = axis.labels, x = NA, y = NA)
  n.vars <- length(var.names)
  angles = seq(from = 0, to = 2 * pi, by = (2 * pi)/n.vars)
  axis$label$x <- sapply(1:n.vars, function(i, x) {
    ((grid.max + abs(centre.y)) * axis.label.offset) * sin(angles[i])
  })
  axis$label$y <- sapply(1:n.vars, function(i, x) {
    ((grid.max + abs(centre.y)) * axis.label.offset) * cos(angles[i])
  })
  if (webtype == "mini") {
    if (length(gridline.label) == 0) {
      values.radar <- c("0%", "50%", "100%")
    }
    else {
      if (length(gridline.label) == 3) {
        values.radar <- gridline.label
      }
      else {
        return("Error: 'gridline label' should have the same length as the mini webtype, e.g. 3. ")
      }
    }
    grid.mid <- (grid.min + grid.max)/2
    gridline <- NULL
    gridline$min$path <- funcCircleCoords(c(0, 0), grid.min +
                                            abs(centre.y), npoints = 360)
    gridline$mid$path <- funcCircleCoords(c(0, 0), grid.mid +
                                            abs(centre.y), npoints = 360)
    gridline$max$path <- funcCircleCoords(c(0, 0), grid.max +
                                            abs(centre.y), npoints = 360)
    gridline$min$label <- data.frame(x = gridline.label.offset,
                                     y = grid.min + abs(centre.y), text = as.character(grid.min))
    gridline$max$label <- data.frame(x = gridline.label.offset,
                                     y = grid.max + abs(centre.y), text = as.character(grid.max))
    gridline$mid$label <- data.frame(x = gridline.label.offset,
                                     y = grid.mid + abs(centre.y), text = as.character(grid.mid))
  }
  else if (webtype == "lux") {
    if (length(gridline.label) == 0) {
      values.radar <- c("0%", "20%", "40%",
                        "60%", "80%", "100%")
    }
    else {
      if (length(gridline.label) == 6) {
        values.radar <- gridline.label
      }
      else {
        return("Error: 'gridline label' should have the same length as the luxurious webtype, e.g. 6. ")
      }
    }
    grid.mid1 <- 0.2
    grid.mid2 <- 0.4
    grid.mid3 <- 0.6
    grid.mid4 <- 0.8
    gridline <- NULL
    gridline$min$path <- funcCircleCoords(c(0, 0), grid.min +
                                            abs(centre.y), npoints = 360)
    gridline$mid1$path <- funcCircleCoords(c(0, 0), grid.mid1 +
                                             abs(centre.y), npoints = 360)
    gridline$mid2$path <- funcCircleCoords(c(0, 0), grid.mid2 +
                                             abs(centre.y), npoints = 360)
    gridline$mid3$path <- funcCircleCoords(c(0, 0), grid.mid3 +
                                             abs(centre.y), npoints = 360)
    gridline$mid4$path <- funcCircleCoords(c(0, 0), grid.mid4 +
                                             abs(centre.y), npoints = 360)
    gridline$max$path <- funcCircleCoords(c(0, 0), grid.max +
                                            abs(centre.y), npoints = 360)
    gridline$min$label <- data.frame(x = gridline.label.offset,
                                     y = grid.min + abs(centre.y), text = as.character(grid.min))
    gridline$max$label <- data.frame(x = gridline.label.offset,
                                     y = grid.max + abs(centre.y), text = as.character(grid.max))
    gridline$mid1$label <- data.frame(x = gridline.label.offset,
                                      y = grid.mid1 + abs(centre.y), text = as.character(grid.mid1))
    gridline$mid2$label <- data.frame(x = gridline.label.offset,
                                      y = grid.mid2 + abs(centre.y), text = as.character(grid.mid2))
    gridline$mid3$label <- data.frame(x = gridline.label.offset,
                                      y = grid.mid3 + abs(centre.y), text = as.character(grid.mid3))
    gridline$mid4$label <- data.frame(x = gridline.label.offset,
                                      y = grid.mid4 + abs(centre.y), text = as.character(grid.mid4))
  }
  else {
    return("Error: 'webtype' only contains two types ('mini' and 'lux') so far.  ")
  }
  theme_clear <- theme_bw(base_size = base.size) + theme(axis.text.y = element_blank(),
                                                         axis.text.x = element_blank(), axis.ticks = element_blank(),
                                                         panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                         panel.border = element_blank(), legend.key = element_rect(linetype = "blank"))
  if (multiplots) {
    facet_vec <- factor(unique(facet1df), levels = as.vector(unique(facet1df)))
    no.facet <- length(facet_vec)
    multiaxislabel <- cbind(axis$label[rep(seq_len(nrow(axis$label)),
                                           no.facet), ], rep(facet_vec, each = nrow(axis$label)))
    names(multiaxislabel)[4] <- "facet1"
    base <- ggplot2::ggplot(multiaxislabel) + xlab(NULL) +
      ylab(NULL) + coord_equal() + geom_text(data = subset(multiaxislabel,
                                                           multiaxislabel$x < (-x.centre.range)), aes(x = x,
                                                                                                      y = y, label = str_wrap(text, width = 15)), size = axis.label.size, hjust = 1, colour = "#002060") +
      scale_x_continuous(limits = c(-1.5 * plot.extent.x,
                                    1.5 * plot.extent.x)) + scale_y_continuous(limits = c(-plot.extent.y,
                                                                                          plot.extent.y)) + facet_wrap(~facet1)
  }
  else if (multiplots == FALSE) {
    base <- ggplot2::ggplot(axis$label) + xlab(NULL) + ylab(NULL) +
      coord_equal() + geom_text(data = subset(axis$label,
                                              axis$label$x < (-x.centre.range)), aes(x = x, y = y,
                                                                                     label = str_wrap(text, width = 15)), size = axis.label.size, hjust = 1, colour = "#002060") +
      scale_x_continuous(limits = c(-1.5 * plot.extent.x,
                                    1.5 * plot.extent.x)) + scale_y_continuous(limits = c(-plot.extent.y,
                                                                                          plot.extent.y))
  }
  else {
    return("Error: 'multiplots' can be either '1D' for facets plotting or 'none' for single plotting. ")
  }
  if (radarshape == "round") {
    if (webtype == "mini") {
      base <- base + geom_path(data = gridline$min$path,
                               aes(x = x, y = y), lty = gridline.min.linetype,
                               colour = gridline.min.colour, size = grid.line.width[1])
      base <- base + geom_path(data = gridline$mid$path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[2])
      base <- base + geom_path(data = gridline$max$path,
                               aes(x = x, y = y), lty = gridline.max.linetype,
                               colour = gridline.max.colour, size = grid.line.width[3])
    }
    else if (webtype == "lux") {
      base <- base + geom_path(data = gridline$min$path,
                               aes(x = x, y = y), lty = gridline.min.linetype,
                               colour = gridline.min.colour, size = grid.line.width[1])
      base <- base + geom_path(data = gridline$mid1$path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[2])
      base <- base + geom_path(data = gridline$mid2$path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[3])
      base <- base + geom_path(data = gridline$mid3$path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[4])
      base <- base + geom_path(data = gridline$mid4$path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[5])
      base <- base + geom_path(data = gridline$max$path,
                               aes(x = x, y = y), lty = gridline.max.linetype,
                               colour = gridline.max.colour, size = grid.line.width[6])
    }
    else {
      return("Error: 'webtype' only contains two types ('mini' and 'lux') so far.  ")
    }
  }
  else if (radarshape == "sharp") {
    if (webtype == "mini") {
      oddindex <- seq(1, nrow(axis$path), 2)
      evenindex <- seq(2, nrow(axis$path), 2)
      axis$innerpath <- axis$path[oddindex, ]
      axis$outerpath <- axis$path[evenindex, ]
      axis$innerpath <- rbind(axis$innerpath, head(axis$innerpath,
                                                   1))
      axis$outerpath <- rbind(axis$outerpath, head(axis$outerpath,
                                                   1))
      axis$middlepath <- (axis$innerpath + axis$outerpath)/2
      base <- base + geom_path(data = axis$innerpath, aes(x = x,
                                                          y = y), lty = gridline.min.linetype, colour = gridline.min.colour,
                               size = grid.line.width[1]) + geom_path(data = axis$outerpath,
                                                                      aes(x = x, y = y), lty = gridline.max.linetype,
                                                                      colour = gridline.max.colour, size = grid.line.width[3]) +
        geom_path(data = axis$middlepath, aes(x = x,
                                              y = y), lty = gridline.mid.linetype, colour = gridline.mid.colour,
                  size = grid.line.width[2])
    }
    else if (webtype == "lux") {
      oddindex <- seq(1, nrow(axis$path), 2)
      evenindex <- seq(2, nrow(axis$path), 2)
      axis$innerpath <- axis$path[oddindex, ]
      axis$outerpath <- axis$path[evenindex, ]
      axis$innerpath <- rbind(axis$innerpath, head(axis$innerpath,
                                                   1))
      axis$outerpath <- rbind(axis$outerpath, head(axis$outerpath,
                                                   1))
      axis$middle1path <- (-axis$innerpath + axis$outerpath)/5 +
        axis$innerpath
      axis$middle2path <- (-axis$innerpath + axis$outerpath) *
        2/5 + axis$innerpath
      axis$middle3path <- (-axis$innerpath + axis$outerpath) *
        3/5 + axis$innerpath
      axis$middle4path <- (-axis$innerpath + axis$outerpath) *
        4/5 + axis$innerpath
      base <- base + geom_path(data = axis$innerpath, aes(x = x,
                                                          y = y), lty = gridline.min.linetype, colour = gridline.min.colour,
                               size = grid.line.width[1])
      base <- base + geom_path(data = axis$middle1path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[2])
      base <- base + geom_path(data = axis$middle2path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[3])
      base <- base + geom_path(data = axis$middle3path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[4])
      base <- base + geom_path(data = axis$middle4path,
                               aes(x = x, y = y), lty = gridline.mid.linetype,
                               colour = gridline.mid.colour, size = grid.line.width[5])
      base <- base + geom_path(data = axis$outerpath, aes(x = x,
                                                          y = y), lty = gridline.max.linetype, colour = gridline.max.colour,
                               size = grid.line.width[6])
    }
    else {
      return("Error: 'webtype' only contains two types ('mini' and 'lux') so far.  ")
    }
  }
  else {
    return("Error: 'radarshape' should be specified...")
  }
  base <- base + geom_text(data = subset(axis$label, abs(axis$label$x) <=
                                           x.centre.range), aes(x = x, y = y, label = str_wrap(text, width = 15)), size = axis.label.size,
                           hjust = 0.5, colour = "#002060")
  base <- base + geom_text(data = subset(axis$label, axis$label$x >
                                           x.centre.range), aes(x = x, y = y, label = str_wrap(text, width = 15)), size = axis.label.size,
                           hjust = 0, colour = "#002060")
  base <- base + theme_clear
  if (radarshape == "round") {
    base <- base + geom_polygon(data = gridline$max$path,
                                aes(x = x, y = y), fill = background.circle.colour,
                                alpha = background.circle.transparency)
  }
  else if (radarshape == "sharp") {
    base <- base + geom_polygon(data = axis$outerpath, aes(x = x,
                                                           y = y), fill = background.circle.colour, alpha = background.circle.transparency)
  }
  else {
    return("Error: 'radarshape' should be specified...")
  }
  base <- base + geom_path(data = axis$path, aes(x = x, y = y,
                                                 group = axis.no), colour = axis.line.colour)
  if (multiplots) {
    multigrouppath <- cbind(group$path, rep(facet1df, each = nrow(group$path)/nrow(plot.data)))
    names(multigrouppath)[4] <- "facet1"
    if (polygonfill) {
      base <- base + geom_polygon(data = multigrouppath,
                                  aes(x = x, y = y, col = factor(group), fill = factor(group)),
                                  alpha = polygonfill.transparency, show.legend = F) +
        facet_wrap(~facet1)
    }
    base <- base + geom_path(data = multigrouppath, aes(x = x,
                                                        y = y, group = group, colour = group), size = group.line.width) +
      facet_wrap(~facet1)
    base <- base + geom_point(data = multigrouppath, aes(x = x,
                                                         y = y, group = group, colour = group), size = group.point.size) +
      facet_wrap(~facet1)
  }
  else if (multiplots == FALSE) {
    if (polygonfill) {
      base <- base + geom_polygon(data = group$path, aes(x = x,
                                                         y = y, col = factor(group), fill = factor(group)),
                                  alpha = polygonfill.transparency, show.legend = F)
    }
    base <- base + geom_path(data = group$path, aes(x = x,
                                                    y = y, group = group, colour = group), size = group.line.width)
    base <- base + geom_point(data = group$path, aes(x = x,
                                                     y = y, group = group, colour = group), size = group.point.size)
  }
  else {
    return("Error: 'multiplots' can be either '1D' for facets plotting or 'none' for single plotting. ")
  }
  if (plot.legend) {
    if (multiplots == FALSE) {
      base <- base + labs(colour = legend.title, size = legend.text.size) +
        theme(legend.text = element_text(size = legend.text.size),
              legend.position = "left") + theme(legend.key.height = unit(2,
                                                                         "line"))
    }
    else if (multiplots) {
      base <- base + labs(colour = legend.title, size = legend.text.size) +
        theme(legend.text = element_text(size = legend.text.size),
              legend.position = "bottom") + theme(legend.key.height = unit(2,
                                                                           "line"))
    }
    else {
      return("Error: 'multiplots' can be either '1D' for facets plotting or 'none' for single plotting. ")
    }
  }
  else {
    base <- base + theme(legend.position = "none")
  }
  if (label.gridline.min == TRUE) {
    base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[1], width = 15)),
                             data = gridline$min$label, size = grid.label.size *
                               0.8, hjust = 1, colour = "#002060")
  }
  if (label.gridline.max == TRUE) {
    base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[length(values.radar)], width = 15)),
                             data = gridline$max$label, size = grid.label.size *
                               0.8, hjust = 1, colour = "#002060")
  }
  if (webtype == "mini") {
    if (label.gridline.mid == TRUE) {
      base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[2], width = 15)),
                               data = gridline$mid$label, size = grid.label.size *
                                 0.8, hjust = 1, colour = "#002060")
    }
  }
  else if (webtype == "lux") {
    if (label.gridline.mid == TRUE) {
      base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[2], width = 15)),
                               data = gridline$mid1$label, size = grid.label.size *
                                 0.8, hjust = 1, colour = "#002060")
      base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[3], width = 15)),
                               data = gridline$mid2$label, size = grid.label.size *
                                 0.8, hjust = 1, colour = "#002060")
      base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[4], width = 15)),
                               data = gridline$mid3$label, size = grid.label.size *
                                 0.8, hjust = 1, colour = "#002060")
      base <- base + geom_text(aes(x = x, y = y, label = str_wrap(values.radar[5], width = 15)),
                               data = gridline$mid4$label, size = grid.label.size *
                                 0.8, hjust = 1, colour = "#002060")
    }
  }
  else {
    return("Error: 'webtype' only contains two types ('mini' and 'lux') so far.  ")
  }
  if (label.centre.y == TRUE) {
    centre.y.label <- data.frame(x = 0, y = 0, text = as.character(centre.y))
    base <- base + geom_text(aes(x = x, y = y, label = str_wrap(text, width = 15)),
                             data = centre.y.label, size = grid.label.size, hjust = 0.5, colour = "#002060")
  }
  if (!is.null(group.colours)) {
    colour_values <- rep(group.colours, 100)
    if (!is.null(group.fill.colours)) {
      fill_values <- rep(group.fill.colours, 100)
    }
    else {
      fill_values <- colour_values
    }
  }
  else {
    colour_values <- rep(c("#FF5A5F", "#FFB400",
                           "#007A87", "#8CE071", "#7B0051",
                           "#00D1C1", "#FFAA91", "#B4A76C",
                           "#9CA299", "#565A5C", "#00A04B",
                           "#E54C20"), 100)
    fill_values <- colour_values
  }
  base <- base + theme(legend.key.width = unit(3, "line")) +
    theme(text = element_text(size = 20)) + scale_colour_manual(values = colour_values) +
    scale_fill_manual(values = fill_values) + theme(legend.title = element_blank())
  if (plot.title != "") {
    base <- base + ggtitle(plot.title)
  }
  if (stripbackground == FALSE) {
    base <- base + theme(strip.background = element_blank())
  }
  
  base +

  labs(caption = "Elaborado por Pulso PUCP",
       tag = glue("N=",radar.tag)) +

  theme(legend.title = element_blank(),legend.position = "bottom",legend.text = element_text(size=10, face = "bold",family="sans"),legend.key.height = unit(.2, "cm"),
        plot.caption = element_text(face = "italic",family="sans"),plot.margin = unit(c(0,0,1,0),"cm"),plot.tag = element_text(size = 8, color="grey40"),plot.tag.position = "topright",

        text = element_text(size = 9, color="#002060",family="sans"),
        ) +
  guides(color=guide_legend(nrow = 2, byrow = TRUE)) +
  coord_equal(clip="off")
}


