- [Orders not in Final Disposition (daily email csv report)](#orders-not-in-final-disposition-daily-email-csv-report)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Technical Requirements](#40-technical-requirements)
- [4.1 Out of scope](#41-out-of-scope)
- [5.0 Architecture](#50-architecture)
- [6.0 References](#60-references)

# Orders not in Final Disposition (daily email csv report)

# 1.0 Overview
Orders not in final disposition are defined as orders in the past 2 weeks that have not been shipped and have not been cancelled / deleted.  In technical terms, these are orders with a null shipped date and a null reason code. 

These orders indicate issues in the system that should be addressed at 4 pm EST before the end of the business day. 

Email attachment size may be limited to 35 MB. PHI and PII are not part of this dataset.

# 2.0 Objectives
We want an email sent at 4 pm EST daily with a csv attachment containing the orders not in final disposition.

# 3.0 Stakeholders
1. Clients affected by orders not in final disposition
2. Sofie operations team
3. Sofie BI team: Ivan Liao, Elangovan Srinivasan, Ajay (ICB)
4. Email list maintainer: Ivan Liao
5. Email recipients
   1. Operations team: "William Crisp" <william.crisp@sofie.com>; "Jerrod Brown" <jerrod.brown@sofie.com>; "Casey Melby" <casey.melby@sofie.com>; "Micah Bounds" <Micah.Bounds@sofie.com>; "Andrea Tremblay" <Andrea.Tremblay@sofie.com>; "Eric Kroencke" <Eric.Kroencke@sofie.com>; "Elangovan Srinivasan" <elangovan.srinivasan@sofie.com>

# 4.0 Technical Requirements
1. Daily email to designated email list at 4 pm EST.  Covers past 2 weeks of orders.
3. Filters by `Cal Date = <Today's Date>` AND `ShipDate IS NULL` AND `Reason code IS NULL` 
4. Attached csv with the following fields
   1. Rx ID
   2. Pharmacy
   3. Product
   4. Client
   5. Cal Date
   6. Cal Time
   7. Order Type

# 4.1 Out of scope

# 5.0 Architecture
1. Manual process... SQL client > SQL query > CSV export > Cleanup > Attach and email

# 6.0 References