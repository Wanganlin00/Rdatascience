################################           比较两独立样本          ############################################################################

set.seed(10)
test1 <- rnorm(50,mean = 10,sd = 1)
set.seed(100)
test2 <- rnorm(100,mean = 10,sd = 5)
set.seed(1000)
test3 <- rnorm(150,mean = 15,sd = 1)
set.seed(10000)
test4 <- runif(500,min = 7,max = 13)

set.seed(100000)
test5 <- runif(500,min = 7,max = 13)
# 统计描述

descriptive_summary <- function(x, na.rm = TRUE) {
    
    if(na.rm) x <- x[!is.na(x)]
    
    skewness <- function(x,na.rm=TRUE){
        if(na.rm) x <- x[!is.na(x)]
        n=length(x)
        μ=mean(x)
        SD=sd(x)
        sknewness = mean(((x-μ)/SD)^3)
        return(sknewness=sknewness)
    }
    
    kurtosis<-function(x,na.rm=TRUE){
        if(na.rm) x<-x[!is.na(x)]
        n=length(x)
        μ=mean(x)
        SD=sd(x)
        kurtosis= mean(((x-μ)/SD)^4)-3
        return(kurtosis=kurtosis)
    }
    
    # capture_variable_name <- function(x) {
    #     y <- rlang::enexpr(x)
    #     return(y)
    # }


    results <- tibble(
        variables = 1,
        n = length(x),
        mean_sd=paste0(round(mean(x,na.rm = na.rm),digits = 4),"±",round(sd(x,na.rm = na.rm),digits = 4)),
        # paste0(sprintf("%.4f",pi),"±",sprintf("%.4f",pi))
        median = median(x,na.rm = na.rm),
        se = sd(x,na.rm = na.rm)/sqrt(length(x)),
        skewness = skewness(x,na.rm = na.rm),
        excess_kurtosis = kurtosis(x,na.rm = na.rm),
        min=min(x,na.rm = na.rm),
        max=max(x,na.rm = na.rm),
        quantile1 = quantile(x, probs = 0.25,na.rm = na.rm),
        quantile3 = quantile(x, probs = 0.75,na.rm = na.rm),
        
    )
    
    
    return( results )
    
}


descriptive_summary(mtcars$mpg)



test <- function(x) {
    
    
    results <- tibble(
        variable = f(x),
        n = length(x),
    )
    return(results)
}
test(mtcars$mpg)




# 正态性检验

normality_test1 <- ks.test(test1 ,pnorm,mean=mean(test1),sd=sd(test1),exact = T) |> lapply(I) |> as_tibble()
normality_test1
normality_test2 <- ks.test(test2 ,pnorm,mean=mean(test2),sd=sd(test2),exact = T) |> lapply(I) |> as_tibble()
normality_test2

p1_density <- ggplot(tibble(test1),aes(test1))+
    geom_density()+
    geom_function(fun=dnorm,color="red",
                  args=list(mean=mean(test1),sd=sd(test1)))+
    xlim(c(mean(test1)-3*sd(test1),mean(test1)+3*sd(test1)))
p1_qq <- ggplot(tibble(test1),aes(sample=test1))+
    stat_qq(color="red")+
    stat_qq_line()




var.test(test1,test2)

df <- tibble(
    dv=c(test4,test5),
    group=rep(c("1","2"),each=500),
)

car::leveneTest(dv~group,data=df)


bartlett.test(dv~group,data=df)
var.test(test1,test2)
t.test(test1,test2,var.equal = F)
wilcox.test(test1,test2)

var.test(test1,test3)
t.test(test1,test3,var.equal = T)
wilcox.test(test1,test3)



compare_samples <- function(sample1, sample2,response,group,...) {
    # 检查样本是否为数值向量
    if (!is.numeric(sample1) || !is.numeric(sample2)) {
        stop("两样本必须都是数值向量")
    }
    
    # 统计描述
    desc1 <- summary(sample1)
    desc2 <- summary(sample2)
    
    # 正态性检验
    normality_test1 <- shapiro.test(sample1)
    normality_test2 <- shapiro.test(sample2)
    
    # 方差齐性检验
    var_test <- var.test(sample1, sample2)
    
    # 根据检验结果选择适当的统计检验
    if (normality_test1$p.value > 0.05 && normality_test2$p.value > 0.05) {
        # 正态性满足
        if (var_test$p.value > 0.05) {
            # 方差齐性也满足
            test_result <- t.test(sample1, sample2, var.equal = TRUE)
            test_type <- "t-test (equal variances)"
        } else {
            # 方差不齐性
            test_result <- t.test(sample1, sample2, var.equal = FALSE)
            test_type <- "Welch's t-test (unequal variances)"
        }
    } else {
        # 正态性不满足
        test_result <- wilcox.test(sample1, sample2)
        test_type <- "Wilcoxon rank sum test (non-normal data)"
    }
    
    # 将结果整合到数据框中
    result_df <- data.frame(
        Sample1_Mean = desc1$Mean,
        Sample1_SD = desc1$SD,
        Sample2_Mean = desc2$Mean,
        Sample2_SD = desc2$SD,
        Normality_Test1_p = normality_test1$p.value,
        Normality_Test2_p = normality_test2$p.value,
        Variance_Test_Statistic = var_test$statistic,
        Variance_Test_p = var_test$p.value,
        Test_Statistic = test_result$statistic,
        P_Value = test_result$p.value,
        Test_Type = test_type
    )
    
    return(result_df)
}

# 使用示例
# 假设sample1和sample2是两个向量，包含你的数据
# result_df <- compare_samples(c(1, 2, 3, 4, 5), c(2, 3, 4, 5, 6))
# print(result_df)




