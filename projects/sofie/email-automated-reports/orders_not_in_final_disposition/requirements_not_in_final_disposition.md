- [Orders not in Final Disposition (daily email csv report)](#orders-not-in-final-disposition-daily-email-csv-report)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Technical Requirements](#40-technical-requirements)
- [4.1 Out of scope](#41-out-of-scope)
- [5.0 Architecture](#50-architecture)
- [6.0 Next Steps](#60-next-steps)
- [7.0 References](#70-references)
- [8.0 Change Log](#80-change-log)

# Orders not in Final Disposition (daily email csv report)

# 1.0 Overview
Orders not in final disposition are defined as orders in the past 2 weeks that have not been shipped and have not been cancelled / deleted. The specific order statuses should are listed below...
- Filled
- Redirected Received Filled
- Redirected Received Unfilled
- Redirected Sent Cancelled Unfilled
- Redirected Sent Cancelled Filled
- Redirected Sent Shipping Cancelled
- Redirected Sent Filled
- Redirected Sent Unfilled
- Unfilled

These orders indicate issues in the system that should be addressed at 4 pm EST before the end of the business day. 

Email attachment size may be limited to 35 MB. PHI and PII are not part of this dataset.

# 2.0 Objectives
We want an email sent at 4 pm EST daily with a csv attachment containing the orders not in final disposition.

# 3.0 Stakeholders
1. Clients affected by orders not in final disposition
2. Sofie Operations team
3. Sofie BI team: Ivan Liao, Elangovan Srinivasan
4. Email list maintainer: Ivan Liao
5. Email recipients
   1. Operations team: "William Crisp" <william.crisp@sofie.com>; "Jerrod Brown" <jerrod.brown@sofie.com>; "Casey Melby" <casey.melby@sofie.com>; "Micah Bounds" <Micah.Bounds@sofie.com>; "Andrea Tremblay" <Andrea.Tremblay@sofie.com>; "Eric Kroencke" <Eric.Kroencke@sofie.com>; "Elangovan Srinivasan" <elangovan.srinivasan@sofie.com>; "Distro-Pharmacy-Managers" <Distro-Pharmacy-Managers@sofie.com>;

# 4.0 Technical Requirements
1. Daily email to designated email list at 4 pm EST.  Covers past 2 weeks of orders.
3. Filters by `Cal Date = <2 weeks ago to today>` AND `PackedDate IS NULL` AND `Reason code IS NULL` AND `Filled <> 2`
   1. PackDate is used because this is the Shipping Date displayed in BioRx
   2. Filled is filtered out for 2 to filter out Redirected Sent Shipped orders
4. Attached csv with the following fields
   1. Rx ID
   2. Pharmacy
   3. Product
   4. Client
   5. Cal Date
   6. Cal Time
   7. Order Type
   8. FilledDate
   9. ShipDate

# 4.1 Out of scope

# 5.0 Architecture
1. Manual process ... SQL client > SQL query > CSV file export > Rename and attach then email

# 6.0 Next Steps
1. Biorx real time setup and automation

# 7.0 References
1. Biorx order status transition flowchart ([link](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&dark=auto#G1XBU1yV6Zvagh8fJKWV4DSWl5y7suk-l-))
2. Biorx order status definitions spreadsheet ([link](https://zevacor365.sharepoint.com/:x:/s/BI/IQAE3Y4M9OxNTpllrJ0XENAuAdSpsKUkajiz95bE8_O6q_w?e=YONpwh))

# 8.0 Change Log
1. Added additional fields 
   1. FilledDate  
   2. ShipDate
2. Filters were adjusted to only allow orders that were not in final disposition.
   1. Filled
   2. Redirected Received Filled
   3. Redirected Received Unfilled
   4. Redirected Sent Cancelled Unfilled (same as orders that require attention's "Redirected Cancelled")
   5. Redirected Sent Cancelled Filled (same as orders that require attention's "Redirected Cancelled")
   6. Redirected Sent Shipping Cancelled (same as orders that require attention's "Redirected Shipped Cancelled")
   7. Redirected Sent Filled
   8. Redirected Sent Unfilled
   9. Unfilled
   