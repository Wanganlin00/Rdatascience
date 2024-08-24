# ~\etc\Rprofile.site

options(repos = c(CRAN = "https://cran.rstudio.com/"))

options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor")


# Things you might want to change

# options(papersize="a4")
# options(editor="notepad")
# options(pager="internal")

# set the default help type
# options(help_type="text")
options(help_type = "html")

# set a site library
# .Library.site <- file.path(chartr("\\", "/", R.home()), "site-library")

# set a CRAN mirror
# local({r <- getOption("repos")
#       r["CRAN"] <- "http://my.local.cran"
#       options(repos=r)})

options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor") # "https://mirrors.ustc.edu.cn/CRAN/"

options(repos = c(CRAN = "https://cran.rstudio.com/"))

# getOption("repos")
# options("BioC_mirror")

# Give a fortune cookie, but only to interactive sessions
# (This would need the fortunes package to be installed.)
#  if (interactive())
#    fortunes::fortune()

.First <- function() {
  library(showtext, quietly = T)
  font_add("Times New Roman Regular", "C:/Windows/Fonts/times.ttf")
  font_add("Times New Roman Bold", "C:/Windows/Fonts/timesbd.ttf")
  font_add("Times New Roman Bold Italic", "C:/Windows/Fonts/timesbi.ttf")
  font_add("Times New Roman Italic", "C:/Windows/Fonts/timesi.ttf")
  font_add("黑体 常规", "C:/Windows/Fonts/simhei.ttf")
  font_add("楷体 常规", "C:/Windows/Fonts/simkai.ttf")
  showtext_auto()
  # library(data.table)
  # library(knitr)
  # library(tinytex)
  library(conflicted)
  conflict_prefer("filter", winner = "dplyr")
  conflict_prefer("select", winner = "dplyr")
  conflict_prefer("setdiff", "GenomicRanges")
  library(tidyverse)
  library(patchwork)
  # library(BiocManager)
  library(readxl)
  library(writexl)
  message(cat("0", rep("=", 100), "100%", sep = ""))
  message(today())
}


.Last <- function() {

}


# 更新 R Gui

installr::updateR()

tools <- c(
  "installr", "devtools",
  "showtext", "svglite",
  "conflicted", "reticulate", "BiocManager")


DS <- c(
  "tidyverse", "data.table", "arrow", "tidymodels", "readxl", "writexl", "janitor",
  "mice", "missForest", "VIM"
)

statistics <- c(
  "moments", "nortest", "HH", "emmeans", "ez", "afex", "gee", "geepack", "epiDisplay", "psych",
  "poissonreg", "censored", "multilevelmod", "discrim", "ggeffects",
  "factoextra", "tidyclust"
)
remotes::install_github("jbryer/psa", build_vignettes = TRUE, dependencies = "Enhances")

visualization <- c(
  "patchwork", "ggpubr", "ggpattern", "survminer", "ggsurvfit", "pROC", "ggrepel", "ggcorrplot", "ggprism",
  "pheatmap", "ggfortify", "ggthemes", "ggpmisc", "plotly", "ggraph", "tidygraph"
)


table <- c("gt", "gtsummary", "tableone")


plug_in <- c("esquisse", "colourpicker", "styler")


pkgs <- c(tools, DS, statistics, visualization, table, plug_in)

lapply(pkgs, library)

# 语言

# 安装 en
# ~\etc\Rconsole    language=en
