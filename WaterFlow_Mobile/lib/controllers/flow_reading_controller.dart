import 'package:get/get.dart';
import 'package:waterflow_mobile/project_configs/flow_reading_service_config.dart';

/// Water flow reading controller
class FlowReadingController extends GetxController {
  // Variable calling the water flow reading service
  late final FlowReadingServiceConfig _flowReadingServiceConfig;

  // Getter that captures data from the service
  RxString get timestamp => _flowReadingServiceConfig.timestamp;
  RxDouble get flowRate => _flowReadingServiceConfig.flowRate;

  /// GETX LifeCycle
  // Initializing the service
  @override
  void onInit() {
    super.onInit();

    // Initializing the service inside the controller
    _flowReadingServiceConfig = FlowReadingServiceConfig();

    // Connecting to the websocket
    _flowReadingServiceConfig.connectWebSocket();
  }

  // Disconnecting from the websocket
  @override
  void onClose() {
    _flowReadingServiceConfig.disconnectWebSocket();
    super.onClose();
  }
}