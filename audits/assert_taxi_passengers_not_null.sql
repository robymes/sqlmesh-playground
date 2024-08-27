AUDIT (
  name assert_taxi_passengers_not_null
);
SELECT * 
FROM playground.taxi_kpi_gold
WHERE
  passenger_tot IS NULL;
