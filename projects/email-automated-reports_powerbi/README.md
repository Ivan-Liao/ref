# Power BI Paginated Report Creation
1. Select fields
2. Aggregate or deselect summarization
3. Save in a power bi premium workspace that houses the semantic model

# Power Automate
1. Recurrance
2. Export To File for Paginated Reports
```
Export Format: CSV, PDF, PPTX, etc.
ParameterValues:
  Name - 1: Param_<table_name>_<field_name>
# note that underscores are escaped using its hex ASCII code _5F_, example: Param_f_5f_ordered_CalibrationDate
```
3. Send an email (V2)
```
Attachments: 
  Name - 1: # like data.csv
  Content - 1: # Search for dynamic content (output of previous block)
```

# Testing


# References
1. It is possible to pass in a variable to the parameters field of the Export to File action
   1. Used with button power automate button with filters already established in Power BI
   2. https://youtu.be/FrY4O2Qs5bI?si=fCtWEODBD8EtdhJI 