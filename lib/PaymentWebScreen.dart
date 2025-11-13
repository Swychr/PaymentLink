import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentResponse {
  final PaymentStatus status;
  final String? paymentId;
  final String? url;
  var request2;

  bool get isSuccess => status == PaymentStatus.Success;
  bool get isError => status == PaymentStatus.Error;
  bool get isNothing => status == PaymentStatus.None;

  PaymentResponse(this.status, {this.url, this.paymentId, this.request2});

  @override
  String toString() => "Status: $status | PaymentId: $paymentId";
}

enum AfterPaymentBehaviour {
  BeforeCallbackExecution,
  AfterCallbackExecution,
  None,
}

enum PaymentStatus { Success, Error, None }

class PaymentWebScreen extends StatefulWidget {
  final Uri uri;
  final String transactionId;
  final AfterPaymentBehaviour afterPaymentBehaviour;

  const PaymentWebScreen({
    Key? key,
    required this.uri,
    required this.transactionId,
    required this.afterPaymentBehaviour,
  }) : super(key: key);

  @override
  State<PaymentWebScreen> createState() => _PaymentWebScreenState();
}

class _PaymentWebScreenState extends State<PaymentWebScreen> {
  late final WebViewController _controller;
  double _progress = 0;
  bool _isLoading = true;
  PaymentResponse response = PaymentResponse(PaymentStatus.None);

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            _handleStart(Uri.parse(url));
          },
          onProgress: (progress) {
            setState(() => _progress = progress / 100);
          },
          onPageFinished: (url) {
            _handleStop(Uri.parse(url));
          },
          onWebResourceError: (error) {
            _handleError(Uri.parse(error.url!), error.description);
          },
        ),
      )
      ..loadRequest(widget.uri);
  }

  Future<bool> _onWillPop() async {
    final canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      _controller.goBack();
      return false;
    } else {
      Navigator.of(context).pop(response);
      return true;
    }
  }

  void _handleStart(Uri uri) {
    response = _getResponse(uri);
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCallbackExecution) {
      Navigator.of(context).pop(response);
    }
  }

  void _handleError(Uri uri, String message) {
    response = _getResponse(uri);
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCallbackExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _handleStop(Uri uri) async {
    response = _getResponse(uri);

    if (response.status == PaymentStatus.Error) {
      // await apiTransactionCancel(widget.transactionId);
      Navigator.of(context).pop(response);
    } else if (response.status == PaymentStatus.Success) {
      Navigator.of(context).pop(response);
      // navigate to success screen
      //Redirect to Success Scren
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => IntouchRechargeSuccessScreen(
      //       transactionId: widget.transactionId,
      //     ),
      //   ),
      // );
    } else {
      setState(() => _isLoading = false);
    }
  }

  PaymentResponse _getResponse(Uri uri) {
    final url = uri.toString();
    final isSuccess = url.contains("/callback");
    final isError = url.contains("cancelled");
    if (!isError && !isSuccess) {
      return PaymentResponse(PaymentStatus.None, url: url);
    }
    final status =
    isSuccess && !isError ? PaymentStatus.Success : PaymentStatus.Error;
    return PaymentResponse(status,
        paymentId: uri.queryParameters["paymentId"], url: url);
  }

  void _showCancelDialog() {
    AwesomeDialog(
      context: context,
      keyboardAware: true,
      dismissOnBackKeyPress: false,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      btnCancelText: 'Cancel',
      btnOkText: 'Confirm',
      title: 'Are you sure you want to proceed?',
      body: Center(
        child: Column(
          children: [
            const Text(
              "Transaction Decline Alert!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              "Are you sure you want to cancel the transaction?",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        //Call Cancel Transaction Api
        Navigator.of(context).pop();
      },
    ).show();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: _showCancelDialog,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          title: const Text(
            "Payment",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: false,
          elevation: 1.0,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_progress < 1)
              LinearProgressIndicator(value: _progress),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
