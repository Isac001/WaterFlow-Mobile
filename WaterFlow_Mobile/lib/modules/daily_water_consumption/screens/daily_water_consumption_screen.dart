import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/controllers/daily_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/models/daily_water_consumption_models.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/daily_water_consumption_graph.dart';
import 'package:waterflow_mobile/widgets/paged_list_widget.dart';

// This is the screen that displays the daily water consumption list.
class DailyWaterConsumptionScreen extends StatefulWidget {
  const DailyWaterConsumptionScreen({super.key});

  @override
  State<DailyWaterConsumptionScreen> createState() =>
      _DailyWaterConsumptionScreenState();
}

class _DailyWaterConsumptionScreenState
    extends State<DailyWaterConsumptionScreen> {
  // Get the instance of the controller using GetX.
  final DailyWaterConsumptionController _dailyWaterConsumptionController =
      Get.find<DailyWaterConsumptionController>();

  @override
  Widget build(BuildContext context) {
    // Main structure of the screen.
    return Scaffold(
      // Top bar of the screen.
      appBar: AppBar(
        toolbarHeight: Get.mediaQuery.size.height * 0.1, // Dynamic height.
        centerTitle: true,
        backgroundColor: ThemeColor.primaryColor,
        elevation: 0,
        // Back button on the left.
        leading:  IconButton(
            onPressed: () {
              Get.toNamed('/home'); // Navigate to home screen.
            },
            iconSize: Get.mediaQuery.size.height * 0.050,
            icon: const Icon(Icons.keyboard_return_sharp, color: ThemeColor.redAccent),
          ),
        title: const Text(
          'Consumo Diário',
          style: TextStyle(
            color: ThemeColor.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
      ),
      // The body of the screen, which contains the paged list.
      body: PagedListViewWidget(
        // Connect the list to the controller.
        pagingController: _dailyWaterConsumptionController.pagingController,
        // This function builds each item (card) in the list.
        itemBuilder: (BuildContext context, dailyConsumption, int index) {
          final DailyWaterConsumptionModel dailyWaterConsumption =
              dailyConsumption;

          // Return a styled card for each consumption entry.
          return Padding(
            padding: const EdgeInsets.all(kPaddingSM),
            child: Card(
              color: ThemeColor.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMedium, vertical: kPaddingSM),
                // Lays out the card content horizontally.
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Column for the text information.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dailyWaterConsumption.dateLabel.toString(),
                          style: const TextStyle(
                              color: ThemeColor.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsizeMedium),
                        ),
                        Text(
                          'Total Consumidos: ${dailyWaterConsumption.totalConsumption.toString()} L/m3',
                          style: const TextStyle(
                              color: ThemeColor.whiteColor,
                              fontSize: kFontsizeStandard),
                        ),
                      ],
                    ),
                    // Button to show the chart dialog.
                    IconButton(
                      icon: const Icon(Icons.incomplete_circle_rounded),
                      color: ThemeColor.whiteColor,
                      iconSize: 40,
                      onPressed: () {
                        // Show a popup dialog when the button is pressed.
                        Get.dialog(
                          Dialog(
                            child: Container(
                              height: 350,
                              padding: const EdgeInsets.all(kPaddingMedium),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(kRadiusMedium),
                              ),
                              // Lays out the dialog content vertically.
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Date label as the dialog title.
                                  Text(
                                    dailyWaterConsumption.dateLabel.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: kFontsizeMedium,
                                      color: ThemeColor.primaryColor,
                                    ),
                                  ),
                                  // The chart widget, expanded to fill available space.
                                  Expanded(
                                    child: PizzaWaterConsumptionGraph(
                                      title: '',
                                      consumedValue: dailyWaterConsumption
                                              .totalConsumption ??
                                          0.0,
                                      unit: 'L/m3',
                                    ),
                                  ),
                                  // Button to close the dialog.
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: ThemeColor.primaryColor,
                                      foregroundColor: ThemeColor.whiteColor,
                                    ),
                                    child: const Text("Fechar"),
                                    onPressed: () {
                                      Get.back(); // Closes the dialog.
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          barrierDismissible: false, // User must press the button to close.
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}