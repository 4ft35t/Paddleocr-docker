PADDLE_VER=$(cat version.txt)

tag=$PADDLE_VER
tag_noavx=${tag}-noavx

sudo docker build -t c403/paddleocr:$tag .

cat <<EOF > Dockerfile-noavx
FROM c403/paddleocr:$tag

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget python3-pip \
    && wget --directory-prefix /tmp/ https://paddle-wheel.bj.bcebos.com/${PADDLE_VER}/linux/linux-cpu-mkl-noavx/paddlepaddle-${PADDLE_VER}-cp38-cp38-linux_x86_64.whl \
    && pip install --force-reinstall /tmp/paddlepaddle-${PADDLE_VER}-cp38-cp38-linux_x86_64.whl
RUN apt-get -y remove wget python3-pip \
    && apt-get -y install --no-install-recommends python3-setuptools \
    && apt-get -y autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /root/.cache /tmp/*

CMD ["python3", "/app.py"]
EOF

sudo docker build -f Dockerfile-noavx -t c403/paddleocr:$tag_noavx .
