library(ggplot2)
library(dplyr)
library(plotly)
library(gss)

data=read.csv('C:/Users/yudyd/Desktop/carbon_emisson.csv')
data$year = unlist(lapply(strsplit(data$date, split="/"),function(x){x[3]}))

country_names=names(table(data$country)) 
country_co2_year=c()
for (ii in 1:14) {
  country_names_ii=country_names[ii]
  dataii=data[which(data$country==country_names_ii),]
  temper=c()
  for (iii in c('2019','2020','2021','2022','2023')) {
    dataiii=dataii[which(dataii$year==iii),]
    temper=c(temper,mean(dataiii$value))
  }
  country_co2_year=rbind(country_co2_year,temper)
}
rownames(country_co2_year)=country_names
colnames(country_co2_year)=c('2019','2020','2021','2022','2023')
colSums(country_co2_year[-14,])-country_co2_year[14,]
cty_year=data.frame(country_co2_year[-c(3,9,14),])
# cty_year$cty=rownames(cty_year)

cty=t(cty_year[,-5]) %>% data.frame()
cty$year = c(2019,2020,2021,2022)
# ggplot()+
#   geom_line(data=cty,aes(x=year,y=Brazil,color='Brazil'))+
#   geom_line(data=cty,aes(x=year,y=China,color='China'))+
#   geom_line(data=cty,aes(x=year,y=France,color='France'))+
#   geom_line(data=cty,aes(x=year,y=Germany,color='Germany'))+
#   geom_line(data=cty,aes(x=year,y=India,color='India'))+
#   geom_line(data=cty,aes(x=year,y=Italy,color='Italy'))+
#   geom_line(data=cty,aes(x=year,y=Japan,color='Japan'))+
#   geom_line(data=cty,aes(x=year,y=Spain,color='Spain'))+
#   geom_line(data=cty,aes(x=year,y=Russia,color='Russia'))+
#   geom_line(data=cty,aes(x=year,y=United.Kingdom,color='United Kingdom'))+
#   geom_line(data=cty,aes(x=year,y=United.States,color='United States'))+
#   theme_bw()+
#   lab('')
cty=t(cty_year[-5]) %>% data.frame()
cty$year = c(2019,2020,2021,2022)
cty_long <- tidyr::pivot_longer(cty, cols = -year, names_to = "Country", values_to = "value")

# 画图，确保将颜色映射到'country'这个变量
ggplot(cty_long, aes(x = year, y = value, group = Country, color = Country)) +
  geom_line() +
  scale_color_manual(values = c("Brazil" = 'blue', 
                                "China" = 'red', 
                                "France" = 'darkblue', 
                                "Germany" = 'green',
                                "India" = 'brown', 
                                "Italy" = 'purple', 
                                "Japan" = 'lightcoral',
                                "Spain" = 'yellow', 
                                "Russia" = 'orange', 
                                "United.Kingdom" = 'grey',
                                "United.States" = 'pink'))+
  ylab('Total Carbon Emission(MT)')+
  xlab('Year')+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())



cluster1=cty_year
# 利用碎石图确定聚类个数
mydata=cluster1
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) # 计算离均差平方和
for (i in 2:10) wss[i] <- sum(kmeans(mydata, 
                                     centers=i)$withinss) #计算不同聚类个数的组内平方和
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares") # 绘图

# K-Means聚类分析
fit1 <- kmeans(mydata, 3) # 设定聚类个数为3
# 获取聚类均值
aggregate(mydata,by=list(fit1$cluster),FUN=mean) # aggregate()是一个分类汇总函数
# 返回聚类的结果
res <- data.frame(mydata, fit1$cluster)


# Ward层次聚类
d <- dist(mydata, method = "euclidean") # 计算各个样本点之间的欧氏距离
fit2 <- hclust(d, method="ward.D") #进行Ward层次聚类
plot(fit2) # 绘制树状图展示聚类结果
groups <- cutree(fit2, k=2) # 设定聚类个数为3

pca1 <- prcomp(cluster1,center = TRUE,scale. = TRUE)

df1 <- pca1$x # 提取PC score
df1 <- as.data.frame(df1) # 注意：如果不转成数据框形式后续绘图时会报错
summ1 <- summary(pca1)
summ1

dp2d=df1[,1:2]
dp3d=df1[,1:3]
dp2d$group=as.factor(groups)
dp3d$group=as.factor(groups)

ggplot(dp2d,aes(PC1,PC2,color=group))+
  geom_point(size=3)+
  scale_color_manual(values = c('blue','red'),label=c('Other countries','China'))+
  theme_bw()+
  theme(legend.title=element_blank())


GDP=read.csv('C:/Users/yudyd/Desktop/GDP.csv')
[1] "Brazil"         "China"          "EU27 & UK"      "France"         "Germany"       
[6] "India"          "Italy"          "Japan"          "ROW"            "Russia"        
[11] "Spain"          "United Kingdom" "United States"  "WORLD"       

gdp=matrix(0,nrow = 11,ncol = 4)
gdp[1,]=unlist(GDP[which(GDP$Country.Name=='巴西'),c('X2019','X2020','X2021','X2022')])
gdp[2,]=unlist(GDP[which(GDP$Country.Name=='中国'),c('X2019','X2020','X2021','X2022')])
gdp[3,]=unlist(GDP[which(GDP$Country.Name=='法国'),c('X2019','X2020','X2021','X2022')])
gdp[4,]=unlist(GDP[which(GDP$Country.Name=='德国'),c('X2019','X2020','X2021','X2022')])
gdp[5,]=unlist(GDP[which(GDP$Country.Name=='印度'),c('X2019','X2020','X2021','X2022')])
gdp[6,]=unlist(GDP[which(GDP$Country.Name=='意大利'),c('X2019','X2020','X2021','X2022')])
gdp[7,]=unlist(GDP[which(GDP$Country.Name=='日本'),c('X2019','X2020','X2021','X2022')])
gdp[8,]=unlist(GDP[which(GDP$Country.Name=='俄罗斯联邦'),c('X2019','X2020','X2021','X2022')])
gdp[9,]=unlist(GDP[which(GDP$Country.Name=='西班牙'),c('X2019','X2020','X2021','X2022')])
gdp[10,]=unlist(GDP[which(GDP$Country.Name=='英国'),c('X2019','X2020','X2021','X2022')])
gdp[11,]=unlist(GDP[which(GDP$Country.Name=='美国'),c('X2019','X2020','X2021','X2022')])
cty_year1=cty_year[-c(3,9,14),-5]
cty_year_pergdp=cty_year1*10^6/gdp


cty=t(cty_year_pergdp) %>% data.frame()
cty$year = c(2019,2020,2021,2022)
cty_long <- tidyr::pivot_longer(cty, cols = -year, names_to = "Country", values_to = "value")

# 画图，确保将颜色映射到'country'这个变量
ggplot(cty_long, aes(x = year, y = value, group = Country, color = Country)) +
  geom_line() +
  scale_color_manual(values = c("Brazil" = 'blue', 
                                "China" = 'red', 
                                "France" = 'darkblue', 
                                "Germany" = 'green',
                                "India" = 'brown', 
                                "Italy" = 'purple', 
                                "Japan" = 'lightcoral',
                                "Spain" = 'yellow', 
                                "Russia" = 'orange', 
                                "United.Kingdom" = 'grey',
                                "United.States" = 'pink'))+
  ylab('Carbon Emission per GDP(MT/MD)')+
  xlab('Year')+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())




cluster1=cty_year_pergdp
# 利用碎石图确定聚类个数
mydata=cluster1
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) # 计算离均差平方和
for (i in 2:10) wss[i] <- sum(kmeans(mydata, 
                                     centers=i)$withinss) #计算不同聚类个数的组内平方和
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares") # 绘图

# K-Means聚类分析
fit1 <- kmeans(mydata, 3) # 设定聚类个数为3
# 获取聚类均值
aggregate(mydata,by=list(fit1$cluster),FUN=mean) # aggregate()是一个分类汇总函数
# 返回聚类的结果
res <- data.frame(mydata, fit1$cluster)


# Ward层次聚类
d <- dist(mydata, method = "euclidean") # 计算各个样本点之间的欧氏距离
fit2 <- hclust(d, method="ward.D") #进行Ward层次聚类
plot(fit2) # 绘制树状图展示聚类结果
groups <- cutree(fit2, k=3) # 设定聚类个数为3
groups[2]=4
groups
pca1 <- prcomp(cluster1,center = TRUE,scale. = TRUE)

df1 <- pca1$x # 提取PC score
df1 <- as.data.frame(df1) # 注意：如果不转成数据框形式后续绘图时会报错
summ1 <- summary(pca1)
summ1

dp2d=df1[,1:2]
dp3d=df1[,1:3]
dp2d$group=as.factor(groups)
dp3d$group=as.factor(groups)

ggplot(dp2d,aes(PC1,PC2,color=group))+
  geom_point(size=3)+
  scale_color_manual(values = c('blue','brown','orange','red'),label=c('Other Countries','India','Russia','China'))+
  theme_bw()+
  theme(legend.title = element_blank())

p=plot_ly(dp3d, x=~PC1,y=~PC2,z=~PC3,
          type="scatter3d",mode="markers",color=~group,
          colors=c('blue','green','red'))
p


population=read.csv('C:/Users/yudyd/Desktop/人口数据.csv')
popu=matrix(0,nrow = 11,ncol = 4)
popu[1,]=unlist(population[which(population$Country.Name=='巴西'),c('X2019','X2020','X2021','X2022')])
popu[2,]=unlist(population[which(population$Country.Name=='中国'),c('X2019','X2020','X2021','X2022')])
popu[3,]=unlist(population[which(population$Country.Name=='法国'),c('X2019','X2020','X2021','X2022')])
popu[4,]=unlist(population[which(population$Country.Name=='德国'),c('X2019','X2020','X2021','X2022')])
popu[5,]=unlist(population[which(population$Country.Name=='印度'),c('X2019','X2020','X2021','X2022')])
popu[6,]=unlist(population[which(population$Country.Name=='意大利'),c('X2019','X2020','X2021','X2022')])
popu[7,]=unlist(population[which(population$Country.Name=='日本'),c('X2019','X2020','X2021','X2022')])
popu[8,]=unlist(population[which(population$Country.Name=='俄罗斯联邦'),c('X2019','X2020','X2021','X2022')])
popu[9,]=unlist(population[which(population$Country.Name=='西班牙'),c('X2019','X2020','X2021','X2022')])
popu[10,]=unlist(population[which(population$Country.Name=='英国'),c('X2019','X2020','X2021','X2022')])
popu[11,]=unlist(population[which(population$Country.Name=='美国'),c('X2019','X2020','X2021','X2022')])
cty_year1=cty_year[-c(3,9,14),-5]
cty_year_pergdpper1=cty_year1*10^6/(gdp/popu)


cty=t(cty_year_pergdpper1) %>% data.frame()
cty$year = c(2019,2020,2021,2022)
cty_long <- tidyr::pivot_longer(cty, cols = -year, names_to = "Country", values_to = "value")

# 画图，确保将颜色映射到'country'这个变量
ggplot(cty_long, aes(x = year, y = value, group = Country, color = Country)) +
  geom_line() +
  scale_color_manual(values = c("Brazil" = 'blue', 
                                "China" = 'red', 
                                "France" = 'darkblue', 
                                "Germany" = 'green',
                                "India" = 'brown', 
                                "Italy" = 'purple', 
                                "Japan" = 'lightcoral',
                                "Spain" = 'yellow', 
                                "Russia" = 'orange', 
                                "United.Kingdom" = 'grey',
                                "United.States" = 'pink'))+
  ylab('Carbon Emission per GDP per capita(MT/MD/P)')+
  xlab('Year')+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())


cluster1=cty_year_pergdpper1
# 利用碎石图确定聚类个数
mydata=cluster1
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) # 计算离均差平方和
for (i in 2:10) wss[i] <- sum(kmeans(mydata, 
                                     centers=i)$withinss) #计算不同聚类个数的组内平方和
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares") # 绘图

# K-Means聚类分析
fit1 <- kmeans(mydata, 2) # 设定聚类个数为3
# 获取聚类均值
aggregate(mydata,by=list(fit1$cluster),FUN=mean) # aggregate()是一个分类汇总函数
# 返回聚类的结果
res <- data.frame(mydata, fit1$cluster)


# Ward层次聚类
d <- dist(mydata, method = "euclidean") # 计算各个样本点之间的欧氏距离
fit2 <- hclust(d, method="ward.D") #进行Ward层次聚类
plot(fit2) # 绘制树状图展示聚类结果
groups <- cutree(fit2, k=2) # 设定聚类个数为3
groups[2]=3
groups
pca1 <- prcomp(cluster1,center = TRUE,scale. = TRUE)

df1 <- pca1$x # 提取PC score
df1 <- as.data.frame(df1) # 注意：如果不转成数据框形式后续绘图时会报错
summ1 <- summary(pca1)
summ1

dp2d=df1[,1:2]
dp3d=df1[,1:3]
dp2d$group=as.factor(groups)
dp3d$group=as.factor(groups)

ggplot(dp2d,aes(PC1,PC2,color=group))+
  geom_point(size=3)+
  scale_color_manual(values = c('blue','brown','red'),label=c('Other Countries','India','China'))+
  theme_bw()+
  theme(legend.title = element_blank())

p=plot_ly(dp3d, x=~PC1,y=~PC2,z=~PC3,
          type="scatter3d",mode="markers",color=~group,
          colors=c('blue','green','red'))
p




area=matrix(0,11,4)
area[1,]=8515167 
area[2,]=9478057 
area[3,]=1106843  
area[4,]=357022 
area[5,]=3287263 
area[6,]=301340	
area[7,]=377975 
area[8,]=17234034 
area[9,]=505992 
area[10,]=243610 
area[11,]=9525067 
cty_year1=cty_year[-c(3,9,14),-5]
cty_year_perarea=cty_year1*10^8/area


cty=t(cty_year_perarea) %>% data.frame()
cty$year = c(2019,2020,2021,2022)
cty_long <- tidyr::pivot_longer(cty, cols = -year, names_to = "Country", values_to = "value")

# 画图，确保将颜色映射到'country'这个变量
ggplot(cty_long, aes(x = year, y = value, group = Country, color = Country)) +
  geom_line() +
  scale_color_manual(values = c("Brazil" = 'blue', 
                                "China" = 'red', 
                                "France" = 'darkblue', 
                                "Germany" = 'green',
                                "India" = 'brown', 
                                "Italy" = 'purple', 
                                "Japan" = 'lightcoral',
                                "Spain" = 'yellow', 
                                "Russia" = 'orange', 
                                "United.Kingdom" = 'grey',
                                "United.States" = 'pink'))+
  ylab('Carbon Emission')+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())


cluster1=cty_year_perarea
# 利用碎石图确定聚类个数
mydata=cluster1
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) # 计算离均差平方和
for (i in 2:10) wss[i] <- sum(kmeans(mydata, 
                                     centers=i)$withinss) #计算不同聚类个数的组内平方和
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares") # 绘图

# K-Means聚类分析
fit1 <- kmeans(mydata, 4) # 设定聚类个数为3
# 获取聚类均值
aggregate(mydata,by=list(fit1$cluster),FUN=mean) # aggregate()是一个分类汇总函数
# 返回聚类的结果
res <- data.frame(mydata, fit1$cluster)


# Ward层次聚类
d <- dist(mydata, method = "euclidean") # 计算各个样本点之间的欧氏距离
fit2 <- hclust(d, method="ward.D") #进行Ward层次聚类
plot(fit2) # 绘制树状图展示聚类结果
groups <- cutree(fit2, k=3) # 设定聚类个数为3
groups[2]=4
groups
pca1 <- prcomp(cluster1,center = TRUE,scale. = TRUE)

df1 <- pca1$x # 提取PC score
df1 <- as.data.frame(df1) # 注意：如果不转成数据框形式后续绘图时会报错
summ1 <- summary(pca1)
summ1

dp2d=df1[,1:2]
dp3d=df1[,1:3]
dp2d$group=as.factor(groups)
dp3d$group=as.factor(groups)

ggplot(dp2d,aes(PC1,PC2,color=group))+
  geom_point(size=3)+
  scale_color_manual(values = c('blue','green','yellow','red'),label=c('BrazilFranceIndiaRussiaSpainUS','GermanyItalyUK','Japan','China'))+
  theme_bw()

p=plot_ly(dp3d, x=~PC1,y=~PC2,z=~PC3,
          type="scatter3d",mode="markers",color=~group,
          colors=c('blue','green','yellow','red'))
p



prov_gdp=read.csv('C:/Users/yudyd/Desktop/地区生产总值.csv')
sigma=apply(prov_gdp[,-1],1,sd)
mu=apply(prov_gdp[,-1],1,mean)
vario=sigma/mu

gdp_manual=read.csv('C:/Users/yudyd/Desktop/gdp_manual.csv')
sigma=apply(gdp_manual[,-1],1,sd)
mu=apply(gdp_manual[,-1],1,mean)
vario=sigma/mu
vario_df=data.frame('年份'=gdp_manual[,1],'变异系数'=vario)
write.csv(vario_df,file = 'C:/Users/yudyd/Desktop/变异系数.csv')



library(gplots)

set.seed(123) # 设置随机种子，以便结果可复现

data=cty_year_pergdp
data=as.matrix(data)
# 计算距离
dist_matrix <- dist(data)

# 执行层次聚类
hc <- hclust(dist_matrix)

# 绘制基本树状图
plot(hc, main="Hierarchical Clustering Dendrogram", 
     xlab="Index", ylab="Height", sub="")


# 使用 gplots 包中的函数进行美化
heatmap.2(data, trace="none", col=bluered(10), 
          margin=c(10, 10), main="Clustered Heatmap", 
          dendrogram="row",  # 只对行进行聚类
          Colv=NA,           # 禁用列的聚类
          Rowv=as.dendrogram(hc))


# 使用ggplot2包中的函数进行美化
library(ggdendro)
ggdendrogram(hc, rotate = TRUE, theme_dendro = TRUE) + 
  theme_bw() +
  labs(title="Hierarchical Clustering with ggplot2")


shap=read.csv('C:/Users/yudyd/Desktop/shapres.csv',header = F)
shapbar=apply(shap,2,function(x){sum(abs(x))})


data_name=read.csv('C:/Users/yudyd/Desktop/data_带名字.csv')
name_chinese=data_name[33,] %>% unlist
names(name_chinese)=c()
name_english=data_name[34,] %>% unlist
names(name_english)=c()
name_short=data_name[35,] %>% unlist
names(name_short)=c()
datax=data_name[-c(33:35),-c(1:2)]

name=data.frame(Chinese=name_chinese,English=name_english,Short=name_short)[-1,]
write.csv(name,file = 'C:/Users/yudyd/Desktop/name.csv',row.names = F,fileEncoding = 'UTF-8')

df=data.frame(Group=name_short[-c(1:2)],Counts=shapbar)
df$Group <- factor(df$Group, levels = df$Group[order(-df$Counts,decreasing = T)])
df$Counts=round(df$Counts,2)
ggplot(df, aes(x=Group, y=Counts)) +
  geom_bar(stat="identity", fill="darkcyan") +
  coord_flip() +
  ggtitle("") +
  xlab("") +
  ylab("Variable Importance (Mean Absolute SHAP Values)")+
  geom_text(aes(label=Counts), hjust=-.05, color="black") +
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank(),  # 删除次要网格线
        panel.background = element_blank(),  # 删除背景填充
        axis.line = element_line(colour = "black"))+
  # scale_x_discrete(expand = c(0, 0))+
  scale_y_continuous(expand = c(0, 0.15, 0, 1.3))

lwd=2
a=list()

id=which(name_short[-c(1:2)]=='I/G')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[1]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('I/G')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(0.4,0.45,0.5,0.54))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 0.45,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust=0.5))



id=which(name_short[-c(1:2)]=='EE')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[2]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('EE')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(1.26,2,3,4,5),labels = c('1.26','2','3','4','5'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 1.26,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust=0.5))

##


id=which(name_short[-c(1:2)]=='PCG')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[3]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('PCG')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(15550,40000,60000,80000),
                     labels = c('15550','40000','60000','80000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 15550,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##


id=which(name_short[-c(1:2)]=='PCCSU')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[4]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('PCCSU')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(7600,15000,25000),
                     labels = c('7600','15000','25000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 7600,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##

id=which(name_short[-c(1:2)]=='ISW/G')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[5]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('ISW/G')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(0.66,1,2,3),
                     labels = c('0.66','1','2','3'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 0.658,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##

id=which(name_short[-c(1:2)]=='SI')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[6]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('SI')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(0,115000,2e5,3e5,4e5),
                     labels = c('0','115000','200000','300000','400000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 115000,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##


id=which(name_short[-c(1:2)]=='RDE')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[7]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('RDE')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(242500,1000000,2000000),
  labels = c('242500','1000000','2000000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 242500,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##


id=which(name_short[-c(1:2)]=='PCCSR')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
# dp1=data.frame(x=as.numeric(datax[,id]),y=as.numeric(data_name[1:32,2]))
# plot(dp1)
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[8]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('PCCSR')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(2380,5000,10000,15000),
                     labels = c('2380','5000','10000','15000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 2380,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##


id=which(name_short[-c(1:2)]=='LP')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
# dp1=data.frame(x=as.numeric(datax[,id]),y=as.numeric(data_name[1:32,2]))
# plot(dp1)
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[9]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('LP')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(2.32,5,10,15),
                     labels = c('2.32','5','10','15'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 2.32,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##


id=which(name_short[-c(1:2)]=='NFE')
dp=data.frame(x=as.numeric(datax[,id]),y=shap[,id])
# dp1=data.frame(x=as.numeric(datax[,id]),y=as.numeric(data_name[1:32,2]))
# plot(dp1)
breaks=seq(min(dp$x),max(dp$x),length=5) %>% round(2)

a[[10]]=ggplot(dp,aes(x=x,y=y))+
  geom_point()+
  xlab('NFE')+
  ylab('SHAP Value')+
  scale_x_continuous(breaks = c(37000,100000,200000),
                     labels = c('37000','100000','200000'))+
  geom_hline(yintercept = 0,color='salmon',lty='dashed',lwd=lwd)+
  geom_vline(xintercept = 37000,color='darkcyan',lty='dashed',lwd=lwd)+
  theme_bw()+
  theme(panel.grid.major = element_blank(),  # 删除主要网格线
        panel.grid.minor = element_blank())

##

library(ggpubr)
setwd('C:/Users/yudyd/Desktop/')
pdf('SHAP.pdf',height = 10, width = 10,family="GB1")
ggarrange(a[[1]],a[[2]],a[[3]],a[[4]],
          a[[5]],a[[6]],a[[7]],a[[8]],
          a[[9]],a[[10]],
          common.legend = F,nrow=4,ncol=3)
dev.off()

# sum(data[which(data$date=='19/09/2023'&data$country=='WORLD'),c('value')])
# sum(data[which(data$date=='19/09/2023'),c('value')])
# sum(data[which(data$date=='19/09/2022'&data$country=='WORLD'),c('value')])
# sum(data[which(data$date=='19/09/2022'),c('value')])
# sum(data[which(data$date=='19/09/2021'&data$country=='WORLD'),c('value')])
# sum(data[which(data$date=='19/09/2021'),c('value')])
# 
# sum(data[which(data$date=='19/09/2023'&data$country!='WORLD'),c('value')])
# sum(data[which(data$date=='19/09/2022'&data$country!='WORLD'),c('value')])
# sum(data[which(data$date=='19/09/2021'&data$country!='WORLD'),c('value')])
# 
# d2019=data[which(data$year=='2019'),]
# d1=data[which(data$country=='WORLD'),]
# d2=data[-which(data$country=='WORLD'),]
# sum(d1$value)-sum(d2$value)


bed_ratio=read.csv('C:/Users/yudyd/Desktop/床位比.csv')

plot(x=bed_ratio$年份,y=bed_ratio$ratio)
datatemp <- data.frame(x=bed_ratio$年份,y=bed_ratio$ratio)
mod_ssanova <- ssanova(y~x,data = datatemp)
pred82800 <- predict(mod_ssanova,newdata=data.frame(x=c(1991:1994,1996:1999,2001)))
datamain <- data.frame('年份'=c(1991:1994,1996:1999,2001),ratio=pred82800)

ggplot(datamain,aes(x=x,y=y))+
  geom_point(data = datatemp,aes(x=x,y=y))+
  geom_line(color = 'red',size = 1)+
  theme_bw()

bed_ratio_new=rbind(bed_ratio[,c(1,4)],datamain)

write.csv(bed_ratio_new,'C:/Users/yudyd/Desktop/bed_ratio_new.csv')
