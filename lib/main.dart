import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swychr_link/PaymentWebScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // On Android use the hybrid composition (Surface) implementation:

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swychr Payment WebView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Payment Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _paymentLinkController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final transactionId = _transactionIdController.text.trim();
      final paymentLink = _paymentLinkController.text.trim();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
              PaymentWebScreen(uri: Uri.parse(paymentLink),  transactionId: transactionId, afterPaymentBehaviour: AfterPaymentBehaviour.None,)));


      _transactionIdController.clear();
      _paymentLinkController.clear();
    }
  }

  AppBar _appBar(BuildContext context) {
    const _name = "User";
    return AppBar(
      backgroundColor: Colors.purple,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundImage: const AssetImage("assets/images/avatar.png"),
          backgroundColor: Colors.white,
        ),
      ),
      title: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome",
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                _name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.verified, color: Colors.yellow),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.notifications_active_outlined, color: Colors.white),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF2F2),
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column( children: [
            Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Column(
                children: <Widget>[




                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Center(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('\u275D', style: const TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)), const Spacer()],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                              child: Text("The is sample app functionality to open the payment link in webview inside IOS as well as Android. This will take transaction id and payment_link as input and open the same in the webview", textAlign: TextAlign.center, style: const TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text('\u275E', style: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      )),

                  SizedBox(height: 10)


                ],
              ),
            ),
          ),
      Padding(
        padding: const EdgeInsets.only(
            left: 12, right: 12, top: 12, bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),

              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Payment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Transaction ID
                    TextFormField(
                      controller: _transactionIdController,
                      decoration: InputDecoration(
                        labelText: 'Transaction ID',
                        hintText: 'Enter transaction ID',
                        prefixIcon: const Icon(Icons.confirmation_number_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter transaction ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Payment Link
                    TextFormField(
                      controller: _paymentLinkController,
                      decoration: InputDecoration(
                        labelText: 'Payment Link',
                        hintText: 'Enter payment link (URL)',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter payment link';
                        } else if (!Uri.tryParse(value)!.isAbsolute) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Full-width button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        icon: const Icon(Icons.send),
                        label: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),)
            ),
          ),
          ]
        )),
    );
  }
}
