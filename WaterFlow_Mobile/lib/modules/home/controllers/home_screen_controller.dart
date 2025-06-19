import 'package:get/get.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

/// Controller for the Home Screen
class HomeScreenController extends GetxController {

  // Variable can be used to store the user's timezone and current time
  final Rx<tz.TZDateTime?> currentTime = Rx<tz.TZDateTime?>(null);

  // Variable to store the formatted date
  final RxString formattedDate = ''.obs;

  // Variable to store the user's timezone location
  late tz.Location userLocation;

  // Timer to update the current time periodically
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _setupTimeZoneAndStartTime();

    ever(currentTime, (tz.TZDateTime? time) {
      if (time == null) {
        formattedDate.value = 'Carregando data...';
      } else {
        final DateFormat formatter = DateFormat.yMMMMd('pt_BR');
        formattedDate.value = formatter.format(time);
      }
    });
  }

  /// Method to clean up resources when the controller is closed
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Method to initialize the timezone and start the timer
  void _setupTimeZoneAndStartTime() {
    userLocation = tz.getLocation('America/Fortaleza');
    currentTime.value = tz.TZDateTime.now(userLocation);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = tz.TZDateTime.now(userLocation);
    });
  }
}
