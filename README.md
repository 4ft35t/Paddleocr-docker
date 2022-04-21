# Paddleocr-docker
run Paddleocr inside docker

Paddleocr 官方 docker 镜像体积高达 11G，本项目只为使用自带的官方模型做 ocr 识别，没有模型训练功能。

docker hub: https://hub.docker.com/r/c403/paddleocr

## 体积对比
官方的 https://registry.hub.docker.com/r/paddlepaddle/paddle/ 下载后 11G。

本项目体积
```bash
REPOSITORY       TAG           IMAGE ID       CREATED        SIZE
c403/paddleocr   2.2.2-noavx   8118af5b4709   10 hours ago   2.63GB
c403/paddleocr   2.2.2         d428e6ea1a2b   10 hours ago   1.98GB
ubuntu           20.04         ba6acccedd29   6 months ago   72.8MB
```

## 使用方法
`docker run -p 5000:5000 c403/paddleocr`

启动时会自动从官网 https://github.com/PaddlePaddle/PaddleOCR 下载 mobile 版模型库。
app.py 监听 5000 端口, 提供 API

__/ocr__
`method`: [POST, PUT]

Parameters:

- img - upload image file to ocr
- imgurl - download image from imgurl and ocr. when both with img, perfer `img`
- outtype – (optional) output format [text, json], default text

### ocr 样例
- 上传文件识别
  ` curl 127.0.0.1:5000/ocr -F img=@/tmp/img.png`
  返回结果
  > PHO CAPITAL
  > 107 state street
  > ...

- 从图片url识别, 并输出 json 格式
  `curl 127.0.0.1:5000/ocr -F imgurl=https://raw.githubusercontent.com/PaddlePaddle/PaddleOCR/release/2.4/doc/imgs_en/254.jpg -F outtype=json`

  json 格式
  ```json
  {
    "success": true,
    "results": [
      {"confidence":0.8821941018104553,"text":"PHO CAPITAL","text_region":[[67.0,50.0],[327.0,45.0],[327.0,76.0],[68.0,82.0]]},
      {"confidence":0.8678863048553467,"text":"107 state street","text_region":[[73.0,92.0],[452.0,85.0],[453.0,115.0],[74.0,122.0]]},
      ...
    ]
  }
  ```

## 群晖使用说明
群晖的 CPU 不支持 AVX(Advanced Vector Extensions) 指令集，选择有 `-noavx` 的 tag。

## 其它说明
本镜像中 API 只是简单运行，生产环境中使用请在前面套 gunicorn + nginx。
