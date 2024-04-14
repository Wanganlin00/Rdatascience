library(tidyverse)
library(babynames)


                        #创建字符串####

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

#转义字符   \
single_quote <- '\'' # or "'"
double_quote <-  "\""# or '"'
backslash <- "\\"
x <- c(single_quote, double_quote, backslash)
x
str_view(x)  

#Raw strings

tricky1 <- "double_quote <- \"\\\"\" # or '\"'\nsingle_quote <- '\\'' # or \"'\""
str_view(tricky1)

tricky2 <- r"(double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'")"
str_view(tricky2)
#r"()"       r"[]"          r"{}"         r"--()--"      r"---()---"


?Quotes  #\n\t\b
x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
x
str_view(x)
x <- "This\u00a0is\u00a0tricky"
x
str_view(x)

                               #从数据创建字符串####
#str_c（）将任意数量的向量作为参数，并返回长度与其中最长向量相同的字符向量
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))
str_c(c("x","y"),NA)  #NA NA

df <- tibble(name = c("Flora", "David", "Terra", NA))
df |>
  mutate(greeting = str_c("Hello ", name, "!"))

c(c('x','y',NA),'z')  #合并
coalesce(c('x','y',NA),'z') #删除NA合并
df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"), #注意顺序
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")  #
  )

#str_glue()   a character vector's each element  into a single string
df |> mutate(greeting = str_glue("Hi {name}!"))
df |> mutate(greeting = str_glue("{{Hi {name}!}}")) #double up 转义

#str_flatten()  a character vector combines each element ，return a single string
str_flatten(c("x", "y", "z"))#默认""
str_flatten(c("x", "y", "z"),collapse = "+")
str_flatten(c("x", "y", "z"), "+", last = "-")
?str_flatten

df <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)
df |>
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ",",last=" and "))


           #tidyr包        #提取 Extracting data from strings  ####
df |> separate_longer_delim(col, delim)
df |> separate_longer_position(col, width)
df |> separate_wider_delim(col, delim, names)
df |> separate_wider_position(col, widths)

#分隔成行
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")

df2 <- tibble(x = c("1211", "131", "21"))
df2 |> 
  separate_longer_position(x, width = 2)

#分成列
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", NA, "year") #用NA省略
  )
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA")) 
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )
tibble(x = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))|> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start" #"debug"，"align_end"
  )

tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))|> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"    #"debug"，"drop"     #     debug |> filter(!x_ok)
  )


                          #字母####

str_length(c("a", "R for data science", NA))   #长度
babynames
babynames |>
  count(length = str_length(name), wt = n)
babynames |>
  group_by(length=str_length(name)) %>% 
  summarise(sum=sum(n),n=n())

#子集 str_sub(string, start, end)
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)

                    #非英文文本####

#编码    从十六进制数字到字符的映射称为编码  UTF-8
charToRaw("Hadley")

x1 <- "text\nEl Ni\xf1o was particularly bad this year"
x2 <- "text\n\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
read_csv(x1, locale = locale(encoding = "Latin1"))
read_csv(x2, locale = locale(encoding = "Shift-JIS"))
#字母变体
u <- c("\u00fc", "u\u0308")
str_view(u)
str_length(u)
str_sub(u, 1, 1)
u[[1]] == u[[2]]
str_equal(u[[1]], u[[2]])

#与语言环境相关的函数
stringi::stri_locale_list()
str_to_upper(c("i", "ı"), locale = "tr")#土耳其语
str_sort(c("a", "c", "ch", "h", "z"), locale = "cs") #捷克语
