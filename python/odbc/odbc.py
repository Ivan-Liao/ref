"""
using pd.read_sql_query
"""
import pyodbc
import pandas as pd
import json

with open("H:\\secrets.json") as f:
    secrets = json.load(f)
host = "dremtstent"
port = 31010
uid = ""
pwd = ''
driver = "Dremio Connector"

conn = pyodbc.connect(
    "Driver={}; ConnectionType=Direct; HOST={}; PORT={}; AuthenticationType=Plain; UID={}; PWD={}".format(
        driver, host, port, uid, pwd
    ),
    autocommit=True,
)


print("Successfully connected to Dremio")

df = pd.read_sql_query(
    """
    select *
    from EnterpriseData.InformationServices.BacklogProjects
    FETCH FIRST 5 ROWS ONLY
    """,
    conn,
)
print(df)


"""
using cursor
"""
import pyodbc
import json

with open("H:\\secrets.json") as f:
    secrets = json.load(f)

host = "dremtstent"
port = 31010
uid = ""
pwd = ''
driver = "Dremio Connector"

conn = pyodbc.connect(
    "Driver={}; ConnectionType=Direct; HOST={}; PORT={}; AuthenticationType=Plain; UID={}; PWD={}".format(
        driver, host, port, uid, pwd
    ),
    autocommit=True,
)


print("Successfully connected to Dremio")

cursor = conn.cursor()

row_list = cursor.execute(
    """
    select *
    from EnterpriseData.InformationServices.BacklogProjects
    FETCH FIRST 5 ROWS ONLY
    """
)

for row in row_list:
    print(row)
