import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';

class ModelService {
  YOLO? _yolo;
  Completer<void>? _loadingCompleter;
  late YOLOViewController controller;

  ModelService._();
  static final ModelService instance = ModelService._();

  Future<void> loadYOLO() async {
    if (_loadingCompleter != null) return _loadingCompleter!.future;
    _loadingCompleter = Completer<void>();

    try {
      final modelName = "yoloV8F_640_float16.tflite";
      final modelAssetPath = 'assets/models/$modelName';
      final tempDir = Directory.systemTemp;
      final modelFile = File('${tempDir.path}/$modelName');
      final modelData = await rootBundle.load(modelAssetPath);
      await modelFile.writeAsBytes(modelData.buffer.asUint8List());

      _yolo = YOLO(
        modelPath: modelFile.path,
        task: YOLOTask.detect,
        useGpu: false,
      );

      await _yolo!.loadModel();
      print("Loaded Model: $modelName");
      _loadingCompleter!.complete();
    } catch (e) {
      print("Error loading model: $e");
      _loadingCompleter!.completeError(e);
      _loadingCompleter = null; // Allow retry on next call
      rethrow;
    }
  }

  Future<List<dynamic>> predict(Uint8List image) async {
    await loadYOLO();
    final results = await _yolo!.predict(
      image,
      confidenceThreshold: 0.5,
      iouThreshold: 0.5,
    );
    return results['boxes'];
  }

  // dispose
  void dispose() {
    _yolo?.dispose();
    _loadingCompleter = null;
  }
}
