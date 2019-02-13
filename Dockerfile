# Dockerfile
FROM python:2.7

RUN apt-get update && apt-get install -y python-pdal

RUN git clone --recurse-submodules https://github.com/audaciouscode/Web-Historian-Server.git /app
# WORKDIR /app/passive_data_kit
# RUN git checkout 55bb567cbbb5068a5ca14dcf91a537db537f284f

WORKDIR /app
COPY local_settings.py /app/historian/local_settings.py

WORKDIR /app/
RUN sed -i -e 's/futures/#futures/g' requirements.txt # There is a problem with this Python package. Solve later.
RUN pip install -r requirements.txt

WORKDIR /app/passive_data_kit
RUN sed -i -e 's/futures/#futures/g' requirements.txt # There is a problem with this Python package. Solve later.
RUN pip install -r requirements.txt

WORKDIR /app

EXPOSE 8000
