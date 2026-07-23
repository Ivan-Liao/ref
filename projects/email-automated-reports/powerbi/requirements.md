- [Daily Orders Email CSV Report](#daily-orders-email-csv-report)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Requirements](#40-requirements)
- [4.1 Out of scope](#41-out-of-scope)
- [5.0 Architecture](#50-architecture)
- [6.0 References](#60-references)

# Daily Orders Email CSV Report

# 1.0 Overview
Unfulfilled orders are defined as orders with reason codes that in general map to `Orders Fulfilled = No` in [Reason Code Mapping](https://zevacor365.sharepoint.com/:x:/r/sites/BI/_layouts/15/Doc.aspx?sourcedoc=%7B6CEB8972-8FB2-4BD1-9171-5A159517ECDC%7D&file=Reason%20Codes%20Mapping%20for%20Operations%20and%20Sales%26Billing.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1). The exact list of reason codes included is in 4.0.2. Unfulfilled orders are a pain point with clients. We want to facilitate a process to proactively take action or provide visibility when unfulfilled orders happen.

We will be constrained by data readily available in Power BI. Data is also dependent on reliability of Azure Synapse data warehousing process and Power BI Service. Email attachment size may be limited to 35 MB. PHI and PII are not part of this dataset.

# 2.0 Objectives
We want to address this issue in a timely manner based on the reason codes. 

# 3.0 Stakeholders
1. Clients affected by unfulfilled orders
2. Sofie Operations team
3. Sofie Sales team
4. Sofie BI team: Ivan Liao, Elangovan Srinivasan
5. Email list maintainer: Brad Stamp
6. Email recepients
   1. First pass testing: Brad.Stamp@sofie.com, william.crisp@sofie.com
   2. brian.schumer@sofie.com, Eric.Kroencke@sofie.com, joseph.cascone@sofie.com, malia.proskey@sofie.com, Mike.Parisi@sofie.com, Phyllis.Hoelsworth@sofie.com, Tim.Riemen@sofie.com
   3. Operations team: Distro-Pharmacy-Managers@sofie.com
   4.  Sales team: **TODO** NESalesTeam@sofie.com?

# 4.0 Requirements
1. Daily email to designated email list at 6 am EST
   1. **TODO** which days? Tues - Sun?
2. Filters only for the following reason codes: 300, 310, 320, 340, 370, 220, 230, 240, 250, 270, 500, 510, 520
3. Filters by `Cal Date = Previous Day's Date`.  
4. Attached csv with the following fields
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

# 4.1 Out of scope
1. Filters by `Cal Date = Previous Day's Date` or `LastModified = Previous Day's Date`.  This is needed because sometimes Credit Order Reason codes will be updated after days after the Cal Date.
   1. Currently Browser based paginated report builder lacks complex filtering capability.  Will retry as soon as desktop version is installed.
2. Templated email message potentially with Product, Pharmacy, Client, Order Date, Cal Date, Reason, or additional fields. 
3. Out of scope fields
   1. Procedure Name ... due to semantic model issue
   2. Procedure Description ... due to semantic model issue
   3. Route Name ... not useful in current state
   4. Route Description .... not useful in current state

# 5.0 Architecture
1. [Link to architecture diagram](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=CSV%20Automated%20Emails%20for%20Unfulfilled%20Orders&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D186-DBOhJdZMVcRPczB89Of2NXASOqNBR%26export%3Ddownload#%7B%22pageId%22%3A%22L0mPaQPRMhuCCB-t4P-Q%22%7D)

# 6.0 References
1. [Link to Reason Code Mapping](https://zevacor365.sharepoint.com/:x:/r/sites/BI/_layouts/15/Doc.aspx?sourcedoc=%7B6CEB8972-8FB2-4BD1-9171-5A159517ECDC%7D&file=Reason%20Codes%20Mapping%20for%20Operations%20and%20Sales%26Billing.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1)
2. [Link to BI Sharepoint documentation](https://zevacor365.sharepoint.com/sites/BI)

