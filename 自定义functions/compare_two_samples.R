# 加载所需包
library(tidyverse)
library(rstatix)
library(nortest)  # 用于 Lilliefors 正态性检验
library(car)      # 用于 Levene's 方差齐性检验

# 自定义函数
compare_two_samples <- function(sample1, sample2) {
    
    # 正态性检验：Shapiro-Wilk 和 Lilliefors
    normality_SW_test1 <- shapiro.test(sample1)
    normality_SW_test2 <- shapiro.test(sample2)
    normality_lf_test1 <- nortest::lillie.test(sample1)
    normality_lf_test2 <- nortest::lillie.test(sample2)
    
    # 方差齐性检验：F检验和 Levene's test
    var_test_F <- var.test(sample1, sample2)
    var_test_levene <- car::leveneTest(c(sample1, sample2), 
                                       factor(rep(1:2, c(length(sample1), length(sample2)))))
    
    # 正态性检验结果
    is_normal_SW1 <- normality_SW_test1$p.value > 0.05
    is_normal_SW2 <- normality_SW_test2$p.value > 0.05
    is_normal_LF1 <- normality_lf_test1$p.value > 0.05
    is_normal_LF2 <- normality_lf_test2$p.value > 0.05
    
    # 判断两组样本是否均符合正态性（Shapiro-Wilk 或 Lilliefors 检验之一）
    if ((is_normal_SW1 & is_normal_SW2) | (is_normal_LF1 & is_normal_LF2)) {
        # 根据方差齐性选择检验方法（F检验或 Levene's test 之一）
        if (var_test_F$p.value > 0.05 & var_test_levene$`Pr(>F)`[1] > 0.05) {
            # 方差相等，进行标准 t 检验
            two_samples_test_res <- t.test(sample1, sample2, var.equal = TRUE)
            method <- "T-test (Equal Variance)"
        } else {
            # 方差不等，进行 Welch t 检验
            two_samples_test_res <- t.test(sample1, sample2, var.equal = FALSE)
            method <- "Welch T-test (Unequal Variance)"
        }
    } else {
        # 至少一个样本不符合正态性，进行 Mann-Whitney U 检验（非参数检验）
        two_samples_test_res <- wilcox.test(sample1, sample2)
        method <- "Mann-Whitney U Test (Non-parametric)"
    }
    
    # 构建结果数据框
    result <- tibble(
        Test = c("Shapiro-Wilk Test (Sample 1)", "Shapiro-Wilk Test (Sample 2)", 
                 "Lilliefors Test (Sample 1)", "Lilliefors Test (Sample 2)", 
                 "F Test for Variance", "Levene's Test for Variance", method),
        Statistic = c(normality_SW_test1$statistic, normality_SW_test2$statistic, 
                      normality_lf_test1$statistic, normality_lf_test2$statistic, 
                      var_test_F$statistic, var_test_levene$`F value`[1], two_samples_test_res$statistic),
        p_value = c(normality_SW_test1$p.value, normality_SW_test2$p.value, 
                    normality_lf_test1$p.value, normality_lf_test2$p.value, 
                    var_test_F$p.value, var_test_levene$`Pr(>F)`[1], two_samples_test_res$p.value),
        df1 = c(NA, NA, NA, NA, var_test_F$parameter[1], var_test_levene$Df[1], ifelse(is.null(two_samples_test_res$parameter), NA, two_samples_test_res$parameter)),
        df2 = c(NA, NA, NA, NA, var_test_F$parameter[2], var_test_levene$Df[2], NA)
    )
    
    return(result)
}

# 示例使用
set.seed(123)
sample1 <- rnorm(30, mean = 5, sd = 1)
sample2 <- rnorm(30, mean = 5.5, sd = 1.2)

# 调用函数
result <- compare_two_samples(sample1, sample2)
print(result)

