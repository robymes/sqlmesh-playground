#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE sql_mesh_state;
    CREATE DATABASE sql_mesh_dwh;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "sql_mesh_state" <<-EOSQL
    CREATE USER sql_mesh_state_user WITH PASSWORD 'sql_mesh_state_pwd';
    GRANT ALL PRIVILEGES ON DATABASE sql_mesh_state TO sql_mesh_state_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "sql_mesh_dwh" <<-EOSQL
    CREATE USER sql_mesh_dwh_user WITH PASSWORD 'sql_mesh_dwh_pwd';
    GRANT ALL PRIVILEGES ON DATABASE sql_mesh_dwh TO sql_mesh_dwh_user;
EOSQL