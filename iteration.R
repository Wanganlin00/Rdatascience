                                 #修改多个列####
across(.cols, .fns, ..., .names = NULL, .unpack = FALSE)
if_any(.cols, .fns, ..., .names = NULL)
if_all(.cols, .fns, ..., .names = NULL)
everything()        #选择每一列
where()  #根据类型选择列
'where(is.numeric) selects all numeric columns.
where(is.character) selects all string columns.
where(is.Date) selects all date columns.
where(is.POSIXct) selects all date-time columns.
where(is.logical) selects all logical columns.'


A <- c(3,4,1,2,5)
all(A>2)
any(A>2)
which(A>4)

#Selecting columns with .cols
set.seed(1234)
df <- tibble(
  grp = sample(1:2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
df |> 
  group_by(grp) |> 
  summarize(
    n=n(),
    across(everything(), median))

#Calling a single function

#Calling multiple functions
rnorm_na <- function(n, n_na, mean = 0, sd = 1) {
  sample(c(rnorm(n - n_na, mean = mean, sd = sd), rep(NA, n_na)))
}

df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)
df_miss
df_miss |> 
  summarize(
    across(a:d, function(x) median(x, na.rm = TRUE)),
    n = n()
  )
df_miss |> 
  summarize(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),#用\代替function
      n_miss = \(x) sum(is.na(x)))
      ),
    n = n()
  )

#Column names
df_miss |> 
  summarize( #汇总
    across(
      .col=a:d,
      .fns=list(
        median = \(x) median(x, na.rm = TRUE),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    ),
    n = n(),
  )
df_miss |> 
  mutate(     #添加
    across(a:d, \(x) coalesce(x, 0), .names = "{.col}_na_zero")
  )
#Filtering
df_miss |> dplyr::filter(if_any(a:d, is.na))
# same as df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))


df_miss |> dplyr::filter(if_all(a:d, is.na))
# same as df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))


#in functionsacross()
expand_dates <- function(df) {
  df |> 
    mutate(
      across(where(is.Date), list(year = year, month = month, day = mday))
    )
}

df_date <- tibble(
  name = c("Amy", "Bob"),
  date = ymd(c("2009-08-03", "2010-01-16"))
)

df_date |> 
  expand_dates()

summarize_means <- function(df, summary_vars = where(is.numeric)) {
  df |> 
    summarize(
      across({{ summary_vars }}, \(x) mean(x, na.rm = TRUE)),
      n = n(),
      .groups = "drop"
    )
}
diamonds |> 
  group_by(cut) |> 
  summarize_means()
diamonds |> 
  group_by(cut) |> 
  summarize_means(c(carat, x:z))

#Vs pivot_longer
df
df |> 
  summarize(across(a:d, list(median = median, mean = mean)))

long <- df |> 
  pivot_longer(a:d,names_to = "name",values_to = "value") |> 
  group_by(name) |> 
  summarize(
    median = median(value),
    mean = mean(value)
  )
long
long |> 
  pivot_wider(
    names_from = name,
    values_from = c(median, mean),
    names_vary = "slowest",
    names_glue = "{name}_{.value}"
  )
                          #读取多个文件####
rm(list = ls())
# 分部进行  list.files(path,pattern,full.name)
paths <- list.files("data", pattern = "sales[.]csv$", 
                    full.names = TRUE,recursive = TRUE)
paths
library(arrow)
files<-list(
  read_csv("data/01-sales.csv"),
  read_csv("data/02-sales.csv"),
  read_csv("data/03-sales.csv")
)
files

rm(list = ls())
                      #循环迭代  purrr::map(),list_rbind(),list_cbind ####
map(x, f)
list( f(x[[1]]) , f(x[[2]]) , ..., f(x[[n]] ))   #  map(list,function)

files <- map(paths, read_csv) 
length(files)
files

purrr::list_rbind(files)    #行合并


#路径中的数据
set_names(paths,basename)  #从路径中提取文件名,文件名也是一列数据
files <- list(
  "01-sales.csv"=read_csv("data/01-sales.csv"),
  "02-sales.csv"=read_csv("data/02-sales.csv"),
  "03-sales.csv"=read_csv("data/03-sales.csv"))

files <- map(set_names(paths,basename),read_csv)#简写 文件名进入数据框
files
files$`01-sales.csv`

paths |> 
  set_names(basename) |> 
  map(read_csv) |> 
  list_rbind(names_to = "file_name_csv") |> #文件名 to 列名
  write_csv( "data/2019第一季度销售情况.csv") #保存



#推荐多次简单迭代
paths |> 
  map(read_csv) |> 
  map(\(df) df |> dplyr::filter(!is.na(n)))|> 
  map(\(df) df |> mutate(id =LETTERS[1:nrow(df)] )) |> 
  list_rbind()

#异构数据
df_types <- function(df) {  #捕获数据框结构
  tibble(
    col_name = names(df), 
    col_type = map_chr(df, vctrs::vec_ptype_full),
    n_miss = map_int(df, \(x) sum(is.na(x)))
  )
}
files |> 
  map(df_types) |> 
  list_rbind(names_to = "file_name") |> 
  select(-n_miss) |> 
  pivot_wider(names_from = col_name, values_from = col_type)


#处理故障
files <- paths |> 
  map(possibly(\(path) readxl::read_excel(path), NULL))
data <- files |> list_rbind()

failed <- map_vec(files, is.null)  #获取失败文件路径
paths[failed]



                           #保存多个对象####
rm(list = ls())
paths <- list.files("data", pattern = "sales[.]csv$", 
                    full.names = TRUE,recursive = TRUE)

#写入数据库####
con <- DBI::dbConnect(duckdb::duckdb())
duckdb::duckdb_read_csv(con, "sales", paths) #读取到数据库
library(DBI)
library(dbplyr)
dbListTables(con)

con |> 
  dbReadTable("sales") |> 
  as_tibble()
tbl(con, "sales") 

DBI::dbCreateTable(con, "gapminder", template)  #创建数据库table
append_file <- function(path) {       #追加文件路径
  df <- readxl::read_excel(path)
  df$year <- parse_number(basename(path))
  DBI::dbAppendTable(con, "gapminder", df)
}
paths |> map(append_file)
paths |> walk(append_file)  #不看输出

                                       #写出 csv 文件####

by_clarity <- diamonds |> 
  group_nest(clarity)        #分组列表列
by_clarity

by_clarity <- by_clarity |> 
  mutate(path = str_glue("data/diamonds-{clarity}.csv"))#添加文件名
by_clarity
                                  #map2()walk2() 两个参数变化
map2(by_clarity$data, by_clarity$path, write_csv) #控制台有输出
walk2(by_clarity$data, by_clarity$path, write_csv) #控制台无输出


                             #保存绘图####
carat_histogram <- function(df) {
  ggplot(df, aes(x = carat)) + geom_histogram(binwidth = 0.1)  
}
carat_histogram(by_clarity$data[[1]])

by_clarity <- diamonds |> 
  group_nest(clarity) 
by_clarity <- by_clarity |> 
  mutate(
    plot = map(data, carat_histogram),
    path = str_glue("data/histogram-{clarity}.png")
  )
by_clarity
walk2(
  by_clarity$path,
  by_clarity$plot,
  \(path, plot) ggsave(path, plot, width = 6, height = 6)
)
