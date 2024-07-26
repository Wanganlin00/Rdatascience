# ~\etc\Rprofile.site

options(repos = c(CRAN = "https://cran.rstudio.com/"))

options(BioC_mirror="https://mirrors.tuna.tsinghua.edu.cn/bioconductor")




# conflict_prefer(name = "filter", winner = "dplyr")

# Things you might want to change

# options(papersize="a4")
# options(editor="notepad")
# options(pager="internal")

# set the default help type
# options(help_type="text")
options(help_type="html")

# set a site library
# .Library.site <- file.path(chartr("\\", "/", R.home()), "site-library")

# set a CRAN mirror
# local({r <- getOption("repos")
#       r["CRAN"] <- "http://my.local.cran"
#       options(repos=r)})

options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor")

options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Give a fortune cookie, but only to interactive sessions
# (This would need the fortunes package to be installed.)
#  if (interactive()) 
#    fortunes::fortune()

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
  conflict_prefer("setdiff","GenomicRanges")
  library(tidyverse)
  library(patchwork)
  # library(BiocManager)
  library(readxl)
  library(writexl)
  message(cat("0", rep("=", 100), "100%", sep = ""))
  getOption("repos")
  options("BioC_mirror")
}


.Last<-function() {
  message(cat("0",rep("=",100),"100%",sep = ""))
  message(today())
}

# when you try to load a package that is not installed?
# When using library, you get an error message. With require, the
# return value is FALSE and a warning is printed

# 更新 RGui 

installr::updateR(cran_mirror = "https://mirrors.ustc.edu.cn/CRAN/")

pkgs <- c('conflicted','installr',"devtools",'reticulate','BiocManager',
          'readxl', 'writexl','showtext',"janitor","svglite",
          'tidyverse',"data.table","arrow",
          'mice', 'missForest', 'VIM')

stat <- c('moments', 'nortest','HH','emmeans',"ez",'afex' ,'gee', 'geepack','epiDisplay', 'psych',
          "tidymodels",'poissonreg','censored', 'multilevelmod','discrim',
          'factoextra', 'tidyclust',"tidygraph"
          )
remotes::install_github('jbryer/psa', build_vignettes = TRUE, dependencies = 'Enhances')

graph <- c('patchwork',"ggpubr","survminer","ggrepel","ggcorrplot","ggsurvfit",'ggfortify',"ggprism",
        'ggpmisc','pheatmap',"ggthemes","pROC","ggrapg"
        )

tbl <- c('gt', 'gtsummary', 'tableone')



install.packages(pkgs)
install.packages(stat)

# 语言

# 安装 en
# ~\etc\Rconsole    language=en

