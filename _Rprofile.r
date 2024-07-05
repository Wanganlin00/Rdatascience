# ~\etc\Rprofile.site

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


# 更新 RGui 

installr::updateR(cran_mirror = "https://mirrors.ustc.edu.cn/CRAN/")

pkgs <- c('conflicted','installr',"devtools",'reticulate','BiocManager',
          'readxl', 'writexl','showtext',"janitor","svglite",
          'tidyverse',"data.table","arrow",
          'mice', 'missForest', 'VIM')

stat <- c('moments', 'nortest','HH','emmeans',"ez",'afex' ,'gee', 'geepack','epiDisplay', 'psych','dendextend', 'rpart.plot', 'vip',
          "tidymodels",'poissonreg','censored', 'multilevelmod')
remotes::install_github('jbryer/psa', build_vignettes = TRUE, dependencies = 'Enhances')

graph <- c('patchwork',"ggpubr","survminer","ggrepel","ggcorrplot","ggsurvfit",'ggfortify',
        'ggpmisc','pheatmap',"ggthemes","pROC")

tbl <- c('gt', 'gtsummary', 'tableone')



install.packages(pkgs)
install.packages("pROC")

install.packages(stat)

# 语言

# 安装 en
# ~\etc\Rconsole    language=en

