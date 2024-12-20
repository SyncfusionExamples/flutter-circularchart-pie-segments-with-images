import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PieChart(),
      ),
    );
  }
}

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  PieChartState createState() => PieChartState();
}

class PieChartState extends State<PieChart> {
  ui.Image? _image1;
  ui.Image? _image2;
  ui.Image? _image3;
  ui.Image? _image4;
  Widget? _renderWidget;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  void _fetchImage() async {
    _image1 = await _loadImage('assets/images/instagram.png', [
      Colors.purple.withValues(alpha: 0.4),
      Colors.white,
    ]);
    _image2 = await _loadImage('assets/images/facebook.png', [
      Colors.indigo.withValues(alpha: 0.4),
      Colors.white,
    ]);
    _image3 = await _loadImage('assets/images/twitter.png', [
      Colors.blue.withValues(alpha: 0.4),
      Colors.white,
    ]);
    _image4 = await _loadImage('assets/images/snapchat.png', [
      Colors.yellow.withValues(alpha: 0.4),
      Colors.white,
    ]);

    if (mounted) {
      setState(() {});
    }
  }

  Future<ui.Image> _loadImage(
      String assetPath, List<Color> gradientColors) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream =
        AssetImage(assetPath).resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) async {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(info.image.width.toDouble(), info.image.height.toDouble()),
          gradientColors,
        );
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ),
        paint,
      );
      canvas.drawImage(info.image, Offset.zero, Paint());
      final ui.Image finalImage = await recorder
          .endRecording()
          .toImage(info.image.width, info.image.height);
      completer.complete(finalImage);
    }));
    return completer.future;
  }

  List<_ChartShaderData> _getChartData() {
    return <_ChartShaderData>[
      _ChartShaderData(
        'Instagram',
        42,
        '42%',
        ui.ImageShader(
          _image1!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
      _ChartShaderData(
        'Facebook',
        20,
        '20%',
        ui.ImageShader(
          _image2!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
      _ChartShaderData(
        'Twitter',
        15,
        '15%',
        ui.ImageShader(
          _image3!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
      _ChartShaderData(
        'Snapchat',
        23,
        '23%',
        ui.ImageShader(
          _image4!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
    ];
  }

  PieSeries<_ChartShaderData, String> _buildPieSeries() {
    return PieSeries<_ChartShaderData, String>(
      dataSource: _getChartData(),
      xValueMapper: (_ChartShaderData data, int index) => data.x,
      yValueMapper: (_ChartShaderData data, int index) => data.y,
      strokeColor: Colors.purple,
      strokeWidth: 2,
      explode: true,
      explodeAll: true,
      explodeOffset: '3%',
      radius: '63%',
      dataLabelMapper: (_ChartShaderData data, int index) => data.text,
      pointShaderMapper: (dynamic data, int index, Color color, Rect rect) =>
          data.shader,
      dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          connectorLineSettings: ConnectorLineSettings(
            color: Colors.purple,
            width: 2,
            length: '15%',
            type: ConnectorType.line,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_image1 != null &&
        _image2 != null &&
        _image3 != null &&
        _image4 != null) {
      _renderWidget = SfCircularChart(
        title: ChartTitle(
          text: 'Social Media App Usage in India',
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top,
        ),
        series: <PieSeries<_ChartShaderData, String>>[
          _buildPieSeries(),
        ],
      );
    } else {
      _renderWidget = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return _renderWidget!;
  }

  @override
  void dispose() {
    _image1 = null;
    _image2 = null;
    _image3 = null;
    _image4 = null;

    super.dispose();
  }
}

class _ChartShaderData {
  _ChartShaderData(this.x, this.y, this.text, this.shader);

  final String x;
  final num y;
  final String text;
  final Shader shader;
}
