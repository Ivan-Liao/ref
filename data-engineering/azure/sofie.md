# workspaces
1. main
   1. sofiesyndev1
2. sandbox
   1. sfedw-syn-hb01
3. Logic apps used by Luis

# P & L report
1. OLD Pipeline
   1. SAP 
   2. ETL 
      1. 6 logic apps 
      2. .NET code to push from SAP to Azure 
   3. Azure SQL Server
      1. Luis creates views
      2. SQL Server Management Studio 20
   4. BI
   5. Report Layer
   6. Power BI
2. New Pipeline
   1. SAP
   2. Synapse Spark Notebooks
      1. API call on 6 tables
      2. .NET on other tables not yet finished
      3. Parquet files ADLS2
      4. Delta tables
      5. Bronze > Silver > Gold > Gold Reporting

# TODO
1. Azure SQL
2. Synapse analytics sofiesyndev1