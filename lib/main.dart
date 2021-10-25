import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_android/stripe_android.dart';
import 'my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51JNCsQR8ObOtZe763FSXayIqb5uAlHwJ9oLOdHi5iMmcyUCJDfrcNOcWYMwC450TpugJbPyU7aYOaUTIOBDc42j100rbFHkDKk';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Payment',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomeScreen(),
    );
  }
}
