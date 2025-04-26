import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/context_ex.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/home.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/time_circular_container.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/time_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FlashSale extends StatelessWidget {
  const FlashSale({super.key, required this.iscircle});
   final bool iscircle;

  @override

  Widget build(BuildContext context) {
    if(homeData.flashDeal == null) return const SizedBox();
    return Column(
      children: [
        GestureDetector(
          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FlashDealList();
          }));},
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 10, 10),
                  child: Text(AppLocalizations.of(context)!.flash_sale, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                  Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
              ],
            ),
          ),
        ),
        
        Center(
          child: ListenableBuilder(listenable: homeData,
           builder: (context, child) {
            return Container(
              width: context.isPhoneWidth ? double.maxFinite : 300,
              margin: context.isPhoneWidth ? null : const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color:  AppConfig.businessSettingsData.flashDealBgColor ?? const Color(0xFFF9F8F8),
                borderRadius: context.isPhoneWidth ? null : BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildTimerRow(homeData.flashDealRemainingTime),
                  const SizedBox(height: 15),
                  FlashBannerWidget(
                    bannerLink: homeData.flashDeal?.banner, 
                    slug: homeData.flashDeal!.slug,
                  ),
                  const SizedBox(height: 10),
                ],
            ));
          }),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
   String timeText(String val, {int default_length = 2}) {
    return val.padLeft(default_length, '0');
  }
  Widget buildTimerRow(CurrentRemainingTime time) {
    return Builder(
      builder: (context) {
        if(iscircle)  {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: SingleChildScrollView(
              child: Row(
                
                children: [
               const Spacer(),
               //const SizedBox(width: 20,),
                  TimeCircularContainer(
                    currentValue: time.days,
                  totalValue: 365,
                  timeText:timeText((time.days).toString(), default_length: 3),
                  timeType: LangText(context).local.days,),
                  const SizedBox(width: 10,),
                  TimeCircularContainer(
                    currentValue: time.hours,
                    totalValue: 24,
                    timeText:timeText((time.hours).toString(), default_length: 3),
                    timeType: LangText(context).local.hours,),
                    const SizedBox(width: 10,),
                  TimeCircularContainer(
                    currentValue: time.min,
                    totalValue: 60,
                    timeText:timeText((time.min).toString(), default_length: 2),
                    timeType: LangText(context).local.minutes,),
                    const  SizedBox(width: 15,),
                    TimeCircularContainer(
                      currentValue: time.sec,
                      totalValue: 60,
                      timeText:timeText((time.sec).toString(), default_length: 2),
                      timeType: LangText(context).local.seconds,),
                    const  SizedBox(width: 10,),
                    Flexible(
                      child: RichText(text: TextSpan(text:LangText(context).local.shop_more_ucf,
                       style: const TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 68, 71, 73),
                          ),
                          
                      children: const [
                        
                        WidgetSpan(
                          child:  Icon(
                            Icons.arrow_forward_outlined,
                            size: 10,
                            color: Color.fromARGB(255, 68, 71, 73),
                          ),
                        ),
                      ]
                       ),
                      
                      
                      ),
                      
                      
                      )
                    
                        
                //   Flexible(
                //     flex: 2,
                //   child: Row(
                //    // mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Flexible(
                //         flex: 2,
                //         child: Text(
                //           LangText(context).local.shop_more_ucf,
                //           //overflow: TextOverflow.clip, // عشان لو كبر الكلام
                //           style: const TextStyle(
                //             fontSize: 10,
                //             color: Color.fromARGB(255, 68, 71, 73),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 3),
                //       const Icon(
                //         Icons.arrow_forward_outlined,
                //         size: 10,
                //         color: Color.fromARGB(255, 68, 71, 73),
                //       ),
                //       const SizedBox(width: 10),
                //     ],
                //   ),
                // ),
              
            
                ],
              ),
            ),
          );
        }
        return Container(
          height: 35,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                RowTimeDataWidget(time: "${time.days}", timeType: LangText(context).local.days, isFirst: true),
                RowTimeDataWidget(time: "${time.hours}", timeType: LangText(context).local.hours),
                RowTimeDataWidget(time: "${time.min}", timeType: LangText(context).local.minutes),
                RowTimeDataWidget(time: "${time.sec}", timeType: LangText(context).local.seconds),
              ],
            ),
          ),
        );
      }
    );
  }
}