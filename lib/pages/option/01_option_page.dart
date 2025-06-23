import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../define/define.dart';
import '../../utils/util.dart';
import '../../components/appSnackbar.dart';

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

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'idlepoe@gmail.com',
      query: Uri.encodeFull(
        'subject=OfficeLounge 앱 문의&body=안녕하세요.\n\n문의사항:\n\n\n\n---\n앱 버전: $_appVersion\n기기 정보: ${Theme.of(context).platform}',
      ),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        AppSnackbar.error('이메일 앱을 실행할 수 없습니다.');
      }
    } catch (e) {
      AppSnackbar.error('이메일 앱 실행 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "옵션",
          style: const TextStyle(
            color: Color(0xFF191F28),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF191F28)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 앱 정보 섹션
            _buildSection(
              title: "앱 정보",
              children: [
                _buildOptionTile(
                  icon: LineIcons.appStore,
                  title: "버전",
                  subtitle: _appVersion,
                  showArrow: false,
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: LineIcons.info,
                  title: "라이선스",
                  subtitle: "오픈소스 라이선스",
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return LicensePage(
                            applicationName: "오피스 라운지",
                            applicationVersion: _appVersion,
                            applicationIcon: Image.asset('assets/icon_it.png'),
                            applicationLegalese: "",
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 사용자 관리 섹션
            _buildSection(
              title: "사용자 관리",
              children: [
                _buildOptionTile(
                  icon: LineIcons.userSlash,
                  title: "차단한 사용자",
                  subtitle: "차단한 사용자 목록 및 해제",
                  onTap: () {
                    Get.toNamed("/blocked-users");
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 법적 정보 섹션
            _buildSection(
              title: "법적 정보",
              children: [
                _buildOptionTile(
                  icon: LineIcons.userShield,
                  title: "개인정보처리방침",
                  subtitle: "개인정보 수집 및 이용에 대한 안내",
                  onTap: () {
                    Get.toNamed("/privacy-policy");
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 개발자 정보 섹션
            _buildSection(
              title: "개발자 정보",
              children: [
                _buildOptionTile(
                  icon: LineIcons.user,
                  title: "개발자",
                  subtitle: "jylee",
                  showArrow: false,
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: LineIcons.envelope,
                  title: "문의하기",
                  subtitle: "idlepoe@gmail.com",
                  onTap: _launchEmail,
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0064FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0064FF), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF191F28),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        trailing:
            showArrow
                ? const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF9CA3AF),
                  size: 16,
                )
                : null,
        onTap: onTap,
      ),
    );
  }
}
