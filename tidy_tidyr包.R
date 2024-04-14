#数据重塑

#                             宽表-->长表                            ####
pivot_longer(data ,cols ,names_to ,names_sep ,values_to ,names_pattern ,...)

#值列中只有一个变量####
tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)|> 
  pivot_longer(
    cols = -id,
    names_to = "measurement",
    values_to = "value"
  )
#值列中有两个变量
tibble(ID=c("A","B","C"),
       GDP_2019=c(114,251,152),
       GDP_2018=c(215,115,141),
       GDP_2017=c(141,244,243)) %>% 
  pivot_longer(
    cols = -ID,
    names_to =c(".value","year"),
    names_sep = "_") %>% 
  .[order(.$year),]


billboard
billboard |> 
  pivot_longer(
    cols = starts_with("wk"), #cols指定哪些列不是变量
    names_to = "week",        #names_to将存储原列名，命名为week
    values_to = "rank",       #values_to命名存储在单元格值中的值，命名为 rank
    values_drop_na = TRUE    #删除含有NA的行
  )|> 
  mutate(
    week = parse_number(week)#忽略第一个连续数字前后的字符
  ) %>% 
  dplyr::filter(week>20)|>          #很少有歌曲在前 100 名中停留超过 20 周。
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

#值列中有多个变量####
who2
who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  )

household
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), #".value"将 以_分隔的第一部分用作列名来存储值，
                                    #第二部分child1，child2作为新变量child的值
    names_sep = "_", 
    values_drop_na = TRUE #删除NA
  )
tribble(
  ~d1_name,~d1_major,~d2_name,~d2_major,~d3_name,~d3_major,
  '张非',"math",'李斯','English','王武','statistic',
  '钟爱','English','陈述','math','孙健','medicine'
) %>% 
  pivot_longer(
    col=starts_with("d"),
    names_to = c("group",".value"),
    #names_sep = "_",
    names_pattern = "(.*\\d)(.*)"  #正则表达式
  )



#                     长表-->宽表                 ####
pivot_wider(data ,id_cols ,names_from ,values_from ,valus_fill ,...)

#一个列名列####
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)
df |> 
  distinct(measurement) |> #新列名是唯一值
  pull()
df |> 
  select(-measurement, -value) |> 
  distinct()              #输出中的行，id_cols
df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA) #组成空数据框

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

#多个列名列或多个值列####

cms_patient_experience
cms_patient_experience |> 
  distinct(measure_cd, measure_title)  #唯一值 列名列
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),#唯一标识列，默认是除了name_from,value_from指定列之外的列，measure列只有6种，不具有标识作用
    names_from = measure_cd,#列名来自某一列的单元格值
    values_from = prf_rate  #值来自原数值变量列的单元格值
  )

us_rent_income
us_rent_income %>% 
  pivot_wider(
    names_from = variable,
    values_from = c(estimate,moe)
  )

#常见错误####
tibble(
  x=1:6,
  y=c("A","A",'B','B','C','C'),
  z=c(3,5,7,9,11,13)
) %>% 
  pivot_wider(
    names_from = y,
    values_from = z
  )            #无法压缩行数

tibble(
  x=1:6,
  y=c("A","A",'B','B','C','C'),
  z=c(3,5,7,9,11,13)
) %>% 
  .[-1] %>% #删除标识列——x列，值不能被唯一识别
  pivot_wider(
    names_from = y,
    values_from = z
  )  

tibble(
  x=1:6,
  y=c("A","A",'B','B','C','C'),
  z=c(3,5,7,9,11,13)
) %>% 
  group_by(y) %>% #增加各组的唯一识别列
  mutate(group_n=row_number()) %>% 
  .[-1] %>% #删除唯一标识列
  pivot_wider(
    names_from = y,
    values_from = z
  ) %>% 
  .[-1]
  
#                                 拆分列        ####
#separate(data,col,into,sep,...)

table3
table3 %>% 
  separate(rate,into = c('cases','population'),
           sep='/',convert=TRUE)
tibble(
  Class=c("Class 1",'Class 2'),
  name=c('Amy,Aly,Cron,Tex','Bob,Jhon,Mike')
) %>% 
  separate_rows(name,sep = ',') %>%    #还原
  group_by(Class) %>% 
  summarise(name=str_c(name,collapse = ','))


#extract() #正则表达式

tibble(
  obs.=c('Rich(Sam)','Wind(Ash)','Bil(Hela)'),
  A_count=c(7,10,5)
) %>% 
  extract(obs.,into = c("site","surveyor"),
          regex = "(.*)\\((.*)\\)")
#                                 合并列        ####
#unite(data,col,sep,...)
table5
table5 %>% 
  unite(year_Y,century,year,sep='')
                 


