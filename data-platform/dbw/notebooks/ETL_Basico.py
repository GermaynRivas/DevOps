# Databricks notebook source
pip install pyodbc

# COMMAND ----------

### Borra punto de conexión creado
mount_point = "/mnt/bronce"
dbutils.fs.unmount(mount_point)

# COMMAND ----------

nsecretos = dbutils.secrets.listScopes()

for secreto in nsecretos:
  print(secreto.name)

# COMMAND ----------

dataLakeName=dbutils.secrets.get(scope = "secretos", key = "dataLakeName")
KeydataLakeName=dbutils.secrets.get(scope = "secretos", key = "KeydataLakeName")
#Montaje Rapido para pruebas
storage="/mnt/bronce" # variable path interno dentro del dbfs
try:
  dbutils.fs.mount(
  source = "wasbs://bronce@"+dataLakeName+".blob.core.windows.net//", #ruta del blob storage
  mount_point = storage,
  extra_configs ={ "fs.azure.account.key."+dataLakeName+".blob.core.windows.net":KeydataLakeName}
  )
except Exception as e:
  if "Directory already mounted" in str(e):
    pass
  else:
    raise e
print("Success.")

# COMMAND ----------

# MAGIC %fs ls /mnt/bronce

# COMMAND ----------

import pandas as pd
import numpy as np


file_location = "/dbfs/mnt/bronce/Alumnos.csv"
dfp = pd.read_csv(file_location,header='infer')
print(dfp)

# COMMAND ----------

dfp['valormatricula'] = dfp["skAlumno"] * 2
dfa=[dfp[['idAlumno','tipoDocumento','numeroDocumento','apellido1','apellido2','nombre1',	'nombre2','direccion','codMunicipio','telefono',	'email','fechaNacimiento','codMunicipioNac','codGenero','codEstrato','codSisben','valormatricula']]]
dfa = dfa[0]
dfa = dfa.fillna('')
print(dfa)

# COMMAND ----------

#Montaje Rapido para pruebas
storage="/mnt/plata" # variable path interno dentro del dbfs
try:
  dbutils.fs.mount(
  source = "wasbs://plata@"+dataLakeName+".blob.core.windows.net//", #ruta del blob storage
  mount_point = storage,
  extra_configs ={ "fs.azure.account.key."+dataLakeName+".blob.core.windows.net":KeydataLakeName}
  )
except Exception as e:
  if "Directory already mounted" in str(e):
    pass
  else:
    raise e
print("Success.")

# COMMAND ----------

# MAGIC %fs ls /mnt/plata

# COMMAND ----------

import pandas as pd
import numpy as np
file_location = "/dbfs/mnt/plata/Datoscurados.csv"
dfa.to_csv(file_location)
