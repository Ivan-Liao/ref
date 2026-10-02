- [Biorx Eventhouse Real Time Data Dashboard 2026](#biorx-eventhouse-real-time-data-dashboard-2026)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Architecture](#40-architecture)
- [5.0 Next Steps](#50-next-steps)
- [6.0 Requirements](#60-requirements)
  - [6.1 Order Status Counts Report](#61-order-status-counts-report)
  - [6.2 Order Details report](#62-order-details-report)
- [7.0 References](#70-references)
  - [7.1 Research on Eventhouse dashboards versus PowerBI](#71-research-on-eventhouse-dashboards-versus-powerbi)
- [8.0 Changlog](#80-changlog)
  - [8.1 October 1, 2026](#81-october-1-2026)

# Biorx Eventhouse Real Time Data Dashboard 2026

# 1.0 Overview
Fabric Eventhouse dashboards are a native dashboarding solution. 

Dashboard ([link](https://app.fabric.microsoft.com/groups/7ebbb5d0-48f3-42a1-a1a1-503631ad2535/kustodashboards/d37220d3-db2e-4ade-87d7-3a8bd5036890?experience=fabric-developer&extensionScenario=openArtifact&v-_pharmacy=all&v-_product=all&v-_client=all&page=9a955cbb-83e2-44ce-9971-7831f65a6d6f&v-_from=24hours&v-_to=now&v-order_status=all))

# 2.0 Objectives
We want git versioned Eventhouse dashboards for realtime biorx data. Specifically, we want to monitor the counts of the order statuses as well as the row level order details.

# 3.0 Stakeholders
1. Operations team: William Crisp, Micah Bounds, Julian Nwoko, Jerrod Brown, Casey Melby, Andrea Tremblay
2. Sofie IT team: Vincent Oliveri, Kulsoom Naeem
3. Sofie BI team: Ivan Liao, Elangovan Srinivasan, Srihari Ramaiah, Kal ICB, Sean Murphy

# 4.0 Architecture
[Architecture Diagram](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=BioRx%20Real%20Time%20Architecture.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1XWn--OlKma_YzSjIjk1e1js3wuu7Clr5%26export%3Ddownload)

# 5.0 Next Steps
1.  Bring in inventory and orderedredirect tables
2.  Redirect data
   1. Put transferred site (possibly in a separate redirected report page)
   2. Cal time at redirected from or to pharmacy

# 6.0 Requirements

## 6.1 Order Status Counts Report

Order Statuses tracked
1. Total Orders
2. Total Deleted
3. Total Unfilled
4. Total Filled = Total Orders - Total Deleted - Total Unfilled
5. Total Packed
6. Total Shipped
7. Total Delivered

## 6.2 Order Details report

**Columns**
1. Rx ID
2. Pharmacy
3. Order Status
4. Product
5. Client
6. Reason Code
7. Reason
8. ReasonDT
9. Dose Activity
10. Cal Date
11. Cal Time
12. Order Date
13. Order Time
14. Filled Date
15. Filled Time
16. Packed Date
17. Packed Time
18. Shipped Date
19. Shipped Time
20. Delivered Date
21. Delivered Time
22. Delivered Late Minutes
    1.  Note that this is the difference in minutes between the Delivered Time and the Calibration Time.
    2.  Note that negative numbers means it was delivered early.

___

**Conditional Formatting**
1. Order Status
   1. Red for "Deleted"
   2. No color for "Unfilled"
   3. Yellow for "Filled"
   4. Green for any "Shipped" status
   5. Blue for "Delivered"
2. Delivered Late Minutes
   1. Red for late delivery time after calibration time
   2. Yellow for non ideal delivery time within 30 minutes of calibration time
   3. Green for ideal delivery time more than 30 minutes before calibration time.
   
# 7.0 References

## 7.1 Research on Eventhouse dashboards versus PowerBI
1. PowerBI has more visual report support and flexibility.
2. PowerBI provides less native refresh cadence support below 30 minutes.
   1. Eventhouse dashboard refresh cadence natively supports as fast as 10 seconds.
3. PowerBI is less efficient 
   1. PowerBI requires per-visual querying while Eventhouse dashboards can use a base query
   2. PowerBI translates DAX from KQL
   3. PowerBI manages the query
   4. PowerBI returns results to the visual
   5. Kusto source system costs still apply

# 8.0 Changlog

## 8.1 October 1, 2026
1. Documented workflow to export to CSV
2. "Order Status Counts" page
   1. Added counts for "Total Redirected Shipped" and "Total Redirected Delivered"
3. "Order Details" page
   1. New column Delivered Late Minutes was added.  Note that negative numbers mean the order was delivered x minutes early before the cal time.
      1. Green for when order was delivered more than 30 minutes earlier than the Cal Time
      2. Yellow for when order was delivered on time but less than 30 minutes earlier than the Cal Time
      3. Red for when order was delivered later than Cal Time
   2. Rx ID renamed to Rx Number
   3. Order status is now positioned right after Rx Number
   4. Order Status was added as a filter at the top
   5. Rx Number values no longer have commas
   6. The following order statuses were added
      1. Delivered
      2. Redirected Sent Shipped.  Note, there is currently no Redirected Sent Delivered.
      3. Redirected Received Shipped
      4. Redirected Received Delivered.  This was added to distinguish Redirected orders in Delivered status.