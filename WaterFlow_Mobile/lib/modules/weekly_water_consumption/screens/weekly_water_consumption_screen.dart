import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/controllers/weekly_water_consumption_controller.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/models/weekly_water_consumption_model.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/icon_button_widget.dart';
import 'package:waterflow_mobile/widgets/paged_list_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

// Displays a list of weekly water consumption records.
class WeeklyWaterConsumptionScreen extends StatefulWidget {
  const WeeklyWaterConsumptionScreen({super.key});

  @override
  State<WeeklyWaterConsumptionScreen> createState() =>
      _WeeklyWaterConsumptionScreenState();
}

class _WeeklyWaterConsumptionScreenState
    extends State<WeeklyWaterConsumptionScreen> {
  // Get an instance of the controller to manage state and data fetching.
  final WeeklyWaterConsumptionController _weeklyWaterConsumptionController =
      Get.find<WeeklyWaterConsumptionController>();

  @override
  Widget build(BuildContext context) {
    // Define screen dimensions for a responsive UI.
    final screenSize = MediaQuery.of(context).size;
    // Variables for the decorative triangles in the background.
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      backgroundColor: ThemeColor.whiteColor,
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
                height: primaryTriangleHeight,
                width: primaryTriangleWidth,
              ),
            ),
          ),
          // Main content area, padded and safe from system UI.
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenSize.height * 0.09, bottom: kPaddingLarge),
              child: _listWeeklyRegisters(),
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

  // Builds the paginated list of weekly consumption records.
  Widget _listWeeklyRegisters() {
    // Uses a PagedListView to automatically handle pagination from the controller.
    return PagedListViewWidget(
      pagingController: _weeklyWaterConsumptionController.pagingController,
      // A custom builder for each item in the list.
      itemBuilder: (BuildContext context, weeklyConsumption, int index) {
        final WeeklyWaterConsumptionModel weeklyWaterConsumption =
            weeklyConsumption;

        // Each record is displayed in a Card widget for clear separation.
        return Padding(
          padding: const EdgeInsets.all(kPaddingSmall),
          child: Card(
            key: ValueKey(weeklyWaterConsumption.id),
            color: ThemeColor.primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingMedium, vertical: kPaddingSM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weeklyWaterConsumption.dateLabel.toString(),
                          maxLines: 3,
                          style: const TextStyle(
                              color: ThemeColor.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsizeMedium),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total consumido:  ${weeklyWaterConsumption.totalConsumption.toString()} Lm3',
                          maxLines: 6,
                          style: const TextStyle(
                            color: ThemeColor.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // This button navigates to the detail screen for the specific record.
                  IconButton(
                    onPressed: () {
                      // Navigates to the detail screen, passing the record's ID and title.
                      Get.toNamed(
                        '/weeklyDetail',
                        arguments: {
                          'id': weeklyWaterConsumption.id!,
                          'title': weeklyWaterConsumption.dateLabel ??
                              'Consumo Detalhado'
                        },
                      );
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

  // A private widget for the exit button.
  Widget _exitButton() {
    return IconButtonWidget(
      // Navigates back to the home screen when tapped.
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