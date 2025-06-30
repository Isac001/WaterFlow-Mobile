import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/controllers/flow_reading_controller.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/menu_button_widget.dart';
import 'package:waterflow_mobile/widgets/radial_graph_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Calling the controller injected by GetX
  // final HomeScreenController _homeScreenController =
  //     Get.find<HomeScreenController>();

  final FlowReadingController _flowReadingController =
      Get.find<FlowReadingController>();

  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    // Screen size variable to get the screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      backgroundColor: ThemeColor.whiteColor,

      ///[TODO] Add the screens navigation
      // Adding the navigation bar with the button to switch between screens
      bottomNavigationBar: BottomAppBar(
        color: ThemeColor.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Button to daily report
            MenuButtonWidget(
              icon: Icons.water_damage_outlined,
              label: 'Diário',
              isSelected: true,
              onPressed: () {
                      Get.offNamed('/dailyWaterConsumption');

              },
            ),
            // Button to weekly report
            MenuButtonWidget(
              icon: Icons.water_damage_outlined,
              label: 'Semanal',
              isSelected: false,
              onPressed: () {},
            ),
            // Button to monthly report
            MenuButtonWidget(
              icon: Icons.water_damage_outlined,
              label: 'Mensal',
              isSelected: true,
              onPressed: () {},
            ),
            // Button to bimestral report
            MenuButtonWidget(
              icon: Icons.water_damage_outlined,
              label: 'Bimestral',
              isSelected: true,
              onPressed: () {},
            ),
            MenuButtonWidget(
              icon: Icons.person,
              label: 'Perfil',
              isSelected: true,
              onPressed: () {},
            )
          ],
        ),
      ),

      // Main body of the screen
      body: Stack(
        children: [
          // Positioning the background triangles
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: TriangleClipper(isTopCorner: true),
              child: Container(
                color: ThemeColor.secondaryColor,
                width: secondaryTriangleWidth,
                height: secondaryTriangleHeight,
              ),
            ),
          ),

          // Positioning the background triangles
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: TriangleClipper(isTopCorner: true),
              child: Container(
                color: ThemeColor.primaryColor,
                width: primaryTriangleWidth,
                height: primaryTriangleHeight,
              ),
            ),
          ),

          // Sefe area to avoid notches and system UI overlaps
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displaying the radial graph
                    _radialGrap(),
                    // Displaying the formatted date from the controller
                    _timestampText()
                  ],
                ),
              ),
            ),
          ),

          // Positioned logout button
          MediaQuery(
            data: MediaQuery.of(context),
            child: Positioned(
                top: MediaQuery.of(context).size.height * 0.01,
                right: MediaQuery.of(context).size.width * 0.02,

                // Logout button to exit the application
                child: _logoutButton()),
          ),

          ///[TODO] Add notification functionality
          // Positioned notification button
          MediaQuery(
            data: MediaQuery.of(context),
            child: Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              right: MediaQuery.of(context).size.width * 0.02,

              // Notification button to show notifications [TODO: Add notifications functionality]
              child: _notificationsButton()
            ),
          )
        ],
      ),
    );
  }

  Widget _timestampText() {
    return Obx(
      () => TextFormField(
        // The key is used to update the text field when the timestamp changes
        key: ValueKey(_flowReadingController.timestamp.value),
        initialValue: _flowReadingController.timestamp.value,
        enabled: false,

        // Setting the text style
        style: TextStyle(
          color: ThemeColor.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),

        // Setting the input decoration
        decoration: InputDecoration(
          labelText: 'Data e Hora da Leitura',
          labelStyle: TextStyle(
            color: ThemeColor.primaryColor,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: ThemeColor.primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kRadiusSmall),
              borderSide: BorderSide(
                  color: ThemeColor.primaryColor,
                  width: MediaQuery.of(context).size.width * 0.005)),
        ),
      ),
    );
  }

  Widget _radialGrap() {
    // Displaying the radial graph with the websocket data
    return Obx(
      () {
        return RadialGraphWidget(
            currentValue: _flowReadingController.flowRate.value);
      },
    );
  }

  Widget _logoutButton() {

    // Logout button to exit the application
    return IconButton(
      onPressed: () async {
        try {
          await _authController.logout();
          Get.offNamed('/login');
        } catch (e) {
          Get.snackbar(
            'Erro no Logout',
            'Não foi possível sair. Tente novamente.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },

      // Setting the icon
      icon: Icon(Icons.exit_to_app_outlined,
          color: ThemeColor.redAccent,
          size: MediaQuery.of(context).size.width * 0.12),
    );
  }

  Widget _notificationsButton() {

    // Notification button to show notifications [TODO: Add notifications functionality]
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.notification_important_outlined,
          color: ThemeColor.secondaryColor,
          size: MediaQuery.of(context).size.width * 0.12),
    );
  }
}
