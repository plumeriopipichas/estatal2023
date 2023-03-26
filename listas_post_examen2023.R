setwd("/home/FedericoYU/Documentos/Chamba/Olimpiada/Estatal 2023/estatal2023_Rproject/")

library(dplyr)
library(readr)

source("funciones_adhoc.R")

###-------Hacer la lista general de participacion

basica_sedes_oficial<-list()
path<-"../listas_generadas/participacion_oficial/basica/"
m<-nchar(dir(path))
sedes <- substr(dir(path),14,m-4)
for (sede in sedes){
  x<-grep(sede,dir(path))
  basica_sedes_oficial[[sede]]<-read.csv(
    paste(path,dir(path)[x],sep=""))
  print(dim(basica_sedes_oficial[[sede]]))
}

lista_general_participacion<-juntar_bases(basica_sedes_oficial)
lista_general_participacion$Escuela<-
  subte(lista_general_participacion$Escuela)

###---------- Cotejar las claves con la lista de asistencia de donde
### se hicieron las portadas

# asistencia_oficial<-list()
# path<-"../listas_generadas/participacion_oficial/asistencia/"
# m<-nchar(dir(path))
# sedes <- substr(dir(path),14,m-4)
# for (sede in sedes){
#   x<-grep(sede,dir(path))
#   asistencia_oficial[[sede]]<-read.csv(
#     paste(path,dir(path)[x],sep=""))
#   print(dim(asistencia_oficial[[sede]]))
# }
# 
# asistencia<-juntar_bases(asistencia_oficial)
# 
# distintos <- character()
# repetidas <- character()
# ausentes <- character()
# 
# for (clave in asistencia$clave[1:5]){
#   x <- which(lista_general_participacion$clave==clave)
#   y <- which(asistencia$clave==clave)
#   if (!asistencia$Nombre[x]==lista_general_participacion$Nombre[x]){
#     distintos<-c(distintos,clave)    
#   }
#   if (length(x)==0){
#     ausentes <- c(ausentes,clave)
#   }
#   if (length(x)>1){
#     repetidas<-c(repetidas,clave)
#   }
# }



rm(clave,m,path,x,y)