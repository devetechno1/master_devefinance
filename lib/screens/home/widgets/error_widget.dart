import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';
import '../../../custom/btn.dart';
import '../home_page_type_enum.dart';

class ErrorWidget extends StatefulWidget {
  final String? errorMessage;
  final bool? canPop;
  final void Function()? onTap;
  final bool? canGoHome;
  const ErrorWidget(
      {super.key, this.errorMessage, this.canPop, this.canGoHome, this.onTap});

  @override
  State<ErrorWidget> createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorWidget> {
  bool _goingUp = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop ?? false,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder(
                tween: Tween<Offset>(
                  begin: Offset(0, _goingUp ? 0 : -0.07),
                  end: Offset(0, _goingUp ? -0.07 : 0),
                ),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                onEnd: () {
                  setState(() {
                    _goingUp = !_goingUp;
                  });
                },
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: Offset(0, offset.dy * 100),
                    child: child,
                  );
                },
                child: Image.asset(AppImages.oops),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "oops".tr(context: context),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  widget.errorMessage ?? "some_things_went_wrong".tr(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              widget.onTap == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Btn.minWidthFixHeight(
                        minWidth: 250,
                        height: 30,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "try_again".tr(context: context),
                          //'close_all_capital'.tr(context: context),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: widget.onTap,
                      ),
                    ),
              if (widget.canGoHome == true)
                TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePageType.home.screen),
                      );
                    },
                    child: Text(
                      "go_home".tr(
                        context: context,
                      ),
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
