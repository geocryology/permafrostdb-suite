FROM postgis/postgis:13-master

COPY ./SQL/1_observations_schema.sql /docker-entrypoint-initdb.d/1_observations_schema.sql
COPY ./SQL/2_add_device_defaults.sql /docker-entrypoint-initdb.d/2_add_device_defaults.sql
COPY ./SQL/3_add_roles.sql /docker-entrypoint-initdb.d/3_add_roles.sql
