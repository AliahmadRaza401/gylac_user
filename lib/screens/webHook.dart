
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {

  String? paymentUrl;

  PaymentWebView({this.paymentUrl});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController? controller;



  @override
  void initState() {
    super.initState();
    print(' widget.paymentUrl'+ widget.paymentUrl!);
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment"),
        backgroundColor:  Color.fromRGBO(251, 176, 59,1),
        elevation: 0,),
      body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
        initialUrl:widget.paymentUrl,
         onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
          }




      ),
    );
  }
}
