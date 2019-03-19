# Load data
setwd("/media/veracrypt9/a_documents/group b/computing/data science/datasets")
mydata<-read.csv("oilgspc.csv")
attach(mydata)
train<-mydata[1:400,]
attach(train)
plot(mydata$date,mydata$gspc,type='l',xlab="Date")
title("^GSPC")
plot(mydata$date,mydata$oil,type='l',xlab="Date")
title("Oil Price")

# Regression 1
reg1<-lm(gspc~oil,data=train)
summary(reg1)

# Durbin-Watson Test - Regression 1
library(lmtest)
library(tseries)
library(orcutt)
dwtest(reg1)
reg1residuals=reg1$residuals
plot(reg1residuals,type='l')
title("Residuals")
orcuttreg1<-cochrane.orcutt(reg1)
summary(orcuttreg1)
dwtest(orcuttreg1)

# Cointegration test
library(aTSA)
coint.test(train$gspc,train$oil)
coint.test(train$gspc,train$oil,d=1)
adf.test(train$gspc)
adf.test(train$oil)
adf.test(diff(train$gspc,1))
adf.test(diff(train$oil,1))

# Granger Test
grangertest(train$gspc ~ train$oil, order=119)
grangertest(train$gspc ~ train$oil, order=120)

# Cross-Correlation
ccf1<-ccf(train$gspc,train$oil,lag.max=500,main = "Cross-Correlation")
ccf1

# Regression 2
reg2<-lm(gspc[121:400]~oil[1:280],data=train)
summary(reg2)
dwtest(reg2)
orcuttreg2<-cochrane.orcutt(reg2)
orcuttreg2

# Predictions
test1<-mydata[401:500,]
predict1=1780.0014 + (5.7817*test1$oil) #reg1
predict2=1767.628 + (6.3602*test1$oil) #orcuttreg1
predict3=2148.555 -(2.563*train$oil[281:380]) #reg2
predict4=2094.4549 -(0.7585*train$oil[281:380]) #orcuttreg2

# Error Readings
error1=((test1$gspc-predict1)/predict1)
error2=((test1$gspc-predict2)/predict2)
error3=((test1$gspc-predict3)/predict3)
error4=((test1$gspc-predict4)/predict4)

error1
mean(error1)
percentage_error1=data.frame(abs(error1))
accuracy1=data.frame(percentage_error1[percentage_error1$abs.error1. < 0.05,])
accuracy1
hist(percentage_error1$abs.error1.,main="Histogram: Prediction 1",xlab="Error")

error2
mean(error2)
percentage_error2=data.frame(abs(error2))
accuracy2=data.frame(percentage_error2[percentage_error2$abs.error2. < 0.05,])
accuracy2
hist(percentage_error2$abs.error2.,main="Histogram: Prediction 2",xlab="Error")

error3
mean(error3)
percentage_error3=data.frame(abs(error3))
accuracy3=data.frame(percentage_error3[percentage_error3$abs.error3. < 0.05,])
accuracy3
hist(percentage_error3$abs.error3.,main="Histogram: Prediction 3",xlab="Error")

error4
mean(error4)
percentage_error4=data.frame(abs(error4))
accuracy4=data.frame(percentage_error4[percentage_error4$abs.error4. < 0.05,])
accuracy4
hist(percentage_error4$abs.error4.,main="Histogram: Prediction 4",xlab="Error")