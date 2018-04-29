# Understand InfluxDB concept
# Must read
* Understand key concept: https://docs.influxdata.com/influxdb/v1.5/concepts/key_concepts/
* Understand how to design schema: https://docs.influxdata.com/influxdb/v1.5/concepts/schema_and_data_layout/

## Schema
* database
  - measurement (similar to table in RDB)
     - fields
        - field_key
        - field_value
     - tags
        - field_key
        - field_value

## Terminology
### Fields
* Fields are made up of field keys and field values
* you cannot have data in InfluxDB without fields
* fields are not indexed. Queries that use field values as filters must scan all values that match the other conditions in the query.
* As a result, those queries are not performant relative to queries on tags (more on tags below).
* In general, fields should not contain commonly-queried metadata.

### Tags
* Tags are made up of tag keys and tag values
* Tags are optional. You don’t need to have tags in your data structure
* But it’s generally a good idea to make use of them because, unlike fields, tags are indexed
* Queries on tags are faster and that tags are ideal for storing commonly-queried metadata

### Measurement
* The measurement acts as a container for tags, fields, and the time column, and the measurement name is the description of the data that are stored in the associated fields
* Measurement names are strings, and, for any SQL users out there, a measurement is conceptually similar to a table

### Series
* Series is the collection of data that share a retention policy, measurement, and tag set
