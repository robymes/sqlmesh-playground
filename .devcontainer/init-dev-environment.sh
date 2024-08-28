#!/bin/bash

python -m venv .env
source .env/bin/activate
pip install sqlmesh
pip install "sqlmesh[duckdb, postgres, motherduck, web]"