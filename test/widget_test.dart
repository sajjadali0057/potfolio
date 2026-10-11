import 'package:flutter_test/flutter_test.dart';
import 'package:sajjad_ali_portfolio/app/app.dart';
import 'package:sajjad_ali_portfolio/app/di/injection_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await configureDependencies();
  });

  testWidgets('home renders developer headline', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.textContaining('Engineering reliable'), findsOneWidget);
    expect(find.text('Work'), findsWidgets);
  });
}
