CONVERT_TO_INTEGER(RX_NUM_UNFMTTED_HX, 1, 1, 0)

-- column names only
select '"' || COLUMN_NAME || '"' || ',' as line
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Marketing.Facebook'
ANd Table_Name = 'PostInsights'

-- column names and data types
select 
    Table_Name as EntityName
    ,'' as EntityNameDMCompletes
    ,COLUMN_NAME As AttributeName
    ,'' AS ColumnDescription
    ,'' As AttributeWithExamples
    ,'' As ColumnNameDMCompletes
    ,Case 
    when Data_Type = 'CHARACTER VARYING' then 'String'
    when Data_Type = 'DECIMAL' then 'Float'
    when Data_Type = 'BIGINT' then 'Integer'
    when Data_Type In ('DATE', 'TIMESTAMP') then 'Date'
    Else Data_Type End
    as DataType
    ,'' As CaboodleColumnName
    ,'' As AttributeSource
    ,'' as PrimaryKeyTrueFalse
from INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = '{}'
    ANd Table_Name = '{}'
Order by Ordinal_Position