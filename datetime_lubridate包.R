library(nycflights13)


                               #创建日期/时间####
 #<date>
# <time>
 # <dttm>

#文件导入
csv <- "
date,datetime
2022-01-02,2022-01-02 05:12
"
read_csv(csv)

csv <- "
  date
  01/02/15
"
read_csv(csv, col_types = cols(date = col_date("%m/%d/%y")))
read_csv(csv, col_types = cols(date = col_date("%y/%m/%d")))

#字符串捕获
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

#跨越多个列的日期时间的各个组件
flights |> 
  select(year, month, day, hour, minute) |> 
  mutate(
    departure = make_datetime(year, month, day, hour, minute),
    dep_data=make_date(year,month,day)
    ) |> 
  head(20)

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}
flights_dt <- flights |> 
  dplyr::filter(!is.na(dep_time), !is.na(arr_time)) |> 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) |> 
  select(origin, dest, ends_with("delay"), ends_with("time"))

#使用日期时间时，1 表示 1 秒，因此 binwidth 为 86400 表示一天
#对于日期，1 表示 1 天
# 2013年
flights_dt
flights_dt |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day 
# 2013-01-01
flights_dt |> 
  dplyr::filter(dep_time < ymd(20130102)) |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 s = 10 minutes


#类型转换
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)

today()
as_datetime(today())

now()
as_date(now())
                            
                        

                        #获取日期时间组件####
datetime <- ymd_hms("2026-07-08 12:34:56")
year(datetime)
month(datetime,label = TRUE)
mday(datetime)
yday(datetime)  #一年中的第几天
wday(datetime, label = TRUE, abbr = FALSE)  #星期几
hour(datetime)
minute(datetime)
second(datetime)
flights_dt |> 
  mutate(wday = wday(dep_time, label = TRUE)) |> 
  ggplot(aes(x = wday)) +
  geom_bar()#工作日出发的航班比周末起飞的航班多

flights_dt |> 
  mutate(minute_dep= minute(dep_time)) |> 
  group_by(minute_dep) |> #一小时内按实际出发分钟划分的平均起飞延误
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = minute_dep, y = avg_delay)) +
  geom_line()+#在 20-30分钟和 50-60 分钟内起飞的航班的延误率比其余时间低得多
  geom_point(color="red")
flights_dt |> 
  mutate(minute_dep= minute(dep_time)) |> 
  group_by(minute_dep) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  ) |> 
ggplot(aes(x=minute_dep,y=n))+#对 30 和 60 等整数的强烈偏好
  geom_line()

sched_dep <- flights_dt |> 
  mutate(minute_sched = minute(sched_dep_time)) |> #计划
  group_by(minute_sched) |> 
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
ggplot(sched_dep, aes(x = minute_sched, y = avg_delay)) +
  geom_line()
ggplot(sched_dep,aes(x=minute_sched,y=n))+
  geom_line()#对 0 和 30 等整数的强烈偏好
                       


              #Roundong####
#floor_date()round_date()ceiling_date()

flights_dt |> 
  count(week = floor_date(dep_time, "week")) |> 
  ggplot(aes(x = week, y = n)) +      
  geom_line() +       #每周的航班数量
  geom_point()
flights_dt |>                   #as_hms()
  mutate(dep_hour = hms::as_hms(dep_time - floor_date(dep_time, "day")))  |> 
  ggplot(aes(x = dep_hour)) +
  geom_freqpoly(binwidth = 60 * 30)

                #修改组件####
datetime <- ymd_hms("2026-07-08 12:34:56")
year(datetime) <- 2030
month(datetime) <- 01
hour(datetime) <- hour(datetime) + 1
datetime
update(datetime, year = 2030, month = 2, mday = 2, hour = 2)
update(ymd("2023-02-01"), mday = 30)
update(ymd("2023-02-01"), hour = 400)



                          #时间跨度Time spans ####
#持续时间 duration  始终以秒为单位记录时间跨度
h_age <- today() - ymd("2000-10-18")
as.duration(h_age)
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)/ddays(1)       #365.25 天


#Periods  “人类”时间（如天和月）
years(1)      #365.25 天
years(1) / days(1)
hours(c(12, 24))
days(7)
months(1:6)
ymd("2024-01-01") + dyears(1)  #闰年
ymd("2024-01-01") + years(1) 
                                       
ymd_hms("2026-03-08 01:00:00", tz = "America/New_York")+ddays(1)
ymd_hms("2026-03-08 01:00:00", tz = "America/New_York")+days(1)

flights_dt |> 
  dplyr::filter(arr_time < dep_time) 
flights_dt <- flights_dt |> 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight),  # days(T)=1d
    sched_arr_time = sched_arr_time + days(overnight)
  )
flights_dt


#Intervals
#  start %--% end

y2023 <- ymd("2023-01-01") %--% ymd("2024-01-01")
y2024 <- ymd("2024-01-01") %--% ymd("2025-01-01")
y2023 / days(1)
y2024 / days(1)


                           #     时区            ####
Sys.timezone()
OlsonNames()
