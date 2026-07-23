- [Power BI Paginated Report Creation](#power-bi-paginated-report-creation)
- [Power Automate](#power-automate)
  - [Recurrance](#recurrance)
  - [Export To File for Paginated Reports](#export-to-file-for-paginated-reports)
  - [Compose](#compose)
  - [Filter array](#filter-array)
  - [Select](#select)
  - [Create CSV table](#create-csv-table)
  - [Send an email (V2)](#send-an-email-v2)
- [References](#references)

# Power BI Paginated Report Creation
1. Select fields
```
   1. Rx ID
   2. Pharmacy
   3. Product
   4. Client
   5. Reason Code
   6. Reason
   7. Lot Number
   8. Multidose order flag
   9. Redirected order flag 
   10. Dose
   11. Cal Date
   12. Cal Time
   13. Order Date
   14. Order Time
   15. Filled Date
   16. Filled Time
   17. Packed Date
   18. Packed Time
   19. Shipped Date
   20. Shipped Time
   21. Delivery Date
   22. Delivery Time
```
2. Aggregate or deselect summarization
3. Create parameter on dynamic value to filter data like date
4. Filter by reason codes
5. Save in a power bi premium workspace that houses the semantic model

# Power Automate
## Recurrance
## Export To File for Paginated Reports
1. Export Format
   1. CSV, PDF, PPTX, etc.
2. ParameterValues.Name
   1. `Param_<table_name>_<field_name>`
   2. note that underscores are escaped using its hex ASCII code _5F_, example: `Param_f_5f_ordered_CalibrationDate`
3. ParameterValues.Value
   1. example: `formatDateTime(addDays(utcNow(), -1), 'yyyy-MM-dd')`

## Compose
1. `split(replace(outputs('Get_File_Content')?['body'], decodeUriComponent('%0D'), ''), decodeUriComponent('%0A'))`

## Filter array
1. `skip(outputs('Compose'), 1)`
2. Filter Query
   1. Current item
   2. is not equal to
   3. *Blank*

## Select
1. From
   1. Filter array dynamic content Body
2. Map
```
# format is "<new column name>": @{split(itm(), ',')[0]} where 0 is the order of column
{
  "Rx ID": @{split(item(), ',')[0]},
  "Pharmacy": @{split(item(), ',')[1]},
  "Product": @{split(item(), ',')[2]},
  "Client Name": @{split(item(), ',')[3]},
  "Reason Code": @{split(item(), ',')[4]},
  "Reason": @{split(item(), ',')[5]},
  "Lot Number": @{split(item(), ',')[6]},
  "MultiDose Bulk": @{split(item(), ',')[7]},
  "Redirected Orders": @{split(item(), ',')[8]},
  "Dose": @{split(item(), ',')[9]},
  "Calibration Date": @{split(item(), ',')[10]},
  "Calibration Time": @{split(item(), ',')[11]},
  "Order Date": @{split(item(), ',')[12]},
  "Order Time": @{split(item(), ',')[13]},
  "Filled Date": @{split(item(), ',')[14]},
  "Filled Time": @{split(item(), ',')[15]},
  "Packed Date": @{split(item(), ',')[16]},
  "Packed Time": @{split(item(), ',')[17]},
  "Shipped Date": @{split(item(), ',')[18]},
  "Shipped Time": @{split(item(), ',')[19]},
  "Delivered Date": @{split(item(), ',')[20]},
  "DeliveredTime": @{split(item(), ',')[21]}
}
```

## Create CSV table
1. From
   1. Select Output

## Send an email (V2)
1. To
   1. List of email addresses
2. Subject
3. Body
4. Attachments.Name 
   1. data.csv
   2. concat('unfulfilled_orders_', formatDateTime(addDays(utcNow(), -1), 'yyyy-MM-dd'), '.csv')
5. Attachments.Content 
   1. Search for dynamic content (output of previous block)


# References
1. It is possible to pass in a variable to the parameters field of the Export to File action
   1. Used with button power automate button with filters already established in Power BI
   2. https://youtu.be/FrY4O2Qs5bI?si=fCtWEODBD8EtdhJI 