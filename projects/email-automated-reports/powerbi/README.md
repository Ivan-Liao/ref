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
2. Aggregate or deselect summarization
3. Create parameter on dynamic value to filter data by like date
4. Save in a power bi premium workspace that houses the semantic model

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
  "Pharmacy": @{split(item(), ',')[0]},
  "Product": @{split(item(), ',')[1]},
  "Rx ID": @{split(item(), ',')[2]},
  "Lot Number": @{split(item(), ',')[3]},
  "Not Fulfilled": @{split(item(), ',')[4]},
  "Redirected Orders": @{split(item(), ',')[5]},
  "MultiDose Bulk": @{split(item(), ',')[6]},
  "Reason Code": @{split(item(), ',')[7]},
  "Reason": @{split(item(), ',')[8]},
  "Client Name": @{split(item(), ',')[9]},
  "Order Date": @{split(item(), ',')[10]},
  "Order Time": @{split(item(), ',')[11]},
  "Calibration Date": @{split(item(), ',')[12]},
  "Calibration Time": @{split(item(), ',')[13]},
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