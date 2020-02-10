
shinyServer(function(input, output) {
  ### Dashboard Tab ###
  # barplot - count
  output$count = renderPlot({
    getPalette = colorRampPalette(brewer.pal(8, "Dark2"))
    df %>%
      filter(Genre == input$genre) %>%
      group_by(!!sym(input$variables)) %>%
      summarise(`Number of Apps` = n()) %>%
      ggplot(aes(x=!!sym(input$variables), y=`Number of Apps`, fill = !!sym(input$variables))) + 
      geom_col(width = 0.3) +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      xlab(input$variables) +
      scale_fill_manual(values = getPalette(23))
  })
  
  # scatter plot - average
  output$average = renderPlotly({
    getPalette = colorRampPalette(brewer.pal(8, "Dark2"))
    if (input$variables2 == "Price") {
      p1 = df %>%
        filter(Genre %in% (input$genre2), Price != 0) %>%
        group_by(Genre) %>%
        summarise(Average = round(mean(Price),2)) %>%
        ggplot(aes(x=reorder(Genre,-Average), y=Average, color = factor(Genre))) + geom_point(size = 16, alpha = 0.5) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.title = element_blank(),
              legend.position = "right"
        ) +
        xlab("Genre") +
        ylab(paste("Average", input$variables2,collapse = " ") ) 
      ggplotly(p1)
    }
    else if (input$variables2 == "Rating Score") {
      p2 = df %>%
        filter(Genre %in% (input$genre2), `Number of Rating` != 0) %>%
        group_by(Genre) %>%
        summarise(Average = round(mean(`Rating Score`),2)) %>%
        ggplot(aes(x=reorder(Genre,-Average), y=Average, color = factor(Genre))) + geom_point(size = 16, alpha = 0.5) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.title = element_blank(),
              legend.position = "right"
              ) +
        xlab("Genre") +
        ylab(paste("Average", input$variables2,collapse = " ") ) 
      ggplotly(p2)
    }
    else {
      p3=df %>%
        filter(Genre %in% (input$genre2)) %>%
        group_by(Genre) %>%
        summarise(Average = round(mean(!!sym(input$variables2)),2)) %>%
        ggplot(aes(x=reorder(Genre,-Average), y=Average, color = factor(Genre))) + geom_point(size = 16,alpha = 0.5) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.title = element_blank(),
              legend.position = "right"
        ) +
        xlab("Genre") +
        ylab(paste("Average", input$variables2,collapse = " ") ) 
      ggplotly(p3)
    }
  })
  
  # density plot
  output$dist = renderPlot({
    getPalette = colorRampPalette(brewer.pal(8, "Dark2"))
    if (input$variables3 == "Price")  {
      df %>%
        filter(Genre == input$genre3, Price != 0) %>%
        ggplot(aes(x=Price)) + geom_density() +
        geom_vline(aes(xintercept = median(Price)), lty = 2, colour = "gray50") + 
        theme_bw() +
        scale_fill_manual(values = getPalette(23)) +
        xlab("Price") + 
        ylab("Density")
    } 
    else if (input$variables3 == "Rating Score"){
      df %>%
        filter(Genre == input$genre3, `Number of Rating` != 0) %>%
        ggplot(aes(x=`Rating Score`)) + geom_density() +
        geom_vline(aes(xintercept = median(`Rating Score`)), lty = 2, colour = "gray50") + 
        theme_bw() +
        scale_fill_manual(values = getPalette(23)) +
        xlab("Rating Score") + 
        ylab("Density")
    }
    else{
      df %>%
        filter(Genre == input$genre3) %>%
        ggplot(aes(x=!!sym(input$variables3))) + geom_density() +
        geom_vline(aes(xintercept = median(!!sym(input$variables3))), lty = 2, colour = "gray50") + 
        theme_bw() +
        scale_fill_manual(values = getPalette(23)) +
        xlab(input$genre3) + 
        ylab("Density")
    }
  })
  
  ### Analysis Tab ###
  output$Corr = renderValueBox({
    if (input$targervar == "Rating Score") {
      x = df %>% filter(Genre == input$genre4, `Number of Rating` !=0) %>% select(!!sym(input$xvar))
      y = df %>% filter(Genre == input$genre4, `Number of Rating` !=0) %>% select(!!sym(input$targervar))
      cor = round(cor(x,y),2)
      valueBox(cor, "Correlation", icon = icon("star-of-david"), color = "yellow")
    }
    else {
      x = df %>% filter(Genre == input$genre4) %>% select(!!sym(input$xvar))
      y = df %>% filter(Genre == input$genre4) %>% select(!!sym(input$targervar))
      cor = round(cor(x,y),2)
      valueBox(cor, "Correlation", icon = icon("star-of-david"), color = "yellow")
    }
  })
  
  output$pvalue = renderValueBox({
    if (input$targervar == "Rating Score") {
      dt = df %>% filter(Genre == input$genre4, `Number of Rating` !=0) %>% select(`Rating Score`, !!sym(input$xvar))
      lm = summary(lm(`Rating Score`~., data = dt))
      pvalue = round(lm$coefficients[2,4],8)
      valueBox(pvalue, "P-value", icon = icon("not-equal"), color = "aqua")
    }
    else {
      dt = df %>% filter(Genre == input$genre4) %>% select(`Number of Rating`, !!sym(input$xvar))
      lm = summary(lm(`Number of Rating`~., data = dt))
      pvalue = round(lm$coefficients[2,4],8)
      valueBox(pvalue, "P-value", icon = icon("not-equal"), color = "aqua")
    }
  })
  
  output$coef = renderValueBox({
    if (input$targervar == "Rating Score") {
      dt = df %>% filter(Genre == input$genre4,`Number of Rating` !=0) %>% select(`Rating Score`, !!sym(input$xvar))
      lm = summary(lm(`Rating Score`~., data = dt))
      pvalue = round(lm$coefficients[2,1],2)
      valueBox(pvalue, "Coefficient", icon = icon("square-root-alt"), color = "olive")
    }
    else {
      dt = df %>% filter(Genre == input$genre4) %>% select(`Number of Rating`, !!sym(input$xvar))
      lm = summary(lm(`Number of Rating`~., data = dt))
      pvalue = round(lm$coefficients[2,1],2)
      valueBox(pvalue, "Coefficient", icon = icon("square-root-alt"), color = "olive")
    }
  })
  
  # scatter plot
  output$scatter = renderPlotly({
    if (input$targervar == "Rating Score") {
      df %>%
        filter(Genre == input$genre4, `Number of Rating` !=0) %>%
        ggplot(aes(x = !!sym(input$xvar), y = !!sym(input$targervar))) + geom_point(color = "#336633", position = "jitter", alpha = 0.5, size = 1.5) +
        theme_bw() + geom_smooth(method = "lm",formula = y ~ x, color = "black", size=0.5) +
        theme(axis.title.x = element_text(size = 15, vjust = -0.35),
              axis.title.y = element_text(size = 15, vjust = 0.35))
    }
    else {
      df %>%
        filter(Genre == input$genre4) %>%
        ggplot(aes(x = !!sym(input$xvar), y = !!sym(input$targervar))) + geom_point(color = "#336633", position = "jitter", alpha = 0.5, size = 1.5) +
        theme_bw() + geom_smooth(method = "lm", formula = y ~ x, color = "black", size=0.5) +
        ylim(0, 100000) +
        theme(axis.title.x = element_text(size = 15, vjust = -0.35),
              axis.title.y = element_text(size = 15, vjust = 0.35))
    }
  })
  
  ### Competitor Tab ###
  # competitor table
  output$table <- DT::renderDataTable({
    df$Genre = as.factor(df$Genre)
    datatable(df[, c(1,3:13)], rownames=F,
              colnames = c("App Name",
                           "Price",
                           "# of Ratings",
                           "Rating Score",
                           "Content Rating",
                           "Genre",
                           "# of Supported Devices",
                           "# of Screenshots",
                           "# of Supported Languages",
                           "VPP Licence",
                           "Free/Paid",
                           "Size(MB)"),
              filter = "top",
              options = list(
                scrollX = T,
                fixedColumns = T,
                autoWidth = T,
                columnDefs = list(list(width = "50px",targets = 0))))
  })
})

  
  