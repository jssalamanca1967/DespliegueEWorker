Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV['AWSAccessKeyId'], ENV['AWSSecretKey']),
})
