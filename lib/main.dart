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
  Widget? _renderWidget;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  void _fetchImage() async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    const ImageProvider imageProvider = AssetImage('assets/images/apple.png');
    imageProvider
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer.complete(info);
      final ImageInfo imageInfo = await completer.future;

      _image1 = imageInfo.image;
    }));

    final Completer<ImageInfo> completer1 = Completer<ImageInfo>();
    const ImageProvider imageProvider1 = AssetImage('assets/images/orange.png');
    imageProvider1
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer1.complete(info);
      final ImageInfo imageInfo1 = await completer1.future;
      _image2 = imageInfo1.image;
    }));

    final Completer<ImageInfo> completer2 = Completer<ImageInfo>();
    const ImageProvider imageProvider2 = AssetImage('assets/images/pears.png');
    imageProvider2
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      completer2.complete(info);
      final ImageInfo imageInfo2 = await completer2.future;

      _image3 = imageInfo2.image;
      if (mounted) {
        setState(() {});
      }
    }));
  }

  List<_ChartShaderData> _buildChartData() {
    return <_ChartShaderData>[
      _ChartShaderData(
        'Apple',
        45,
        '45%',
        ui.ImageShader(
          _image1!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
      _ChartShaderData(
        'Orange',
        30,
        '30%',
        ui.ImageShader(
          _image2!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
      _ChartShaderData(
        'Pears',
        25,
        '25%',
        ui.ImageShader(
          _image3!,
          TileMode.repeated,
          TileMode.repeated,
          Matrix4.identity().scaled(0.5).storage,
        ),
      ),
    ];
  }

  PieSeries<_ChartShaderData, String> _buildPieSeries() {
    return PieSeries<_ChartShaderData, String>(
      dataSource: _buildChartData(),
      xValueMapper: (_ChartShaderData data, int index) => data.x,
      yValueMapper: (_ChartShaderData data, int index) => data.y,
      strokeColor: Colors.deepPurple.shade400,
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
            color: Colors.deepPurple.shade400,
            width: 2,
            length: '15%',
            type: ConnectorType.line,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.deepPurple.shade400,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_image1 != null && _image2 != null && _image3 != null) {
      _renderWidget = SfCircularChart(
        title: ChartTitle(
          text: 'Sales comparison of fruits in a shop',
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
