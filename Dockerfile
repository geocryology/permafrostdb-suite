FROM alpine/git as setup

WORKDIR /opt
RUN git clone https://github.com/geocryology/sensorDb

FROM postgis/postgis:13-master as main

ENV POSTGRES_NAME=observations
ENV POSTGRES_USER=observations

# Get database DNA from sensorDb repo
COPY --from=setup /opt/sensorDb/observations.sql /docker-entrypoint-initdb.d/10_build_database.sql
COPY --from=setup /opt/sensorDb/device_sensor_profiles.csv /docker-entrypoint-initdb.d/device_sensor_profiles.csv
COPY --from=setup /opt/sensorDb/device_sensor_profiles.sql /docker-entrypoint-initdb.d/11_add_device_defaults.sql

# We need absolute path here
RUN sed -i 's@device_sensor_profiles.csv@/docker-entrypoint-initdb.d/device_sensor_profiles.csv@' /docker-entrypoint-initdb.d/11_add_device_defaults.sql

COPY ./SQL/4_modify.sql /docker-entrypoint-initdb.d/4_modify.sql
