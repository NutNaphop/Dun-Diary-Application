import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_vision/flutter_vision.dart';

class ModelService {
  late FlutterVision _vision;
  bool _isLoaded = false;
  
  ModelService._() {
    _vision = FlutterVision();
  }

  static final ModelService instance = ModelService._();

  Future<void> loadModel() async {
    try {
      if (_isLoaded) return;

      await _vision.loadYoloModel(
        labels: 'assets/models/labels.txt',
        modelPath: 'assets/models/weights_float32.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 2,
        useGpu: false,
      );

      _isLoaded = true;
    } catch (e) {
      print("Error");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> runInference(File imageFile) async {
    if (!_isLoaded) await loadModel();

    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      final result = await _vision.yoloOnImage(
        bytesList: imageBytes,
        imageHeight: 640,
        imageWidth: 640,
        iouThreshold: 0.5,
        confThreshold: 0.5,
        classThreshold: 0.5,
      );
      return result;
    } catch (e) {
      print("Error");
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      await _vision.closeYoloModel();
      _isLoaded = false;
      print("Model Closed");
    } catch (e) {
      print("Error closing model: $e");
    }
  }
}
