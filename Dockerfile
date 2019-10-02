# docker build -t ml_converter_image .
FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y software-properties-common apt-transport-https curl && \
  add-apt-repository ppa:jonathonf/python-3.6 && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv git curl yarn virtualenv && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs && \
  python3.6 -m pip install pip --upgrade && \
  python3.6 -m pip install wheel && \
  pip3 install torch torchvision onnx && \ 
  pip3 install git+https://github.com/golunovas/onnx-tensorflow.git && \
  cd /root && \ 
  git clone --single-branch --branch 0.8.x https://github.com/golunovas/tfjs-converter && \ 
  cd tfjs-converter/python && \ 
  pip3 install -r requirements.txt && \ 
  ./build-pip-package.sh build/ && \
  pip3 install build/tensorflowjs-0.8.6-py3-none-any.whl && \
  cd /root && rm -rf tfjs-converter && \ 
  pip3 install keras-preprocessing==1.0.2 keras-applications==1.0.4
COPY optimize_onnx /root
RUN chmod +x /root/optimize_onnx
ENV PATH="/root:${PATH}"