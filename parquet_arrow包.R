library(tidyverse)
library(arrow)

                                    #获取数据####
dir.create("data", showWarnings = FALSE)
curl::multi_download(      # 9GB       #西雅图公共图书馆借书人次/书/月
  "https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv",
  "data/seattle-library-checkouts.csv",   #路径
  resume = TRUE
)
                                # 打开数据集####
seattle_csv <- arrow::open_dataset(
  sources = "data/seattle-library-checkouts.csv", 
  col_types = arrow::schema(ISBN = string()),
  format = "csv"
)
"seattle_csv
glimpse(seattle_csv)                                    #慢
seattle_csv |> 
  group_by(CheckoutYear) |> 
  summarise(Checkouts = sum(Checkouts)) |>              #慢
  arrange(CheckoutYear) |> 
  dplyr::collect()"
                         


                            #The parquet format ####
#readr::read_file()
path_pq<-"data/seattle-library-checkouts"

                            #重写为parquet格式文件
seattle_csv |>
group_by(CheckoutYear) |>
  write_dataset(path_pq, format = "parquet")

tibble(
  files = list.files(path_pq, recursive = TRUE),        #列出路径中的文件，递归
  size_MB = file.size(file.path(path_pq, files)) / 1024^2
) |> 
  summarise(
    size_GB=sum(size_MB/1024)
  )
  

                       #    Using dplyr with arrow  ####

seattle_pq <- open_dataset(path_pq)

query <- seattle_pq |> 
  dplyr::filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(CheckoutYear)
query
collect(query)       #返回结果

#性能
seattle_pq |> 
dplyr::filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

#duckdb
seattle_pq |> 
  to_duckdb() |>  #arrow::to_duckdb()
  dplyr::filter(CheckoutYear >= 2018, MaterialType == "BOOK") |>
  group_by(CheckoutYear) |>
  summarize(TotalCheckouts = sum(Checkouts,na.rm = TRUE)) |>
  arrange(desc(CheckoutYear)) |>
  collect()


