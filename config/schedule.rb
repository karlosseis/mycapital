# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#


##  PARA AÑADIRLO AL CRONTAB ###
## OJO, pone bin/rails y hay que dejar rails a secas.
# Change to your application's directory.
# cd /my/app

# View config/schedule.rb converted to cron syntax
# bundle exec whenever

# Update crontab
# bundle exec whenever -i

# Overwrite the whole crontab (be careful with this one!)
# bundle exec whenever -w

# See all the options for the whenever command
# bundle exec whenever -h


 every 5.minutes do
   runner "SharePricesUpdateJob.perform_now"
 end
 every 7.minutes do
   runner "UpdateCompaniesHeaderSumFields.perform_now"
 end

every 1.day, :at => '8:28 am' do
  runner "PopulateExpectedDividendsJob.perform_now"
  runner "PopulateEstimatedMovementsJob.perform_now"
end
# Learn more: http://github.com/javan/whenever
