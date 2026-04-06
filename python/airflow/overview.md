# Operators
1. Dataflow
   1. DataflowStartFlexTemplateOperator
   2. DataflowTemplatedJobStartOperator
   3. DataflowCreatePythonJobOperator
2. Dataproc
   1. DataprocCreateBatchOperator
   2. DataprocSubmitJobOperator
3. BigQueryInsertJobOperator

# Performance
1. Optimization
   1. Quick wins
      1. tuning worker concurrency and DAG concurrency, things like the max_active_tasks_per_dag parameter
         1. memory usage below 80%
      2. sampling logging instead of logging everything