# -*- coding: utf-8 -*-
"""
Created on Tue May 25 16:20:10 2021

@author: Ivan6461
"""


import cx_Oracle as cx
conn = cx.connect(dsn = 'CLARITY_PRD')

print("Successfully connected to CLARITY_PRD")

cursor = conn.cursor()

row_list = cursor.execute(
    """
    select PAT_ID
        , CITY
    from PATIENT
    where rownum < 50
    """)
    
for row in row_list:
    print(row[0], ' city: ', row[1])