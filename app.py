#!/usr/bin/env python3
# coding: utf-8
# @2022-04-19 20:52:24
# vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4:

import requests
from flask import Flask, request
from paddleocr import PaddleOCR
from io import BytesIO
from PIL import Image
import numpy as np

app = Flask(__name__)
ocr = PaddleOCR(use_angle_cls=True, lang="ch", use_gpu=False)

@app.route('/ocr', methods=['PUT', 'POST'])
def ocr_text():
    img = request.files.get('img')
    if not img:
        img_url = request.form['imgurl']
        img = requests.get(img_url).content
        img = BytesIO(img)
    else:
        file_obj = BytesIO()
        img.save(file_obj)
        img = file_obj
    img = Image.open(img).convert('RGB')

    result = ocr.ocr(np.array(img), det=True, rec=True, cls=True)
    text = '\n'.join([i[1][0] for i in result])

    output_format = request.form.get('outtype', 'text')
    if output_format == 'text':
        return text
    ret = {'success': True, 'results': []}
    for each in result:
        item = {
            'confidence': each[1][1].item(),
            'text': each[1][0],
            'text_region': each[0]
            }
        ret['results'].append(item)
    return ret

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
