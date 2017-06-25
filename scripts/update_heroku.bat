heroku run --app limitless-gorge-32493 rails runner "SharePricesUpdateJob.perform_now"
heroku run --app limitless-gorge-32493 rails runner "PopulateExpectedDividendsJob.perform_now"
heroku run --app limitless-gorge-32493 rails runner "PopulateEstimatedMovementsJob.perform_now"