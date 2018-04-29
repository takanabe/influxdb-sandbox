require 'influxdb'

username = 'sandbox'
password = 'sandbox'
database = 'sandbox'
host = "127.0.0.1"
series  = 'issues'


client = InfluxDB::Client.new(
  database,
  username: username,
  host: host,
  password: password,
)

loop do
  issue_count = {
    values: {
      issue_count: rand(10),
      member_count: rand(5..8),
    },
    tags:   { team: 'sre' } # tags are optional
  }
  client.write_point(series, issue_count)

  sleep 1
end
