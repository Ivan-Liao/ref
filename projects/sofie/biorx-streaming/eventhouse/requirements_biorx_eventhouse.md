- [Fabric Real Time Eventhouse Database 2026](#fabric-real-time-eventhouse-database-2026)
- [1.0 Overview](#10-overview)
- [2.0 Objectives](#20-objectives)
- [3.0 Stakeholders](#30-stakeholders)
- [4.0 Architecture](#40-architecture)
- [5.0 Next Steps](#50-next-steps)
- [6.0 Requirements](#60-requirements)
  - [6.1 Database Objects](#61-database-objects)
  - [6.2 Naming conventions](#62-naming-conventions)
  - [6.3 Repo Structure](#63-repo-structure)
  - [6.4 Out of scope](#64-out-of-scope)
- [7.0 References](#70-references)
- [8.0 Changlog](#80-changlog)

# Fabric Real Time Eventhouse Database 2026 

# 1.0 Overview
Fabric Eventhouse is a real time database.  Currently the only data source is from BioRx.

# 2.0 Objectives
We want a git versioned Eventhouse codebase that stores data from various sources. Currently, the primary use of the Fabric Eventhouse is to store operational BioRx data.

# 3.0 Stakeholders
1. Operations team: William Crisp, Micah Bounds, Julian Nwoko, Jerrod Brown, Casey Melby, Andrea Tremblay
2. Sofie IT team: Vincent Oliveri, Kulsoom Naeem
3. Sofie BI team: Ivan Liao, Elangovan Srinivasan, Srihari Ramaiah, Kal ICB, Sean Murphy

# 4.0 Architecture
[Architecture Diagram](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=BioRx%20Real%20Time%20Architecture.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1XWn--OlKma_YzSjIjk1e1js3wuu7Clr5%26export%3Ddownload)

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


## 6.2 Naming conventions
1. All file names will use snake case with lowercase and underscores separating words

## 6.3 Repo Structure
1. Azure Devops repo ([link](https://dev.azure.com/sofiecode/sofie-data-analytics/_git/fabric-analytics))
2. key files
   1. Eventhouse database objects in ...
      1. eh_biorx.Eventhouse/.children/biorx.KQLDatabase/DatabaseSchema.kql
   2. Eventstream properties in ...
      1. es_biorx_initial.Eventstream/eventstream.json
   3. Eventhouse dashboard objects in ...
      1. Order Status.KQLDashboard/RealTimeDashboard.json

## 6.4 Out of scope

   
# 7.0 References


# 8.0 Changlog
