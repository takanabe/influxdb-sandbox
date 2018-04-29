# influxdb-sandbox
Investigation and research about InfluxDB (https://docs.influxdata.com/influxdb/v1.5/)

# Investigation
* [Understand Concept](./CONCEPT.md)
* [Understand Database Management](./MANAGEMENT.md)

# The most important thing I learn from this investigation
* We cannot merge data across measurements with `JOIN` query. (TSDB is not RDB)
* Include all data in a single measurement (Schema design tips)
* We can use Subqueries

from https://www.influxdata.com/blog/tldr-influxdb-tech-tips-june-16-2016/

>There is no way to perform cross-measurement math or grouping. All data must be under a single measurement to query it together. We recommend re-organizing your schema so that all of your data live in one measurement. InfluxDB is not a relational database and mapping data across measurements is not a great schema.

# Sandbox
Use [influxdb client in ruby](https://github.com/influxdata/influxdb-ruby). There are many cases in [github](https://github.com/influxdata/influxdb-ruby/tree/1d9642ee702fda159d1ab8637347970bc78745ba/spec/influxdb/cases)

## Preparation
```
bundle install
docker-compose up -d
```
## case1: Read/Write data
### Add data to InfluxDB
```
bundle exec ruby cases/post_data.rb

#output

[snip]

influxdb_1  | [httpd] 172.21.0.1 - sandbox [29/Apr/2018:10:57:03 +0000] "POST /write?db=sandbox&p=%5BREDACTED%5D&precision=s&u=sandbox HTTP/1.1" 204 0 "-" "Ruby" 0cffa2c4-4b9c-11e8-8119-000000000000 3892
influxdb_1  | [httpd] 172.21.0.1 - sandbox [29/Apr/2018:10:57:04 +0000] "POST /write?db=sandbox&p=%5BREDACTED%5D&precision=s&u=sandbox HTTP/1.1" 204 0 "-" "Ruby" 0d9a355f-4b9c-11e8-811a-000000000000 3700
influxdb_1  | [httpd] 172.21.0.1 - sandbox [29/Apr/2018:10:57:06 +0000] "POST /write?db=sandbox&p=%5BREDACTED%5D&precision=s&u=sandbox HTTP/1.1" 204 0 "-" "Ruby" 0e3487db-4b9c-11e8-811b-000000000000 3992

[snip]
```

### Read data from InfluxDB
```
## Preaparation
bundle exec irb
irb> require 'influxdb'
irb> username = 'sandbox'
irb> password = 'sandbox'
irb> database = 'sandbox'
irb> host = "127.0.0.1"
irb> series  = 'sandbox_measurement'
irb> client = InfluxDB::Client.new(
       database,
       username: username,
       host: host,
       password: password,
    )

## Issue queries
irb> client.query('show databases')
=> [{"name"=>"databases", "tags"=>nil, "values"=>[{"name"=>"sandbox"}, {"name"=>"_internal"}]}]
irb> client.query('show measurements')
=> [{"name"=>"measurements", "tags"=>nil, "values"=>[{"name"=>"sandbox_measurement"}]}]
irb> client.query 'select * from sandbox_measurement limit 3'
```

## case2: Test sub query
### Add data to InfluxDB
```
bundle exec ruby cases/post_two_measurements.rb
```

### Read data from InfluxDB
```
## Preaparation
bundle exec irb
irb> require 'influxdb'
irb> username = 'sandbox'
irb> password = 'sandbox'
irb> database = 'sandbox'
irb> host = "127.0.0.1"
irb> series  = 'sandbox_measurement'
irb> client = InfluxDB::Client.new(
       database,
       username: username,
       host: host,
       password: password,
    )

## Issue queries
irb> client.query('show measurements')
=> [{"name"=>"measurements", "tags"=>nil, "values"=>[{"name"=>"issues"}, {"name"=>"sandbox_measurement"}]}]

irb> client.query('select * from issues limit 5')
=> [{"name"=>"issues", "tags"=>nil, "values"=>[{"time"=>"2018-04-29T11:39:04Z", "issue_count"=>3, "member_count"=>8, "team"=>"sre"}, {"time"=>"2018-04-29T11:39:05Z", "issue_count"=>7, "member_count"=>7, "team"=>"sre"}, {"time"=>"2018-04-29T11:39:06Z", "issue_count"=>8, "member_count"=>6, "team"=>"sre"}, {"time"=>"2018-04-29T11:39:07Z", "issue_count"=>1, "member_count"=>5, "team"=>"sre"}, {"time"=>"2018-04-29T11:39:08Z", "issue_count"=>0, "member_count"=>8, "team"=>"sre"}]}]

irb> results = client.query('select issue_count/member_count AS issue_per_member, issue_count, member_count from issues limit 5')
=> [{"name"=>"issues", "tags"=>nil, "values"=>[{"time"=>"2018-04-29T11:39:04Z", "issue_per_member"=>0.375, "issue_count"=>3, "member_count"=>8}, {"time"=>"2018-04-29T11:39:05Z", "issue_per_member"=>1, "issue_count"=>7, "member_count"=>7}, {"time"=>"2018-04-29T11:39:06Z", "issue_per_member"=>1.3333333333333333, "issue_count"=>8, "member_count"=>6}, {"time"=>"2018-04-29T11:39:07Z", "issue_per_member"=>0.2, "issue_count"=>1, "member_count"=>5}, {"time"=>"2018-04-29T11:39:08Z", "issue_per_member"=>0, "issue_count"=>0, "member_count"=>8}]}]

irb> results[0]["values"].each {|result| puts "member_count: #{result['member_count']}, issue_count: #{result['issue_count'], issue_per_member: #{result['issue_per_member']"}

irb> results[0]["values"].each {|result| puts "member_count: #{result['member_count']}, issue_count: #{result['issue_count']}, issue_per_member: #{result['issue_per
_member']}"}
member_count: 8, issue_count: 3, issue_per_member: 0.375
member_count: 7, issue_count: 7, issue_per_member: 1
member_count: 6, issue_count: 8, issue_per_member: 1.3333333333333333
member_count: 5, issue_count: 1, issue_per_member: 0.2
member_count: 8, issue_count: 0, issue_per_member: 0
```

# Reference
## Docs
* https://docs.influxdata.com/influxdb/v1.5/

## Docker image
* influxdb: https://hub.docker.com/_/influxdb/
