MODEL (
  name playground.taxi_bronze,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column tpep_pickup_datetime
  ),
  start '2022-11-03',
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
  payment_type,
  ROUND(
    (
      EXTRACT(EPOCH FROM (
        tpep_dropoff_datetime - tpep_pickup_datetime
      )) / 3600.0
    )::DECIMAL(18, 3),
    2
  ) AS total_hours
FROM playground.taxi_external
WHERE
  (
    NOT passenger_count IS NULL
  )
  AND (
    tpep_pickup_datetime BETWEEN @start_date AND @end_date
  )