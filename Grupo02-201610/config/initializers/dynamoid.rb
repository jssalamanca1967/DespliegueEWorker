Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2' # This adapter establishes a connection to the DynamoDB servers using Amazon's own AWS gem.
  config.namespace = "designmatch" # To namespace tables created by Dynamoid from other tables you might have. Set to nil to avoid namespacing.
  config.warn_on_scan = true # Output a warning to the logger when you perform a scan rather than a query on a table.
  config.read_capacity = 50 # Read capacity for your tables
  config.write_capacity = 20 # Write capacity for your tables

end
