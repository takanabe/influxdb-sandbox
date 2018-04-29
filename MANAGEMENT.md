# Understand Database management
## Must read
* https://docs.influxdata.com/influxdb/v1.5/query_language/database_management

### Retention policy
* The part of InfluxDB’s data structure that describes:
   - how long InfluxDB keeps data (duration)
   - how many copies of those data are stored in the cluster (replication factor)
   - the time range covered by shard groups (shard group duration)
* RPs are unique per database and along with the measurement and tag set define a series
* When you create a database, InfluxDB automatically creates a retention policy called `autogen` with an infinite duration, a replication factor set to one, and a shard group duration set to seven days

### Replication factor
* The attribute of the retention policy that determines how many copies of the data are stored in the cluster
* InfluxDB replicates data across N data nodes, where N is the replication factor

### Shard group
* Shard groups are logical containers for shards
* Shard groups are organized by time and retention policy
* Every retention policy that contains data has at least one associated shard group
