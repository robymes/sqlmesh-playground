import typing as t
from datetime import datetime
import pandas as pd
import duckdb
from sqlmesh import ExecutionContext, model
from sqlmesh.core.model.kind import ModelKindName

@model(
    "playground.taxi_external",
    kind=dict(
        name=ModelKindName.FULL,
    ),
    columns={
        "VendorID": "int",
        "tpep_pickup_datetime": "datetime",
        "tpep_dropoff_datetime": "datetime",
        "passenger_count": "float",
        "trip_distance": "float",
        "RatecodeID": "float",
        "store_and_fwd_flag": "str",
        "PULocationID": "int",
        "DOLocationID": "int",
        "payment_type": "int",
        "fare_amount": "float",
        "extra": "float",
        "mta_tax": "float",
        "tip_amount": "float",
        "tolls_amount": "float",
        "improvement_surcharge": "float",
        "total_amount": "float",
        "congestion_surcharge": "float",
        "airport_fee": "float"
    },
)

def execute(
    context: ExecutionContext,
    start: datetime,
    end: datetime,
    execution_time: datetime,
    **kwargs: t.Any,
) -> pd.DataFrame:
    
    conn = duckdb.connect('md:?motherduck_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InJvYnltZXNAZ21haWwuY29tIiwic2Vzc2lvbiI6InJvYnltZXMuZ21haWwuY29tIiwicGF0IjoiLXlnd3RNTmc4T0dnMmVnb24xVXdzWUZVQjUzRWZHSVJpT21EMTRmTFE2VSIsInVzZXJJZCI6IjAyMDJjMzA2LTljNWMtNGMzYS1iZGVlLTdlNWFlZTZkY2M0ZSIsImlzcyI6Im1kX3BhdCIsImlhdCI6MTcyNDQwNzkxOH0.vNEM1o48K0R78zC7xeCrQuGcJpCoyB6UG-hJL7fb7VI')
    table_name = "sample_data.nyc.taxi"
        
    chunk_size = 10000
    iterations = 10

    for i in range(iterations):
        query = f"SELECT * FROM {table_name} LIMIT {chunk_size} OFFSET {i}"
        df = conn.execute(query).fetchdf()
        yield df

    conn.close()