install.packages("gss")
library(gss)
bed_ratio=read.csv('E:/Desktop/黑客松/x.csv')
View(bed_ratio)
bed_ratio$x
bed_ratio$时间
plot(x=bed_ratio$time,y=bed_ratio$y)
datatemp <- data.frame(x=bed_ratio$时间,y=bed_ratio$y)
mod_ssanova <- ssanova(y~x,data = datatemp)
pred82800 <- predict(mod_ssanova,newdata=data.frame(x=c(1991:1994,1996,1999)))
datamain <- data.frame('年份'=c(1991:1994,1996,1999),ratio=pred82800)

ggplot(datamain,aes(x=x,y=y))+
  geom_point(data = datatemp,aes(x=x,y=y))+
  geom_line(color = 'red',size = 1)+
  theme_bw()

bed_ratio_new=rbind(bed_ratio[,c(1,4)],datamain)

write.csv(bed_ratio_new,'C:/Users/yudyd/Desktop/bed_ratio_new.csv')

##因子分析
data=read.csv('E:/Desktop/黑客松/datax.csv')
View(data)
library(psych)
data = data[,-1]
data = data[,-1]
View(data)
write.csv(data,'E:/Desktop/黑客松/scale.csv')
data = scale(data)
fa.varimax=fa(data,nfactors=3,rotate="varimax",fm="pa")
fa.varimax
write.csv(fa.varimax,'E:/Desktop/黑客松/fa.csv')

cor=cor(data1)
cor
fa1=fa(cor,nfactors = 7,rotate="none",fm="pa")
fa1
fa.promax=fa(data1,nfactors=7,rotate="promax",fm="pa")
fa.promax
factor.plot(fa.promax,labels=rownames(fa.promax$loadings))
fa.diagram(fa.promax,simple=FALSE)
fa.h=fa(data10,nfactors=7,rotate="varimax",fm="pa",score=TRUE)


