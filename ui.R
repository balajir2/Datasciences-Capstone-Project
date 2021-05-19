suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
suppressWarnings(library(shinyBS))
suppressWarnings(library(shinythemes))

# Start building the page
shinyUI(fluidPage(
    navbarPage(
        "Predict the Next word Application",
        theme = shinytheme("cerulean"),
        tabPanel("Natural Language Processing",
                 HTML("<strong>Author: Balaji Rajan</strong>"),
                 br(),
                 HTML("<strong>Date: May 2021 </strong>"),
                 br(),
                sidebarPanel(
                    width=4,
                    helpText("This app suggests next word based on your inputs."),
                    textInput("inputString", "Enter your sentence", value = ""),
                    br(),
                    br(),
                    br(),
                    br()
                    ),
                ),
        mainPanel(tabsetPanel(
            tabPanel(
                "Prediction",
                p(h2("Predicted Next Word:")),
                verbatimTextOutput("prediction"),
                p(h5("For the first time, please allow the application around 30 seconds to load the data. ")),
                strong("Sentence Input:"),
                tags$style(type='text/css', '#text1 {background-color: rgba(255,255,0,0.40); color: blue;}'),
                textOutput('O_text1'),
                br(),
                strong("Note:"),
                tags$style(type='text/css', '#text2 {background-color: rgba(255,255,0,0.40); color: black;}'),
                textOutput('O_text2')
            ),
            tabPanel(
                "Documentation",
                p(h4("Natural Language Processing")),
                helpText(
                    "This application predicts the next word. It is based on principles of Natural Language Processing"
                ),
                HTML(
                    "<u><b>How does NLP work: </b></u>
                                              <br> <br>
                                              <b> Natural Language Processing </b>
                                              <br>
                                              <br>
                                              An input is taken as a string of words. This word is then converted to 3 grams, 2 grams and 1 gram word <br>
                                              This is then matched with a repository of 4 grams, 3 grams and 2 grams words <br>
                                              the last word after the previous matches is the prediction <br>
                                              "
                ),
            ),
            tabPanel("About",
                     mainPanel(
                         includeMarkdown("about.md")
                     )
            )
    )
)
)
)
)

  