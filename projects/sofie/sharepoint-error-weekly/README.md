1. Recurrance
2. Compose DAX Query
```
EVALUATE
VAR WindowStart =
    DATE(@{formatDateTime(addDays(utcNow(),-7),'yyyy')},
         @{formatDateTime(addDays(utcNow(),-7),'MM')},
         @{formatDateTime(addDays(utcNow(),-7),'dd')})
VAR WindowEnd =
    DATE(@{formatDateTime(utcNow(),'yyyy')},
         @{formatDateTime(utcNow(),'MM')},
         @{formatDateTime(utcNow(),'dd')})
VAR Filtered =
    FILTER(
        'ExceptionandDiscrepencies',
        'ExceptionandDiscrepencies'[SourceSystem] = "SharePoint"
            && 'ExceptionandDiscrepencies'[Error Date] >= WindowStart
            && 'ExceptionandDiscrepencies'[Error Date] < WindowEnd
    )
RETURN
    SELECTCOLUMNS(
        Filtered,
        "Pharmacy",     'ExceptionandDiscrepencies'[Pharmacy Display Name],
        "ErrorDate",    FORMAT('ExceptionandDiscrepencies'[Error Date], "YYYY-MM-DD"),
        "Product",      'ExceptionandDiscrepencies'[Product_Display],
        "BatchNumber",  'ExceptionandDiscrepencies'[Batch Number],
        "ErrorType",    'ExceptionandDiscrepencies'[Error Type],
        "ErrorDetails", 'ExceptionandDiscrepencies'[Error Details]
    )
ORDER BY [Pharmacy], [ErrorDate]
```
3. Run Query
4. Condition True
   1. Select
      1. From: Run Query output
      2. Map: coalesce(item()?['[Pharmacy]'],'')
   2. Create CSV table
      1. From: Select output
   3. Send an email
5. Condition False
   1. Send an email