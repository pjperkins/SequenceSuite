#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(reshape2)
library(cowplot)
library(ggpubr)
library(reactable)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observeEvent(input$comp_dataset,{  
    output$comp_tissue = renderUI({
      fil <- input$comp_dataset
      tab <- read.table(fil$datapath, header = T)
      rownames(tab) <- tab[,1]
      tab <- tab[,-1]
      selectInput('comp_tissue_selector', 'Choose Tissue of Interest', colnames(tab), selected = colnames(tab), multiple = TRUE)
    })})
  
  get_seqs <- eventReactive(input$file_process, {
    fil <- input$SeqFile
    tab <- read.table(fil$datapath, header = T)
    tab <- as.character(tab[,1])
    return(tab)
  })
  
  output$summary_table2 <- renderReactable({
    tab <- get_seqs()
    df <- data.frame(table(tab))
    df$Length <- nchar(as.character(df$tab))
    colnames(df) <- c('Sequence', 'Frequency', 'Length')
    reactable(df)
    
  })
  output$summary_table1 <- renderDataTable({
    tab <- get_seqs()
    num <- length(tab)
    uni <- length(unique(tab))
    minchar <- min(nchar(as.character(df$tab)))
    maxchar <- max(nchar(as.character(df$tab)))
    medchar <- median(nchar(as.character(df$tab)))
    sumtab <- data.frame(num, uni, minchar, medchar, maxchar)
    
    colnames(sumtab) <- c('Number of Sequences', 'Number of Unique Sequences', 'Minimum Length', 'Median Length', 'Maxumum Length')
    print(sumtab)
    
  })
  
  
  
})
