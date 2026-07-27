FilteredOrders = 
FILTER(
    'f_ordered',
    'f_ordered'[C_Flag_Filled] = 0 
    && ( 
        'f_ordered'[CalibrationDate] = DATE(2026, 6, 19) 
        || ('f_ordered'[CalibrationDate] BETWEEN DATE(2026, 6, 16) AND DATE(2026, 6, 18)
        && 'f_ordered'[LastModified] = DATE(2026, 6, 19) 
        )
    )
)

