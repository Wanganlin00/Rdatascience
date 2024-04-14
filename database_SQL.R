library(DBI)
library(dbplyr)
library(tidyverse)


                                           #连接数据库####
con <- DBI::dbConnect(
 # RMariaDB::MariaDB(), 
  username = "foo"
)
con <- DBI::dbConnect(
 # RPostgres::Postgres(), 
  hostname = "databases.mycompany.com", 
  port = 1234
)

library(duckdb)
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")#持久数据库
con <- DBI::dbConnect(duckdb::duckdb())  #临时数据库

dbWriteTable(con, "mpg", ggplot2::mpg)  #添加数据
dbWriteTable(con, "diamonds", ggplot2::diamonds)

#DBI
dbListTables(con)  #列出table


con |> 
  dbReadTable("mpg") |> 
  as_tibble()

sql <- "
  SELECT carat, cut, clarity, color, price 
  FROM diamonds 
  WHERE price > 15000" 
as_tibble(dbGetQuery(con, sql))     #SQL直接从数据库查询

#dbplyr
diamonds_db <- tbl(con, "diamonds")  #创建数据库表（table）
diamonds_db                     

big_diamonds_db <- diamonds_db |> 
  dplyr::filter(price > 15000) |> 
  select(carat:clarity, price)      #dbplyr代码转化为SQL再查询

big_diamonds_db |>
  show_query()

big_diamonds <- collect( big_diamonds_db)            #返回数据到R中
big_diamonds


                                        #SQL####


diamonds_db <- tbl(con, "diamonds")  #创建数据库表（table）
diamonds_db                     

diamonds_db |> 
  select(carat,cut,price) |> 
  dplyr::filter(carat<=3) |> 
  group_by(cut) |> 
  summarize(
    n = n(),
    mean_price = mean(price, na.rm = TRUE)
  ) |> 
  arrange(mean_price) |> 
  show_query()

SQL
"SELECT cut, COUNT(*) AS n, AVG(price) AS mean_price
  FROM (
  SELECT carat, cut, price
  FROM diamonds
  WHERE (carat <= 3.0)
) q01
GROUP BY cut
ORDER BY mean_price
LEFT JOIN y ON (key = key)
INNER JOIN y ON (key = key)"#right_join()full_join()
