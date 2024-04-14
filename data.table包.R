library(data.table)

setkey(dt,v1,v3)  #设置键
setindex(dt,v1,v3)  #设置索引
DT[
  ...
  ][
    ...
    ][
      ...
      ]         #链式操作 ， |> 

#数据读写
DT<-fread("data/students.csv")
DT

fwrite(DT,"data/DT.csv",append = T,sep = "\t")
fwrite(setDT(list(c(0),list(1:5))),"data/DT_list_col.csv") #写出列表列
fwrite(DT,"data/DT.csv.gz",compress = "gzip")     #写出到压缩文件


#数据连接
rbind(DT1,DT2,...)
cbind()

merge(x,y,all.x=T,by="v1") #左连接
merge(x,y,all.y=T,by="v1") #右连接
merge(x,y,by="v1")       #内连接
merge(x,y,all=T,by="v1") #全连接

