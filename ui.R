
dashboardPage(
  ### Header ###
  dashboardHeader(title = "AppStore"),
  
  ### Sidebar ###
  dashboardSidebar(
    sidebarUserPanel("Developer",
                     image = "https://cdn1.iconfinder.com/data/icons/seo-and-web-development-color/64/seo-and-web-development-05-512.png"),
    sidebarMenu(menuItem("Dashboard", tabName = "dashboard", icon = icon("home")), 
                menuItem("Analysis", tabName = "analysis", icon = icon("chart-line")),
                menuItem("Competitors", tabName = "competitors", icon = icon("tablet-alt")),
                menuItem("About", tabName = "about", icon = icon("info"))
                )
  ),
  
  ### Body ###
  dashboardBody(
    tabItems(
      # Dashboard
      tabItem(
        tabName = "dashboard",
        tabsetPanel(
          tabPanel("Count",
                   br(),
                   fluidRow(
                     valueBox(7197, "APPs", icon = icon("app-store"), color = "aqua", width = 3),
                     valueBox(3862, "Games", icon = icon("gamepad"), color = "orange", width = 3),
                     valueBox(4056, "FreeApps", icon = icon("funnel-dollar"), color = "olive", width = 3),
                     valueBox(23, "Genres", icon = icon("align-center"), color = "yellow", width = 3)
                   ),
                   br(),
                   br(),
                   fluidRow(
                     column(10, plotOutput("count")),
                     column(2, 
                            fluidRow(selectizeInput('variables', label = 'Select a variable to compare count', 
                                                    choices = colnames(df)[c(6,11,12)], selected = colnames(df)[12])),
                            # fluidRow(div(style='height:300px; width:700px; overflow: scroll',
                            #              checkboxGroupInput("genre", "Genres", choices = unique(df$Genre), selected = unique(df$Genre)[c(17)])))
                            fluidRow(selectizeInput('genre', label = 'Select a genre', 
                                                    choices = unique(df$Genre), selected = unique(df$Genre)[17]))
                            )
                   )
                   ),
          tabPanel("Average/Distribution",
                   br(),
                   fluidRow(
                     infoBox(title = tags$p("Average Price", style = "font-size: 120%;"), value = tags$p("$3.96", style = "font-size: 150%;"), icon = icon("funnel-dollar"), color = "olive", width = 3),
                     infoBox(title = tags$p("Average Rating", style = "font-size: 120%;"), value = tags$p(4.05, style = "font-size: 150%;"), icon = icon("smile"), color = "yellow", width = 3),
                     infoBox(title = tags$p("Avg # of Rating", style = "font-size: 110%;"),value = tags$p(12893, style = "font-size: 150%;"), icon = icon("sort-numeric-up"), color = "aqua", width = 3),
                     infoBox(title = tags$p("Average Size", style = "font-size: 120%;"), value = tags$p("199MB", style = "font-size: 150%;"), icon = icon("database"), color = "orange", width = 3)
                   ),
                   br(),
                   br(),
                   fluidRow(
                     column(10, plotlyOutput("average")),
                     column(2,
                            fluidRow(selectizeInput('variables2', label = 'Select a variable to compare average', 
                                                    choices = colnames(df)[c(3,4,5,8,9,10,13)], selected = colnames(df)[3])),
                            fluidRow(div(style='height:300px; width:700px; overflow: scroll',
                                         checkboxGroupInput("genre2", "Genres", choices = unique(df$Genre), selected = unique(df$Genre)[c(1,3,4,6,7,10,15,17)])))
                            )
                   ),
                   br(),
                   br(),
                   fluidRow(
                     column(10, plotOutput("dist")),
                     column(2,
                            fluidRow(selectizeInput('variables3', label = 'Select a variable to compare average', 
                                                    choices = colnames(df)[c(3,4,5,8,9,10,13)], selected = colnames(df)[13])),
                            fluidRow(selectizeInput('genre3', label = 'Select a genre', 
                                                    choices = unique(df$Genre), selected = unique(df$Genre)[17]))
                            # fluidRow(div(style='height:300px; width:700px; overflow: scroll',
                            #              checkboxGroupInput("genre3", "Genres", choices = unique(df$Genre), selected = unique(df$Genre)[c(7)])))
                     )
                   )
                   )
        
        )
      ),
      
      # Analysis
      tabItem(tabName = "analysis",
              fluidRow(
                column(11, tags$p(tags$strong("What makes a successful App?"),style = "font-size: 300%;")),
                column(1)
                ),
              br(),
              fluidRow(
                column(4, valueBoxOutput("Corr", width = 12)),
                column(4, valueBoxOutput("pvalue", width = 12)),
                column(4, valueBoxOutput("coef", width = 12))
              ),
              br(),
              fluidRow(
                column(10, plotlyOutput("scatter")),
                column(2,
                       fluidRow(selectizeInput('genre4', label = 'Select a genre', 
                                               choices = unique(df$Genre), selected = unique(df$Genre)[1])),
                       fluidRow(selectizeInput('targervar', label = 'Select your target variable', 
                                               choices = colnames(df)[c(4,5)], selected = colnames(df)[4])),
                       fluidRow(selectizeInput('xvar', label = 'Select your x-axis', 
                                               choices = colnames(df)[c(3,8,9,10,13)], selected = colnames(df)[3])))
              )
      ),
      
      # Competitors
      tabItem(tabName = "competitors", 
              br(),
              fluidRow(
                DT::dataTableOutput("table"), width = 15
              )
              ),
      
      # About
      tabItem(tabName = "about",
              br(),
              br(),
              fluidRow(
                box(title = "About the Dashboard", status = "primary", width = 6,
                    tags$p(
                      class = "text-center",
                      tags$img(class = "img-responsive img-rounded center-block", src = "app-store.jpg", style = "max-width: 150px;")
                    ),
                    tags$p(class = "text-center",tags$strong("What makes a successful App?")),
                    br(),
                    tags$p("App Store is a digital distribution platform for iOS users to browse and download apps. As a iOS user, you have a variety of choices. However, for developers, they are always struggling to make their apps stand out among the whole App Store. In this dashboard, users (developers) would be able to explore the factors influencing the popularity as well as the reputation of the app, and would also be able to see who their competitors are so that they could either learn from their competitors or make themselves distinguishable. "),
                    br(),
                    tags$p(tags$strong("Packages Required: "), "shinydashboard, tidyverse, ggplot2, plotly, DT"),
                    tags$p("Source code can be found", tags$a(href = "https://github.com/AliceXuyuan/appstore-shinydashboard", target = "_blank", "here"), "."),
                    tags$p("For more information about the project, please go to the", tags$a(href = "https://nycdatascience.com/blog/author/xuyuan-zhang/", target = "_blank", "blog page"), ".")
                    ),
                box(title = "About the Author", status = "primary", width = 6,
                    tags$p(
                      class = "text-center",
                      tags$img(class = "img-responsive img-rounded center-block", src = "LinkedInPhoto.png", style = "max-width: 150px;")
                    ),
                    tags$p(class = "text-center",tags$strong("Hi! I'm Alice.")),
                    br(),
                    tags$p("Alice recently completed her Master in Business Analytics at Brandeis International Business School. She has an interest in applying data science in the e-commerce and tourism areas. She is passionate about revealing and telling the “story” behind certain circumstances by analyzing big data. She is always eager to work as an effective and insightful translator, storyteller and visualizer of data."),
                    br(),
                    br(),
                    tags$p(tags$strong("LinkedIn:"), tags$a(href = "https://linkedin.com/in/xuyuan-zhang", target = "_blank", "www.linkedin.com/in/xuyuan-zhang")),
                    tags$p(tags$strong("Github:"), tags$a(href = "https://github.com/AliceXuyuan", target = "_blank", "www.github.com/AliceXuyuan")),
                    tags$p(tags$strong("Blogs:"), tags$a(href = "https://nycdatascience.com/blog/author/xuyuan-zhang/", target = "_blank", "www.nycdatascience.com/blog/author/xuyuan-zhang/"))
                )
              )
              )
    )
  )
)
