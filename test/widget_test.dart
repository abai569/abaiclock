import 'package:flutter_test/flutter_test.dart';
import 'package:abaiclock/main.dart';

void main() {
  testWidgets('Clock app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // 验证标题存在
    expect(find.text('北京时间'), findsOneWidget);
  });
}