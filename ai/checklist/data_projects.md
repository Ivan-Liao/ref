# General
1. [ ] Date formatting 
   1. Strings as standard YYYY-MM-DD format
      1. MySQL / MariaDB: `DATE_FORMAT(o.CalibrationDate, '%Y-%m-%d') AS CalibrationDate`
2. [ ] Scheduling Mistakes
   1. Scheduling in UTC and military time.  Don't confuse 3 am with 3 pm (3 and 15).