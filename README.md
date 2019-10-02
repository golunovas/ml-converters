# ml-converters
This repo was mainly created for keeping various ml model converters in one place. The core idea is to build all the dependencies inside docker images so they can be easily reused. 

#### Notes
- Depthwise conv support was added to onnx-tf. Please refer to my fork https://github.com/golunovas/onnx-tensorflow
- Several issues were fixed in tfjs-converter. My fork https://github.com/golunovas/tfjs-converter/tree/0.8.x
- The code wasn't tested well.

#### Building docker image
```
docker build -t ml_converter_image .
```
#### Optimize onnx model
```
docker run -it --rm -v "$(pwd)"/models:/models/ ml_converter_image optimize_onnx /models/model.onnx /models/optimized_model.onnx
```
#### onnx -> tf (frozen)
```
docker run -it --rm -v "$(pwd)"/models:/models/ ml_converter_image onnx-tf convert -i /models/model.onnx -o /models/model.onnx.pb
```
#### tf (frozen) -> tfjs (json)
```
docker run -it --rm -v "$(pwd)"/models:/models/ ml_converter_image tensorflowjs_converter --output_node_names="output" --input_format=tf_frozen_model --output_format=tensorflowjs --output_json=true /models/model.onnx.pb /models/model
# The model can be found in /models/model/model.json and /models/model/group(M)-shard(K)of(N)
```
