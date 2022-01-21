FROM python:3-alpine

WORKDIR /python

COPY . /python/

RUN mkdir /data
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "/python/entrypoint" ]