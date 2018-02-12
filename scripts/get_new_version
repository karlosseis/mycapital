git pull origin master
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed
RAILS_EVN=production rake assets:precompile
sudo nginx -s reload