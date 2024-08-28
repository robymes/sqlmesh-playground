#!/bin/bash

python -m venv .env
.\.env\Scripts\activate
pip install sqlmesh
pip install "sqlmesh[duckdb, postgres, motherduck, web]"