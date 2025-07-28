----- Rate of Spontaneous Abortions (O03) / Fetal Demise (O36.4) / Still Birth
SELECT
    COUNT(*) OVER ()
FROM
    FullAccess.DiagnosisEventFact diag_fact
    INNER JOIN FullAccess.EncounterFact enc_fact ON diag_fact.EncounterKey = enc_fact.EncounterKey
    INNER JOIN FullAccess.EpisodeEncounterMappingFact epi_map_fact ON epi_map_fact.EncounterKey = enc_fact.EncounterKey
    INNER JOIN FullAccess.EpisodeFact epi_fact ON epi_fact.EpisodeKey = epi_map_fact.EpisodeKey
    INNER JOIN FullAccess.PregnancyFact preg_fact ON preg_fact.EpisodeKey = epi_fact.EpisodeKey
    INNER JOIN FullAccess.DiagnosisDim diag_dim ON diag_dim.DiagnosisKey = diag_fact.DiagnosisKey
    INNER JOIN FullAccess.DateDim preg_end ON preg_fact.WorkingEstimatedDateOfDeliveryKey = preg_end.DateKey
    INNER JOIN FullAccess.DiagnosisTerminologyDim diag_term_dim ON diag_term_dim.DiagnosisKey = diag_dim.DiagnosisKey
    INNER JOIN FullAccess.PatientDim pat_dim ON pat_dim.DurableKey = preg_fact.PatientDurableKey
    INNER JOIN FullAccess.PatientInfectionFact pat_infect_fact ON pat_infect_fact.PatientDurableKey = preg_fact.PatientDurableKey
    AND pat_infect_fact.OnsetDate < cast('2021-04-30' AS DATE)
    AND pat_infect_fact.OnsetDate > cast('2020-05-01' AS DATE)
    AND pat_infect_fact.InfectionName = 'COVID-19 Confirmed'
WHERE
    (
        cast(preg_end.DateValue AS DATE) < cast('2021-04-30' AS DATE)
        AND cast(preg_end.DateValue AS DATE) > cast('2020-05-01' AS DATE)
    )
    AND (
        diag_term_dim.Type = 'ICD-10-CM'
        AND (
            diag_term_dim.Value LIKE 'O03%' -- OR diag_term_dim.Value LIKE 'O45%'
            -- OR diag_term_dim.Value LIKE 'O14%'
            -- OR diag_term_dim.Value LIKE 'O13%'
            -- OR diag_term_dim.Value LIKE 'O11%'
            -- OR diag_term_dim.Value LIKE 'O41.01%'
            -- OR diag_term_dim.Value LIKE 'O36.591%'
            -- OR diag_term_dim.Value LIKE 'O60.1%'
        )
    )
GROUP BY
    preg_fact.PregnancyKey

----- Preop lab
SELECT ORDER_PROC.ORDER_PROC_ID AS "Lab Order ID",
    ZC_ORDERING_MODE.NAME AS "Lab Ordering Mode",
    CEIL(
        OR_LOG.SURGERY_DATE - TRUNC(ORDER_PROC_2.SPECIMN_TAKEN_DATE)
    ) AS "Days Before",
    PATIENT.PAT_MRN_ID AS "Patient MRN",
    PATIENT.PAT_NAME AS "Patient Name",
    PATIENT.BIRTH_DATE AS "Patient Birthdate",
    CLARITY_LOC.LOC_NAME AS "Surgery Location",
    ZC_OR_SERVICE.NAME AS "Surgery Service",
    OR_CASE.OR_CASE_ID AS "OR Case ID",
    ORDER_PROC.AUTHRZING_PROV_ID AS "Authorizing Lab Provider ID",
    c_ser_1.PROV_NAME AS "Authorizing Lab Provider Name",
    ORDER_PROC.ORD_CREATR_USER_ID AS "Lab Order Creator ID",
    CLARITY_EMP.NAME AS "Lab Order Creator Name",
    OR_LOG.SURGERY_DATE AS "Surgery Date",
    ORDER_PROC_2.SPECIMN_TAKEN_TIME AS "Lab Collected Datetime",
    ORDER_PROC.ORDER_TIME AS "Lab Ordered Datetime",
    ORDER_PROC_5.PARENT_ORD_INST_DTTM AS "Parent Lab Ordered Datetime",
    OR_LOG.PRIMARY_PHYS_ID AS "Surgeon ID",
    c_ser_2.PROV_NAME AS "Surgeon Name",
    dpp_hierarchy.SPECIALTY_NAME AS "Surgeon Specialty",
    OR_LOG.SCHED_START_TIME AS "Surgery Scheduled Datetime"
FROM ORDER_PROC ORDER_PROC
    INNER JOIN ORDER_PROC_5 ORDER_PROC_5 ON ORDER_PROC_5.ORDER_ID = ORDER_PROC.ORDER_PROC_ID
    INNER JOIN ORDER_PROC_3 ORDER_PROC_3 ON ORDER_PROC_3.ORDER_ID = ORDER_PROC.ORDER_PROC_ID
    INNER JOIN ORDER_PROC_2 ORDER_PROC_2 ON ORDER_PROC_2.ORDER_PROC_ID = ORDER_PROC.ORDER_PROC_ID
    INNER JOIN OR_LOG OR_LOG ON OR_LOG.PAT_ID = ORDER_PROC.PAT_ID
    AND trunc(ORDER_PROC_2.SPECIMN_TAKEN_DATE) BETWEEN OR_LOG.SURGERY_DATE - 7 AND OR_LOG.SURGERY_DATE
    AND OR_LOG.SURGERY_DATE > SYSDATE - 100
    INNER JOIN OR_CASE OR_CASE ON OR_CASE.LOG_ID = OR_LOG.LOG_ID
    INNER JOIN ZC_ORDERING_MODE ZC_ORDERING_MODE ON ZC_ORDERING_MODE.ORDERING_MODE_C = ORDER_PROC_3.ORDERING_MODE_C
    INNER JOIN ZC_OR_SERVICE ZC_OR_SERVICE ON ZC_OR_SERVICE.SERVICE_C = OR_LOG.SERVICE_C
    INNER JOIN PATIENT PATIENT ON PATIENT.PAT_ID = OR_LOG.PAT_ID
    INNER JOIN CLARITY_LOC CLARITY_LOC ON CLARITY_LOC.LOC_ID = OR_LOG.LOC_ID -- authorizing provider
    INNER JOIN CLARITY_SER c_ser_1 ON c_ser_1.PROV_ID = ORDER_PROC.AUTHRZING_PROV_ID -- lab order creator
    INNER JOIN CLARITY_EMP CLARITY_EMP ON CLARITY_EMP.USER_ID = ORDER_PROC.ORD_CREATR_USER_ID
    INNER JOIN CLARITY_SER c_ser_2 ON c_ser_2.PROV_ID = OR_LOG.PRIMARY_PHYS_ID
    INNER JOIN D_PROV_PRIMARY_HIERARCHY dpp_hierarchy ON dpp_hierarchy.PROV_ID = OR_LOG.PRIMARY_PHYS_ID
WHERE ORDER_PROC_3.ORDERING_MODE_C IS NOT NULL
    AND ORDER_PROC.PROC_ID = 31493
    AND CLARITY_LOC.LOC_NAME NOT LIKE 'CC%'
    AND OR_LOG.CASE_CLASS_C NOT IN (80, 90, 100)