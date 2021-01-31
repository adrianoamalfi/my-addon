ARG BUILD_FROM=homeassistant/amd64-base:latest
FROM $BUILD_FROM

ENV LANG C.UTF-8

ENV DJANGO_DB_NAME=default 
ENV DJANGO_SU_NAME=admin 
ENV DJANGO_SU_EMAIL=admin@example.com
ENV DJANGO_SU_PASSWORD=changeme 
ENV DJANGO_SETTINGS_MODULE=wooeyp.settings 

# Install requirements for add-on
RUN apk add --no-cache python3 py3-pip

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config


# Python 3 HTTP Server serves the current working dir
# So let's set it to our add-on persistent data directory.
WORKDIR /data

COPY requirements.txt /
RUN pip install -r /requirements.txt
COPY Procfile /app/Procfile
COPY start.sh /app/start.sh

ENTRYPOINT ["/app/start.sh"]
CMD ["start"]

LABEL io.hass.version="VERSION" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"
