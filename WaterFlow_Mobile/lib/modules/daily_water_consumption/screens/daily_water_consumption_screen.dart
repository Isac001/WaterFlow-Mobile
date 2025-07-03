import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/controllers/daily_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/models/daily_water_consumption_models.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/icon_button_widget.dart';
import 'package:waterflow_mobile/widgets/pizza_water_consumption.dart';
import 'package:waterflow_mobile/widgets/paged_list_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

// This screen displays a paginated list of daily water consumption records.
class DailyWaterConsumptionScreen extends StatefulWidget {
  const DailyWaterConsumptionScreen({super.key});

  @override
  State<DailyWaterConsumptionScreen> createState() =>
      _DailyWaterConsumptionScreenState();
}

class _DailyWaterConsumptionScreenState
    extends State<DailyWaterConsumptionScreen> {
  // Get an instance of the controller to manage state and data fetching.
  final DailyWaterConsumptionController _dailyWaterConsumptionController =
      Get.find<DailyWaterConsumptionController>();

  @override
  Widget build(BuildContext context) {
    // Define screen dimensions for a responsive UI.
    final screenSize = MediaQuery.of(context).size;
    // Variables for the decorative triangles in the background.
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;
    
    // Main structure of the screen.
    return Scaffold(
      // Use a Stack to layer the background art, the list, and the back button.
      body: Stack(
        children: [
          // Top-left decorative background triangles.
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: TriangleArtWidget(isTopCorner: true),
              child: Container(
                color: ThemeColor.secondaryColor,
                width: secondaryTriangleWidth,
                height: secondaryTriangleHeight,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: TriangleArtWidget(isTopCorner: true),
              child: Container(
                color: ThemeColor.primaryColor,
                width: primaryTriangleWidth,
                height: primaryTriangleHeight,
              ),
            ),
          ),
          // Main content area, padded and safe from system UI.
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.09, bottom: kPaddingLarge),
              child: _listDailyRegisters(),
            ),
          ),
          // Position the back button at the top left of the screen.
          MediaQuery(
            data: MediaQuery.of(context),
            child: Positioned(
              top: screenSize.height * 0.01,
              left: screenSize.width * 0.02,
              child: _exitButton(),
            ),
          )
        ],
      ),
    );
  }

  // Builds the paginated list of daily consumption records.
  Widget _listDailyRegisters() {
    // Uses a PagedListView to automatically handle pagination from the controller.
    return PagedListViewWidget(
      pagingController: _dailyWaterConsumptionController.pagingController,
      // This function builds each item (card) in the list.
      itemBuilder: (BuildContext context, dailyConsumption, int index) {
        final DailyWaterConsumptionModel dailyWaterConsumption =
            dailyConsumption;

        // Each record is displayed in a Card widget for clear separation.
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
                  // Column for the text information (date and total).
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
                  // A button on each card to open a details dialog.
                  IconButton(
                    icon: const Icon(Icons.incomplete_circle_rounded),
                    color: ThemeColor.whiteColor,
                    iconSize: 40,
                    onPressed: () {
                      // Shows a popup dialog using the GetX library.
                      Get.dialog(
                        _dialogPopup(dailyWaterConsumption)
                       
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // A private widget for the exit button.
  Widget _exitButton() {
    return IconButtonWidget(
      // Navigates back to the home screen when tapped.
      onTap: () {
        Get.toNamed('/home');
      },
      icon: Icon(Icons.arrow_back, size: Get.mediaQuery.size.height * 0.05),
      iconColor: ThemeColor.whiteColor,
    );
  }

  // Builds the content for the popup dialog that shows the consumption chart.
  Widget _dialogPopup(DailyWaterConsumptionModel dailyWaterConsumption) {
    // The main dialog window.
    return Dialog(
      // Custom styling for the dialog's appearance.
      child: Container(
        height: Get.mediaQuery.size.height * 0.5,
        padding: const EdgeInsets.all(kPaddingMedium),
        decoration: BoxDecoration(
          color: ThemeColor.whiteColor,
          borderRadius: BorderRadius.circular(kRadiusMedium),
        ),
        // Lays out the dialog content vertically.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displays the date as the title of the dialog.
            Text(
              dailyWaterConsumption.dateLabel.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: kFontsizeMedium,
                color: ThemeColor.primaryColor,
              ),
            ),
            // The pizza chart widget, expanded to fill available space.
            Expanded(
              child: PizzaWaterConsumptionGraph(
                title: '',
                consumedValue: dailyWaterConsumption.totalConsumption ?? 0.0,
                unit: 'L/m3',
              ),
            ),
            // A button to close the dialog.
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ThemeColor.primaryColor,
                foregroundColor: ThemeColor.whiteColor,
              ),
              child: const Text("Fechar"),
              onPressed: () {
                // Get.back() closes the current dialog or route.
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}