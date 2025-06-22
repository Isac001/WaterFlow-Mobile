import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:waterflow_mobile/project_configs/websocket_config.dart';

// Class to configure the water flow service
class FlowReadingServiceConfig extends WebsocketConfig {
  // Variable responsible for updating the reading data
  final RxString timestamp = 'Waiting for data'.obs;
  final RxDouble flowRate = 0.0.obs;

  // Constructor
  FlowReadingServiceConfig() : super('ws/flow-reading/');

  // Call to the abstract function from the parent class
  @override
  void handleIncomingMessage(Map<String, dynamic> data) {

    // Logic to handle the water flow data
    if (data.containsKey('message')) {
      // Casts to Map type
      final messageData = data['message'] as Map<String, dynamic>?;

      if (messageData != null) {
        // Gets values from the map and converts them to string
        final rawTimestamp = messageData['times_tamp']?.toString() ?? 'N/A';
        final rawFlowRate = messageData['flow_rate'];

        // Updates the variable's state
        timestamp.value = rawTimestamp;

        // Parse the flowrate
        if (rawFlowRate != null) {
          flowRate.value = double.tryParse(rawFlowRate.toString()) ?? 0.0;
        } else {
          flowRate.value = 0.0;
        }

        // Else exception
      } else {
        timestamp.value = 'Error: Invalid data format';
        flowRate.value = 0.0;
      }
      // Else exception
    } else {
      timestamp.value = 'Error: Invalid data format';
      flowRate.value = 0.0;
    }
  }
}