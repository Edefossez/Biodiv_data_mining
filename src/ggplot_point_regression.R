
library(ggplot2)

my_data <- mtcars

ggplot(mtcars, aes(wt, mpg)) +
geom_point()

ggplot(mtcars, aes(wt, mpg)) +
geom_point(aes(colour = factor(cyl)))


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(shape = factor(cyl)))


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(size = qsec))


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec))


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  theme_bw()


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm") +
  theme_bw()


formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul) +
  theme_bw()
  

formul <- y ~ poly(x, 3, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul) +
  theme_bw()


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "loess",span = 0.5) +
  theme_bw()



formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,aes(fill = factor(cyl))) +
  theme_bw()


formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,aes(fill = factor(cyl)),color ="black") +
  theme_bw()


formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,aes(fill = factor(cyl)),color ="black") +
  scale_fill_manual(values=c("darkgreen","darkred","darkblue"))+
  theme_bw()


formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,se=F,color ="black") +
  theme_bw()


ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "loess",span = 0.5,se=F,color ="black") +
  theme_bw()



formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,aes(fill = factor(cyl)),color ="black") +
  scale_fill_manual(values=c("darkgreen","darkred","darkblue"))+
  theme_bw()+ 
  theme(legend.position="top")


  
formul <- y ~ poly(x, 1, raw = TRUE)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(colour = factor(cyl),size = qsec,alpha = 1/20))+
  geom_smooth(method = "lm",formula = formul,aes(fill = factor(cyl)),color ="black") +
  scale_fill_manual(values=c("darkgreen","darkred","darkblue"))+
  theme_bw()+ 
  theme(legend.position="none")
  
  