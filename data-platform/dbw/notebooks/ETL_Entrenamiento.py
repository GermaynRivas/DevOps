# Databricks notebook source
pip install pyodbc

# COMMAND ----------

# MAGIC %fs ls /mnt/plata

# COMMAND ----------

import pandas as pd
import numpy as np

file_location = "/dbfs/mnt/plata/Datoscurados.csv"
dfp = pd.read_csv(file_location,header='infer')
print(dfp)

# COMMAND ----------

dfa=[dfp[['idAlumno','tipoDocumento','numeroDocumento','apellido1','nombre1','codMunicipio','fechaNacimiento','codMunicipioNac','codGenero','codEstrato','codSisben','valormatricula']]]
dfa = dfa[0]
dfa = dfa.fillna('')
print(dfa)

# COMMAND ----------

dataLakeName=dbutils.secrets.get(scope = "secretos", key = "dataLakeName")
KeydataLakeName=dbutils.secrets.get(scope = "secretos", key = "KeydataLakeName")
#Montaje Rapido para pruebas
storage="/mnt/oro" # variable path interno dentro del dbfs
try:
  dbutils.fs.mount(
  source = "wasbs://oro@"+dataLakeName+".blob.core.windows.net//", #ruta del blob storage
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

# MAGIC %fs ls /mnt/oro

# COMMAND ----------

#ALMACENAMIENTO EN CONTENEDOR ORO
import pandas as pd
import numpy as np
file_location = "/dbfs/mnt/oro/DatosML.csv"
dfa.to_csv(file_location)

# COMMAND ----------

#ALMACENAMIENTO EN SQLDB
import pandas as pd 
import pyodbc

server = 'tcp:sql-lab-dev.database.windows.net' 
database = 'sqldb-lab-dev' 
username = 'adminuser' 
password = dbutils.secrets.get(scope = "secretos", key = "sqldb-lab-dev")

# COMMAND ----------

# MAGIC %sh
# MAGIC curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# MAGIC curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
# MAGIC sudo apt-get update
# MAGIC sudo ACCEPT_EULA=Y apt-get -q -y install msodbcsql17

# COMMAND ----------

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

# COMMAND ----------

cursor = cnxn.cursor()
for index, row in dfa.iterrows():
    #Sample insert query
    print(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11])
    cursor.execute("INSERT INTO [dbo].[alumnos](idAlumno,tipoDocumento,numeroDocumento,apellido1,nombre1,codMunicipio,fechaNacimiento,codMunicipioNac,codGenero,codEstrato,codSisben,valormatricula) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11])
    
cnxn.commit()
