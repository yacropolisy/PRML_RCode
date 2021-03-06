# define density function
xMin <- 0.0 
xMax <- 5.0
yMin <- 0.0
yMax <- 1.5
datX <- seq( from=xMin, to=xMax, by=0.01 )

dfDNorm1 <- data.frame( x=datX, y=dnorm( x=datX, mean=2.0, sd=0.3 ) )
dfDNorm2 <- data.frame( x=datX, y=dnorm( x=datX, mean=3.0, sd=0.8 ) )


# set graphics parameters
#par( xaxt="n" )
#par( yaxt="n" )

title <- "z«ΖA«ΜNXm¦ͺz"
xlab <- "x"
ylab <- "ήx[likelihood]"
xlim <- range( c(xMin,xMax) )
ylim <- range( c(yMin,yMax) )
col1 <- "red"
col2 <- "blue"

# plot density functions
plot( dfDNorm1,
      main = title,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col1,
      type = "l"
    )
par(new=T)
plot( dfDNorm2,
      main = title,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      col = col2,
      type = "l"
)

#############################
# ROC Curve                 #
#############################

# define density function
xMin <- 0.0 
xMax <- 1.0
yMin <- 0.0
yMax <- 1.0
dat1 <- seq( from=0.0, to=10.0, by=0.01 )
dat2 <- seq( from=0.0, to=10.0, by=0.01 )

dfROC <- data.frame( 
              sigma1 = pnorm( q=dat1, mean=2.0, sd=0.3, lower.tail=TRUE ),
              sigma2 = pnorm( q=dat2, mean=3.0, sd=0.8, lower.tail=TRUE )
        )

# set graphics parameters
win.graph() # 2ΪΜOtBbNEChEΙμ}

titleROC <- "ROCΘό [ROC Curve]"
xlab <- "Uz«¦ [false positive rate]"
ylab <- "^z«¦ [true positive rate]"
xlim <- range( c(xMin,xMax) )
ylim <- range( c(yMin,yMax) )


# plot ROC Curve
plot( dfROC$sigma2, dfROC$sigma1,
      main = titleROC,
      xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      type = "l"      
)
