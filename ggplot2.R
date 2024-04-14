library(ggplot2)

mpg |> distinct(model) # 38
mpg |> distinct(drv) # 4 f r
mpg |> distinct(class) # 7
mpg
ggplot()


#              Adding a smoother to a plot           ####
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(method = "loess",span = 0.2) # loess 平滑局部回归   small n
                                   #span 0非常摆动，1不那么摆动

ggplot(mpg, aes(displ, hwy)) + geom_point() + geom_smooth(span = 1)  #不很摆动

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(method = "lm")

library(MASS)
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  geom_smooth(method = "rlm")   # robust linear model  稳健线性模型

library(mgcv)
ggplot(mpg, aes(displ, hwy)) + 
  geom_point() +                  #y ~ s(x, bs = "cs")
  geom_smooth(method = "gam", formula = y ~ s(x)) #gam 广义相加模型   n>1000
                    


#             Boxplots and jittered points       ####    

ggplot(mpg, aes(drv, hwy)) + geom_jitter()
ggplot(mpg, aes(drv, hwy)) + geom_boxplot()
ggplot(mpg, aes(drv, hwy)) + geom_violin()


#             Histograms and frequency polygons       ####
ggplot(mpg, aes(hwy)) + geom_histogram()
ggplot(mpg, aes(hwy)) + geom_freqpoly()
ggplot(mpg, aes(hwy)) + 
  geom_freqpoly(binwidth = 2.5)
ggplot(mpg, aes(hwy)) + 
  geom_freqpoly(binwidth = 1)


#            Bar charts                ####

ggplot(mpg,aes(drv,hwy,fill=drv))+
  geom_bar(stat = "identity")


                                    #         修改轴     ####
#label
p1<-ggplot(mpg, aes(cty, hwy)) +
  geom_point(alpha = 1 / 3)

p2<-p1+ xlab("city driving (mpg)") + 
  ylab("highway driving (mpg)")

p3<-p1+ xlab(NULL) + ylab(NULL)

p1|p2|p3

#limits
p1<-ggplot(mpg, aes(drv, hwy)) +
  geom_jitter(width = 0.25)
p2<-p1+
  xlim("f", "r") + 
  ylim(20, 30)
p3<-ggplot(mpg, aes(drv, hwy)) +
  geom_jitter(width = 0.25, na.rm = TRUE) + 
  ylim(NA, 30)# For continuous scales, use NA to set only one limit
p1|p2|p3

#            输出               ####
p <- ggplot(mpg, aes(displ, hwy, colour = factor(cyl))) +
  geom_point()
p
print(p)
ggsave("plot.png", p, width = 5, height = 5)
summary(p)


#             单个几何图形         ####
df <- tibble(
  x = c(3, 1, 5), 
  y = c(2, 4, 6), 
  label = c("a","b","c")
)
df
p <- ggplot(df, aes(x, y, label = label)) + 
  labs(x = NULL, y = NULL) + # Hide axis label
  theme(plot.title = element_text(size = 12)) # Shrink plot title
p + geom_point() + ggtitle("point")
p + geom_text() + ggtitle("text")

p + geom_bar(stat = "identity") + ggtitle("bar")|
p + geom_tile() + ggtitle("raster")

p + geom_line() + ggtitle("line")|
p + geom_area() + ggtitle("area")

p + geom_path() + ggtitle("path")|
p + geom_polygon() + ggtitle("polygon")

#  综合几何图形   ####
data(Oxboys, package = "nlme")
head(Oxboys)      #   26×9  234×4

#Multiple groups, one aesthetic      多个变量组合 aes(group = interaction(school_id, student_id))

ggplot(Oxboys, aes(age, height, group = Subject)) + 
  geom_point() + 
  geom_line()
#Different groups on different layers
ggplot(Oxboys, aes(age, height)) + 
  geom_line(aes(group = Subject)) + 
  geom_smooth(method = "lm", linewidth = 2, se = FALSE)
#Overriding the default grouping
ggplot(Oxboys, aes(Occasion, height)) + 
  geom_boxplot() +
  geom_line(colour = "#FF0000",alpha = 0.5)

ggplot(Oxboys, aes(Occasion, height)) + 
  geom_boxplot() +
  geom_line(aes(group=Subject),colour = "#0000FF",alpha = 0.5)
#Matching aesthetics to graphic objects
df <- data.frame(x = 1:3, y = 1:3, colour = c(1, 3, 5))

ggplot(df, aes(x, y, colour = factor(colour))) +  #因子
  geom_line(aes(group = 1), linewidth = 2) +
  geom_point(size = 5)

p_continuous<-ggplot(df, aes(x, y, colour = colour)) +    # continuous color
  geom_line(aes(group = 1), linewidth = 2) +
  geom_point(size = 5)
xgrid <- with(df, seq(min(x), max(x), length = 50))
interp <- data.frame(
  x = xgrid,
  y = approx(df$x, df$y, xout = xgrid)$y,
  colour = approx(df$x, df$colour, xout = xgrid)$y  
) 
p_gradient<-ggplot(interp, aes(x, y, colour = colour)) +   #线性插值  渐变
  geom_line(linewidth = 2) +
  geom_point(data = df, size = 5)  
library(patchwork)
p_continuous|p_gradient

ggplot(mpg, aes(class, fill = hwy)) + geom_bar()|  #reverts to the default grey 
  ggplot(mpg, aes(class, fill = hwy, group = hwy)) + # overriding the grouping
  geom_bar()


ggplot(mpg, aes(displ, cty)) + 
  geom_boxplot(aes(group=displ))


#揭示不确定性####
离散 x，范围：，geom_errorbar()geom_linerange()
离散 x、范围和中心：，geom_crossbar()geom_pointrange()
连续 x，范围：geom_ribbon()
连续 x、范围和中心：geom_smooth(stat = "identity")
y <- c(18, 11, 16)
df <- data.frame(x = 1:3, y = y, se = c(1.2, 0.5, 1.0))

base <- ggplot(df, aes(x, y, ymin = y - se, ymax = y + se))
(base + geom_errorbar()|
base + geom_linerange()|
base + geom_ribbon())/
(base + geom_crossbar()|
base + geom_pointrange()|
base + geom_smooth(stat = "identity"))

# 加权数据 ####
# Unweighted
ggplot(midwest, aes(percwhite, percbelowpoverty)) + 
  geom_point()|
# Weight by population
ggplot(midwest, aes(percwhite, percbelowpoverty)) + 
  geom_point(aes(size = poptotal / 1e6)) + 
  scale_size_area(name="Population\n(millions)", breaks = c(0.5, 1, 2, 4))
?scale_size_area
# Unweighted
ggplot(midwest, aes(percwhite, percbelowpoverty)) + 
  geom_point() + 
  geom_smooth(method = lm, linewidth = 1)|
# Weighted by population
ggplot(midwest, aes(percwhite, percbelowpoverty)) + 
  geom_point(aes(size = poptotal / 1e6)) + 
  geom_smooth(aes(weight = poptotal), method = lm, linewidth = 1) +
  scale_size_area(guide = "none")


ggplot(midwest, aes(percbelowpoverty)) +
  geom_histogram(binwidth = 1) + 
  ylab("Counties")|
ggplot(midwest, aes(percbelowpoverty)) +
  geom_histogram(aes(weight = poptotal), binwidth = 1) +
  ylab("Population (1000s)")


#Displaying distributions####

#一维连续分布
ggplot(diamonds, aes(depth)) + 
  geom_histogram()|
ggplot(diamonds, aes(depth)) + 
  geom_histogram(binwidth = 0.1) + 
  xlim(55, 70)#放大 x 轴
#组间分布

使用颜色和频率多边形。geom_freqpoly()
使用“条件密度图”，.geom_histogram(position = "fill")
显示直方图的小倍数。facet_wrap(~ var)
ggplot(diamonds, aes(depth)) + 
  geom_freqpoly(aes(colour = cut), binwidth = 0.1, na.rm = TRUE) +
  xlim(58, 68) + 
  theme(legend.position = "none")|
ggplot(diamonds, aes(depth)) +              # stat = "bin"  y=count y=density
  geom_histogram(aes(fill = cut,alpha=cut), binwidth = 0.1, position = "fill",na.rm = TRUE) +
  xlim(58, 68) + 
  theme(legend.position = "none")

ggplot(diamonds, aes(depth)) +
  geom_density(na.rm = TRUE) +  #面积都标准化为 1
  xlim(58, 68) + 
  theme(legend.position = "none")|
ggplot(diamonds, aes(depth, fill = cut, colour = cut)) +
  geom_density(alpha = 0.2, na.rm = TRUE) + 
  xlim(58, 68) + 
  theme(legend.position = "none")

ggplot(diamonds, aes(clarity, depth)) +  #分类x
  geom_boxplot()|
ggplot(diamonds, aes(carat, depth)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1))) + #连续x
  xlim(NA, 2.05)

ggplot(diamonds, aes(clarity, depth)) + 
  geom_violin()|
ggplot(diamonds, aes(carat, depth)) + 
  geom_violin(aes(group = cut_width(carat, 0.1))) + 
  xlim(NA, 2.05)


geom_dotplot()：为每个观测值绘制一个点，在空间中仔细调整以避免重叠并显示分布。
它对于较小的数据集很有用。

#  处理过度绘图####
df <- data.frame(x = rnorm(2000), y = rnorm(2000))
norm <- ggplot(df, aes(x, y)) + xlab(NULL) + ylab(NULL)
norm + geom_point()|
norm + geom_point(shape = 1)| # Hollow circles
norm + geom_point(shape = ".") # Pixel sized 像素大小

(norm + geom_bin2d()|
norm + geom_bin2d(bins = 10))/
  (norm + geom_hex()|
   norm + geom_hex(bins = 10))

ggplot(df, aes(x,y)) +geom_point()+
  geom_density2d(linewidth = 0.5, colour = "red")|
ggplot(df, aes(x,y)) +geom_point()+
  geom_density2d_filled(alpha = 0.5)

#     statistical summaries     ####

ggplot(diamonds, aes(color)) + 
  geom_bar()|
ggplot(diamonds, aes(color, price)) + 
  geom_bar(stat = "summary_bin", fun = mean) #平均价格

ggplot(diamonds, aes(table, depth)) + 
  geom_bin2d(binwidth = 1, na.rm = TRUE) + 
  xlim(50, 70) + 
  ylim(50, 70)|
ggplot(diamonds, aes(table, depth, z = price)) + 
  geom_raster(binwidth = 1, stat = "summary_2d", fun = mean,  #平均价格
              na.rm = TRUE) + 
  xlim(50, 70) + 
  ylim(50, 70)


#   可视化三维表面  ####
ggplot(faithfuld, aes(eruptions, waiting)) + 
  geom_contour(aes(z = density, colour = after_stat(level)))

ggplot(faithfuld, aes(eruptions, waiting)) + 
  geom_raster(aes(fill = density))
# Bubble plots work better with fewer observations
small <- faithfuld[seq(1, nrow(faithfuld), by = 10), ]
ggplot(small, aes(eruptions, waiting)) + 
  geom_point(aes(size = density), alpha = 1/3) + 
  scale_size_area()               


#       注释    ####
values <- seq(from = -2, to = 2, by = .01)
df <- data.frame(x = values, y = values ^ 3)
ggplot(df, aes(x, y)) + 
  geom_path() + 
  labs(y = quote(f(x) == x^3))         #数学表达式   ？plotmath

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y)) + 
  geom_point() + 
  labs(x = "Axis title with *italics* and **boldface**")
base |
base + theme(axis.title.x = ggtext::element_markdown())  #ggtext::element_markdown

#文本标签
df <- data.frame(x = 1, y = 3:1, family = c("sans", "serif", "mono"))
ggplot(df, aes(x, y)) + 
  geom_text(aes(label = family, family = family))
df <- data.frame(x = 1, y = 3:1, face = c("plain", "bold", "italic"))
ggplot(df, aes(x, y)) + 
  geom_text(aes(label = face, fontface = face))

df <- data.frame(
  x = c(1, 1, 2, 2, 1.5),
  y = c(1, 2, 1, 2, 1.5),
  text = c(
    "bottom-left", "top-left",  
    "bottom-right", "top-right", "center"
  )
)
ggplot(df, aes(x, y)) +
  geom_text(aes(label = text))|
ggplot(df, aes(x, y)) +
  geom_text(aes(label = text), vjust = "inward", hjust = "inward")

df <- data.frame(
  treatment = c("a", "b", "c"), 
  response = c(1.2, 3.4, 2.5)
)

ggplot(df, aes(treatment, response)) + 
  geom_point() + 
  geom_text(
    mapping = aes(label = paste0("(", response, ")")), 
    nudge_x = -0.3,
    nudge_y=.2
  ) + 
  ylim(1.1, 3.6)
ggplot(mpg, aes(displ, hwy)) + 
  geom_text(aes(label = model)) + 
  xlim(1, 8)|
ggplot(mpg, aes(displ, hwy)) + 
  geom_text(aes(label = model), check_overlap = TRUE) + #去除重叠标签
  xlim(1, 8)

mini_mpg <- mpg[sample(nrow(mpg), 20), ]
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(colour = "red") + 
  ggrepel::geom_text_repel(data = mini_mpg, aes(label = class))


#自定义标签

presidential <- subset(presidential, start > economics$date[1])
ggplot(economics) + 
  geom_rect(
    aes(xmin = start, xmax = end, fill = party), 
    ymin = -Inf, ymax = Inf, alpha = 0.2, 
    data = presidential
  ) + 
  geom_vline(
    aes(xintercept = as.numeric(start)), 
    data = presidential,
    colour = "black", alpha = 0.5
  ) + 
  geom_text(
    aes(x = start, y = 2500, label = name), 
    data = presidential, 
    size = 3, vjust = 0, hjust = 0, nudge_x = 50
  ) + 
  geom_line(aes(date, unemploy)) + 
  scale_fill_manual(values = c("blue", "red")) +
  theme_classic()+
  xlab("date") + 
  ylab("unemployment")


yrng <- range(economics$unemploy)
xrng <- range(economics$date)
caption <- paste(strwrap("Unemployment rates in the US have 
  varied a lot over the years", 40), collapse = "\n")
ggplot(economics, aes(date, unemploy)) + 
  geom_line() + 
  annotate(
    geom = "text", x = xrng[1], y = yrng[2], 
    label = caption, hjust = 0, vjust = 1, size = 4
  )

p <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(
    data = dplyr::filter(mpg, manufacturer == "subaru"), 
    colour = "orange",
    size = 3
  ) +
  geom_point() 
p|p + 
  annotate(geom = "point", x = 5.5, y = 40, colour = "orange", size = 3) + 
  annotate(geom = "point", x = 5.5, y = 40) + 
  annotate(geom = "text", x = 5.6, y = 40, label = "subaru", hjust = "left")|
p + 
  annotate(
    geom = "curve", x = 4, y = 35, xend = 2.65, yend = 27, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(geom = "text", x = 4.1, y = 35, label = "subaru", hjust = "left")

#直接标签
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point()|
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point(show.legend = FALSE) +
  directlabels::geom_dl(aes(label = class), method = "smart.grid")


#分面注释
ggplot(mpg, aes(displ, hwy, colour = factor(cyl))) +
  geom_point() + 
  gghighlight::gghighlight() + 
  facet_wrap(vars(cyl))
ggplot(mpg, aes(displ, hwy)) +
  geom_point() + 
  ggforce::geom_mark_ellipse(aes(label = cyl, group = cyl))

  mod_coef <- coef(lm(log10(price) ~ log10(carat), data = diamonds))
  (ggplot(diamonds, aes(log10(carat), log10(price))) + 
  geom_bin2d() + 
  facet_wrap(vars(cut), nrow = 1))/
(ggplot(diamonds, aes(log10(carat), log10(price))) + 
  geom_bin2d() + 
  geom_abline(intercept = mod_coef[1], slope = mod_coef[2], 
              colour = "white", linewidth = 1) + 
  facet_wrap(vars(cut), nrow = 1))

  
  #图形布局   ####
  p1 + p2
  p1 + p2 + p3 + p4
  p1 + p2 + p3 + plot_layout(ncol = 2)
  p1 / p2
  p3 | p4
  
  p3 | (p2 / (p1 | p4))
  
  layout <- "
AAB
C#B
CDD
"
  p1 + p2 + p3 + p4 + plot_layout(design = layout)
  p1 + p2 + p3 + plot_layout(ncol = 2, guides = "collect")
  p1 + p2 + p3 + guide_area() + plot_layout(ncol = 2, guides = "collect")

  
#修改子图
  p12 <- p1 + p2
  p12[[2]] <- p12[[2]] + theme_light()
  p12
  p1 + p4 & theme_minimal()
  p1 + p4 & scale_y_continuous(limits = c(0, 45))
  
  #添加注解
  p34 <- p3 + p4 + plot_annotation(
    title = "A closer look at the effect of drive train in cars",
    caption = "Source: mpg dataset in ggplot2",
    theme = theme_gray(base_family = "mono"
  )
  p34 & theme_gray(base_family = "mono")
  #Fig. 序号 论文图形 ####
  p123 <- p1 | (p2 / p3)
  p123 + plot_annotation(tag_levels = "I") # Uppercase roman numerics
  p34
  p123[[2]] <- p123[[2]] + plot_layout(tag_level = "new")
  p123 + plot_annotation(tag_levels = c("I", "a"))
  
  #插入图片
  p1 + inset_element(p2, left = 0.5, bottom = 0.4, right = 0.9, top = 0.95)
  p24 <- p2 / p4 + plot_layout(guides = "collect")
  p1 + inset_element(p24, left = 0.5, bottom = 0.05, right = 0.95, top = 0.9)
  p12 <- p1 + inset_element(p2, left = 0.5, bottom = 0.5, right = 0.9, top = 0.95)
  p12 & theme_bw()
  p12 + plot_annotation(tag_levels = "A")
  
  
  
  
  class <- mpg %>% 
    group_by(class) %>% 
    summarise(n = n(), hwy = mean(hwy))

  ggplot(mpg,aes(x=class,y=hwy))+
    geom_point(size=2,position = position_jitter(0.25))+
    geom_point(aes(class,hwy),data=class,size=3,color='red')+
    geom_text(aes(label=paste0("n=",n)),data=class,y = 10)+
    ylim(10,40)
  
  
  
  
  
  
  
  
  
  
  
  
  ?geom_point
  ?layer
#几何对象  ####
  图形基元：
  geom_blank()：不显示任何内容。对于使用数据调整轴限制最有用。
  geom_point()：点。
  geom_path()：路径。
  geom_ribbon()：色带，具有垂直厚度的路径。
  geom_segment()：由开始和结束位置指定的线段。
  geom_rect()：矩形。
  geom_polygon()：填充多边形。
  geom_text()：发短信。
  一个变量：
  离散：
  geom_bar()：显示离散变量的分布。
  连续的：
  geom_histogram()：bin 和 count 连续变量，用条形显示。
  geom_density()：平滑密度估计。
  geom_dotplot()：将单个点堆叠成点图。
  geom_freqpoly()：bin 和 count 连续变量，用线条显示。
  两个变量：
  两者都是连续的：
  geom_point()：散点图。
  geom_quantile()：平滑分位数回归。
  geom_rug()：边缘地毯图。
  geom_smooth()：最贴合的平滑线条。
  geom_text()：文本标签。
  展会分布：
  geom_bin2d()：将 bin 放入矩形并计数。
  geom_density2d()：平滑的 2D 密度估计。
  geom_hex()：分箱成六边形并计数。
  至少一个离散：
  geom_count()：计算不同位置的点数
  geom_jitter()：随机抖动重叠点。
  一个连续的，一个离散的：
  geom_bar(stat = "identity")：预先计算的摘要的条形图。
  geom_boxplot()：箱线图。
  geom_violin()：显示每个组中值的密度。
  一次，一次连续：
  geom_area()：面积图。
  geom_line()：线图。
  geom_step()：阶梯图。
  显示不确定度：
  geom_crossbar()：带中心的垂直条。
  geom_errorbar()：误差线。
  geom_linerange()：垂直线。
  geom_pointrange()：垂直线与中心。
  空间：
  geom_map()：地图数据的快速版本。geom_polygon()
  三个变量：
  geom_contour()：轮廓。
  geom_tile()：用矩形平铺平面。
  geom_raster()：适用于同等大小瓷砖的快速版本。geom_tile()
  
# 统计变换 ####
  stat_bin(): , ,geom_bar()geom_freqpoly()geom_histogram()
  stat_bin2d():geom_bin2d()
  stat_bindot():geom_dotplot()
  stat_binhex():geom_hex()
  stat_boxplot():geom_boxplot()
  stat_contour():geom_contour()
  stat_quantile():geom_quantile()
  stat_smooth():geom_smooth()
  stat_sum():geom_count()
  
  其他统计信息不能使用函数创建：geom_
  stat_ecdf()：计算经验累积分布图。
  stat_function()：根据 x 值的函数计算 y 值。
  stat_summary()：将 Y 值汇总到不同的 X 值。
  stat_summary2d()， ：汇总分箱值。stat_summary_hex()
  stat_qq()：对分位数-分位数图执行计算。
  stat_spoke()：将角度和半径转换为位置。
  stat_unique()：删除重复的行。
  
  ggplot(mpg, aes(trans, cty)) + 
    geom_point() + 
    stat_summary(geom = "point", fun = "mean", colour = "red", size = 4)
  
  ggplot(mpg, aes(trans, cty)) + 
    geom_point() + 
    geom_point(stat = "summary", fun = "mean", colour = "red", size = 4)#这个比较好
  
  用于制作直方图的统计量将生成以下变量：stat_bin
  count，每个条柱中的观测值数
  density，每个条柱中的观测值密度（占总百分比/条形宽度）
  x，bin的中心
  
  ggplot(diamonds, aes(price)) + 
    geom_histogram(binwidth = 500)|
  ggplot(diamonds, aes(price)) + 
    geom_histogram(aes(y = after_stat(density)), binwidth = 500)|
    ggplot(diamonds, aes(price)) + 
    geom_histogram(aes(y = after_stat(x)), binwidth = 500)
  
ggplot(diamonds, aes(price, colour = cut)) + 
    geom_freqpoly(binwidth = 500)|
ggplot(diamonds, aes(price, colour = cut)) +
    geom_freqpoly(aes(y = after_stat(density)), binwidth = 500) 

#  位置调整  ####

#bar
position_stack()：将重叠的条形（或区域）堆叠在一起。
position_fill()：堆叠重叠的条形，缩放以使顶部始终位于 1。
position_dodge()：并排放置重叠的条形图（或箱线图）。
dplot <- ggplot(diamonds, aes(color, fill = cut)) + 
  xlab(NULL) + ylab(NULL) + theme(legend.position = "none")
dplot + geom_bar()|
dplot + geom_bar(position = "fill")|
dplot + geom_bar(position = "dodge")

#point
position_nudge()：按固定偏移量移动点。
position_jitter()：为每个位置添加一点随机噪音。
position_jitterdodge()：躲避组内的点，然后添加一点随机噪音。