options(
    repos = c(CRAN = "https://cran.rstudio.com/")
)
# options(BioC_mirror="https://mirrors.tuna.tsinghua.edu.cn/bioconductor")





.First<-function() {
    library(showtext,quietly = T)
    font_add("Times New Roman Regular","C:/Windows/Fonts/times.ttf")
    font_add("Times New Roman Bold","C:/Windows/Fonts/timesbd.ttf")
    font_add("Times New Roman Bold Italic","C:/Windows/Fonts/timesbi.ttf")
    font_add("Times New Roman Italic","C:/Windows/Fonts/timesi.ttf")
    font_add("黑体 常规","C:/Windows/Fonts/simhei.ttf")
    font_add("楷体 常规", "C:/Windows/Fonts/simkai.ttf")
    showtext_auto()
    # library(data.table)
    # library(mlr3verse)
    # library(knitr)
    # library(tinytex)
    library(conflicted)
    conflict_prefer("filter", winner = "dplyr")
    conflict_prefer("select", winner = "dplyr")
    
    library(tidyverse)
    library(patchwork)
    # library(BiocManager)
    library(readxl)
    library(writexl)
    message(cat("0", rep("=", 100), "100%", sep = ""))
}


.Last<-function() {
    message(cat("0",rep("=",100),"100%",sep = ""))
    message(today())
}


# 更新 R 

installr::updateR()





