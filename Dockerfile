FROM ubuntu:20.04

EXPOSE 5000
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive
COPY app.py /
COPY requirements.txt /tmp

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y python3 python3-pip libgomp1 libglib2.0-0 libsm6 libxrender1 libxext6 \
    && pip install -r /tmp/requirements.txt -i https://pypi.doubanio.com/simple
RUN apt-get -y remove python3-pip \
    && apt-get -y autoremove \
    && apt-get -y install --no-install-recommends python3-setuptools \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /root/.cache /tmp/*

CMD ["python3", "/app.py"]
