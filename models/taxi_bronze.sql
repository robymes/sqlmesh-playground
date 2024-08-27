MODEL (
  name playground.taxi_bronze,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column tpep_pickup_datetime
  ),
  start '2020-01-01',
  cron '@daily',
  grain (VendorID, tpep_pickup_datetime, tpep_dropoff_datetime)
);

SELECT
  VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  passenger_count,
  total_amount,
  trip_distance,
  payment_type
FROM playground.taxi_external
WHERE
  (passenger_count NOTNULL) AND
  (tpep_pickup_datetime BETWEEN @start_date AND @end_date)