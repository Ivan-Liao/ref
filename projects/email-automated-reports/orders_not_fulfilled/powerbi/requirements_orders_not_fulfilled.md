- [Order not Fulfilled (daily email csv report)](#order-not-fulfilled-daily-email-csv-report)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Requirements](#40-requirements)
- [4.1 Out of scope](#41-out-of-scope)
- [5.0 Architecture](#50-architecture)
- [6.0 References](#60-references)
- [7.0 Next Steps](#70-next-steps)
- [8.0 Changlog](#80-changlog)
  - [2026-08-12](#2026-08-12)

# Order not Fulfilled (daily email csv report)

# 1.0 Overview
Unfulfilled orders are a pain point with clients. We want to facilitate a process to proactively take action or provide visibility when unfulfilled orders happen.

Unfulfilled orders are defined as orders with reason codes that in general map to `Orders Fulfilled = No` in [Reason Code Mapping](https://zevacor365.sharepoint.com/:x:/r/sites/BI/_layouts/15/Doc.aspx?sourcedoc=%7B6CEB8972-8FB2-4BD1-9171-5A159517ECDC%7D&file=Reason%20Codes%20Mapping%20for%20Operations%20and%20Sales%26Billing.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1). The exact list of reason codes included is in 4.0.2. 

We will be constrained by data readily available in Power BI. Data is also dependent on reliability of Azure Synapse data warehousing process and Power BI Service. Email attachment size may be limited to 35 MB. PHI and PII are not part of this dataset.

# 2.0 Objectives
We want to address the issue of unfulfilled orders in a timely manner based on the reason codes. 

# 3.0 Stakeholders
1. Clients affected by unfulfilled orders
2. Sofie Operations team
3. Sofie Sales team
4. Sofie BI team: Ivan Liao, Elangovan Srinivasan
5. Email list maintainer: Ivan Liao
6. Email list
   1.  "Brad Stamp" <Brad.Stamp@sofie.com>; "William Crisp" <william.crisp@sofie.com>; "Elangovan Srinivasan" <elangovan.srinivasan@sofie.com>; "Jerrod Brown" <jerrod.brown@sofie.com>; "Casey Melby" <casey.melby@sofie.com>; "Micah Bounds" <Micah.Bounds@sofie.com>; "Andrea Tremblay" <Andrea.Tremblay@sofie.com>; "Nasrin Pourkiani" <Nasrin.Pourkiani@sofie.com>; "Distro-Pharmacy-Managers" <Distro-Pharmacy-Managers@sofie.com>; "Brian Schumer" <brian.schumer@sofie.com>; Eric.Kroencke@sofie.com; "Mike Parisi" <Mike.Parisi@sofie.com>; Phyllis.Hoelsworth@sofie.com; Tim.Riemen@sofie.com
   2.  Sales team: Distro-Sales@sofie.com?

# 4.0 Requirements
1. Daily email to designated email list at 6 am EST
2. Filters only for the following reason codes: 300, 310, 320, 340, 370, 220, 230, 240, 250, 270, 500, 510, 520
3. Filters by `Cal Date = Previous Day's Date`.  
4. Attached csv with the following fields
   1. Rx ID
   2. Pharmacy
   3. Product
   4. Procedure
   5. Client
   6. Reason Code
   7. Reason
   8. Lot Number
   9. Multidose order flag
   10. Redirected order flag 
   11. Dose Activity
   12. Cal Date
   13. Cal Time
   14. Order Date
   15. Order Time
   16. Filled Date
   17. Filled Time
   18. Packed Date
   19. Packed Time
   20. Shipped Date
   21. Shipped Time
   22. Delivery Date
   23. Delivery Time

# 4.1 Out of scope
1. Out of scope fields
   1. Route Name - not useful in current state
   2. Route Description - not useful in current state

# 5.0 Architecture
1. [Link to architecture diagram 2.0](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=CSV%20Automated%20Emails%20for%20Unfulfilled%20Orders&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D186-DBOhJdZMVcRPczB89Of2NXASOqNBR%26export%3Ddownload#%7B%22pageId%22%3A%22L0mPaQPRMhuCCB-t4P-Q%22%7D)

# 6.0 References
1. [Link to Reason Code Mapping](https://zevacor365.sharepoint.com/:x:/r/sites/BI/_layouts/15/Doc.aspx?sourcedoc=%7B6CEB8972-8FB2-4BD1-9171-5A159517ECDC%7D&file=Reason%20Codes%20Mapping%20for%20Operations%20and%20Sales%26Billing.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1)
2. [Link to BI Sharepoint documentation](https://zevacor365.sharepoint.com/sites/BI/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FBI%2FShared%20Documents%2FBIoRx%20email%20and%20Real%20time%20reports%2Frequirements%5Forders%5Fnot%5Ffulfilled%2Emd&parent=%2Fsites%2FBI%2FShared%20Documents%2FBIoRx%20email%20and%20Real%20time%20reports)
3. About 10-20 orders with past calibration dates will have altered reason codes per day.

# 7.0 Next Steps
1. Automated pipeline with Azure Synapse pipeline and Logic app.  The same developed SQL query will be used.

# 8.0 Changlog

## 2026-08-12
1. Orders with reason code 220 (SOFIE Cancelled - Order Entry Error / Duplicate Order) will now be added.  Previously the PowerBI report had filtered these out.
2. Additional orders with calibration dates in the past two weeks have been added. These orders have had their reason code updated on the previous day to one of the reason codes that we track.
3. Archived architecture diagram v1.0
   1. [Link to architecture diagram](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=CSV%20Automated%20Emails%20for%20Unfulfilled%20Orders&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D186-DBOhJdZMVcRPczB89Of2NXASOqNBR%26export%3Ddownload#%7B%22pageId%22%3A%22L0mPaQPRMhuCCB-t4P-Q%22%7D)