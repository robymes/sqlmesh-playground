MODEL (
  name playground.taxi_kpi_gold,
  kind FULL,
  cron '@daily',
  grain VendorId,
  audits (assert_taxi_passengers_not_null)
);

SELECT
  VendorID,
  payment_type,
  SUM(passenger_count) as passenger_tot,
  SUM(total_amount) as amount_tot,
  SUM(trip_distance) as trip_distance_tot
FROM
  playground.taxi_bronze
GROUP BY VendorID, payment_type
