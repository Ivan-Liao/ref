- [Biorx Real Time Data](#biorx-real-time-data)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Architecture](#40-architecture)
- [5.0 Next Steps](#50-next-steps)
- [6.0 Requirements](#60-requirements)
  - [6.1 Database Objects](#61-database-objects)
  - [6.2 Repo Structure](#62-repo-structure)
  - [6.3 Naming conventions](#63-naming-conventions)
  - [6.4 Out of scope](#64-out-of-scope)
- [7.0 References](#70-references)
  - [7.1 PowerBI Dashboard limitations](#71-powerbi-dashboard-limitations)
- [8.0 Changlog](#80-changlog)

# Biorx Real Time Data

# 1.0 Overview
Fabric Eventhouse is a real time database.  Currently the only data source is from BioRx.

# 2.0 Objectives
We want a git versioned Eventhouse codebase that stores data from various sources. Currently, the primary use of the Fabric Eventhouse is to store operational BioRx data.

# 3.0 Stakeholders
1. BioRx users
2. Sofie BI team: Ivan Liao, Elangovan Srinivasan, Srihari Ramaiah, Kal ICB

# 4.0 Architecture

# 5.0 Next Steps
1. retention policy
```
.alter-merge database <your_database_name> policy retention
{
  "SoftDeletePeriod": "45.00:00:00",
  "Recoverability": "Disabled"
}
```

# 6.0 Requirements

## 6.1 Database Objects
Link to spreadsheet tracking all database objects ([link](https://zevacor365.sharepoint.com/:x:/r/sites/BI/Shared%20Documents/Fabric%20Eventhouse/Eventhouse%20Design%20Doc.xlsx?d=w8aef203666fe453cbf33f12392f7c40d&csf=1&web=1&e=KRDkbH))

## 6.2 Repo Structure
1. key files
   1. Eventhouse database objects in ...
      1. eh_biorx.Eventhouse/.children/biorx.KQLDatabase/DatabaseSchema.kql
   2. Eventstream properties in ...
      1. es_biorx_initial.Eventstream/eventstream.json
   3. Eventhouse dashboard objects in ...
      1. Order Status.KQLDashboard/RealTimeDashboard.json

## 6.3 Naming conventions
1. All file names will use snake case with lowercase and underscores separating words


## 6.4 Out of scope

   
# 7.0 References

## 7.1 PowerBI Dashboard limitations
1. Per-visual query inefficiencies
   1. Eventhouse dashboards can use a base query
2. Power BI overhead
   1. Translating DAX from KQL
   2. Managing query
   3. Returning results to the visual
   4. All on top of Kusto source system costs

# 8.0 Changlog
