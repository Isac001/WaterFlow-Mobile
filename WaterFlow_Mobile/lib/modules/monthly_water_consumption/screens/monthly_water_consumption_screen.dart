import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/controllers/monthly_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/models/monthly_water_consumption_model.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/icon_button_widget.dart';
import 'package:waterflow_mobile/widgets/paged_list_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

/// A screen that displays a paginated list of monthly water consumption records.
class MonthlyWaterConsumptionScreen extends StatefulWidget {
  const MonthlyWaterConsumptionScreen({super.key});

  @override
  State<MonthlyWaterConsumptionScreen> createState() =>
      _MonthlyWaterConsumptionScreenState();
}

class _MonthlyWaterConsumptionScreenState
    extends State<MonthlyWaterConsumptionScreen> {
  // Finds the controller responsible for managing the state of this screen.
  final MonthlyWaterConsumptionController _monthlyWaterConsumptionController =
      Get.find<MonthlyWaterConsumptionController>();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to create a responsive UI.
    final screenSize = MediaQuery.of(context).size;
    // Define variables for the decorative triangles in the background.
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;
    
    return Scaffold(
      backgroundColor: ThemeColor.whiteColor,
      // Stack allows layering widgets, like placing content and buttons over a decorative background.
      body: Stack(
        children: [
          // These Positioned widgets create the decorative triangles in the top-left corner.
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
                height: primaryTriangleHeight,
                width: primaryTriangleWidth,
              ),
            ),
          ),
          // SafeArea ensures that the main content is not hidden by system UI (e.g., status bar).
          SafeArea(
            child: Padding(
              // Apply padding to position the list below the decorative triangles.
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.09, bottom: kPaddingLarge),
              // This helper method builds the main list view.
              child: _listMonthlyRegisters(),
            ),
          ),
          // This Positioned widget places the exit button at the top-left of the screen.
          Positioned(
              top: screenSize.height * 0.01,
              left: screenSize.width * 0.02,
              child: _exitButton(),
            ),
        ],
      ),
    );
  }

  /// Builds the paginated list of monthly consumption records.
  Widget _listMonthlyRegisters() {
    // Uses a custom PagedListViewWidget to handle infinite scrolling.
    return PagedListViewWidget(
      // The controller that manages fetching pages and list state.
      pagingController: _monthlyWaterConsumptionController.pagingController,
      // Defines how to build each item in the list.
      itemBuilder: (BuildContext context, monthlyConsumption, int index) {
        final MonthlyWaterConsumptionModel monthlyWaterConsumptionModel =
            monthlyConsumption;

        return Padding(
          padding: const EdgeInsets.all(kPaddingMedium),
          // Each item is a Card for better visual separation.
          child: Card(
            // Using a ValueKey helps Flutter efficiently update the list.
            key: ValueKey(monthlyConsumption.id),
            color: ThemeColor.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingMedium, vertical: kPaddingSM),
              // A Row arranges the text content and the details button horizontally.
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // The Expanded widget ensures the text column takes up all available space.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Displays the date label for the month.
                        Text(
                          monthlyWaterConsumptionModel.dateLabel.toString(),
                          maxLines: 3,
                          style: const TextStyle(
                              color: ThemeColor.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsizeMedium),
                        ),
                        const SizedBox(height: 8),
                        // Displays the total consumption for the month.
                        Text(
                          'Total consumed: ${monthlyWaterConsumptionModel.totalConsumption.toString()} Lm3',
                          maxLines: 6,
                          style: const TextStyle(
                            color: ThemeColor.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Button to navigate to the detailed graph view for this specific month.
                  IconButton(
                    onPressed: () {
                      // Navigates to the detail screen, passing the month's ID and title as arguments.
                      Get.toNamed('/monthlyDetail', arguments: {
                        'id': monthlyWaterConsumptionModel.id,
                        'title': monthlyWaterConsumptionModel.dateLabel ??  'Detailed Consumption'
                      });
                      
                    },
                    icon: const Icon(Icons.stacked_line_chart_outlined),
                    color: ThemeColor.whiteColor,
                    iconSize: Get.mediaQuery.size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// A private helper widget that builds the back/exit button.
  Widget _exitButton() {
    return IconButtonWidget(
      // When tapped, navigates the user back to the home screen.
      onTap: () {
        Get.toNamed('/home');
      },
      icon: Icon(
        Icons.arrow_back,
        size: Get.mediaQuery.size.height * 0.05,
      ),
      iconColor: ThemeColor.whiteColor,
    );
  }
}