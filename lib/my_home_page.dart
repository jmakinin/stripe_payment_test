import 'dart:convert';

import 'package:flutter/src/foundation/print.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  var paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () async {
                  await makePayment();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: const Center(
                    child: Text('Pay'),
                  ),
                ))
          ]),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('20', 'eur');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'DE',
              merchantDisplayName: 'Advent Calendar'));

      displayPaymentSheet();
    } catch (e) {
      print('exception' + e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['client_secret'],
              confirmPayment: true));

      setState(() {
        paymentIntentData = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful, Thank you')));
    } on StripeException catch (e) {
      print(e.toString());
      //debugPrint = e.toString() as DebugPrintCallback;

      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Cancelled'),
              ));
    }

    // catch (e) {
    //   debugPrint = e.toString() as DebugPrintCallback;
    // }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      var body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var dio = Dio();
      var response = await dio.post('https://api.stripe.com/v1/payment_intents',
          data: body,
          options: Options(headers: {
            'Authorization':
                'Bearer sk_test_51JNCsQR8ObOtZe76B4eK5J3ASnKlFWtsYWBIyqJeOiMgUmljuRsjL6tbjBeLpTTVcCGvL6iETKc8YwbaTA6kNRl400YhhQunuK',
            'Content-Type': 'application/x-www-form-urlencoded'
          }));
      return jsonDecode(response.data.toString());
    } catch (e) {
      debugPrint = e.toString() as DebugPrintCallback;
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
