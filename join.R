                                  # equi join ####
x <- tribble(
  ~ID, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~ID, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
full_join(x,y,join_by(ID==ID))
inner_join(x,y,by='ID')
left_join(x,y,by='ID')
right_join(x,y,by='ID')
semi_join(x,y,by='ID') 
anti_join(x,y,by='ID')
                             # Non-equi joins ####
#交叉连接
cross_join(x,y)         #nrow(x) * nrow(y)
#不等式连接
inner_join(x,y, join_by(ID >=ID), keep = TRUE)

#滚动联接  rolling join           
inner_join(x,y, join_by(closest(ID >=ID)))#滚动连接类似于不等式连接，但仅匹配最近一个值。

parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03"))
)
set.seed(123)
employees <- tibble(
  name = sample(babynames::babynames$name, 100),
  birthday = ymd("2022-01-01") + (sample(365, 100, replace = TRUE) - 1)
)
employees
employees |> 
  left_join(parties, join_by(closest(birthday >= party)))
employees |> 
  anti_join(parties, join_by(closest(birthday >= party))) #

# Overlap joins 重叠连接
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end = ymd(c("2022-04-03", "2022-07-10", "2022-10-02", "2022-12-31"))
)
parties
employees |> 
  inner_join(parties, join_by(between(birthday, start, end)), unmatched = "error")



#集合运算   要求变量名（列）完全相同,把观测（行）看成是集合中的元素
x<-tibble(ID=c(1,2),X=c("a1",'a2'))
x
y<-tibble(ID=c(2,3),X=c("a2",'a3'))
y

lubridate::intersect(x,y) #返回共同包含的相同观测
union(x,y)#返回所有不同观测
setdiff(x,y) #返回在x中不在y中
setequal(x,y)#判断是否相等


