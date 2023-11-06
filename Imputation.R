library(gss)
library(readxl)

# 读取Excel文件
file_path <- "/Users/hantingxuan/Desktop/Datathon/datax.xlsx"
df <- read_excel(file_path)

# 显示数据框的前几行
head(df)
View(df)
year = df$时间
year = gsub("年", "", year)
year = as.numeric(year)
df$时间 = year

df1 = df[!is.na(df$`年平均就业人数（万人）`),]
df2 = df[is.na(df$`年平均就业人数（万人）`),]

plot(x=df1$时间,y=df1$`年平均就业人数（万人）`)
datatemp <- data.frame(x=df1$时间,y=df1$`年平均就业人数（万人）`)
mod_ssanova <- ssanova(y~x,data = datatemp)
pred82800 <- predict(mod_ssanova,newdata=data.frame(x=df2$时间))
datamain <- data.frame('year'=df2$时间,data=pred82800)

library(ggplot2)
ggplot(datamain,aes(x=year,y=data))+
  geom_point(data = datamain,aes(x=year,y=data))+
  geom_line(color = 'red',size = 1)+
  theme_bw()

df1 = df[!is.na(df$'大专及以上人口占6岁及以上人口比例'),]
df2 = df[is.na(df$'大专及以上人口占6岁及以上人口比例'),]

plot(x=df1$时间,y=df1$'大专及以上人口占6岁及以上人口比例')
datatemp <- data.frame(x=df1$时间,y=df1$'大专及以上人口占6岁及以上人口比例')
mod_ssanova <- ssanova(y~x,data = datatemp)
pred82800 <- predict(mod_ssanova,newdata=data.frame(x=df2$时间))
datamain <- data.frame('year'=df2$时间,data=pred82800)

library(ggplot2)
ggplot(datamain,aes(x=year,y=data))+
  geom_point(data = datamain,aes(x=year,y=data))+
  geom_line(color = 'red',size = 1)+
  theme_bw()