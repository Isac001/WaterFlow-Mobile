import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/controllers/bimonthly_water_consumption_controller.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/lines_graph_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

/// A screen that displays a detailed graph of monthly consumption for a specific bimonthly period.
class BimonthlyDetailGraphScreen extends StatelessWidget {
  /// Default constructor for the screen widget.
  const BimonthlyDetailGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Finds the existing instance of the bimonthly controller provided by GetX.
    final BimonthlyWaterConsumptionController bimonthlyWaterConsumptionController =
        Get.find<BimonthlyWaterConsumptionController>();
           
    // Retrieves arguments (like ID and title) passed from the previous screen.
    final Map<String, dynamic> arguments = Get.arguments;
    final String bimonthlyId = arguments['id'];
    final String title = arguments['title'];

    // Gets screen dimensions to create a responsive UI layout.
    final screenSize = MediaQuery.of(context).size;
    
    // Defines variables for the decorative triangles in the background.
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      // The body uses a Stack to layer widgets on top of each other (e.g., background art and main content).
      body: Stack(
        children: [
           // This is the larger, secondary triangle for the background decoration.
           Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              // Uses a custom clipper to create the triangle shape.
              clipper: TriangleArtWidget(isTopCorner: true),
              child: Container(
                color: ThemeColor.secondaryColor,
                width: secondaryTriangleWidth,
                height: secondaryTriangleHeight,
              ),
            ),
          ),
          // This is the smaller, primary triangle that sits on top of the secondary one.
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

          // SafeArea ensures the content is not obscured by system UI (like notches or status bars).
          SafeArea(
            child: Center(
              // A SizedBox constrains the graph to a specific portion of the screen.
              child: SizedBox(
                height: Get.mediaQuery.size.height * 0.6,
                width: Get.mediaQuery.size.width * 0.9,
                // FutureBuilder handles asynchronous data fetching and displays UI based on the connection state.
                child: FutureBuilder<List<ChartPoint>>(
                  // The future that fetches and prepares the data for the graph.
                  future: bimonthlyWaterConsumptionController
                      .fetchAndProcessGraphData(bimonthlyId),
                  // The builder function defines what to show based on the future's state.
                  builder: (context, snapshot) {
                    // Shows a loading indicator while data is being fetched.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Shows an error message if the data fetch fails.
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading data: ${snapshot.error}', // Error message in English
                          style: const TextStyle(
                              color: ThemeColor.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsizeLarge),
                        ),
                      );
                    }

                    // Shows a message if no data is available after a successful fetch.
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Data Found!', // Message in English
                          style: TextStyle(
                              color: ThemeColor.secondaryColor,
                              fontSize: kFontsizeLarge,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    
                    // When data is ready, it displays the custom line graph widget.
                    return LinesGraphWidget(
                        title: title, dataPoints: snapshot.data!);
                  },
                ),
              ),
            ),
          ),
          // Positions the exit button at the top-left of the screen.
          Positioned(
              top: screenSize.height * 0.01,
              left:  screenSize.width * 0.02,
              child: _exitButton(),
            ),
        ],
      ),
    );
  }

  /// A private helper widget that builds the back button.
  Widget _exitButton() {
    return IconButton(
      onPressed: () {
        // Navigates back to the previous screen using GetX.
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back,
        color: ThemeColor.whiteColor,
        // Sets the icon size responsively based on the screen height.
        size: Get.mediaQuery.size.height * 0.05,
      ),
    );
  }
}