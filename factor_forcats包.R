                                        #basic####

x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
factor(x1, levels = month_levels,labels = c(1:12)) #默认按字母顺序排序
fct(x1)         #按第一次出现排序
fct(x1, levels = month_levels)

levels(x1) #因子水平

csv <- "
month,value
Jan,12
Feb,56
Mar,12"
df<-read_csv(csv, col_types = cols(month =readr::col_factor(month_levels)))
df$month



                                     # 修改因子顺序 ####
forcats::gss_cat  #因子数据集

relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
ggplot(relig_summary, aes(x = tvhours, y = relig,size=n)) + geom_point()
ggplot(relig_summary,aes(x = tvhours,     #按tvhours升序 重排无序因子水平 
                         y = fct_reorder(relig,tvhours),size=n)) +
  geom_point()


rincome_summary <- gss_cat |>
  group_by(rincome) |>
  summarize(
    age = mean(age, na.rm = TRUE),
    n = n()
  )
rincome_summary
ggplot(rincome_summary,aes(x=age,y=rincome))+
  geom_point()
ggplot(rincome_summary, aes(x = age,     #将任意数量的水平前移至第一
                            y = fct_relevel(rincome, c("Not applicable")))) +
  geom_point()

by_age <- gss_cat |>
  dplyr::filter(!is.na(age)) |> 
  count(age, marital) |>
  group_by(age) |>
  mutate(
    prop = n / sum(n)
  )
by_age
ggplot(by_age, aes(x = age, y = prop, color = marital)) +
  geom_line(linewidth = 1) + 
  scale_color_brewer(palette = "Set1")
                                          
ggplot(by_age, aes(x = age, y = prop,  #按与最大值关联的值对因子重新排序
                   color = fct_reorder2(marital, age, prop))) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") + 
  labs(color = "marital") 


gss_cat |>                    #单独fct_infreq()降序，合用升序
  mutate(marital = marital |> fct_infreq() |> fct_rev()) |>
  ggplot(aes(x = marital)) +
  geom_bar()






                            #修改因子名####
gss_cat |> count(partyid)

gss_cat |>
  mutate(
    partyid = fct_recode(partyid,  #重编因子名
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat"
                        # "Other"                 = "No answer",
                        # "Other"                 = "Don't know",
                        # "Other"                 = "Other party"
    )
  ) |>
  count(partyid)

gss_cat |>
  mutate(
    partyid = fct_collapse(partyid,  #合并水平
                           "other" = c("No answer", "Don't know", "Other party"),
                           "rep" = c("Strong republican", "Not str republican"),
                           "ind" = c("Ind,near rep", "Independent", "Ind,near dem"),
                           "dem" = c("Not str democrat", "Strong democrat")
    )
  ) |>
  count(partyid)


relig_summary 
gss_cat |>
  mutate(relig = fct_lump_lowfreq(relig)) |> #合并除最大组以外的水平为Other
  count(relig)

gss_cat |>
  mutate(relig = fct_lump_n(relig, n = 3)) |> #合并较小组水平为第n+1组Other
  count(relig, sort = TRUE)  #排序

gss_cat |>
  mutate(relig = fct_lump_min(relig,min=100)) |> #合并出现min次以下的水平为Other
  count(relig)

relig_summary |> 
  mutate(
    prop=n/sum(n)
  )
gss_cat |>
  mutate(relig = fct_lump_prop(relig,prop=0.1)) |> #合并出现prop以下的水平为Other
  count(relig)
gss_cat |>
  mutate(relig = fct_lump_prop(relig,prop=-0.1)) |> #合并出现-prop以上的水平为Other
  count(relig)


                               #有序因子####
