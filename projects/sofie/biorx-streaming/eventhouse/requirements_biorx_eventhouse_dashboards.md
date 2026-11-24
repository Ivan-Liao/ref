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
  - [7.1 Dashboard tips and tricks](#71-dashboard-tips-and-tricks)
  - [7.2 Research on Eventhouse dashboards versus PowerBI](#72-research-on-eventhouse-dashboards-versus-powerbi)
- [8.0 Changelog](#80-changelog)
  - [November 20, 2026](#november-20-2026)
  - [October 9, 2026](#october-9-2026)
  - [October 7, 2026](#october-7-2026)
  - [October 1, 2026](#october-1-2026)

# Biorx Eventhouse Real Time Data Dashboard 2026

# 1.0 Overview
Fabric Eventhouse dashboards are a native dashboarding solution. 

Dashboard ([link](https://app.fabric.microsoft.com/groups/7ebbb5d0-48f3-42a1-a1a1-503631ad2535/kustodashboards/d37220d3-db2e-4ade-87d7-3a8bd5036890))

# 2.0 Objectives
We want git versioned Eventhouse dashboards for realtime biorx data. Specifically, we want to monitor the counts of the order statuses as well as the row level order details.

# 3.0 Stakeholders
1. Operations team: William Crisp, Micah Bounds, Julian Nwoko, Jerrod Brown, Casey Melby, Andrea Tremblay
2. Sofie IT team: Vincent Oliveri, Kulsoom Naeem
3. Sofie BI team: Ivan Liao, Elangovan Srinivasan, Srihari Ramaiah, Kal ICB, Sean Murphy
4. Sofie Sales team: Adam Cooper, Dawn Allen, Joseph Cascone, Malia Proskey, Mike Parisi, Phyllis Hoelsworth, Tim Rieman

# 4.0 Architecture
[Architecture Diagram](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=BioRx%20Real%20Time%20Architecture.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1XWn--OlKma_YzSjIjk1e1js3wuu7Clr5%26export%3Ddownload)

# 5.0 Next Steps
<-- * For current iteration tasks

<-- ! For high priority asks

Default text for later iteration tasks

1.  The sales team has requested the following enhancements to the real-time report
    1.  <-- ! Add Account owner as an additional filter, Adam Cooper has not gotten back yet.
    2.  Alerts for CAEs (possible via Fabric Activator in email or Teams). Would need the rules, but it possible.
    3.  Predictive alerts (for when order is in trouble, etc.). Would need the rules, but it possible.
    4.  Introduce role-based views to make it easier for CAEs. They would only see rows associated with them.
2.  Operations team requested the following
3.  Finance team asks
    1.  Billable, unbillable logic
    2.  Reason code history
    3.  Notes field from biorx
4.  Bug Fixes
    1.  Fix discrepancy 167678, deleted at target pharmacy row but shows redirected sent shipped at source pharmacy
    2.  Fix parameter distinct list dependant on current day. Make it a week at least
5.  Backburner
    1.  Bring in inventory table
    2.  Retention policies

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
8. Total Redirected Unfilled
9. Total Redirected Shipped
10. Total Redirected Delivered

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
23. Redirect Rx Number
    1.  Rx Number for the corresponding phamarcy in the redirect relationship
24. Redirect Pharmacy
    1.  Pharmacy in the redirect relationship
25. Redirect Cal Date
    1.  Cal date for the corresponding phamarcy in the redirect relationship
26. Redirect Cal Time
    1.  Cal time for the corresponding phamarcy in the redirect relationship

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

## 7.1 Dashboard tips and tricks
1. The left side panel has tabs for the various available reports.
2. Use the filters in the top of the report.  Select / Deselect all as well as multi-select is available.
3. Export as csv or excel by right click any row in a table and clicking "Export to csv"
4. You can pin any column by clicking on the 3 vertical dots on any column in a table.
5. You can filter by any specific value through the filter icon on every column in a table.
6. You can sort by any column by right clicking a column and pressing "Sort Ascending" or "Sort Descending".  There is currently no way to sort by multiple columns.  The default sort is by Pharmacy Ascending, Cal Date Desc, Cal Time Desc.
7. You can choose specific columns to display by right clicking on any column and clicking "Choose Columns".  This can be reset by right clicking on any column and selecting "Reset Columns".
8. There is a reset button in the top right to reset all filters.

## 7.2 Research on Eventhouse dashboards versus PowerBI
1. PowerBI has more visual report support and flexibility.
2. PowerBI provides less native refresh cadence support below 30 minutes.
   1. Eventhouse dashboard refresh cadence natively supports as fast as 10 seconds.
3. PowerBI is less efficient 
   1. PowerBI requires per-visual querying while Eventhouse dashboards can use a base query
   2. PowerBI translates DAX from KQL
   3. PowerBI manages the query
   4. PowerBI returns results to the visual
   5. Kusto source system costs still apply

# 8.0 Changelog

## November 20, 2026
1.  There are new columns in the "Order Details" page
    1.  is_recalibrated
        1.  "Yes" if this order was recalibrated
    2.  is_same_day_recalibrated
        1.  "Yes" if there was a recalibration that happened on the same day for this order
    3.  recalibration_history
        1.  comma separated list of all recalibrated dates for this order
2.  The Order Details page has a new categorical date filter "Timeframe"
    1.  Options include: No Selection (default), Today, Yesterday, Tomorrow, Current week, Previous week, Next Week, Previous Month, Current Month, Next Month, Past orders (60 days),  Future orders (60 days)
    2.  Note that the week begins on Monday and ends on Sunday
    3.  Note that this filter will override any filters set in Cal Date.  You must set reset the filters or set this to "No Selection" in order to use the Cal Date filter.
3.  The "Orders Details" page now has a max range of orders from 60 day in the past to 60 days in the future

## October 9, 2026
1. New column "Is Redirect Recalibrated"
   1. "Yes" if the redirected cal time is different from the original cal time. Green conditional formatting.
   2. "No" if the redirected cal time is the same as the original cal time. Red conditional formatting.
   3. Empty if not a redirected order.

## October 7, 2026
1. Brought in data from orderedredirect table
2. Order Status Counts page
   1. Added count for Total Redirected Unfilled
3. Order Details page
   1. New columns
      1. Redirect Rx Number
         1. Rx Number for the corresponding phamarcy in the redirect relationship
      2. Redirect Pharmacy
         1. Pharmacy in the redirect relationship
      3. Redirect Cal Date
         1. Cal date for the corresponding phamarcy in the redirect relationship
      4. Redirect Cal Time
         1. Cal Time for the corresponding phamarcy in the redirect relationship
   2. New Order status "Redirected Sent Unfilled"
   3. Pure dates were reformatted to remove the time part

## October 1, 2026
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