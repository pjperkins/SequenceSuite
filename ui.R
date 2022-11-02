#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

options(shiny.maxRequestSize=30*1024^2)

shinyUI(navbarPage(inverse = T,"StrideSeqR",
                   tabPanel("File Processing", #Start page for welcome message, uploading files, and data preprocessing
                            sidebarLayout(
                              sidebarPanel(
                                #actionButton("go", "Go"),
                                #numericInput("n", "n", 50),
                                fileInput( "RNAfile", "Please Choose Your Paired Fastq Files", multiple = T),
                                #fileInput( "RPFfile", "Please Choose Footprinting BAM Files", multiple = T),
                                #fileInput( "ANNOfile", "Please Choose Annotation GFF3 File", multiple = T),
                                #fileInput( "FASTAfile", "Choose FASTA File (Optional)", multiple = T),
                                #fileInput( "TESTfile1", "Choose Reference RNA File (Optional)", multiple = T),
                                #fileInput( "TESTfile2", "Choose Reference RPF File (Optional)", multiple = T),
                                #checkboxInput("prepro", "Preprocess")
                                actionButton("prepro", "Preprocess",icon("paper-plane"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                #submitButton("Submit")
                              ),
                              mainPanel(
                                h3("Facilitating comprehensive analysis of sequences", align = "center"),
                                br(),
                                span("Welcome to ", strong("SequenceSuite") , ", a suite of tools for sequence comparison, analysis, and visualizationg"),
                                p("Get started by uploading a txt file of sequences (one sequence per row) and hitting ", span("Preprocess.", style = "color:blue")),
                                p("Once you recieve conifrmation below that your file has been successfully uploaded and processed, you can utilize the analysis tools listed in the toolbar above."),
                                #hr(),
                                #textOutput("upload"),
                                #textOutput("process"),
                                #textOutput("cheat"),
                                #plotOutput("plot"),
                                #dataTableOutput(outputId = "starter")
                                
                                
                              )
                            )
                   ),
                  tabPanel("Sequence Diversity", #Start page for welcome message, uploading files, and data preprocessing
                            sidebarLayout(
                              sidebarPanel(
                                #actionButton("go", "Go"),
                                #numericInput("n", "n", 50),
                                fileInput( "RNAfile", "Please Choose Your Text File of Sequences", multiple = T),
                                #fileInput( "RPFfile", "Please Choose Footprinting BAM Files", multiple = T),
                                #fileInput( "ANNOfile", "Please Choose Annotation GFF3 File", multiple = T),
                                #fileInput( "FASTAfile", "Choose FASTA File (Optional)", multiple = T),
                                #fileInput( "TESTfile1", "Choose Reference RNA File (Optional)", multiple = T),
                                #fileInput( "TESTfile2", "Choose Reference RPF File (Optional)", multiple = T),
                                #checkboxInput("prepro", "Preprocess")
                                actionButton("prepro", "Preprocess",icon("paper-plane"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                #submitButton("Submit")
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Diversity Metrics"),
                                  tabPanel("Bubble Plot"),
                                  tabPanel("Tile Plot")
                                  
                                )
                                
                                
                              )
                            )
                   ),
                   tabPanel("Sequence Similarity", #Start page for welcome message, uploading files, and data preprocessing
                            sidebarLayout(
                              sidebarPanel(
                                #actionButton("go", "Go"),
                                #numericInput("n", "n", 50),
                                fileInput( "RNAfile", "Please Choose Your RNA-seq BAM Files", multiple = T),
                                #fileInput( "RPFfile", "Please Choose Footprinting BAM Files", multiple = T),
                                #fileInput( "ANNOfile", "Please Choose Annotation GFF3 File", multiple = T),
                                #fileInput( "FASTAfile", "Choose FASTA File (Optional)", multiple = T),
                                #fileInput( "TESTfile1", "Choose Reference RNA File (Optional)", multiple = T),
                                #fileInput( "TESTfile2", "Choose Reference RPF File (Optional)", multiple = T),
                                #checkboxInput("prepro", "Preprocess")
                                actionButton("prepro", "Preprocess",icon("paper-plane"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                #submitButton("Submit")
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Sequence Dendograms"),
                                  tabPanel("Similarity Heatmap")
                                  
                                )
                                
                              )
                            )
                   ),
                   
                   tabPanel("Pattern Analysis", #Start page for welcome message, uploading files, and data preprocessing
                            sidebarLayout(
                              sidebarPanel(
                                #actionButton("go", "Go"),
                                #numericInput("n", "n", 50),
                                fileInput( "RNAfile", "Please Choose Your RNA-seq BAM Files", multiple = T),
                                #fileInput( "RPFfile", "Please Choose Footprinting BAM Files", multiple = T),
                                #fileInput( "ANNOfile", "Please Choose Annotation GFF3 File", multiple = T),
                                #fileInput( "FASTAfile", "Choose FASTA File (Optional)", multiple = T),
                                #fileInput( "TESTfile1", "Choose Reference RNA File (Optional)", multiple = T),
                                #fileInput( "TESTfile2", "Choose Reference RPF File (Optional)", multiple = T),
                                #checkboxInput("prepro", "Preprocess")
                                actionButton("prepro", "Preprocess",icon("paper-plane"), 
                                             style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                                #submitButton("Submit")
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("SpiderWeb Plot"),
                                  tabPanel("Sequence Profile"),
                                  tabPanel("Kmer Tables")
                                  
                                )
                                
                              )
                            )
                   ),
                   tabPanel("Sample Comparison", #Start page for welcome message, uploading files, and data preprocessing
                            sidebarLayout(
                              sidebarPanel(
                                fileInput("comp_dataset", "Choose a dataset:"),
                                selectInput("comp_type", "Comparison Type", choices = list('Rank' = 1, "Frequency" = 2), selected = 1),
                                sliderInput("comp_num", "Top N Sequences", min = 1, max = 100, value = 20),
                                uiOutput('comp_tissue'),
                                actionButton("comp_button", "Apply Changes")
                                
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Heatmap",
                                           plotOutput("cross_heatmap", height = 800)),
                                  tabPanel("Line Plot",
                                           plotOutput("cross_lineplot", height = 800)),
                                  tabPanel("Barplot",
                                           plotOutput("cross_barplot", height = 800))
                                  
                                )
                                
                                
                              )
                            )
                   )
))

#library(rsconnect)
#rsconnect::deployApp('C:/Users/pperkins/OneDrive - StrideBio, Inc/Documents/R Scripts/StrideSeq/')