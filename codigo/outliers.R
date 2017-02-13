##############################################################################################
#
#                             Transparentar
#
#                            Este scrip analiza los datos que reportan los buques de pesca
###############################################################################################


###############################################################################################
#                           Importamos los datos. 
###############################################################################################
# Todo es un csv con las declaraciones de pesca de los buques
todo <- read.table("todo.csv", header=T, quote="\"")
#cambiamos a formato fecha
todo$Fecha.de.Desembarque = as.Date(Fecha.de.Desembarque,format="%d/%m/%Y") 
todo$Fecha.de.Zarpada = as.Date(Fecha.de.Zarpada,format="%d/%m/%Y")
attach(todo)


###############################################################################################
#                           RE tiene, en cada fila, el nombre del cuadrante
#                           y la cantidad de especies que alli se pescaron (en total)
###############################################################################################
rectangulos = levels(Rectangulo)
RE = matrix(NA,ncol=1,nrow=length(rectangulos))
rownames(RE)=rectangulos
for (i in 1:length(rectangulos)){
  rec = rectangulos[i]
  datos = todo[Rectangulo==rec,]
  RE[i,1] = as.numeric(length(levels(as.factor(union(datos$Especie,c())))))
}

###############################################################################################
# Nos quedamos con los cuadrantes en los que  cant de reportes/ cant de especies que se pescan >10,
# es decir, aprox tenemos al menos 10 datos de lo que se pesco de cada especie en ese cuadrante
###############################################################################################
aux = as.matrix(sort(table(Rectangulo))) # cantidad de reportes por rectangulo
aux2 = aux/RE[rownames(sort(table(Rectangulo))),1]
aux3 = aux2[order(aux2),1]
cuadrantes = names(aux3[aux3>10])

###############################################################################################
# Calculamos el riesgo cada cuadrante de los seleccionados en el item anterior
###############################################################################################
lim = 1.96
path = "/home/yamila/repos/transparentar/resultados/graficosVarios/"
riesgo = rep(NA,length(cuadrantes))
names(riesgo) = cuadrantes
for(cuad in cuadrantes){

  datosposta = todo[Rectangulo==cuad,]
  
  # sum(table(datosposta$Especie)>0) # cant de especies
  # sum(table(datosposta$Buque)>0) # cant de buques buques
  
  species = levels(Especie)[table(datosposta$Especie)>0]
  buques = levels(Buque)[table(datosposta$Buque)>0]
  
  # vec es una matrix de dimension cantidad_especies x cant_buques
  # vec[i,j] = cant de kilos que pesco de la especie i el buque j
  vec = matrix(0,nrow=length(species),ncol=length(buques),dimnames=list(species,buques))
  for(i in 1:nrow(datosposta)){
    vec[as.character(datosposta[i,"Especie"]),as.character(datosposta[i,"Buque"])]= as.numeric(datosposta[i,"Kilos"])
  }
  
  png(paste0(path,cuad,".png"), width = 1000, height=1000)
  boxplot(t(vec),las=2, cex.axis=0.5)
  dev.off()
  
  
  ############Sigmas######################
  sdvec=apply(vec,1,sd)
  muvec=apply(vec,1,mean)
  z=(vec-muvec)/sdvec
  
  # riesgo[cuad] = proporcion de buques con al menos una mentira en ese cuadrante
  # una mentira es un dato que con proba 0.95 deberia ser otro
  riesgo[cuad]=100*sum(colSums(z<(-lim) | z>lim)>0)/ncol(vec) #ncol(vec) = cant de buques en ese cuadrante
}

###############################################################################################
# Convertimos el formato riesgo a mat3mart, la matriz que sera usada en el script python para graficar
##############################################################################################

mat2mart=matrix(NA,nrow=length(cuadrantes),ncol=3,dimnames=list(cuadrantes,c("latitud","longitud","riesgo")))
mat2mart[,"riesgo"]=riesgo

for (cuad in cuadrantes){
  mat2mart[cuad,c("latitud","longitud")] = as.matrix(todo[Rectangulo==cuad,c("RecLat","RecLon")][1,])
}
mat2mart[,1] = as.numeric(gsub(",",".",mat2mart[,1]))
mat2mart[,2] = as.numeric(gsub(",",".",mat2mart[,2]))
mat2mart[,3] = as.numeric(mat2mart[,3])/100

write.table(mat2mart,"mat2mart.csv",quote=FALSE,sep=";",row.names=TRUE)
