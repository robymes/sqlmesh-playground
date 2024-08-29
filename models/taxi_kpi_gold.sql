MODEL (
  name playground.taxi_kpi_gold,
  kind FULL,
  cron '@daily',
  grain VendorId,
  audits (
    assert_taxi_passengers_not_null
  )
);

SELECT
  VendorID,
  payment_type,
  SUM(passenger_count) AS passenger_tot,
  SUM(total_amount) AS amount_tot,
  SUM(trip_distance) AS trip_distance_tot,
  SUM(total_hours) AS trip_hours_tot
FROM playground.taxi_bronze
GROUP BY
  VendorID,
  payment_type