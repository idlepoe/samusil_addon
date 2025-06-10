import 'package:get/get.dart';

class HomeController extends GetxController {
  final isDragging = false.obs;

  void setDragging(bool value) {
    isDragging.value = value;
  }
}
