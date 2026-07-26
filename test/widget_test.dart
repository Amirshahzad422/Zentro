import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zentro_app/providers/cart_provider.dart';
import 'package:zentro_app/providers/wishlist_provider.dart';
import 'package:zentro_app/screens/cart.dart';
import 'package:zentro_app/screens/checkout.dart';
import 'package:zentro_app/styles/theme.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        theme: ZentroTheme.lightTheme,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('CartScreen renders correctly and shows empty state', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const CartScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Start Shopping'), findsOneWidget);
  });

  testWidgets('CheckoutScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const CheckoutScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Shipping Address'), findsOneWidget);
    expect(find.text('Delivery Method'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);
  });

  // Responsive layout tests
  testWidgets('CartScreen responsive layout - Desktop', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const CartScreen()));
    await tester.pumpAndSettle();

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
  
  testWidgets('CheckoutScreen responsive layout - Desktop', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const CheckoutScreen()));
    await tester.pumpAndSettle();

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
}
