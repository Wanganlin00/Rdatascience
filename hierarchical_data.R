library(tidyverse)
library(repurrrsive)
library(jsonlite)
#rectangling
##来自JSON或XML的嵌套数据
#JSON 是 javascript object notation 的缩写


                                                  #  list  ####       

list(a = 1:2, b = 1:3, c = 1:4)
c(c(1, 2), c(3, 4))            #一维

x3<-c(list(1, 2), list(3, 4))  #多个成分（向量、矩阵、数组、数据框）组成list
str(x3)
list(a=c(1),b=2,c=3,d=4)

#Hierarchy 层次结构 \树状结构
x4<- list(list(1, 2), list(3, 4))         
str(x4)
x5 <- list(x1=1,x2=list(y1=2,y2=list(z1=3, z2=list(p1=4, p2=list(q1=5)))))
x5
str(x5)
View(x5)

#list-columns 列表列
df <- tibble(
  x = 1:2, 
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df

                          #Unnesting 取消嵌套####

#unnest_wider()
df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32),
)
df1
tidyr::unnest_wider(df1,y)          #子列表已命名->列
tidyr::unnest_wider(df1,y,names_sep = "_")          #消除重复名称

#unnest_longer() 
df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)
df2
tidyr::unnest_longer(df2,y)        #子列表未命名->行

df6 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> unnest_longer(y,keep_empty = TRUE) #保留空行

#不一致的类型
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)
df4 |> unnest_longer(y)  #子列表->行


                                # 案例研究   ####
#非常宽的数据
repos <- tibble(json = gh_repos)
repos          # 6行列表
repos|> 
  unnest_longer(json)   # 176行命名子列表
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json)       #  176×68

repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner,names_sep = "_")      #  "_" 消除重复名称


#关系数据
chars<-tibble(json=got_chars) 
chars
chars |> 
  unnest_wider(json)

chars |> 
  unnest_wider(json) |> 
  select(name,titles) |> 
  unnest_longer(titles) 

tibble(json=got_chars) %>% 
  hoist(json,'name','titles') %>% #等价
  unnest_longer(titles)


#深度嵌套
gmaps_cities
gmaps_cities |> 
  unnest_wider(json)

gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) 

locations <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |> 
  unnest_wider(results)
locations
locations |> 
  select(city, formatted_address, geometry) |> 
  hoist(
    geometry,
    ne_lat = c("bounds", "northeast", "lat"),  #hoist() 直接提取
    sw_lat = c("bounds", "southwest", "lat"),
    ne_lng = c("bounds", "northeast", "lng"),
    sw_lng = c("bounds", "southwest", "lng"),
  )


                              #JSON格式####
# A path to a json file inside the package:
gh_users_json()

gh_users2 <- read_json(gh_users_json())
# Check it's the same as the data we were using previously
identical(gh_users, gh_users2)

#readr::parse_date()readr::parse_datetime()readr::parse_double()
str(parse_json('1'))
str(parse_json('[1, 2, 3]')) #数组

str(parse_json('{"x": [1, 2, 3],"y":[5,6]}'))#对象


json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}        
]'                #数组
df <- tibble(json = parse_json(json)) # json是df的一个列向量成分
df
unnest_wider(df,json)

json <- '{
  "status": "OK", 
  "results": [
    {"name": "John", "age": 34},
    {"name": "Susan", "age": 27}
 ]
}
'                #对象
df <- tibble(json = list(parse_json(json)))
df
df |> 
  unnest_wider(json) |> 
  unnest_longer(results) |> 
  unnest_wider(results)


df <- tibble(results = parse_json(json)$results)
df |> 
  unnest_wider(results)
