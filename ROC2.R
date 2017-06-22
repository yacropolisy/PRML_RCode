#############################
# density function          #
#############################
xMin <- 0.0 
xMax <- 10.0
yMin <- 0.0
yMax <- 1.5
datX <- seq( from=xMin, to=xMax, by=0.01 )

# �m�����z�̏d�Ȃ薳��
dfDNorm1_1 <- data.frame( x=datX, y=dnorm( x=datX, mean=1.0, sd=0.3 ) )
dfDNorm1_2 <- data.frame( x=datX, y=dnorm( x=datX, mean=7.0, sd=0.8 ) )

# �m�����z�̏d�Ȃ�L��P
dfDNorm2_1 <- data.frame( x=datX, y=dnorm( x=datX, mean=5.0, sd=0.3 ) )
dfDNorm2_2 <- data.frame( x=datX, y=dnorm( x=datX, mean=7.0, sd=0.8 ) )

# �m�����z�̏d�Ȃ�L��Q
dfDNorm3_1 <- data.frame( x=datX, y=dnorm( x=datX, mean=6.0, sd=0.3 ) )
dfDNorm3_2 <- data.frame( x=datX, y=dnorm( x=datX, mean=7.0, sd=0.8 ) )

# �m�����z�̕��ϒl��v
dfDNorm4_1 <- data.frame( x=datX, y=dnorm( x=datX, mean=7.0, sd=0.3 ) )
dfDNorm4_2 <- data.frame( x=datX, y=dnorm( x=datX, mean=7.0, sd=0.8 ) )


# set graphics parameters
par( mfrow=c(2,2) )   # 2*2��ʕ\��
#par( xaxt="n" )
par( yaxt="n" )
par( lwd = 1.0 )

title <- "�z���ƉA���̃N���X�m�����z�i�d�Ȃ�̈�L��j"
xlab <- "x"
ylab <- "�ޓx[likelihood]"
xlim <- range( c(xMin,xMax) )
ylim <- range( c(yMin,yMax) )
col1 <- "red"
col2 <- "blue"

#-----------------------------------------
# plot density functions
#-----------------------------------------
title1 <- "�d�Ȃ�̈斳��"
plot( dfDNorm1_1,
      main = title1,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col1,
      type = "l"
)
par(new=T)
plot( dfDNorm1_2,
      main = title1,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col2,
      type = "l"
)
grid()
#-----------------------------------------
title2 <- "�d�Ȃ�̈�L��P"
plot( dfDNorm2_1,
      main = title2,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col1,
      type = "l"
)
par(new=T)
plot( dfDNorm2_2,
      main = title2,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col2,
      type = "l"
)
grid()
#-----------------------------------------
title3 <- "�d�Ȃ�̈�L��Q"
plot( dfDNorm3_1,
      main = title3,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col1,
      type = "l"
)
par(new=T)
plot( dfDNorm3_2,
      main = title3,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col2,
      type = "l"
)
grid()
#-----------------------------------------
title4 <- "���ϒl��v"
plot( dfDNorm4_1,
      main = title4,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col1,
      type = "l"
)
par(new=T)
plot( dfDNorm4_2,
      main = title4,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col2,
      type = "l"
)
grid()
 
#############################
# ROC Curve                 #
#############################
# define density function
xMin <- 0.0 
xMax <- 1.0
yMin <- 0.0
yMax <- 1.01
dat <- seq( from=0.0, to=10.0, by=0.01 ) # ���ʋ��E�i0��10 �Ɉړ�������j

dfROC1 <- data.frame( 
  sigma1 = pnorm( q=dat, mean=1.0, sd=0.3, lower.tail=TRUE ),
  sigma2 = pnorm( q=dat, mean=7.0, sd=0.8, lower.tail=TRUE )
)

dfROC2 <- data.frame( 
  sigma1 = pnorm( q=dat, mean=5.0, sd=0.3, lower.tail=TRUE ),
  sigma2 = pnorm( q=dat, mean=7.0, sd=0.8, lower.tail=TRUE )
)

dfROC3 <- data.frame( 
  sigma1 = pnorm( q=dat, mean=6.0, sd=0.3, lower.tail=TRUE ),
  sigma2 = pnorm( q=dat, mean=7.0, sd=0.8, lower.tail=TRUE )
)

dfROC4 <- data.frame( 
  sigma1 = pnorm( q=dat, mean=7.0, sd=0.3, lower.tail=TRUE ),
  sigma2 = pnorm( q=dat, mean=7.0, sd=0.8, lower.tail=TRUE )
)

# set graphics parameters
#win.graph()           # 2���ڂ̃O���t�B�b�N�E�C���h�E�ɍ�}
par( mfrow=c(2,2) )   # 2*2��ʕ\��
par( xaxt="s" )
par( yaxt="s" )
par( lwd = 2 )

titleROC <- "ROC�Ȑ� [ROC Curve]"
xlab <- "�U�z���� [false positive rate]"
ylab <- "�^�z���� [true positive rate]"
xlim <- range( c(xMin,xMax) )
ylim <- range( c(yMin,yMax) )

#----------------------------------------
# plot ROC Curve
#----------------------------------------
titleROC1 <- "�d�Ȃ�̈�Ȃ�"
plot( dfROC1$sigma2, dfROC1$sigma1,
      main = titleROC1,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      type = "l"      
)
grid()
#---------------------------------------
titleROC2 <- "�d�Ȃ�̈悠��P"
plot( dfROC2$sigma2, dfROC2$sigma1,
      main = titleROC2,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      type = "l"      
)
grid()
#---------------------------------------
titleROC3 <- "�d�Ȃ�̈悠��Q"
plot( dfROC3$sigma2, dfROC3$sigma1,
      main = titleROC3,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      type = "l"      
)
grid()
#---------------------------------------
titleROC4 <- "���ϒl��v"
plot( dfROC4$sigma2, dfROC4$sigma1,
      main = titleROC4,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      type = "l"      
)
grid()

#############################
# AUC                       #
#############################

# calc AUC Value

# plot AUC Value


#############################
# �������� [loss line]      #
#############################
