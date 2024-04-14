library(tidyverse)
library(babynames)
fruit#包含 80 种水果的名称。
words#包含 980 个常用英语单词。
sentences#包含 720 个短句。

                           # 直接匹配####
str_view(fruit, "berry")  
str_view(fruit, "a...e")

                        #字符组 Character classes ####

#   [...]    匹配方括号内任意一个字符
#   [^...]   匹配除方括号内的任意字符
str_view(words, "[aeiou]x[aeiou]")  #匹配元音之间的x

str_view(words, "[^aeiou]y[^aeiou]") #匹配辅音之间的y



                                          # 量词  Quantifier ####
# 贪婪量词 尽可能匹配
# 懒惰量词 原有量词后加一个 ? ，仅保持最小匹配

s<-c("a", "ab", "abb","aab","aa","aabb",'abbbbb')
  str_view(s, "ab?")  #    ?  匹配 0 或 1 次   {0,1}
  str_view(s, "ab??") 
  
  str_view(s, "ab+")  #    +  至少匹配一次    {1,}
  str_view(s, "ab+?")
  str_view(s, "ab*?")  #    *  匹配任意次数    {0,}

  #{n}正好匹配 n 次。
  #{n,}至少匹配 n 次。
  #{n,m}N 次和 M 次之间的匹配。
  x<-c("1234abcd  123 a33a bbbc  2223")
  str_view(x,"\\d{2}")
  
  str_view(x,"\\d{2,}")
  str_view(x,"\\d{2,3}")
  str_view(x,"\\d{2,3}?")
  
  # . 匹配除 \n 以外的任意字符
  
  
                                  # Key functions ####
# Detect matches
  str_detect(c("a", "b", "c"), "[aeiou]")
  babynames |> 
    dplyr::filter(str_detect(name, "x")) |> #筛选包含x的名字
    count(name, wt = n, sort = TRUE)  
  babynames |> 
    group_by(year) |> 
    summarize(prop_x = mean(str_detect(name, "x"))) |> 
    ggplot(aes(x = year, y = prop_x)) + 
    geom_line()
  
  #Count matches
  x <- c("apple", "banana", "pear")
  str_count(x, "p")  

  str_count("abababa", "aba")
  str_view("abababa", "aba")
  
  babynames |> 
    count(name) |> 
    mutate(
      vowels = str_count(name,
                         regex( "[aeiou]",ignore_case = TRUE)),#忽略大小写
      v1=str_count(name, "[aeiouAEIOU]"),
      v2=str_count(str_to_lower(name), "[aeiou]"),
      consonants = str_count(name,
                             regex( "[^aeiou]", ignore_case = TRUE))
    )
# Replace values
  x <- c("apple", "pear", "banana")
  str_replace(x, "[aeiou]", "-")  #替换第一个匹配
  str_replace_all(x, "[aeiou]", "")#替换所有匹配
  
  str_remove(x, "[aeiou]")      #删除        相当于替换符为""
  str_remove_all(x, "[aeiou]")   #str_replace(x, pattern, "")
  
#Extract variables
  df <- tribble(
    ~str,
    "<Sheryl>-F_34",
    "<Kisha>-F_45", 
    "<Brandon>-N_33",
    "<Sharon>-F_38", 
    "<Penny>-F_58",
    "<Justin>-M_41", 
    "<Patricia>-F_84", 
  )
  df |> 
    separate_wider_regex(
      str,
      patterns = c(
        "<", 
        name = "[A-Za-z]+", #匹配 ≥1 个字母
        ">-", 
        gender = ".",        #匹配任意字符
        "_",
        age = "[0-9]+"      #匹配 ≥1 个数字
      )
    )
#Escaping  转义   ####
  
  # To create the regular expression \., we need to use \\.
  dot <- "\\."
  str_view(dot)
  str_view(c("abc", "a.c", "bef"), "a\\.c")  

  x <- "a\\b"         
  str_view(x)        #a\b
  str_view("\\\\")  #\\
  str_view(x, "\\\\") #一个特殊字符需要\\转义
  str_view(x, r"{\\}")
x<-c("abc", "a.c", "a*c", "a c")
str_view(x, "a[.]c")
str_view(x, ".[*]c")

                        #  Anchors  锚点#### 
# 匹配开头或结尾：^$  s
str_view(fruit, "^a")
str_view(fruit, "a$")

str_view(fruit, "apple")
str_view(fruit, "^apple$") #仅匹配完整字符串

#  \b  单词的开头或结尾
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")
str_view(x, "^sum$")
str_view(x, "\\bsum\\b") 
# zero-width match
str_view("abc", c("$", "^", "\\b"))
str_replace_all("abc", c("$", "^", "\\b"), "++")


                            #Character classes####
#  -   定义一个范围，匹配任何小写字母并匹配任何数字。[a-z][0-9]
#  \   对特殊字符进行转义，[\^\-\]]  匹配 ^、-和 ]
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "[abc]+")
str_view(x, "[a-z]+")
str_view(x, "[^a-z0-9]+")

#\d匹配任何数字;匹配任何非数字的内容\D
str_view(x, "\\d+")
str_view(x, "\\D+")
#\s匹配任何空格（例如，空格、制表符、换行符）;匹配任何非空格的内容。\S
str_view(x, "\\s+")
str_view(x, "\\S+")
#\w匹配任何“单词”字符，即字母和数字;匹配任何“非单词”字符。\W
str_view(x, "\\w+")
str_view(x, "\\W+")


#alternation
str_view(fruit, "apple|melon|nut")
str_view(fruit, "aa|ee|ii|oo|uu")

files <- list.files()

str_view(files,"包\\.(R|Rdata|txt)")

         # 分组和引用 ####
# 捕获分组 ()   非捕获分组 (?: )
# 引用
str_view(fruit, "(..)\\1")  #引用第一个
str_view(words, "^(..).*\\1$")
sentences |>                  #交换第二个单词和第3个单词的顺序
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

sentences |> 
  str_match("The (\\w+) (\\w+)") |> 
  head(20)
x <- c("a gray cat", "a grey dog")
str_match(x, "gr(e|a)y")
str_match(x, "gr(?:e|a)y")   #(?: )创建非捕获组

                 #  模式控制  ####
#Regex flags
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, regex("banana", ignore_case = TRUE))


x <- "Line 1\nLine 2\nLine 3"
str_view(x, ".Line")
str_view(x, regex(".Line", dotall = TRUE))#匹配所有内容,包括 \n

str_view(x, "^Line")
str_view(x, regex("^Line", multiline = TRUE))#多行匹配

phone <- regex(                           #注释
  r"(
    \(?     # optional opening parens  
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)
str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)


#固定匹配
str_view(c("", "a", "."), stringr::fixed("a"))
str_view("x X", stringr::fixed("X", ignore_case = TRUE))
















                     #练习####
#检查
str_view(sentences, "^The\\b")  #找到以The开头的句子

str_view(sentences, "^(She|He|It|They)\\b")#找到以代词开头的句子

pn <- c("He is a boy", "She had a good time",
         "Shells come from the sea", "Hadley said 'It's a great day'")
pattern <- "^(She|He|It|They)\\b"
str_detect(pn, pattern)

# 布尔运算
str_view(words, "^[^aeiou]+$")
words[!str_detect(words, "[aeiou]")]

str_view(words, "a.*b|b.*a")
words[str_detect(words, "a") & str_detect(words, "b")]

words[
  str_detect(words, "w") &
    str_detect(words, "a") &
    str_detect(words, "l") 
]

#创建模式
str_view(sentences, "\\b(red|green|blue)\\b")

cols <- colors()
cols <- cols[!str_detect(cols, "\\d")]
str_view(cols)
pattern <- str_c("\\b(", str_flatten(cols, "|"), ")\\b")
str_view(sentences, pattern)

str_escape()

setwd("F:/R语言/tidyverse")
head(list.files(pattern = ".*(\\.R)$"))
