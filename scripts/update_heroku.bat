heroku run --app limitless-gorge-32493 rails runner "SharePriceUpdateFromgooglefinanceJob.perform_now"
heroku run --app limitless-gorge-32493 rails runner "PopulateExpectedDividendsJob.perform_now"
heroku run --app limitless-gorge-32493 rails runner "PopulateEstimatedMovementsJob.perform_now"