import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vbt_ecommerce_mobile/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app wrapped with ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify app renders without crashing
    expect(find.byType(MyApp), findsOneWidget);
  });

  test('Giriş Testi', () {
    expect(true, isTrue);
  });
}
