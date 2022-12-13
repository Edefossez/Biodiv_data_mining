
#### Les bases de ggplot


ggplot(data   = matrix_full,              # spécifier les données
       mapping = aes(x = temp ,    # mapper 'temp' à l'axe des x
                     y = precip  )) +   # mapper 'precip' à l'axe des y
  geom_point()                    # tracer les points


###################################################################
###################################################################
### add lines

 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip)) 

 P+geom_point()
 
 
 P + geom_point() +  geom_line() 
 
 P1 <-  P + geom_point() +  geom_line() 
 
 ###################################################################
 ###################################################################
 ### add labels
 
P2 <-   P1+ geom_point() +  geom_line() +
labs(title    = "temperature vs. precipitation",
     subtitle = "data from species niche",
     x        = "temperature in degree C",
     y        = "precipitation in mm ",
     caption  = "bidiversity data mining 2022")
 
 P2
 
 ###################################################################
 ###################################################################
 ### change theme
 
 P2 + theme_bw() + theme(
   axis.title = element_text(colour = "blue", face = "bold"),
   plot.title = element_text(colour = "blue", face = "bold"),
   plot.subtitle = element_text(colour = "blue", face = "bold"))
 
 
 
 ###################################################################
 ###################################################################
 ###  points and lines types
 
 
 P <- ggplot(data = matrix_full, mapping = aes(x = temp, y = precip)) +
   geom_point(shape = 16, size = 3, color = "blue") 
 
 #size and lines type could be fixed
 P + geom_point(shape = 18, size = 3, color = "blue")  +
     geom_line(color = "red", linetype = 3) 
 
 #size  ccould be linked to values 
 
 P + geom_point(shape = 16, size = matrix_full$temp, color = "blue")  +
   geom_line(color = "red", linetype = 3) 
 
####################################################################
###################################################################
######## create group 
 
 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip, color =LC_names)) 
 P + geom_point(shape = 18, size = 3)  +
   geom_line(linetype = 3) 
 
 
 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip, color = matrix_full$temp)) 
 P + geom_point(shape = 18, size = 3)  + geom_line(linetype = 1) 
 
 
 ####################################################################
 ###################################################################
 ######## plot with factor
 
 
 P_fact <- ggplot(data   = matrix_full, mapping = aes(x = LC_names , y = temp)) 
 
 P_fact + geom_point(shape = 18, size = 3)
 
 P_fact +  geom_point(alpha = 0.1, size = 3) ### with transparency for overlap 
 

 ####################################################################
 ###################################################################
 ######## boxplot from factor
   
 P_fact <- ggplot(data   = matrix_full, mapping = aes(x = LC_names , y = temp)) 
 
 P_fact + geom_boxplot()

   
##### add point and  value
 
 P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) + ### change boxplot width 
   geom_jitter(alpha = 0.2, size = 2, width = 0.1) + # add points and spread point 
   stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") # add mean 
   
  
 
 P_fact + geom_boxplot(varwidth = TRUE, outlier.shape = NA) + ### change boxplot width 
   geom_jitter(alpha = 0.2, size = 2, width = 0.1) + # add points and spread point 
   stat_summary(fun = mean, shape = 13, size = 1, colour = "darkgreen") + # add mean 
   scale_fill_manual(values=cols)
 
 
 #### fill color boxplot 
 
 P_fact <- ggplot(data   = matrix_full,  aes(y = temp , fill = LC_names)) 
 
 P_fact + geom_boxplot() 
 
 
 #### control color
 
 P_fact <- ggplot(data   = matrix_full,  aes(y = temp , fill = LC_names)) 
 
 P_fact + geom_boxplot() + 
   
   scale_fill_manual(values= cols <-  c("darkgreen","darkred","darkblue","orange","brown","darkkhaki","darkslategrey") )
 

 

   
 ####################################################################
 ###################################################################
 ######## lines and regression
 
 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip)) 
 P + geom_smooth()       
 

 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip)) 
 
 P + geom_point(shape = 18, size = 3) +
     geom_smooth()      
 
 P <- ggplot(data   = matrix_full, mapping = aes(x = temp , y = precip, color =LC_names)) 
 
 P + geom_point(shape = 18) + 
     geom_smooth(method = "lm", se = FALSE)
 
 
 
 ####################################################################
 ###################################################################
 ######## histogram 
 
 
 
 ggplot(matrix_full, aes(x=temp)) +  ### frequency  
   geom_histogram()
 
 ggplot(matrix_full, aes(x=temp)) +  ### change breaks
   geom_histogram(bins=100)

 
 ggplot(matrix_full, aes(x=temp)) +  ### density
   geom_histogram(aes(y=..density..), position="identity")
 
 
 ####################################################################
 ###################################################################
 ######## density
 
 
 ggplot(matrix_full, aes(x=temp)) +  
   geom_density(adjust = 1,alpha=0.5)
 
 
 ggplot(matrix_full, aes(x=temp)) +
   geom_density(adjust = 0.1)   ## smooth with adjust
 
 ggplot(matrix_full, aes(x=temp)) +
   geom_density(adjust = 3) ## smooth with adjust
 
 

 ggplot(matrix_full, aes(x=temp,fill=factor(LC_names))) + ## add factor
   geom_density(adjust = 3)
 
 
 ggplot(matrix_full, aes(x=temp,fill=factor(LC_names))) +  ## add factor
   geom_density(adjust = 3,alpha=0.5)+ 
   theme_classic()   ## change theme
 
 
 
 ##### change group color  ### http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
 
 ggplot(matrix_full, aes(x=temp,fill=factor(LC_names))) +
   geom_density(adjust = 3,alpha=0.5)+
   scale_fill_manual(values=c("darkgreen","darkred","darkblue","orange","brown","darkkhaki","darkslategrey"))+
   theme_classic()
 
 cols <-  c("darkgreen","darkred","darkblue","orange","brown","darkkhaki","darkslategrey") ## external color values
 ggplot(matrix_full, aes(x=temp,fill=factor(LC_names))) +
   geom_density(adjust = 3,alpha=0.5)+
   scale_fill_manual(values=cols)+
   theme_classic()
 
 ##### mix histogram and denistiy 
 
 cols <-  c("darkgreen","darkred","darkblue","orange","brown","darkkhaki","darkslategrey") 
 
 ggplot(matrix_full, aes(x=temp,fill=factor(LC_names))) +
   geom_density(adjust = 1,alpha=0.5)+
   scale_fill_manual(values=cols)+
   geom_histogram(aes(y=..density..), alpha=0.3, position="identity")+
   theme_classic()
 
 
 
 
 
 