# Notice:
# When updating this file, please also update virtualization/Docker/Dockerfile.dev
# This way, the development image and the production image are kept in sync.

FROM python:3.7-stretch
LABEL maintainer="Paulus Schoutsen <Paulus@PaulusSchoutsen.nl>"

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_SSOCR no
#ENV INSTALL_DLIB no
#ENV INSTALL_IPERF3 no

VOLUME /config

WORKDIR /usr/src/app

# Copy build scripts
COPY virtualization/Docker/ virtualization/Docker/
RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop==0.12.2 cchardet cython tensorflow

# Copy source
COPY . .

EXPOSE 8123
EXPOSE 8300
EXPOSE 51827

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
