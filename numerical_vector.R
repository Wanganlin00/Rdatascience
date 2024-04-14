#  数值向量 ####

#解析数字####data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==
parse_double()
parse_number("1244gag") #忽略非数字文本
?parse_number
?col_number
#计数####
count()
flights |> count(dest, sort = TRUE)
flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),#访问有关“当前”组的信息
    delay = mean(arr_delay, na.rm = TRUE)
  )
flights |> 
  group_by(dest) |> 
  summarize(
    carriers = n_distinct(carrier)) |> #计算一个或多个变量的不同（唯一）值的数量
  arrange(desc(carriers))

#加权计数
flights |> count(tailnum, wt = distance)
flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))


#数值转换####

#recycling or repeating the short vector  ####
x <- c(1, 2, 10, 20)
x / 5
x / c(5, 5, 5, 5)
x * c(1, 2)
x * c(1, 2, 3)
flights |> 
  dplyr::filter(month == c(1, 2)) # 1月份出发的奇数行中的航班和 2 月份出发的偶数行中的航班
flights |> 
  dplyr::filter(month %in% c(1, 2)) # 1月份和2月份出发的航班

#Minimum and maximum####
df <- tribble(
  ~x, ~y,
  1,  3,
  5,  2,
  7, NA,
)

df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),  #每行的最小值或最大值
    max = pmax(x, y, na.rm = TRUE)
  )
df |> 
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )
#Modular arithmetic  模运算####
1:10 %/% 3       #整除

1:10 %% 3       #余数
flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  dplyr::filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") + 
  geom_point(aes(size = n))
#Logarithms 对数####
log(exp(10))
log2(8)
log10(1000)
#Rounding 舍入 ####
round(x, digits)
round(123.456, 2)
round(123.456, -2)
#Round to nearest multiple of 4
round(x / 4) * 4
# Round to nearest 0.25
round(x / 0.25) * 0.25
# ***.5 will be rounded to the even integer（偶数整数）
round(c(2.5,3.5,6.5,7.5,11.5)) 
x<-123.456

floor(x)
ceiling(x)


#Cutting numbers into ranges####
x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))   #因子
cut(x, breaks = c(0, 5, 10, 100),right = F)
cut(x, breaks = c(0, 5, 10, 100),include.lowest =T)

cut(x, 
    breaks = c(0, 5, 10, 15, 20), 
    labels = c("sm", "md", "lg", "xl"))
y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))


cumsum(1:10) #累和
# 常规转换   ####
#排名
x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)
min_rank(desc(x))
#偏移量offset
x <- c(2, 5, 11, 11, 19, 35)
dplyr::lag(x,n=2)  #滞后
lead(x,n=3 )#前移

# 连续标识符
events <- tibble(
  time = c(3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)
events <- events |> 
  mutate(
    previous_1=dplyr::lag(time),
    previous_1.default=dplyr::lag(time,default = first(time)),
    next_1=lead(time),
    diff = time - dplyr::lag(time,default = first(time)),
    has_gap = diff >= 5
  )
events
events |> mutate(
  group = cumsum(has_gap)
)

df <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
) %>% 
  group_by(id = consecutive_id(x)) |> 
  slice_head(n = 3)
df


#numeric summaries####
summarize(
  mean = mean(dep_delay, na.rm = TRUE),
  median = median(dep_delay, na.rm = TRUE),
  min(),
  max(),
  quantile(x, 0.25),
  xquantile(x, 0.5),
  quantile(x, 0.95),
  sd(),
  IQR(),    #quantile(x, 0.75) - quantile(x, 0.25)
  #distribution
  first_dep = first(dep_time, na_rm = TRUE), 
  fifth_dep = nth(dep_time, 5, na_rm = TRUE),
  last_dep = last(dep_time, na_rm = TRUE),
  x / sum(x),
  (x - mean(x)) / sd(x),
  (x - min(x)) / (max(x) - min(x)),
  n = n(),
  .groups = "drop"
)