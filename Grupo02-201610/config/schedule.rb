# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# set :environment, :development
# Example:
#
# set :output, "/cron_log.log"
#
#!/usr/bin/env ruby
every 1.minute do
#   command "/usr/bin/some_great_command"
  runner "DisenioController.prueba"
#   rake "some:great:rake:task"
  #print("CAMBIO")
  command "echo 'HOLA'"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
