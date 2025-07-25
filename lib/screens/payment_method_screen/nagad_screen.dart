import 'dart:convert';

import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/payment_repository.dart';
import 'package:active_ecommerce_cms_demo_app/screens/orders/order_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/main_helpers.dart';
import '../../helpers/shared_value_helper.dart';
import '../profile.dart';

class NagadScreen extends StatefulWidget {
  final double? amount;
  final String payment_type;
  final String? payment_method_key;
  final package_id;
  final int? orderId;
  const NagadScreen(
      {Key? key,
      this.amount = 0.00,
      this.orderId = 0,
      this.payment_type = "",
      this.package_id = "0",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _NagadScreenState createState() => _NagadScreenState();
}

class _NagadScreenState extends State<NagadScreen> {
  int? _combined_order_id = 0;
  bool _order_init = false;
  String? _initial_url = "";
  bool _initial_url_fetched = false;

  final WebViewController _webViewController = WebViewController();
    bool get goToOrdersScreen => widget.payment_type != "cart_payment" || _order_init;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.payment_type == "cart_payment") {
      createOrder();
    }

    if (widget.payment_type != "cart_payment") {
      // on cart payment need proper order id
      getSetInitialUrl();
    }
  }

  Future<void> createOrder() async {
    final orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(
        orderCreateResponse.message,
      );
      Navigator.of(context).pop(goToOrdersScreen);
      return;
    }

    _combined_order_id = orderCreateResponse.combined_order_id;
    _order_init = true;
    setState(() {});

    getSetInitialUrl();
  }

  Future<void> getSetInitialUrl() async {
    final nagadUrlResponse = await PaymentRepository().getNagadBeginResponse(
        widget.payment_type,
        _combined_order_id,
        widget.package_id,
        widget.amount,
        widget.orderId!);

    if (nagadUrlResponse.result == false) {
      ToastComponent.showDialog(
        nagadUrlResponse.message!,
      );
      Navigator.of(context).pop(goToOrdersScreen);
      return;
    }

    _initial_url = nagadUrlResponse.url;
    _initial_url_fetched = true;

    setState(() {});

    nagad();
    //print(_initial_url);
    //print(_initial_url_fetched);
  }

  nagad() {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onWebResourceError: (error) {
          //   Navigator.of(context).pop(goToOrdersScreen);
          // },
          // onHttpError: (error) {
          //   Navigator.of(context).pop(goToOrdersScreen);
          // },
          onPageFinished: (page) {
            if (page.contains("/nagad/verify/") ||
                page.contains('/check-out/confirm-payment/')) {
              getData();
            } else {
              if (page.contains('confirm-payment')) {
                print('yessssssss');
              } else {
                print('nooooooooo');
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_initial_url!), headers: commonHeader);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  void getData() {
    String? paymentDetails = '';
    _webViewController
        .runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var responseJSON = jsonDecode(data as String);
      if (responseJSON.runtimeType == String) {
        responseJSON = jsonDecode(responseJSON);
      }
      if (responseJSON["result"] == false) {
        ToastComponent.showDialog(
          responseJSON["message"],
        );
        Navigator.of(context).pop(goToOrdersScreen);
      } else if (widget.payment_type == "order_re_payment") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const OrderList(from_checkout: true);
        }));
      } else if (responseJSON["result"] == true) {
        paymentDetails = responseJSON['payment_details'];
        onPaymentSuccess(paymentDetails);
      }
    });
  }

  Future<void> onPaymentSuccess(paymentDetails) async {
    final nagadPaymentProcessResponse = await PaymentRepository()
        .getNagadPaymentProcessResponse(widget.payment_type, widget.amount,
            _combined_order_id, paymentDetails);

    if (nagadPaymentProcessResponse.result == false) {
      ToastComponent.showDialog(
        nagadPaymentProcessResponse.message!,
      );
      Navigator.of(context).pop(goToOrdersScreen);
      return;
    }

    ToastComponent.showDialog(
      nagadPaymentProcessResponse.message!,
    );
    if (widget.payment_type == "cart_payment") {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const OrderList(from_checkout: true);
      }));
    } else if (widget.payment_type == "wallet_payment") {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Wallet(from_recharge: true);
      }));
    } else if (widget.payment_type == "customer_package_payment") {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
        return const Profile();
      }));
    }
  }

  Widget? buildBody() {
    if (_order_init == false &&
        _combined_order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text('creating_order'.tr(context: context)),
        ),
      );
    } else if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text('fetching_nagad_url'.tr(context: context)),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebViewWidget(
            controller: _webViewController,
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
              app_language_rtl.$!
                  ? CupertinoIcons.arrow_right
                  : CupertinoIcons.arrow_left,
              color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(goToOrdersScreen),
        ),
      ),
      title: Text(
        'pay_with_nagad'.tr(context: context),
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
