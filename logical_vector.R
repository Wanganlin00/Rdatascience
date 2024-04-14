                                  # Logical vectors ####

#比较   < ，<=，>，>=，!=，== ####
library(nycflights13)
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
  ) |> 
  dplyr::filter(daytime & approx_ontime)
#Floating point comparison
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x
print(x, digits = 20) # 计算机存储1/49和sqrt(2) 有固定的小数位数，后续计算有偏差
x == c(1, 2)       
#忽略小差异
dplyr::near(x, c(1, 2))

#m issing value 缺失值  传染性    contagious
#is.na()
dplyr::filter(flights ,is.na(dep_time))

flights |> 
  dplyr::filter(month == 1, day == 1) |> 
  arrange(desc(is.na(dep_time)), dep_time) 
#第一次排序根据is.na()降序T->F,第二次排序根据dep_time升序

#Boolean algebra 布尔代数####
df <- tibble(x = c(TRUE, FALSE, NA))

df |> 
  mutate(
    and = x & NA, # FALSE & NA=F
    or = x | NA   # TRUE | NA=T
  )


#顺序 
flights |> 
  dplyr::filter(month == 11 | month == 12)
#错误
flights |> 
  dplyr::filter(month == 11 | 12) #除0以外
NA | 12
FALSE|12
NA|0 
F|0
#x %in% y
flights |> 
  dplyr::filter(month %in% c(11, 12))
c(1, 2, NA) == NA
c(1, 2, NA) %in% NA
flights |> 
  dplyr::filter(dep_time %in% c(NA, 0800))


#Summaries####
#逻辑摘要
flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE), #返回逻辑值
    #找出每个航班在起飞时是否最多延误一个小时
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    #是否有任何航班在抵达时延误五个小时或更长时间
    .groups = "drop"
  )

#数字摘要
flights |> 
  group_by(year, month, day) |>  
  summarize(  #T->1,F->0，mean(0,1)->proportion
    all_delayed = mean(dep_delay <= 60, na.rm = TRUE),#起飞时最多延误一小时的航班比例
    any_long_delay = sum(arr_delay >= 300, na.rm = TRUE),#抵达时延误五小时或更长时间的航班数量
    .groups = "drop"
  )

#逻辑子集
flights |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay <= 0], na.rm = TRUE),
    n= n(),#每天的航班总数，按分组计数
    .groups = "drop"
  )
#条件转换  if_else  case_when   ####

#if_else(condition，true，false,missing)
x<-c(-3:3,NA)
if_else(x == 0, "0", if_else(x < 0, "-ve", "+ve"),missing = NA)


#case_when()

x <- c(-3:3, NA)
case_when(
  x == 0   ~ "0",      
  x < 0    ~ "-ve",    #优先使用第一个匹配条件
  x > 0    ~ "+ve",
  is.na(x) ~ NA,
  .default = "Error"  #没有匹配，默认NA，可修改
)
flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)      ~ "cancelled",
      arr_delay < -30       ~ "very early",
      arr_delay < -15       ~ "early",
      abs(arr_delay) <= 15  ~ "on time",
      arr_delay < 60        ~ "late",
      arr_delay < Inf       ~ "very late",
    ),
    .keep = "used"
  )
#兼容类型
数字向量和逻辑向量是兼容的
字符串和因子是兼容的
日期和日期时间是兼容的






                                  