#install.packages("kernlab")

# expand lib on memory
library( MASS )    # MASS package
library( kernlab ) # 

# set options
options( digits=7 ) # �\������

#####################################
# set iris data
#####################################
# expand on memory
data( iris )

# copy data from iris data
dfIris <- data.frame(
  datSLength = iris$Sepal.Length,
  datSWidth  = iris$Sepal.Width,
  datPLength = iris$Petal.Length,
  datPWidth  = iris$Petal.Width,
  
  # ��ʁisetosa,virginica�j���P�̃N���X�ɂ܂Ƃ߂�,
  # �Q�̃N���X�iC1�Fsetosa and virginica�AC2�Fversicolor�j�̎��ʖ��ɕϊ�����B
  class   = c( rep("C1",50), rep("C2",50), rep("C1",50) )
)

# sort from C1 to C2�i���`�����s�\�Ȏ��ʖ��ɂ��邽�߃\�[�g���Ȃ��j
#dfIris$class   <- dfIris$class[ order( dfIris$class ) ]
#dfIris$datSLength <- dfIris$datSLength[ order( dfIris$class ) ]
#dfIris$datSWidth  <- dfIris$datSWidth[ order( dfIris$class ) ]
#dfIris$datPLength <- dfIris$datPLength[ order( dfIris$class ) ]
#dfIris$datPWidth  <- dfIris$datPWidth[ order( dfIris$class ) ]


#####################################
# LDA : liner discriminant analysis #
#####################################
iris_ida <- lda( dfIris$class ~ . , data = dfIris )
summary( iris_ida )
print( iris_ida )
irislinerC <- apply( iris_ida$means%*%iris_ida$scaling, 2, mean ) # �萔��C
cat( "\nConstant term:\n" )
print( irislinerC )

# print idification result in table
resultIris <- predict( iris_ida )
tblIris <- table( dfIris$class, resultIris$class )
cat( "\nIdification result:" )
print( tblIris )

# release memory
#rm( iris )

# Coefficients of idification lines 
datSLength_LD <- iris_ida$scaling[1]
datSWidth_LD  <- iris_ida$scaling[2]
datPLength_LD <- iris_ida$scaling[3]
datPWidth_LD  <- iris_ida$scaling[4]

# mapping iris data �i�A�����f�[�^���ʑ��j
dfIrisTransLd <- data.frame(
  x1 = rep(0,150), x2 = rep(0,150),
  class = c( rep("C1", 50), rep("C2", 50), rep("C1", 50) ) 
)

# setosa
#dfIrisTransLd$x1[1:50] <- ( datSLength_LD*iris$Sepal.Length[1:50] + datSWidth_LD*iris$Sepal.Width[1:50] + irislinerC )
#dfIrisTransLd$x2[1:50] <- ( datPLength_LD*iris$Petal.Length[1:50] + datPWidth_LD*iris$Petal.Width[1:50] + irislinerC )
dfIrisTransLd$x1[1:50] <- ( datSLength_LD*iris$Sepal.Length[1:50] + datPLength_LD*iris$Petal.Length[1:50] + irislinerC )
dfIrisTransLd$x2[1:50] <- ( datSWidth_LD*iris$Sepal.Width[1:50] + datPWidth_LD*iris$Petal.Width[1:50] + irislinerC )

# versicolor
#dfIrisTransLd$x1[51:100] <- ( datSLength_LD*iris$Sepal.Length[51:100] + datSWidth_LD*iris$Sepal.Width[51:100] + irislinerC )
#dfIrisTransLd$x2[51:100] <- ( datPLength_LD*iris$Petal.Length[51:100] + datPWidth_LD*iris$Petal.Width[51:100] + irislinerC )
dfIrisTransLd$x1[51:100] <- ( datSLength_LD*iris$Sepal.Length[51:100] + datPLength_LD*iris$Petal.Length[51:100] + irislinerC )
dfIrisTransLd$x2[51:100] <- ( datSWidth_LD*iris$Sepal.Width[51:100] + datPWidth_LD*iris$Petal.Width[51:100] + irislinerC )

# virginica
#dfIrisTransLd$x1[101:150] <- ( datSLength_LD*iris$Sepal.Length[101:150] + datSWidth_LD*iris$Sepal.Width[101:150] + irislinerC )
#dfIrisTransLd$x2[101:150] <- ( datPLength_LD*iris$Petal.Length[101:150] + datPWidth_LD*iris$Petal.Width[101:150] + irislinerC )
dfIrisTransLd$x1[101:150] <- ( datSLength_LD*iris$Sepal.Length[101:150] + datPLength_LD*iris$Petal.Length[101:150] + irislinerC )
dfIrisTransLd$x2[101:150] <- ( datSWidth_LD*iris$Sepal.Width[101:150] + datPWidth_LD*iris$Petal.Width[101:150] + irislinerC )


#########################
# set gaussian kernel   #
#########################
#-------------------------------------------------------
# GaussianKernel()
# [in]
#  x :        [vector] input data set x-axis's
#  alpha :    [scaler] constant value
#  mean :     [vector] mean vector
#  matSigma : [matrix] covariance matrix
# [out]
#  gauss :    [scaler] function value (z value)
#-------------------------------------------------------
GaussianKernel <- function( x, alpha, mean, matSigma )
{
  mean <- matrix( rep( mean, each = nrow(x) ), ncol = ncol(x) ) # x �Ɠ������̍s���
  devX <- t( x - mean )                                         # ��ɍ����v�Z�B�������ȍ~�̌v�Z�Ŏg����悤�]�u�B
#print(x)
#print(mean)
#print(devX)
  gauss <- exp( -alpha*t(devX) %*% solve( matSigma ) %*% devX ) 
#print(gauss)
  return( gauss )
}

# �P�ڂ�GaussianKernel �isetosa�j��contour()�p�̃f�[�^�\��
lstGKernel1 <- list(
  x1 = seq( from = -20, to = 5, by = 0.2 ),
  x2 = seq( from = -20, to = 5, by = 0.2 ),
  z = matrix( 0, nrow = 100, ncol = 100 ),
  
  dat_alpha = 0.003,
  vec_u = c( -7.61,0.22 ),
  matS = matrix( c(0.72,-0.53,-0.53,0.84), nrow = 2, ncol = 2 )
)
lstGKernel1$z <- matrix( 0, nrow = length(lstGKernel1$x1), ncol = length(lstGKernel1$x2) )
lstGKernel1$vec_u <- c( mean(dfIrisTransLd$x1[1:50]), mean(dfIrisTransLd$x2[1:50]) )  # setosa�̕��z�̕���
lstGKernel1$matS <- var( cbind(dfIrisTransLd$x1[1:50], dfIrisTransLd$x2[1:50] ) )

lstGKernel1$z <- GaussianKernel( 
  x = cbind( lstGKernel1$x1, lstGKernel1$x2 ), 
  alpha = lstGKernel1$dat_alpha, 
  mean = lstGKernel1$vec_u , matSigma = lstGKernel1$matS
)

# �Q�ڂ�GaussianKernel�iversicolor�j��contour()�p�̃f�[�^�\��
lstGKernel2 <- list(
  x1 = lstGKernel1$x1,
  x2 = lstGKernel1$x2,
  z = matrix( 0, nrow = 100, ncol = 100 ),
  
  dat_alpha = lstGKernel1$dat_alpha*10,
  vec_u = c( 1.83,-0.73 ),
  matS = matrix( c(1.07,0.24,0.24,0.76), nrow = 2, ncol = 2 )
)
lstGKernel2$z = matrix( 0, nrow = length(lstGKernel2$x1), ncol = length(lstGKernel2$x2) )
lstGKernel2$vec_u <- c( mean(dfIrisTransLd$x1[51:100]), mean(dfIrisTransLd$x2[51:100]) )  # versicolor�̕��z�̕���
lstGKernel2$matS <- var( cbind(dfIrisTransLd$x1[51:100], dfIrisTransLd$x2[51:100] ) )

lstGKernel2$z <- GaussianKernel( 
  x = cbind( lstGKernel2$x1, lstGKernel2$x2 ),
  alpha = lstGKernel2$dat_alpha, 
  mean = lstGKernel2$vec_u , matSigma = lstGKernel2$matS
)

# GaussianKernel()�Ŏʑ������f�[�^�̍\��
# setora
iris_Gkernel1_s <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[1:50], dfIrisTransLd$x2[1:50] ), 
  alpha = lstGKernel1$dat_alpha, 
  mean = lstGKernel1$vec_u , matSigma = lstGKernel1$matS
)
iris_Gkernel2_s <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[1:50], dfIrisTransLd$x2[1:50] ), 
  alpha = lstGKernel2$dat_alpha, 
  mean = lstGKernel2$vec_u , matSigma = lstGKernel2$matS
)

iris_Gkernel1_s <- iris_Gkernel1_s[ order(iris_Gkernel1_s) ]
iris_Gkernel2_s <- iris_Gkernel2_s[ order(iris_Gkernel2_s) ]
dfIrisTrasGkernel_s <- data.frame(
  fs_x = iris_Gkernel1_s[1:50],
  fc_x = iris_Gkernel2_s[1:50]
)

# versicolor
iris_Gkernel1_c <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[51:100], dfIrisTransLd$x2[51:100] ), 
  alpha = lstGKernel1$dat_alpha, 
  mean = lstGKernel1$vec_u , matSigma = lstGKernel1$matS
)
iris_Gkernel2_c <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[51:100], dfIrisTransLd$x2[51:100] ), 
  alpha = lstGKernel2$dat_alpha, 
  mean = lstGKernel2$vec_u , matSigma = lstGKernel2$matS
)

iris_Gkernel1_c <- iris_Gkernel1_c[ order(iris_Gkernel1_c) ]
iris_Gkernel2_c <- iris_Gkernel2_c[ order(iris_Gkernel2_c) ]
dfIrisTrasGkernel_c <- data.frame(
  fs_x = iris_Gkernel1_c[1:50],
  fc_x = iris_Gkernel2_c[1:50]
)

# virginica
iris_Gkernel1_v <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[101:150], dfIrisTransLd$x2[101:150] ), 
  alpha = lstGKernel1$dat_alpha, 
  mean = lstGKernel1$vec_u , matSigma = lstGKernel1$matS
)

iris_Gkernel2_v <- GaussianKernel( 
  x = cbind( dfIrisTransLd$x1[101:150], dfIrisTransLd$x2[101:150] ), 
  alpha = lstGKernel2$dat_alpha, 
  mean = lstGKernel2$vec_u , matSigma = lstGKernel2$matS
)

iris_Gkernel1_v <- iris_Gkernel1_v[ order(iris_Gkernel1_v) ]
iris_Gkernel2_v <- iris_Gkernel2_v[ order(iris_Gkernel2_v) ]
dfIrisTrasGkernel_v <- data.frame(
  fs_x = iris_Gkernel1_v[1:50],
  fc_x = iris_Gkernel2_v[1:50]
)

###########################################
# logisitic regression in non-liner space
###########################################
# ���W�X�e�B�b�N��A�p�̃f�[�^�̍\��
dfIrisTrasGkernel <- data.frame(
  fs_x = c( dfIrisTrasGkernel_s$fs_x, dfIrisTrasGkernel_c$fs_x, dfIrisTrasGkernel_v$fs_x ),
  fc_x = c( dfIrisTrasGkernel_s$fc_x, dfIrisTrasGkernel_c$fc_x, dfIrisTrasGkernel_v$fc_x ),
  class = c( rep("C1",50), rep("C2",50), rep("C1",50))
)
iris_glm <- glm(                      # ��ʉ����`���f���̊֐�
  formula = dfIrisTrasGkernel$class ~ .,  # ���f����
  family = binomial(link = "logit"),  # �ړI�ϐ��̊m�����z
  # �����N�֐� binomial(link = "logit") �ړI�ϐ���2�l�ϐ�
  # �Ή����Ă��郊���N�֐���'logit'�i���W�X�e�B�b�N��A�^���W�b�g���f���j
  data = dfIrisTrasGkernel
)
print( iris_glm )

# print idification result in table
resultIrisGkernel <- predict( iris_glm )
tblIris <- table( dfIrisTrasGkernel$class, dfIrisTrasGkernel$class )
cat( "\nIdification result:" )
print( tblIris )

# ���W�X�e�B�b�N��A�֐�plot�p�̃f�[�^�\��
# logit(pi) = iris_glm$coefficients[1] + iris_glm$coefficients[2]*x1 + iris_glm$coefficients[3]*x2
LogisticFunction <- function( x1, x2, cof_x1, cof_x2, c_term )
{
  logistic <- cof_x1*x1 + cof_x2*x2 + c_term
  return(logistic)
}

dfIrisLogistic <- data.frame(
  x1 = seq( from = 0, to = 1, by = 0.01 ),
  x2 = seq( from = 0, to = 1, by = 0.01 ),
  z = 0
)
dfIrisLogistic$z <- matrix( 0, nrow = length(dfIrisLogistic$x1), ncol = length(dfIrisLogistic$x2) )

# outer()�֐���x1,x2�̑S�g�ݍ��킹�ɑ΂���z�l����x�ɋ��߂�
dfIrisLogistic$z <- outer(
  dfIrisLogistic$x1, dfIrisLogistic$x2,
  LogisticFunction,
  iris_glm$coefficients[2],
  iris_glm$coefficients[3],
  iris_glm$coefficients[1]
)

############################
# set graphics parameters  #
############################
# ���Ɋւ��Ẵf�[�^���X�g
lstAxis <- list(                        
  xMin = 0.0, xMax = 1.0,  # x���̍ŏ��l�A�ő�l
  yMin = 0.0, yMax = 1.0,  # y���̍ŏ��l�A�ő�l
  zMin = 0.0, zMax = 1.0,  # z���̍ŏ��l�A�ő�l
  xlim = range( c(0.0, 1.0) ), 
  ylim = range( c(0.0, 1.0) ), 
  zlim = range( c(0.0, 1.0) ),
  mainTitle = "mainTitle", # �}�̃��C���^�C�g���i�}�̏�j
  subTitle  = "subTitle",  # �}�̃T�u�^�C�g���i�}�̉��j
  xlab      = "x", # x���̖��O
  ylab      = "y", # y���̖��O
  zlab      = "z"  # z���̖��O
)
lstAxis$xMin <- -10
lstAxis$xMax <-  5
lstAxis$yMin <- -20
lstAxis$yMax <- -10
lstAxis$zMin <- 0
lstAxis$zMax <- 1
lstAxis$xlim = range( c(lstAxis$xMin, lstAxis$xMax) )
lstAxis$ylim = range( c(lstAxis$yMin, lstAxis$yMax) )
lstAxis$zlim = range( c(lstAxis$zMin, lstAxis$zMax) )
lstAxis$xlab <- "LD_x1"
lstAxis$ylab <- "LD_x2"
lstAxis$mainTitle <- "�Q�̃K�E�X�j�֐��ɂ�����`�ʑ��̓�����\ncontours of Nonlinear mapping by 2-kernels"
lstAxis$subTitle <- "class C1 : setosa and virginica, class C2 : versicolor"

# plot frame only
par(new=F)
plot.new()  # clear
plot( c(), type='n',
      main = lstAxis$mainTitle,
      xlim=lstAxis$xlim, ylim=lstAxis$ylim,
      xlab=lstAxis$xlab, ylab=lstAxis$ylab
)
grid() #�O���b�h����ǉ�

############################
# Draw figure              #
############################
# plot setosa
par(new=T)
plot(
  dfIrisTransLd$x1[1:50], dfIrisTransLd$x2[1:50],
  type='p',
  col = "red",
  pch = 's',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab  
)
grid() #�O���b�h����ǉ�

# add plot versicolor
par(new=T)
plot(
  dfIrisTransLd$x1[51:100], dfIrisTransLd$x2[51:100],
  type='p',
  col = "blue",
  pch = 'c',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab  
)

# add plot virginica
par(new=T)
plot(
  dfIrisTransLd$x1[101:150], dfIrisTransLd$x2[101:150],
  type='p',
  col = "red",
  pch = 'v',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab
)

# Gaussian Kernel1 �̓������ǋL
par(new=TRUE)
contour(
  x = lstGKernel1$x1, y = lstGKernel1$x2, z = lstGKernel1$z,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  lwd = 1,
  lty = 2,
  col = "darkgreen",
  levels = seq( from = 0, to = 500, by = 50 ),
  nlevels = 1
)

# Gaussian Kernel2 �̓������ǋL
par(new=TRUE)
contour(
  x = lstGKernel2$x1, y = lstGKernel2$x2, z = lstGKernel2$z,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  lwd = 1,
  lty = 2,
  col = "green",
  levels = seq( from = 0, to = 200, by = 20 ),
  nlevels = 10
)

# �}��̒ǉ�
legend(
  x = -10, y = -16,
  legend = c( "setosa","versicolor","virginica" ),
  col = c( "red","blue", "red"),
  pch = c( 's','c','v'),
  text.width = 3
)

#---------------------------------------------
# �K�E�X�j�֐��ɂ�����`�ʑ���Ԃł�plot
#---------------------------------------------
lstAxis$xMin <- 0
lstAxis$xMax <- 1
lstAxis$yMin <- 0
lstAxis$yMax <- 1
lstAxis$zMin <- 0
lstAxis$zMax <- 1
lstAxis$xlim = range( c(lstAxis$xMin, lstAxis$xMax) )
lstAxis$ylim = range( c(lstAxis$yMin, lstAxis$yMax) )
lstAxis$zlim = range( c(lstAxis$zMin, lstAxis$zMax) )
lstAxis$xlab <- "fs(x)"
lstAxis$ylab <- "fc(x)"
lstAxis$mainTitle <- "����`��ԏ�ł̃��W�X�e�B�b�N��A�ɂ�鎯��\nIdentification by logistic in nonlinear space"
lstAxis$subTitle <- "class C1 : setosa and virginica, class C2 : versicolor"


# plot setosa
plot(
  dfIrisTrasGkernel_s,
  type='p',
  col = "red",
  pch = 's',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab  
)
grid() #�O���b�h����ǉ�

# add plot versicolor
par(new=T)
plot(
  dfIrisTrasGkernel_c,
  type='p',
  col = "blue",
  pch = 'c',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab  
)

# add plot virginica
par(new=T)
plot(
  dfIrisTrasGkernel_v,
  type='p',
  col = "red",
  pch = 'v',
  main = lstAxis$mainTitle,
  sub = lstAxis$subTitle,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim, 
  xlab=lstAxis$xlab, ylab=lstAxis$ylab
)

# logistic��A�̓������ǋL
par(new=TRUE)
contour(
  x = dfIrisLogistic$x1, y = dfIrisLogistic$x2, z = dfIrisLogistic$z,
  xlim=lstAxis$xlim, ylim=lstAxis$ylim,
  lwd = 2,
  lty = 3,
  levels = c(-50, -20, -10, 0, 10, 20, 50)
)
# ���ʋ��E�ƂȂ铙�����������\��
par(new=TRUE)
contour(
  x = dfIrisLogistic$x1, y = dfIrisLogistic$x2, z = dfIrisLogistic$z,
  xlim = lstAxis$xlim, ylim = lstAxis$ylim,
  lwd = 2,
  col = "green",
  levels = 0.5
)

#-------------------------------
# Gauggassan function (3d plot) 
#-------------------------------
# lstAxis$mainTitle <- "�K�E�X�j�֐�\nGaussian kernel function 1"
# lstAxis$subTitle <- "setosa�̃f�[�^���z��萶��"
# lstAxis$xlab <- "LD_x1"
# lstAxis$ylab <- "LD_x2"
# lstAxis$zlab <- "fs(x)"
# persp(
#   x =  lstGKernel1$x1, y = lstGKernel1$x2, z = lstGKernel1$z,
#   theta = 20, phi = 15, expand = 0.5, d = 2,
#   border = "darkgray", ltheta = 120, shade = 0.8,
#   cex.axis = 0.8,
#   main = lstAxis$mainTitle,
#   sub = lstAxis$subTitle,
#   xlab = lstAxis$xlab, ylab = lstAxis$ylab, zlab = lstAxis$zlab,
# #  xlim = range( c(-10,10) ), ylim = range( c(-10,10) ),
#   col = "green",
#   ticktype = "detailed"
# )
# 
# lstAxis$mainTitle <- "�K�E�X�j�֐�\nGaussian kernel function 2"
# lstAxis$subTitle <- "virginica�̃f�[�^���z��萶��"
# lstAxis$zlab <- "fc(x)"
# persp(
#   x =  lstGKernel2$x1, y = lstGKernel2$x2, z = lstGKernel2$z,
#   theta = 20, phi = 15, expand = 0.5, d = 2,
#   border = "darkgray", ltheta = 120, shade = 0.8,
#   cex.axis = 0.8,
#   main = lstAxis$mainTitle,
#   sub = lstAxis$subTitle,
#   xlab = lstAxis$xlab, ylab = lstAxis$xlab, zlab = lstAxis$zlab,
# #  xlim = range( c(-10,10) ), ylim = range( c(-10,10) ),
#   col = "green",
#   ticktype = "detailed"
# )