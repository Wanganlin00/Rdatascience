rm(list = ls())


                                        #向量函数####
name <- function(arguments) {
  body
}

                              #数据框函数####
grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by({{ group_var }}) |> #embracing拥抱 {{}}
    summarize(mean=mean({{ mean_var }}))   
  #拥抱变量会告诉 dplyr使用存储在参数中的值，而不是将参数作为文本变量名称
}
df <- tibble(
  mean_var = c(1,2),
  group_var = c("g","h"),
  group = c(1,1),
  x = c(10,100),
  y = c(100,200)
)
df
grouped_mean(df,group, x)


#When to embrace?####
Data-masking: arrange()filter()summarize() compute with variables
Tidy-selection:select()relocate()rename() select variables.

summary6 <- function(data, var) {
  data |> summarize(
    min = min({{ var }}, na.rm = TRUE),
    mean = mean({{ var }}, na.rm = TRUE),
    median = median({{ var }}, na.rm = TRUE),
    max = max({{ var }}, na.rm = TRUE),
    n = n(),
    n_miss = sum(is.na({{ var }})),
    .groups = "drop"
  )
}
diamonds |> 
  group_by(cut) |> 
  summary6(carat)
count_prop <- function(df, var, sort = FALSE) {
  df |>
    count({{ var }}, sort = sort) |>
    mutate(prop = n / sum(n))
}
diamonds |> count_prop(clarity)

unique_where <- function(df, condition, var) {
  df |> 
    dplyr::filter({{ condition }}) |> 
    distinct({{ var }}) |> 
    arrange({{ var }})
}
nycflights13::flights |> unique_where(month == 12, dest)

# Data-masking vs. tidy-selection####
count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by({{ group_vars }}) |> #select variables inside a function that uses data-masking
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

count_missing <- function(df, group_vars, x_var) {
  df |>      #pick()
    group_by(pick({{ group_vars }})) |> #use tidy-selection inside data-masking functions
    summarize(                          
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
  )
}

nycflights13::flights |> 
  count_missing(c(year, month, day), dep_time)


#绘图函数####
histogram <- function(df, var, binwidth = NULL) {
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth)
}

diamonds |> histogram(carat, 0.1)

sorted_bars <- function(df, var) {
  df |>               #walrus operator   :=
    mutate({{ var }} := fct_rev(fct_infreq({{ var }})))  |>
    ggplot(aes(y = {{ var }})) +
    geom_bar()
}

diamonds |> sorted_bars(clarity)
