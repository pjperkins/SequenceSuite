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
  
  output$summary_table <- renderReactable({
    tab <- get_seqs()
    df <- data.frame(table(tab))
    df$Length <- nchar(as.character(df$tab))
    colnames(df) <- c('Sequence', 'Frequency', 'Length')
    reactable(df)
    
  })
  
  heatmap_plot <- eventReactive(input$comp_button, {
    fil <- input$comp_dataset
    tab <- read.table(fil$datapath, header = T)
    rownames(tab) <- tab[,1]
    tab <- tab[,-1]
    samples <- tab[1:input$comp_num,]
    for(i in 1:ncol(samples)){
      samples[,i] <- as.numeric(samples[,i])
    }
    #
    samples[samples == 100000] <- NA
    #
    par(mfrow = c(3, (ceiling((ncol(samples)/3)))))
    
    which_tissues <- input$comp_tissue_selector
    samples
    
    for(i in which_tissues){
      wewant <- i
      notcols <- colnames(samples)[-which(colnames(samples) == wewant)]
      samples <- samples[,c(wewant,notcols)]
      samples <- samples[order(samples[,1]),]
      
      uqs <- apply(samples, 1, function(x) quantile(x,.75, na.rm = T))
      lqs <- apply(samples, 1, function(x) quantile(x,.25, na.rm = T))
      iqrs <- uqs - lqs
      limits <- lqs - (1.5*iqrs)
      diffs <- limits - samples[,1]
      ind <- which(diffs > 0)
      minind <- apply(samples, 1, function(x) which(x==min(x, na.rm = T)))
      minind[which(lengths(minind)>1)] <- 10000
      islow <- which(minind == 1)
      print(diffs)
      image(1:ncol(samples), 1:nrow(samples), z = t(as.matrix(samples)), xlab = " Tissue", ylab ="Ranked Sequences", xaxt='n', yaxt = 'n', main = colnames(samples)[1], col = hcl.colors(12, "Dynamic", rev = TRUE))
      axis(side = 1, at = 1:ncol(samples), labels = colnames(samples))
      for(indy in islow){
        rect(xleft = 0, ybottom = indy-.5, xright = 8.5, ytop = indy+.5, border = 'orange')
        text(1,indy, rownames(samples)[indy], cex = 0.6)
      }
      for(indy in ind){
        rect(xleft = 0, ybottom = indy-.5, xright = 8.5, ytop = indy+.5, border = 'red')
        text(1,indy, rownames(samples)[indy], cex = 0.6)
      }
    }
  })
  
  output$cross_heatmap <- renderPlot({
    heatmap_plot()
  })
  
  
  line_plot <- eventReactive(input$comp_button, {
    fil <- input$comp_dataset
    tab <- read.table(fil$datapath, header = T)
    rownames(tab) <- tab[,1]
    tab <- tab[,-1]
    samples <- tab[1:input$comp_num,]
    for(i in 1:ncol(samples)){
      samples[,i] <- as.numeric(samples[,i])
    }
    #
    samples[samples == 100000] <- NA
    #
    par(mfrow = c(3, (ceiling((ncol(samples)/3)))))
    
    which_tissues <- input$comp_tissue_selector
    
    for(i in which_tissues){
      wewant <- i
      notcols <- colnames(samples)[-which(colnames(samples) == wewant)]
      samples <- samples[,c(wewant,notcols)]
      samples <- samples[order(samples[,1]),]
      
      uqs <- apply(samples, 1, function(x) quantile(x,.75, na.rm = T))
      lqs <- apply(samples, 1, function(x) quantile(x,.25, na.rm = T))
      iqrs <- uqs - lqs
      limits <- lqs - (1.5*iqrs)
      diffs <- limits - samples[,1]
      ind <- which(diffs > 0)
      minind <- apply(samples, 1, function(x) which(x==min(x, na.rm = T)))
      minind[which(lengths(minind)>1)] <- 10000
      islow <- which(minind == 1)
      
      colz <- rep('grey90', input$comp_num)
      colz[ind] <- 'black'
      ylimit = max(samples, na.rm = T)
      samples[is.na(samples)] <- ylimit
      plot(x = 1:ncol(samples), y = samples[1,], type = 'l', ylim = c(0,ylimit), xaxt='n', xlab = 'Tissue', ylab = 'Sequence Rank', main = colnames(samples)[1])
      axis(side = 1, at = 1:ncol(samples), labels = colnames(samples))
      for(idd in 2:input$comp_num){
        vals <- samples[idd,]
        lines(x = 1:ncol(samples), y = vals, type = 'l', ylim = c(0,ylimit), col = 'grey90')
      }
      for(il in islow){
        vals <- samples[il,]
        lines(x = 1:ncol(samples), y = vals, type = 'l', ylim = c(0,ylimit), col = 'orange', lwd = 2)
      }
      for(ie in ind){
        vals <- samples[ie,]
        lines(x = 1:ncol(samples), y = vals, type = 'l', ylim = c(0,ylimit), col = 'red', lwd = 2)
      }
    }
    
  })
  
  output$cross_lineplot <- renderPlot({
    line_plot()
  })
  
  
  cross_bar_plot <- eventReactive(input$comp_button, {
    fil <- input$comp_dataset
    tab <- read.table(fil$datapath, header = T)
    rownames(tab) <- tab[,1]
    tab <- tab[,-1]
    samples <- tab[1:input$comp_num,]
    for(i in 1:ncol(samples)){
      samples[,i] <- as.numeric(samples[,i])
    }
    #
    # samples[samples == 100000] <- NA
    #
    par(mfrow = c(3, (ceiling((ncol(samples)/3)))))
    
    which_tissues <- input$comp_tissue_selector
    glist <- list()
    gind <- 1
    for(i in which_tissues){
      wewant <- i
      notcols <- colnames(samples)[-which(colnames(samples) == wewant)]
      samples <- samples[,c(wewant,notcols)]
      samples <- samples[order(samples[,1]),]
      
      samples[,2:8] <- samples[,2:8] - samples[,1]
      samples$AA <- rownames(samples)
      ms <- melt(samples[,2:ncol(samples)])
      colnames(ms) <- c('AA', 'Tissue', 'Rank_Difference')
      g <- ggplot(data = ms, aes(x = AA, y = Rank_Difference, fill = Tissue)) + geom_bar(stat = 'identity')+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + ggtitle(i)
      glist[[gind]] <- g
      gind <- gind + 1
    }
    ggarrange(plotlist=glist)
  })
  
  output$cross_barplot <- renderPlot({
    cross_bar_plot()
  })
  
  
  
})
