import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../define/define.dart';
import '../../utils/util.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  var logger = Logger();
  int _languageIndex = 0;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _languageIndex = await Utils.getLanguage();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "option".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ListTile(
            //   leading: Icon(Icons.language),
            //   title: Text("language_change".tr),
            //   trailing: Text(("language_" + _languageIndex.toString()).tr),
            //   onTap: () async {
            //     _languageIndex = _languageIndex + 1;
            //     if (_languageIndex == 3) {
            //       _languageIndex = 0;
            //     }
            //     await Utils.setLanguage(_languageIndex);
            //     var locale = Locale('en', 'US');
            //     if (_languageIndex == 2) {
            //       locale = Locale('ja', 'JP');
            //     } else if (_languageIndex == 1) {
            //       locale = Locale('ko', 'KR');
            //     }
            //     Get.updateLocale(locale);
            //     setState(() {});
            //   },
            // ),
            ListTile(
              title: Text("privacy_policy".tr),
              leading: const Icon(LineIcons.userShield),
              onTap: () async {
                // await Navigator.of(context).push(SwipeablePageRoute(
                //   builder: (BuildContext context) => PrivacyPolicy(),
                // ));
                Get.toNamed("/privacy_policy");
              },
            ),
            ListTile(
              title: Text("license".tr),
              leading: const Icon(LineIcons.info),
              onTap: () async {
                // Navigator.of(context).push(
                //   SwipeablePageRoute(
                //     builder: (BuildContext context) => LicensePage(
                //       applicationName: "app_name".tr,
                //       applicationVersion: "1.0.0",
                //       applicationIcon: Image.asset('assets/icon_it.png'),
                //       applicationLegalese: "",
                //     ),
                //   ),
                // );
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LicensePage(
                        applicationName: "app_name".tr,
                        applicationVersion: "1.0.0",
                        applicationIcon: Image.asset('assets/icon_it.png'),
                        applicationLegalese: "",
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text("${"version".tr} : $_appVersion"),
              leading: const Icon(LineIcons.appStore),
              onTap: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
