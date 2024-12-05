import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class SensorValue {
  final DateTime time;
  final num value;

  SensorValue({required this.time, required this.value});

  Map<String, dynamic> toJSON() => {'time': time, 'value': value};

  static List<Map<String, dynamic>> toJSONArray(List<SensorValue> data) =>
      List.generate(data.length, (index) => data[index].toJSON());
}

// ignore: must_be_immutable
class HeartBPMDialog extends StatefulWidget {
  final Widget? centerLoadingWidget;
  final double? cameraWidgetHeight;
  final double? cameraWidgetWidth;
  final bool? showTextValues;
  final double? borderRadius;
  final void Function(int) onBPM;
  final void Function(SensorValue)? onRawData;
  final int sampleDelay;
  final BuildContext context;
  double alpha = 0.6;
  final Widget? child;

  HeartBPMDialog({
    Key? key,
    required this.context,
    this.sampleDelay = 2000 ~/ 30,
    required this.onBPM,
    this.onRawData,
    this.alpha = 0.8,
    this.child,
    this.centerLoadingWidget,
    this.cameraWidgetHeight,
    this.cameraWidgetWidth,
    this.showTextValues,
    this.borderRadius,
  });

  void setAlpha(double a) {
    if (a <= 0) throw Exception("Smoothing factor cannot be 0 or negative");
    if (a > 1) throw Exception("Smoothing factor cannot be greater than 1");
    alpha = a;
  }

  @override
  _HeartBPMDialogState createState() => _HeartBPMDialogState();
}

class _HeartBPMDialogState extends State<HeartBPMDialog> {
  CameraController? _controller;
  bool _processing = false;
  int currentValue = 0;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _deinitController();
    super.dispose();
  }

  void _deinitController() async {
    isCameraInitialized = false;
    if (_controller == null) return;
    await _controller!.dispose();
  }

  Future<void> _initController() async {
    if (_controller != null) return;
    try {
      List<CameraDescription> _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
      await _controller!.initialize();
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => _controller!.setFlashMode(FlashMode.torch));
      _controller!.startImageStream((image) {
        if (!_processing && mounted) {
          _processing = true;
          _scanImage(image);
        }
      });
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
      throw e;
    }
  }

  static const int windowLength = 50;
  final List<SensorValue> measureWindow = List<SensorValue>.filled(
      windowLength, SensorValue(time: DateTime.now(), value: 0),
      growable: true);

  void _scanImage(CameraImage image) async {
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;

    measureWindow.removeAt(0);
    measureWindow.add(SensorValue(time: DateTime.now(), value: _avg));

    _smoothBPM(_avg).then((value) {
      if (widget.onRawData != null) {
        widget.onRawData!(
          SensorValue(
            time: DateTime.now(),
            value: _avg,
          ),
        );
      }

      Future<void>.delayed(Duration(milliseconds: widget.sampleDelay))
          .then((onValue) {
        if (mounted) {
          setState(() {
            _processing = false;
          });
        }
      });
    });
  }

  Future<int> _smoothBPM(double newValue) async {
    double maxVal = 0, _avg = 0;

    measureWindow.forEach((element) {
      _avg += element.value / measureWindow.length;
      if (element.value > maxVal) maxVal = element.value as double;
    });

    double _threshold = (maxVal + _avg) / 2;
    int _counter = 0, previousTimestamp = 0;
    double _tempBPM = 0;
    for (int i = 1; i < measureWindow.length; i++) {
      if (measureWindow[i - 1].value < _threshold &&
          measureWindow[i].value > _threshold) {
        if (previousTimestamp != 0) {
          _counter++;
          _tempBPM += 60000 /
              (measureWindow[i].time.millisecondsSinceEpoch -
                  previousTimestamp);
        }
        previousTimestamp = measureWindow[i].time.millisecondsSinceEpoch;
      }
    }

    if (_counter > 0) {
      _tempBPM /= _counter;
      _tempBPM = (1 - widget.alpha) * currentValue + widget.alpha * _tempBPM;
      setState(() {
        currentValue = _tempBPM.toInt();
      });
      widget.onBPM(currentValue);
    }

    return currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isCameraInitialized
          ? Column(
              children: [
                Container(
                  constraints: BoxConstraints.tightFor(
                    width: widget.cameraWidgetWidth ?? 100,
                    height: widget.cameraWidgetHeight ?? 130,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 10),
                    child: _controller!.buildPreview(),
                  ),
                ),
                if (widget.showTextValues == true) ...{
                  Text(currentValue.toStringAsFixed(0)),
                } else
                  SizedBox(),
                widget.child == null ? SizedBox() : widget.child!,
              ],
            )
          : Center(
              child: widget.centerLoadingWidget != null
                  ? widget.centerLoadingWidget
                  : CircularProgressIndicator(),
            ),
    );
  }
}

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  List<int> data = [];
  int? bpmValue = 0;
  Timer? _timer;
  List<int> bpmValues = [];
  bool _countingDown = false; // Trạng thái đếm ngược

  void _startMeasurement() {
    setState(() {
      bpmValues.clear();
      bpmValue = 0;
      _countingDown = true;
    });

    _timer?.cancel();
    _timer = Timer(Duration(seconds: 15), () {
      if (bpmValues.isNotEmpty) {
        int sum = bpmValues.reduce((a, b) => a + b);
        setState(() {
          bpmValue = (sum / bpmValues.length).toInt();
          _countingDown = false;
        });
        _showResultDialog(bpmValue!);
      }
    });
  }

  void _cancelMeasurement() {
    _timer?.cancel();
    setState(() {
      _countingDown = false;
    });
  }

  void _showResultDialog(int bpmValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Kết quả đo nhịp tim',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Màu sắc chữ cho tiêu đề
            ),
          ),
          content: Text(
            '$bpmValue bpm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.red, // Màu sắc chữ cho nội dung
            ),
          ),
          titlePadding: EdgeInsets.all(20), // Khoảng cách giữa tiêu đề và lề
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20), // Khoảng cách giữa nội dung và lề
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SensorValue> rawData = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Đo nhịp tim'),
        backgroundColor: Colors.blue[900], // Màu sắc nền cho thanh tiêu đề
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Đo nhịp tim",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Màu sắc chữ cho tiêu đề
                ),
              ),
              SizedBox(height: 20),
              Icon(Icons.favorite, color: Colors.red, size: 64),
              SizedBox(height: 20),
              HeartBPMDialog(
                context: context,
                onRawData: (value) {
                  setState(() {
                    if (rawData.length == 100) rawData.removeAt(0);
                    rawData.add(value);
                  });
                },
                onBPM: (value) => setState(() {
                  bpmValues.add(value);
                }),
                child: Text(
                  bpmValue?.toString() ?? "-",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                showTextValues: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _countingDown ? _cancelMeasurement : _startMeasurement,
                child: Text(_countingDown ? "Dừng lại" : "Bắt đầu đo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _countingDown
                      ? Colors.red
                      : Colors.blue[900], // Màu sắc nút
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
