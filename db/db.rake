#CAPTURE NEW: rails db:restore_from_production\[capture\]
#DOWNLOAD LATEST: rails db:restore_from_production\[download\]
#RESTORE: rails db:restore_from_production

#[HEROKU_APP_NAME] = Name of your heroku app.
#[NUMBER_OF_CORES] = Number of concurrent jobs to run for pg_restore.

namespace :db do
  desc 'Pull down the latest backup from Heroku and rebuild your local database with it.'
  task :restore_from_production, [:process] => :environment do |task, args|
    if args.process == 'capture'
      capture_new_backup
      download_latest_backup
    end
    if args.process == 'download' 
      download_latest_backup
    end
    drop_and_recreate_local
    restore_local
  end

  def capture_new_backup
    puts '==> Capturing new production backup on Heroku.'
    system 'heroku pg:backups:capture --app=limitless-gorge-32493'
  end

  def download_latest_backup
    puts '==> Downloading latest production backup from Heroku.'
    system 'rm latest.dump'
    system 'heroku pg:backups:download --app=limitless-gorge-32493'
  end

  def drop_and_recreate_local
    puts '==> Dropping your local database.'
    Rake::Task['db:drop'].invoke
    puts '==> Recreating your local database.'
    Rake::Task['db:create'].invoke
  end

  def restore_local
    puts '==> Restoring local database from production backup.'
    system "pg_restore --verbose --clean --no-acl --no-owner -j 1 -h localhost -d #{Rails.configuration.database_configuration['development']['database']} latest.dump"
    puts '==> All done!'
  end
end