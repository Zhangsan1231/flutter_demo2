import 'package:get/get.dart';

import '../controllers/ai_ring_controller.dart';

class AiRingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiRingController>(
      () => AiRingController(),
    );
  }
}
