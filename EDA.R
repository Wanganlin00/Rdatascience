Exploratory data analysis
1、生成有关数据的问题
2、通过对数据进行可视化、转换和建模来寻找答案
3、使用您学到的知识来完善您的问题和/或生成新问题

变量中会出现哪种类型的变异？
变量之间发生什么类型的协变？
#变异是一个变量的值在不同的测量中变化的趋势，同一观测值的测量值之间以及观测值之间的变化
#协变
哪些值最常见？为什么？
哪些值是稀有的？为什么？这符合您的期望吗？
#    典型值Typical values       ####
smaller <- diamonds |> 
  dplyr::filter(carat < 3)
smaller

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
#为什么整克拉和克拉的普通部分钻石更多？
#为什么每个峰的右边的钻石比每个峰的左边的钻石多？


#     异常值Unusual values     ####
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)+ #异常值的唯一证据是 x 轴上的异常宽限值
  coord_cartesian(ylim = c(0, 100)) #缩放y轴
#三个不寻常的值：0、~30 和 ~60
unusual <- diamonds |> 
  dplyr::filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |>
  arrange(y)
unusual            #y!=0,重编为NA    ，y过大 数据输入错误？
diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y)) #异常值替换为NA
diamonds2 %>% 
  count(x,y)
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

#了解缺失值观测值与记录值观测值的不同之处
f1<-nycflights13::flights |> 
  select(dep_time,sched_dep_time) %>% 
  mutate(
    cancelled = is.na(dep_time),#变量中的缺失值表示航班已取消
    sched_hour = sched_dep_time %/% 100,#计划出发时间，整除
    sched_min = sched_dep_time %% 100,#取余数
    sched_dep_time = sched_hour + (sched_min / 60)
  )
f1 %>% 
  count(cancelled)

  ggplot(f1,aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)
?geom_freqpoly
  
协变是两个或多个变量的值以相关方式一起变化的趋势
#       协变 covariation    ####

#分类变量和数值变量
ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

ggplot(diamonds, aes(x = price, y = after_stat(density))) + #统计变换,归一化
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

diamonds
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()   #？ideal的水平的价格低？
ggplot(diamonds, aes(x = fct_reorder(cut, price, median), y = price)) +#排序
  geom_boxplot()

#两个分类变量
diamonds %>% 
  count(cut,color)
ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

diamonds %>% 
  count(cut,color) %>% 
  ggplot( aes(x = cut, y = color,size=n)) +
  geom_point()

diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))
?geom_tile

#两个数值变量
ggplot(smaller, aes(x = carat, y = price)) +
  geom_point(alpha=.01)

ggplot(smaller, aes(x = carat, y = price)) +
  geom_bin2d()          #矩形
# install.packages("hexbin")
ggplot(smaller, aes(x = carat, y = price)) +
  geom_hex()            #六边形

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat,width = 0.1)))
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat,width = 0.1)),varwidth = T)

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(color = cut_number(carat, 20)))
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 20)))
?cut_number


#        Patterns and models        ####这种模式可能是由于巧合（即随机机会）吗？
你如何描述模式所隐含的关系？
模式所暗示的关系有多强？
还有哪些其他变量可能会影响这种关系？
如果查看数据的各个子组,这种关系是否会发生变化
#
library(tidymodels)
diamonds_log <- diamonds |>
  mutate(
    log_price = log(price),  #对数化
    log_carat = log(carat)
  )
diamonds_log
diamonds_fit <- linear_reg() %>%     #线性回归
  fit(log_price ~ log_carat, data = diamonds_log) #拟合模型
diamonds_fit

augment(diamonds_fit, new_data = diamonds_log)  #添加预测值和残差值

diamonds_aug <- augment(diamonds_fit, new_data = diamonds_log) |>
  mutate(.resid = exp(.resid))   #残差指数化
diamonds_aug 
ggplot(diamonds_aug, aes(x = carat, y = .resid)) + #消除克拉和价格之间的关系
  geom_point() 
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point() 
ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()     #相对于它们的克拉大小，质量更好的钻石更贵。
