import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  // 设置全屏沉浸模式
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '北京时间',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFd4af37)),
        useMaterial3: true,
      ),
      home: const ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  DateTime _now = DateTime.now();
  Timer? _timer;
  bool _showDigital = true;
  bool _showAnalog = true;
  bool _showDate = true;
  bool _showWeekday = true;
  bool _showBrand = true;
  String _brandText = 'ANALOGUECLOCK';

  final List<String> _weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16213e),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 标题
                    const Text(
                      '北京时间',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color(0x44FFFFFF),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // 数字时间
                    if (_showDigital)
                      Text(
                        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}:${_now.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()],
                          shadows: [
                            Shadow(
                              color: Color(0x66FFFFFF),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    
                    // 模拟表盘
                    if (_showAnalog)
                      SizedBox(
                        width: 350,
                        height: 350,
                        child: CustomPaint(
                          painter: AnalogClockPainter(
                            now: _now,
                            showBrand: _showBrand,
                            brandText: _brandText,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    
                    // 日期和星期
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_showDate)
                          Text(
                            '${_now.year}年${_now.month}月${_now.day}日',
                            style: const TextStyle(
                              fontSize: 19,
                              color: Color(0x88FFFFFF),
                              letterSpacing: 2,
                            ),
                          ),
                        if (_showDate && _showWeekday)
                          const SizedBox(width: 12),
                        if (_showWeekday)
                          Text(
                            _weekdays[_now.weekday % 7],
                            style: const TextStyle(
                              fontSize: 19,
                              color: Color(0x88FFFFFF),
                              letterSpacing: 2,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 设置按钮
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white24, size: 24),
                  onPressed: () {
                    _showSettingsPanel();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0x99162162),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleItem('数字时间', _showDigital, (v) {
                setModalState(() => _showDigital = v);
                setState(() {});
              }),
              _buildToggleItem('模拟表盘', _showAnalog, (v) {
                setModalState(() => _showAnalog = v);
                setState(() {});
              }),
              _buildToggleItem('日期显示', _showDate, (v) {
                setModalState(() => _showDate = v);
                setState(() {});
              }),
              _buildToggleItem('星期显示', _showWeekday, (v) {
                setModalState(() => _showWeekday = v);
                setState(() {});
              }),
              _buildToggleItem('品牌标识', _showBrand, (v) {
                setModalState(() => _showBrand = v);
                setState(() {});
              }),
              const Divider(color: Colors.white12),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '自定义品牌标识',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                onChanged: (v) {
                  setModalState(() => _brandText = v);
                  setState(() {});
                },
                controller: TextEditingController(text: _brandText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        value: value,
        activeTrackColor: const Color(0xFFd4af37),
        onChanged: onChanged,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class AnalogClockPainter extends CustomPainter {
  final DateTime now;
  final bool showBrand;
  final String brandText;

  AnalogClockPainter({
    required this.now,
    required this.showBrand,
    required this.brandText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // 绘制表盘背景
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        colors: [const Color(0xFF2c3e50), const Color(0xFF0d0d10)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // 绘制金色边框 (6px)
    final borderPaint = Paint()
      ..color = const Color(0xFFcaa055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, borderPaint);

    // 绘制60个刻度线
    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * pi / 180;
      final isMajor = i % 5 == 0;
      
      final tickPaint = Paint()
        ..color = isMajor ? const Color(0xFFcaa055) : const Color(0x55caa055)
        ..strokeWidth = isMajor ? 2.5 : 1
        ..style = PaintingStyle.stroke;
      
      final innerRadius = radius - (isMajor ? 15 : 10);
      final outerRadius = radius - 5;
      
      final innerPoint = Offset(
        center.dx + innerRadius * cos(angle - pi/2),
        center.dy + innerRadius * sin(angle - pi/2),
      );
      final outerPoint = Offset(
        center.dx + outerRadius * cos(angle - pi/2),
        center.dy + outerRadius * sin(angle - pi/2),
      );
      
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // 绘制数字
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final x = center.dx + (radius - 50) * cos(angle);
      final y = center.dy + (radius - 50) * sin(angle);
      
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // 绘制品牌文字
    if (showBrand && brandText.isNotEmpty) {
      textPainter.text = TextSpan(
        text: brandText.toUpperCase(),
        style: const TextStyle(
          color: Color(0x20FFFFFF),
          fontSize: 12,
          letterSpacing: 3,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + radius * 0.3));
    }

    final hour = now.hour % 12;
    final minute = now.minute;
    final second = now.second;
    final millisecond = now.millisecond;

    // 时针 (粗圆角)
    final hourAngle = (hour * 30 + minute * 0.5) * pi / 180;
    _drawHand(canvas, center, radius * 0.26, hourAngle, 7, const Color(0xFFf1ebd9));

    // 分针
    final minuteAngle = (minute * 6 + second * 0.1) * pi / 180;
    _drawHand(canvas, center, radius * 0.38, minuteAngle, 5, const Color(0xFFf1ebd9));

    // 秒针 (细长，末端有圆点)
    final secondAngle = (second * 6 + millisecond * 0.006) * pi / 180;
    _drawSecondHand(canvas, center, radius * 0.52, secondAngle);

    // 中心铆钉 (金色圆环)
    final centerOuterPaint = Paint()..color = const Color(0xFFcaa055);
    canvas.drawCircle(center, 7.5, centerOuterPaint);
    
    final centerInnerPaint = Paint()..color = const Color(0xFF0d0d10);
    canvas.drawCircle(center, 2.5, centerInnerPaint);
  }

  void _drawHand(Canvas canvas, Offset center, double length, double angle, double width, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final endPoint = Offset(
      center.dx + length * sin(angle),
      center.dy - length * cos(angle),
    );
    
    canvas.drawLine(center, endPoint, paint);
  }

  void _drawSecondHand(Canvas canvas, Offset center, double length, double angle) {
    final paint = Paint()
      ..color = const Color(0xFFe0524c)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final endPoint = Offset(
      center.dx + length * sin(angle),
      center.dy - length * cos(angle),
    );
    
    canvas.drawLine(center, endPoint, paint);
    
    // 末端红色圆点
    final dotPaint = Paint()..color = const Color(0xFFe0524c);
    canvas.drawCircle(endPoint, 4.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant AnalogClockPainter oldDelegate) {
    return now.millisecond != oldDelegate.now.millisecond ||
           brandText != oldDelegate.brandText ||
           showBrand != oldDelegate.showBrand;
  }
}