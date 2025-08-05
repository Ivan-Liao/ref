# Architecture
1. Driver directs Executors
   1. Executors are located on JVM with X number of cores in each JVM, each core is an executor
   2. Shuffle is a task where data is persisted into another phase
   3. Tasks are performed by executors
2. Execution plans are defined as DAGs