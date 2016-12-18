lim = 1.96


todo <- read.table("todo.csv", header=T, quote="\"")
attach(todo)

todo$Fecha.de.Desembarque = as.Date(Fecha.de.Desembarque,format="%d/%m/%Y") #cambia a formato fecha
todo$Fecha.de.Zarpada = as.Date(Fecha.de.Zarpada,format="%d/%m/%Y")
attach(todo)

rectangulos = levels(Rectangulo)
RE = matrix(NA,ncol=1,nrow=length(rectangulos))
rownames(RE)=rectangulos
for (i in 1:length(rectangulos)){
  rec = rectangulos[i]
  datos = todo[Rectangulo==rec,]
  RE[i,1] = as.numeric(length(levels(as.factor(union(datos$Especie,c())))))
}


aux = as.matrix(sort(table(Rectangulo)))
aux2 = aux/RE[rownames(sort(table(Rectangulo))),1]
aux3 = aux2[order(aux2),1]
cuadrantes = names(aux3[aux3>10])

riesgo = rep(NA,length(cuadrantes))
names(riesgo) = cuadrantes
for(cuad in cuadrantes){

  datosposta = todo[Rectangulo==cuad,]
  
  sum(table(datosposta$Especie)>0) #24 especies
  sum(table(datosposta$Buque)>0) #36 buques
  
  species = levels(Especie)[table(datosposta$Especie)>0]
  buques = levels(Buque)[table(datosposta$Buque)>0]
  vec = matrix(0,nrow=length(species),ncol=length(buques),dimnames=list(species,buques))
  
  for(i in 1:nrow(datosposta)){
    vec[as.character(datosposta[i,"Especie"]),as.character(datosposta[i,"Buque"])]= as.numeric(datosposta[i,"Kilos"])
  }
  
  png(paste0("/home/yamila/Escritorio/HackatonAgro/graficos/boxplotCuadrante",cuad,".png"), width = 1000, height=1000)
  boxplot(t(vec),las=2, cex.axis=0.5)
  dev.off()
  
  
  ############Sigmas######################
  sdvec=apply(vec,1,sd)
  muvec=apply(vec,1,mean)
  z=(vec-muvec)/sdvec
  
  riesgo[cuad]=100*sum(colSums(z<(-lim) | z>lim)>0)/ncol(vec)
}

mat2mart=matrix(NA,nrow=length(cuadrantes),ncol=3,dimnames=list(cuadrantes,c("latitud","longitud","riesgo")))
mat2mart[,"riesgo"]=riesgo
for (cuad in cuadrantes){
  mat2mart[cuad,c("latitud","longitud")] = as.matrix(todo[Rectangulo==cuad,c("RecLat","RecLon")][1,])
}
mat2mart[,1] = as.numeric(gsub(",",".",mat2mart[,1]))
mat2mart[,2] = as.numeric(gsub(",",".",mat2mart[,2]))
mat2mart[,3] = as.numeric(mat2mart[,3])/100

write.table(mat2mart,"mat2mart.csv",quote=FALSE,sep=";",row.names=TRUE)
