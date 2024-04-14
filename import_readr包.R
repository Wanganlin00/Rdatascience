#readr 包   read_csv,tsv,rds,csv2,tsv2;   write_*
#haven 包   read_spss,dta,sas  write_spss write_stata write_sas
#readtext包  readtext  json,html,pdf,doc,xlsx
#xml2包       XML


                      #csv文件 （comma separated Values|逗号分隔值）####
read_csv(file,col_names,col_select,col_types,locale,skip,na,n_max,...)

#read_csv2,读取以分号;作分隔符的文件
#read_tsv,读取以制表符tab作分隔符的文件
#read_delim(),任意指定分隔符
#read_fwf()，reads fixed-width files固定宽度，fwf_widths()fwf_positions()
#read_table（）读取固定宽度文件的常见变体，其中列由空白分隔。
#read_log() reads Apache-style log files
students <- read_csv("data/students.csv", 
                     locale=locale(encoding="GBK"),# 默认编码UTF-8
                     na = c("N/A", ""))
#read_csv(path, na = "99")
students  #变量名称包含空格，用反引号``括

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

students |>               #install.packages("janitor")
  janitor::clean_names()  #一次性整理变量名

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan), #因子
    age = parse_number(if_else(age == "five", "5", age)) #数值
  )
students

read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE #无列名，自动X1——Xn
)
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z") #设置列名
)
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2      #跳过前n行
)
read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"  #通过'#'标记的行
)
read_csv("a,b
         1,'2,3'
         4,5,6")

set.seed(1234)
tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
) %>% 
  mutate(
    `3`=`2`/`1`
  ) %>% 
  rename(
    one=`1`,
    two=`2`,
    three=`3`
  )

#控制列类型

#列类型，col_logical()，col_integer()，col_character()，col_factor()，
#col_date()，col_datetime()，col_number()，col_skip()跳过列
read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")
simple_csv <- "
  x
  10
  .
  20
  30"
read_csv(simple_csv)

df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)
problems(df)
read_csv(simple_csv, na = ".")

another_csv <- "
x,y,z
1,2,3"
read_csv(
  another_csv, 
  col_types = cols(.default = col_character())#覆盖默认列类型
)
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())#指定列
)

#写出csv文件####
#write_csv(x,path,na,append)

write_csv(students,"data/students-2.csv")
read_csv("data/students-2.csv")#设置的变量类型信息factor会丢失


#批量读取csv文件####
sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")

sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE) #正则表达式
read_csv(sales_files, id = "file") #id标识数据来源




#数据框####
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)
tribble(              #transposed tibble
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)










                                #Excel文件####

library(readxl)
library(writexl)
read_excel(path,sheet,range,col_names,col_types,skip,na,n_max,...) 

 #col_type=c("skip","guess","logical","numeric","date","text","list" )

#读取excelspreadsheet####
students<-read_excel("tidyverse/data/students.xlsx",
                     col_names = c("student_id", "full_name", 
                                   "favourite_food", "meal_plan", "age"),
                     skip = 1, #跳过第1行
                     na = c("", "N/A"),
                     col_types = c("numeric", "text", "text", "text", "text")
                     )
students <- students |>
  mutate(
    age = if_else(age == "five", "5", age),
    age = parse_number(age)
  )
students


#读取excel worksheet####
excel_sheets("tidyverse/data/penguins.xlsx")
penguins_biscoe <- read_excel("tidyverse/data/penguins.xlsx", sheet = "Biscoe", na = "NA")
penguins_dream  <- read_excel("tidyverse/data/penguins.xlsx", sheet = "Dream", na = "NA")
penguins_torgersen<-read_excel("tidyverse/data/penguins.xlsx", sheet = "Torgersen")

dim(penguins_biscoe)
dim(penguins_dream)
dim(penguins_torgersen)

penguins <- bind_rows(penguins_torgersen, penguins_biscoe, penguins_dream)
penguins


#读取worksheet一部分

deaths<-read_excel("tidyverse/data/deaths.xlsx",range = "A5:F15")

#写出Excel文件####

write_xlsx(deaths,"tidyverse/data/deathsA5_F15.xlsx")




#批量读取Excel文件####
files<-fs::dir_ls("data",recurse = TRUE,glob="*.xlsx")
files
library(readxl)
excel<-map_dfr(set_names(files),read_excel,sheet=1,.id="source")#不同Excel文件 行合并

path="data/b二季度各业GDP.xlsx"
df<-map_dfc(set_names(excel_sheets(path)),
            ~read_excel(path,sheet=.x),.id="sheet")  #同一Excel文件的sheet 列合并



#批量写出到Excel文件####
dfs1<-iris %>% group_split(Species)   #分组成列表
dfs1
files.name<-str_c("data/",levels(iris$Species),".xlsx")  #文件名
files.name
walk2(dfs1,files.name,write_xlsx)   #写出到不同Excel文件

dfs2<-dfs1 %>% set_names(levels(iris$Species))  #sheet名
write_xlsx(dfs2,"data/iris.xlsx") #写出到同一Excel文件的多个sheet



                              #RDS和parquet格式####
write_rds(students, "data/students.rds")# 
read_rds("data/students.rds")

library(arrow)
write_parquet(students, "data/students.parquet")#a fast binary file format
read_parquet("data/students.parquet")


# 1-列出目录中的文件  list.files(path,pattern,full.name)
paths <- list.files("data/seattle-library-checkouts", 
                    pattern = "[.]parquet$", 
                    full.names = TRUE,recursive = TRUE)
paths
# 2-放入列表
library(arrow)
files<-list(
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2005/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2006/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2016/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2017/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2018/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2019/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2020/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2021/part-0.parquet"),
  read_parquet("data/seattle-library-checkouts/CheckoutYear=2022/part-0.parquet")
)
