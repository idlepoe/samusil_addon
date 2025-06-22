import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_lounge/define/define.dart';
import 'package:office_lounge/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../controllers/profile_controller.dart';
import 'appSnackbar.dart';

class ReportBottomSheet extends StatefulWidget {
  final Article article;

  const ReportBottomSheet({super.key, required this.article});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final List<String> _reportReasons = [
    '스팸/광고',
    '욕설/비방',
    '음란/선정적 내용',
    '개인정보 노출',
    '거짓 정보',
    '기타',
  ];
  String _selectedReason = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '게시글 신고하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '신고 사유를 선택해주세요',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  // 신고 사유 선택
                  Expanded(
                    child: Column(
                      children: [
                        ..._reportReasons.map(
                          (reason) => RadioListTile<String>(
                            title: Text(reason),
                            value: reason,
                            groupValue: _selectedReason,
                            onChanged: (value) {
                              setState(() {
                                _selectedReason = value ?? '';
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 상세 내용 입력
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '상세 내용 (선택사항)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: _reasonController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: '신고 사유에 대한 상세한 내용을 입력해주세요.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed:
                    _selectedReason.isEmpty || _isLoading
                        ? null
                        : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          '신고하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport() async {
    if (_selectedReason.isEmpty) {
      AppSnackbar.warning('신고 사유를 선택해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileController = ProfileController.to;
      final profile = profileController.profile.value;

      // Firestore에 신고 내용 저장
      final db = FirebaseFirestore.instance;
      final articleRef = db
          .collection(Define.FIRESTORE_COLLECTION_ARTICLE)
          .doc(widget.article.id);

      // 서브컬렉션에 신고 내용 저장
      await articleRef.collection('reports').add({
        'reporter_uid': profile.uid,
        'reporter_name': profile.name,
        'reason': _selectedReason,
        'detail': _reasonController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });

      // 게시글의 count_report +1
      await articleRef.update({'count_report': FieldValue.increment(1)});

      // SharedPreferences에 신고한 게시물 ID 저장
      final prefs = await SharedPreferences.getInstance();
      final reportedArticles = prefs.getStringList('reported_articles') ?? [];
      reportedArticles.add(widget.article.id);
      await prefs.setStringList('reported_articles', reportedArticles);

      Get.back();
      AppSnackbar.success('신고가 접수되었습니다.');
    } catch (e) {
      logger.e(e);
      AppSnackbar.error('신고 처리 중 오류가 발생했습니다.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
