#dplyr 
#tidyr

                          #显式缺失值   Explicit missing values   ####

#last observation carried forward    locf
treatment <- tribble(
  ~person,           ~treatment, ~response,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         NA,
  "Katherine Burke",  1,         4
)
treatment |>
  tidyr::fill(everything())  #填充NA上一个观测的值


# Fixed values
x <- c(1, 4, 5, 7, -99)
dplyr::na_if(x,-99)

x <- c(1, 4, 5, 7, NA)
dplyr::coalesce(x, 0)

# NaN :not a number
x<-c(0/0,0*Inf,Inf-Inf,1/0)
x
is.nan(x)


                             #隐式缺失值 Implicit missing values  ####
stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4), #缺失2021第一季度
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)      
)
#Pivoting

stocks |>
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )
#Complete
stocks |>
  tidyr::complete(year, qtr)

#Joins
library(nycflights13)

flights |> 
  distinct(faa = dest) |> 
  anti_join(airports)
flights |> 
  distinct(tailnum) |> 
  anti_join(planes)
 
                                          #因子和空组####

health <- tibble(
  name   = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
  smoker = factor(c("no", "no", "no", "no", "no"), levels = c("yes", "no")),
  age    = c(34, 88, 75, 47, 56),
)
health |> count(smoker)
health |> count(smoker, .drop = FALSE) #保留因子所有水平

p<-ggplot(health, aes(x = smoker)) +
  geom_bar() 

p+scale_x_discrete()
p+scale_x_discrete(drop = FALSE) #保留因子所有水平

health |> 
  group_by(smoker, .drop = FALSE) |> #保留因子所有水平
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  )
health |> 
  group_by(smoker) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  ) |> 
  complete(smoker)# 显式处理
