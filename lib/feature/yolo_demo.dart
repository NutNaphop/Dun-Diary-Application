import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(YOLODemo());

class YOLODemo extends StatefulWidget {
  @override
  _YOLODemoState createState() => _YOLODemoState();
}

class _YOLODemoState extends State<YOLODemo> {
  YOLO? yolo;
  File? selectedImage;
  List<dynamic> results = [];
  bool isLoading = false;
  String? executionTime; // เก็บเวลาที่ใช้ประมวลผล

  // รายชื่อโมเดลที่มีใน Assets
  final Map<String, String> models = {
    "YOLOv8 Accuracy (Float16)": "yoloV8A_640_float16.tflite",
    "YOLOv8 Fast (Float16)": "yoloV8F_640_float16.tflite",
  };

  String selectedModelKey = "YOLOv8 Fast (Float16)"; // Default selection

  @override
  void initState() {
    super.initState();
    loadYOLO(models[selectedModelKey]!);
  }

  @override
  void dispose() {
    yolo?.dispose();
    super.dispose();
  }

  // ฟังก์ชันโหลดโมเดลตามชื่อไฟล์ที่ส่งมา
  Future<void> loadYOLO(String modelName) async {
    setState(() {
      isLoading = true;
      results = []; // ล้างผลลัพธ์เก่า
      executionTime = null;
    });

    try {
      // Dispose ตัวเก่าก่อนถ้ามี
      yolo?.dispose();

      final modelAssetPath = 'assets/models/$modelName';
      final metadataAssetPath = 'assets/models/metadata.yaml';

      final tempDir = Directory.systemTemp;
      final modelFile = File('${tempDir.path}/$modelName');
      final metadataFile = File('${tempDir.path}/metadata.yaml');

      final modelData = await rootBundle.load(modelAssetPath);
      await modelFile.writeAsBytes(modelData.buffer.asUint8List());

      if (modelName.contains("yolo26")) {
        try {
          final metadataData = await rootBundle.load(metadataAssetPath);
          await metadataFile.writeAsBytes(metadataData.buffer.asUint8List());
          print("Loaded metadata for YOLO26");
        } catch (e) {
          print("No metadata found for YOLO26, proceeding without it.");
        }
      }

      yolo = YOLO(
        modelPath: modelFile.path,
        task: YOLOTask.detect,
        useGpu: false
      );

      await yolo!.loadModel();
      print("Loaded Model: $modelName");
    } catch (e) {
      print("Error loading model: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading model: $e")));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> pickAndDetect() async {
    if (yolo == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        isLoading = true;
        results = [];
        executionTime = null;
      });

      // เริ่มจับเวลา
      final stopwatch = Stopwatch()..start();

      try {
        final imageBytes = await selectedImage!.readAsBytes();

        // Predict
        final detectionResults = await yolo!.predict(
          imageBytes,
          confidenceThreshold: 0.4, // ลดลงหน่อยเผื่อบางอัน confidence ต่ำ
          iouThreshold: 0.5,
        );

        stopwatch.stop(); // หยุดเวลา
        print("results: $detectionResults");
        if (mounted) {
          setState(() {
            // ดึงค่า boxes ออกมา
            var rawBoxes = detectionResults['boxes'] as List<dynamic>? ?? [];

            // กรองข้อมูลขยะ (สำหรับเคส YOLO26 ที่ค่าอาจจะเพี้ยน)
            results = rawBoxes.where((box) {
              final conf = box['confidence'] as double;
              return conf > 0.0 && conf <= 1.0; // เอาเฉพาะค่าที่ Make sense
            }).toList();

            // เรียงลำดับจากน้อยไปมากโดยใช้ top (y1) เป็นหลัก
            results.sort((a, b) {
              final y1A = (a['x1'] as num?)?.toDouble() ?? 0.0;
              final y1B = (b['x1'] as num?)?.toDouble() ?? 0.0;
              return y1A.compareTo(y1B);
            });

            executionTime = "${stopwatch.elapsedMilliseconds} ms";
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error during prediction: $e");
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dun Diary Model Test')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. ส่วนเลือกโมเดล (Dropdown)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedModelKey,
                    items: models.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(
                          key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != selectedModelKey) {
                        setState(() {
                          selectedModelKey = newValue;
                        });
                        loadYOLO(models[newValue]!); // โหลดโมเดลใหม่ทันที
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 2. แสดงรูปภาพ
              Expanded(
                flex: 2,
                child: selectedImage != null
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: Image.file(selectedImage!, fit: BoxFit.contain),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Center(child: Text("Select an image to test")),
                      ),
              ),

              SizedBox(height: 10),

              // 3. แสดงผลลัพธ์เวลาและจำนวนที่เจอ
              if (isLoading)
                CircularProgressIndicator()
              else ...[
                Text(
                  executionTime != null
                      ? "Time: $executionTime"
                      : "Ready to detect",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text('Detected Objects: ${results.length}'),
              ],

              SizedBox(height: 10),

              // ปุ่มกดเลือกรูป
              ElevatedButton.icon(
                onPressed: !isLoading ? pickAndDetect : null,
                icon: Icon(Icons.camera_alt),
                label: Text('Pick Image & Run Inference'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),

              Divider(),

              // 4. List แสดงค่า Confidence ของแต่ละกล่อง
              Expanded(
                flex: 2,
                child: results.isEmpty
                    ? Center(child: Text("No valid objects detected"))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final detection = results[index];
                          // แปลงค่าให้แสดงผลง่ายๆ
                          final conf = (detection['confidence'] * 100)
                              .toStringAsFixed(1);
                          final cls = detection['class'] ?? "Unknown";

                          final x1 = (detection['x1'] as num?)?.toInt() ?? 0;
                          final y1 = (detection['y1'] as num?)?.toInt() ?? 0;
                          final x2 = (detection['x2'] as num?)?.toInt() ?? 0;
                          final y2 = (detection['y2'] as num?)?.toInt() ?? 0;

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(cls.toString()),
                              ),
                              title: Text("Class ID: $cls"),
                              subtitle: Text("L: $x1, T: $y1, R: $x2, B: $y2"),
                              trailing: Text(
                                "$conf%",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
