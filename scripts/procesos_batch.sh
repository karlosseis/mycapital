RAILS_ENV=production rails runner "SharePriceUpdateFromgooglefinanceJob.perform_now"
RAILS_ENV=production rails runner "PopulateExpectedDividendsJob.perform_now"
RAILS_ENV=production rails runner "PopulateEstimatedMovementsJob.perform_now"