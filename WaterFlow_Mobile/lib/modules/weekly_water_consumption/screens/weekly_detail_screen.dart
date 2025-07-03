import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/controllers/weekly_water_consumption_controller.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/lines_graph_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

// Defines the screen that shows the details of weekly water consumption.
class WeeklyDetailScreen extends StatelessWidget {
  const WeeklyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get an instance of the controller using GetX for state management.
    final WeeklyWaterConsumptionController weeklyWaterConsumptionController =
        Get.find<WeeklyWaterConsumptionController>();
        
    // Get arguments (like ID and title) passed from the previous screen.
    final Map<String, dynamic> arguments = Get.arguments;
    final String weeklyId = arguments['id'];
    final String title = arguments['title'];

    // Define screen dimensions for a responsive UI layout.
    final screenSize = MediaQuery.of(context).size;
    
    // Variables for the decorative triangles in the background.
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      // Use a Stack to layer the background art, the graph, and the back button.
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
          
          // Use SafeArea to ensure content is not obscured by system UI (like notches).
          SafeArea(
            child: Center(
              // Use FutureBuilder to display data that will be fetched asynchronously.
              child: SizedBox(
                height: Get.mediaQuery.size.height * 0.6,
                width: Get.mediaQuery.size.width * 0.9,
                child: FutureBuilder<List<ChartPoint>>(
                  // The future that fetches and prepares the data for the graph.
                  future: weeklyWaterConsumptionController
                      .fetchAndProcessGraphData(weeklyId),
                  builder: (context, snapshot) {
                    // Show a loading indicator while data is being fetched.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Show an error message if the data fetch fails.
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                          style: const TextStyle(
                              color: ThemeColor.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: kFontsizeLarge),
                        ),
                      );
                    }

                    // Show a message if no data is available.
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum dado Encontrado!',
                          style: TextStyle(
                              color: ThemeColor.secondaryColor,
                              fontSize: kFontsizeLarge,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    
                    // When data is ready, display the line graph.
                    return LinesGraphWidget(
                        title: title, dataPoints: snapshot.data!);
                  },
                ),
              ),
            ),
          ),
          
          // Position the back button at the top left of the screen.
          MediaQuery(
            data: MediaQuery.of(context),
            child: Positioned(
              top: screenSize.height * 0.01,
              left:  screenSize.width * 0.02,
              child: _exitButton(),
            ),
          ),
        ],
      ),
    );
  }

  // A private widget for the exit button.
  Widget _exitButton() {
    return IconButton(
      onPressed: () {
        // Navigate back to the previous screen using GetX.
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back,
        color: ThemeColor.whiteColor,
        // Set icon size responsively based on screen height.
        size: Get.mediaQuery.size.height * 0.05,
      ),
    );
  }
}