import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:flutter/material.dart';

import '../services/navigation_service.dart';

class ForceUpdateScreen extends StatelessWidget {
  final String storeUrl;

  const ForceUpdateScreen({Key? key, required this.storeUrl}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.system_update, size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              Text(
                LangText(context).local.avaliable_update,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
               Text(
               LangText(context).local.please_update_to_continue,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed:() => NavigationService.handleUrls(storeUrl, context),
                child:  Text(LangText(context).local.update_now_ucf),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
