library(tidyverse)
library(rvest)

 #  HTML basic：HyperText Markup Language 超文本标记语言 ####
"<html>                  #document metadata
  <head>                       #start tag <...>
  <title>Page title</title>
  </head>                     #end tag  </...>
<body>   #contents  # Block tags: <h1><section><p><ol> <ul>heading 1,section,paragraph,ordered list
 <h1 id='first' >  A heading</h1>   #<tag attributes> id,class 命名属性 name1='value1'
   <p>Some text &amp; <b>some bold text.</b></p>   #Inline tags:<b><i><a>  bold,italics,link
                                #  HTML escapes： &gt;&lt;&amp    greater than:>,less than:<，ampersand：&
   <a href='webscraping' > https://r4ds.hadley.nz/webscraping </a> #href <a>
   <img src='myimg.png' width='100' height='100'>   #src <img>
</body>
"
                                        #提取数据 ####
read_html("http://rvest.tidyverse.org/")

                       #查找元素
html <- minimal_html("
  <h1>This is a heading</h1>
  <p id='first'>This is a paragraph</p>
  <p id='important'>This is an important paragraph</p>
  <p class='important'>This is an important paragraph</p>
  <p class='first'>This is a  paragraph</p>
   <img id='first',src='myimg.png' width='100' height='100'> 
")
#cascading style sheets:级联样式表     CSS选择器
html
html |> html_elements("p")  #selects all p
html |> html_elements(".first") # all  .class
html |> html_elements("#first")#  all   #id
    
html |> html_element("p")  #返回第一个

html |> html_elements("b")    #> {xml_nodeset (0)}
html |> html_element("b")     #> {xml_missing}   #> <NA>

#嵌套选择 Nesting selections
html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ")
characters <- html |> html_elements("li")
characters
characters |> html_element("b")
characters |> html_element(".weight")
characters |> html_elements(".weight")

# Text 
characters |> 
  html_element("b") |> 
  html_text2()
characters |> 
  html_element(".weight") |> 
  html_text2()                 #提取纯文本内容
#attributes
html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")
html |> 
  html_elements("p") |> 
  html_element("a") |> 
  html_attr("href")

#table              <table><tr><th><td> 行、标题heading、数据

html <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
  ")
html |> 
  html_element(".mytable") |> 
  html_table(convert = F)

                                 #示例####
#1
url <- "https://rvest.tidyverse.org/articles/starwars.html"
html <- read_html(url)

section <- html |> html_elements("section") #提取元素section
section
tibble(
  title = section |> 
    html_element("h2") |>   #提取h2标题文本：电影名称
    html_text2(),
  released = section |> 
    html_element("p") |>    #提取p段落文本：日期
    html_text2() |> 
    str_remove("Released: ") |> 
    parse_date(),
  director = section |>       
    html_element(".director") |> #提取.class=director属性：导演
    html_text2(),
  intro = section |> 
    html_element(".crawl") |>  #提取.class=crawl属性：简介
    html_text2()
)
#2 IMDB top 250 电影

