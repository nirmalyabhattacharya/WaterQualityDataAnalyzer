#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(gridExtra)
library(RColorBrewer)


water_data <- read.csv("IndiaAffectedWaterQualityAreas.csv", header=TRUE,colClasses = c("factor","factor","factor","factor","factor", "character","factor","character"))
water_data$Year<-dmy(water_data$Year)

names(water_data)<-c("State","District","Block","Panchayat","Village","Habitation","QualityParameter","Year")
names(water_data)<-c("State","District","Block","Panchayat","Village","Habitation","QualityParameter","Year")

wd_temp<-water_data %>% select(Year,State,QualityParameter)%>%group_by(Year,State,QualityParameter) %>%mutate(ObservationsPerImpurity=n())
wd_temp<-wd_temp %>%select(Year,State,QualityParameter,ObservationsPerImpurity)%>%group_by(Year,State) %>%mutate(ObservationsPerYear=n())
wd_temp<-wd_temp %>%select(Year,State,QualityParameter,ObservationsPerImpurity,ObservationsPerYear)%>%group_by(Year,State) %>%mutate(Percentage=(ObservationsPerImpurity/ObservationsPerYear)*100)


no_of_rows=0
shinyServer(function(input, output) {
   
  output$barPlot <- renderPlot({
      input_year<-input$year
      year_value=ymd(paste(input_year,"04","01",sep="-"))
      state_value<-input$state
      impurity_value<-input$impurity
      
      wd_temp_year_state_impurity<-as.data.frame(wd_temp %>% select(Year,State,QualityParameter,ObservationsPerImpurity)%>%filter(Year==year_value,State==state_value))
      
      wd_temp_year_state_impurity<-unique(subset(wd_temp_year_state_impurity, State==state_value & Year==year_value))

      wd_temp_year_state_impurity<-as.data.frame(wd_temp %>% select(Year,State,QualityParameter,ObservationsPerImpurity)%>%filter(Year==year_value,State==state_value))
      
      wd_temp_year_state_impurity<-unique(subset(wd_temp_year_state_impurity, State==state_value & Year==year_value))
      
      wd_temp_year_impurity_state<-as.data.frame(wd_temp %>% select(Year,State,QualityParameter,ObservationsPerImpurity,Percentage))
      wd_temp_year_impurity_state<-unique(subset(wd_temp_year_impurity_state, QualityParameter==impurity_value & Year==year_value))
      wd_temp_year_impurity_state_top10<-head(arrange(wd_temp_year_impurity_state,desc(Percentage)), n = 10)   
      plot_title_year_state<-paste("Count of different types of impurities found in samples \nfrom the state of",state_value,"during the year",input_year)
      plot_title_year_impurity<-paste("Ranking of states (Top 10) based on the percentage of observations \nwhere",impurity_value,"was found during the year",input_year)
      
      p_year_state<-ggplot(wd_temp_year_state_impurity, aes(x=QualityParameter, y=ObservationsPerImpurity, fill=QualityParameter)) + geom_bar(stat="identity") + theme_bw() + guides(fill=FALSE)+ scale_fill_brewer(palette="Set2")+labs(x="Impurity Type", y="Count of Observations",title=plot_title_year_state)

      p_year_impurity<-ggplot(wd_temp_year_impurity_state_top10, aes(x=State, y=Percentage, fill=State)) + geom_bar(stat="identity") + theme_bw() +theme(axis.text.x = element_text(angle = 90, hjust = 1))+ guides(fill=FALSE)+ scale_fill_brewer(palette="Set3")+labs(x="States", y="Percentage of total observations",title=plot_title_year_impurity)

    no_of_rows=as.integer(input$YearStateWise)+as.integer(input$YearImpurityState)

    ifelse(no_of_rows==2, grid.arrange(p_year_state,p_year_impurity,nrow=2,ncol=1),NA)

    ifelse(no_of_rows!=2 && input$YearStateWise,print(p_year_state),NA)
    ifelse(no_of_rows!=2 && input$YearImpurityState,print(p_year_impurity),NA)
  })
  
})
