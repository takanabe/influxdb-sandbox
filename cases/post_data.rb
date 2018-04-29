require 'influxdb'

username = 'sandbox'
password = 'sandbox'
database = 'sandbox'
host = "127.0.0.1"
series  = 'sandbox_measurement'


client = InfluxDB::Client.new(
  database,
  username: username,
  host: host,
  password: password,
)

# Enumerator that emits a sine wave
Value = (0..360).to_a.map {|i| Math.send(:sin, i / 10.0) * 10 }.each

loop do
  data = {
    values: { value: Value.next },
    tags:   { wave: 'sine' } # tags are optional
  }

  # how to use write_point: https://github.com/influxdata/influxdb-ruby/blob/cab60b2b1f0da97c895b87dbc14e9ec706698f4e/lib/influxdb/query/core.rb#L71
  client.write_point(series, data)

  sleep 1
end
