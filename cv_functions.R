rm(list=ls())
library(tidyverse)
# 
# setwd("~/Documents/CV")
# dt <- readr::read_csv2("QuantCo/entries.csv")
# ref<- readr::read_tsv("QuantCo/references.csv")

# ref %>% 
#   mutate(init=paste0("\\textbf{\\href{",website,"}{\\textbf{\\color{black}",name,"}}}")) %>% 
#   select(!c(name,website)) %>% 
#   relocate(init) %>% 
#   t() %>% 
#   as_tibble() %>%
#   mutate(tab=paste("&",V1,V2,V3,"\\\\")) %>% 
#   pull(tab) %>%
#   paste0("\\begin{tabular*}{\\textwidth}{l@{\\extracolsep{0.03\\textwidth}}p{0.32\\textwidth}p{0.32\\textwidth}p{0.32\\textwidth}}",
#          .,"\\end{tabular*}",collapse="\n")
#   unite(sep="&")

det_paste <- function(x,detail_type){
  if(all(is.na(x))){
    ret <- "\\empty"
    }else{
      x <- x[!is.na(x)]
      if(detail_type=="item"){
        ret <- paste(c("\\begin{itemize}",
                       paste0("\\item ",x),
                       "\\end{itemize}"),collapse = "\n")}
      if(detail_type=="text"){
        ret <- paste0("\\justify{{\\small{",x,"}}}",collapse="\n")
        
      }
      }
  return(ret)
}

entry_paste <- function(what,where,desc,time,detail){
  what <- if_else(all(is.na(what)),"\\empty",what)
  where <- if_else(all(is.na(where)),"\\empty",where)
  desc <- if_else(all(is.na(desc)),"\\empty",desc)
  time <- if_else(all(is.na(time)),"\\empty",time)
  detail <- if_else(all(is.na(detail)),"\\empty",detail)
  paste0("\\sh{",what,"}{",where,"}{",desc,"}{",time,"}",detail)
}

entries <- function(ls,detail_type=c("item","text")){
  
  ent_ls <- lapply(ls,function(x){
    lapply(seq_along(x),function(i)assign(names(x)[[i]],x[[i]],sys.frame()))
    det <- det_paste(detail,detail_type)
    ent <- entry_paste(what,where,desc,time,det)
    return(ent)})
  out <- paste("\\begin{itemize}\n\\item\n",
               paste0(ent_ls,collapse = "\n\\item\n"),
               "\\end{itemize}")
  return(out)
}

print_entries <- function(dt,sec,detail_type){
  ret <- dt %>% 
    filter(section==sec)  %>%
    pivot_longer(contains("detail")) %>% 
    select(!name) %>% 
    unique() %>% 
    mutate(group=row_number()) %>%
    group_by(across(-c(value,group))) %>%
    summarise(detail=list(value),group=max(group)) %>% 
    ungroup() %>% 
    arrange(group) %>% 
    select(!c(section,group)) %>% 
    transpose() %>% 
    entries(detail_type=detail_type)
  return(ret)
}

print_ref <- function(dt){
  dt %>% 
  mutate(init=paste0("\\textbf{\\href{",website,"}{\\textbf{\\color{black}",name,"}}}")) %>%
    select(!c(name,website)) %>%
    relocate(init) %>%
    t() %>%
    as_tibble() %>%
    unite(tab,sep="&") %>% 
    mutate(tab=paste0(tab,"\\\\")) %>% 
    pull(tab) %>%
    paste0(collapse=" & ") %>%
    paste0("\\begin{tabular*}{\\textwidth}{l@{\\extracolsep{0.03\\textwidth}}p{0.32\\textwidth}p{0.32\\textwidth}p{0.32\\textwidth}}\n&",
           .,"\n\\end{tabular*}", collapse="\n")
}

