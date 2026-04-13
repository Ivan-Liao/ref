- [Intro](#intro)
- [IAM, Quotas, Permissions](#iam-quotas-permissions)
- [Portability](#portability)
- [Security](#security)
- [Seperation of Storage and Compute](#seperation-of-storage-and-compute)
- [Transforms](#transforms)

# Intro
A language-agnostic way to represent pipelines / a set of protocols for transforming data that allows 
1. Running pipelines authored in any SDK on any runner (like dataflow), 
2. implementing new Beam transforms using a language of choice and 
3. utilizing these transforms from other languages, and Cross-language transforms

# IAM, Quotas, Permissions
1. Dataflow User roles
   1. Viewer
   2. Developer (can be used as foundation for more custom roles)
   3. Admin
2. Dataflow service account
3. Dataflow controller service account (assigned to compute VMs in Dataflow pipeline)
   1. Default compute engine service account
   2. Best practice create custom compute engine account for production workloads
      1. Dataflow worker role
      2. Bigquery data viewer role
      3. other tool roles
4. Quotas
   1. CPU
   2. External IP
   3. Persistent Disks
      1. Default PD size is 400 GB

# Portability
1. Docker based containerization

# Security
1. Data Locality
   1. region and zone
2. Shared VPC
3. Private IPs
   1. disables external IP usage
4. CMEK (customer managed encryption key)

# Seperation of Storage and Compute 
1. Shuffle Service for batch  (reduced worker load)
2. Streaming Engine for streaming (reduced worker load)
3. Flexible Resource Scheduling
   1. Reduce cost by scheduling techniques in the Dataflow Shuffle Service and leverage a mix of preemptible and normal virtual machines.
   2. This makes FlexRS suitable for workloads that are not time-critical, such as daily or weekly jobs


# Transforms
1. CoGroupByKey
2. Combine
   1. Commutative and associative operations, more efficient than GroupByKey
3. Flatten
   1. Two or more PCollections containing same type and fuse them together
4. GroupByKey
   1. Groups elements with same key together on same worker
   2. Used for Joins 
5. ParDo
   1. Apply function to each element of PCollection
   2. Higher level ParDo functions
      1. Filter
      2. Map
         1. Formatting, partial extraction, or type-conversion
      3. MapElements
      4. FlatMapElements
      5. WithKeys
      6. Keys
      7. Values
6. Partition
   1. Somewhat the opposite of Flatten.  Divides one Pcollection into multiple
7. Sources and Sinks
   1. TextIO
      1. ReadAllFromText()
      2. WriteToText()
   2. FileIO
      1. Process files once
         1. FileIO.MatchFiles('<file pattern>') ... fileio.ReadMatches()
      2. Process files as they arrive
         1. beam.io.ReadFromPubSub
      3. Write files
         1. beam.io.fileio.WriteToFiles(path='', destination='',sink='') # can use dynamic destinations
   3. BigqueryIO
   4. PubsubIO
   5. KafkaIO
   6. BigtableIO
   7. AvroIO
   8. Splittable DoFn
8. Triggers
   1. Default trigger after watermark
   2. Trigger after fixed time
   3. Composite trigger
   4. Data driven trigger (next 5 late messages after watermark)
9.  Watermark
   1. Relationship between event time and processing time
   2. Watermark is updated with every new message received
10. Windows
   1. Fixed, non overlapping
   2. sliding, may overlap ... frequency with which sliding windows begin is called period
      1. 60 second sliding window with period of 30 seconds
      2. useful for moving averages
   3. session
      1. minimum gap duration
      2. useful for active user tracking
   4. Time tracking
      1. Event time to recover order of messages
      2. processing time
   5. Accumulation modes
      1. Accumulation
      2. Discard