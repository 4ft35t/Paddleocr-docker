PADDLE_VER=$(cat version.txt)

tag=$PADDLE_VER
tag_noavx=${tag}-noavx

sudo docker build -t c403/paddleocr:$tag .
sudo docker tag c403/paddleocr:$tag c403/paddleocr:latest

sudo docker build -f Dockerfile-noavx --build-arg PADDLE_VER=$PADDLE_VER -t c403/paddleocr:$tag_noavx .
sudo docker tag c403/paddleocr:$tag_noavx c403/paddleocr:latest-noavx

sudo docker push c403/paddleocr:$tag
sudo docker push c403/paddleocr:$tag_noavx
sudo docker push c403/paddleocr:latest
sudo docker push c403/paddleocr:latest-noavx
