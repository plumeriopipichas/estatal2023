setwd("/home/FedericoYU/Documentos/Chamba/Olimpiada/Estatal 2023/estatal2023_Rproject/")

library(dplyr)
library(readr)
library(stringr)

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
### se hicieron las portadas. 

# asistencia_oficial<-list()
# path<-"../listas_generadas/participacion_oficial/asistencia/"
# m<-nchar(dir(path))
# sedes <- substr(dir(path),18,m-4)
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


#-------------- agregar los registros extras y los que tienen cambios en 
# la clave

print(c("antes",nrow(lista_general_participacion)))
lista_general_participacion <-rbind(lista_general_participacion,
          read.csv("../listas_crudas/modificados_y_extras.csv"))
print(c("despues",nrow(lista_general_participacion)))

#-------------un poco de limpiez a la lista general ----------

x<-which(lista_general_participacion$Nombre=="")
lista_general_participacion <- lista_general_participacion[-x, ]
lista_general_participacion$Primer_apellido<-
  limpiar(lista_general_participacion$Primer_apellido)
lista_general_participacion$Segundo_apellido<-
  limpiar(lista_general_participacion$Segundo_apellido)
lista_general_participacion$Nombre<-
  limpiar(lista_general_participacion$Nombre)


#---------- para las constancias de entrenadores ----------

entrenadores_sedes <-list()
path<-"../listas_crudas/entrenadores"
m<-nchar(dir(path))
sedes <- substr(dir(path),14,m-4)
for (sede in sedes){
  x<-grep(sede,dir(path))
  entrenadores_sedes[[sede]]<-read.csv(
    paste(path,"/",dir(path)[x],sep=""))
  entrenadores_sedes[[sede]]$sede<-sede
  print(c("entrenadores",sede))
  print(dim(entrenadores_sedes[[sede]]))
}

lista_entrenadores<-juntar_bases(entrenadores_sedes)
lista_entrenadores$Institucion<-subte(lista_entrenadores$Institucion)
lista_entrenadores$Nombre<-notitle(lista_entrenadores$Nombre)
lista_entrenadores$Nombre<-limpiar(lista_entrenadores$Nombre)
lista_entrenadores<-unique(lista_entrenadores)

write.csv(lista_entrenadores,"../listas_generadas/lista_entrenadores.csv",row.names = FALSE)
rm(entrenadores_sedes)

#----------Depurar listas con las respuestas

respuestas_sedes<-list()  #donde se guardaran las respuestas por sede, 
#depuradas, sin mas datos
sin_registro<-list() #donde se guardaran las claves que no aparecen 
#en la lista del registro

vars <- c("Identificacion","Aciertos")
nr <- 12

for (i in 1:12){
  temp <- paste("Resp_",as.character(i),sep="")
  vars<-c(vars,temp)
}

for (sede in sedes[c(1:8,11:15)]){
  print(c("jojo",sede))
  path <- paste("../listas_crudas/respuestas_examen/",
                sede,"2023.csv", sep="")
  respuestas_sedes[[sede]]<-read.csv(path)%>%
    select(all_of(vars))%>%
    unique()
  path <- paste("../listas_generadas/respuestas_depuradas/",sede,
    "_resp2023.csv",sep="")
  write.csv(respuestas_sedes[[sede]],path,row.names = FALSE)
  x<-which(respuestas_sedes[[sede]]$Identificacion%in%
             lista_general_participacion$clave)
  if (length(x)<nrow(respuestas_sedes[[sede]])){
    sin_registro[[sede]]<-respuestas_sedes[[sede]][-x, ]
    sin_registro[[sede]]$sede<-sede
  }
}

sin_registro_todos <- juntar_bases(sin_registro)
respuestas_examen <- juntar_bases(respuestas_sedes)


write.csv(sin_registro_todos,"../listas_generadas/
          examenes_sin_registro.csv",row.names = FALSE)


rm(i,m,nr,path,sede,temp,x)