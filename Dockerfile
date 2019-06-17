# Dockerfile

# The Passive Data Kit's development targets the latest Long Term Support (LTS) versions of Django. This Docker image contains Python version 2.7.
FROM python:2.7

# Passive Data Kit uses GeoDjango and the Postgres database's native GIS features to implement some location-based features used to support data quality monitoring and other analysis tools. This requires the python-pdal package.
# When a data export is requested in the Passive Data Kit server dashboard, a file is generated and e-mailed to the requester. This requires a mail application such as the sendmail package.
RUN apt-get update && apt-get install -y python-pdal sendmail

# The Web Historian version of the Passive Data Kit is included as a submodule in this repository and is copied onto the Docker image. To ensure the application continues to function in the future, a specific commit is fixed in the submodule.
COPY Web-Historian-Server/ /app/

# The local settings, which are not included in the Passive Data Kit repository and which contain information specific to the current setup, are copied into the main Django directory.
COPY local_settings.py /app/historian/local_settings.py

# Finally, all requirements, including Django version 1.11.20, are installed.
WORKDIR /app/passive_data_kit
RUN pip install -r requirements.txt

WORKDIR /app/
RUN pip install -r requirements.txt
