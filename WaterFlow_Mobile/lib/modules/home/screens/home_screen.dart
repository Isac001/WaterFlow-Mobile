import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/auth/controllers/auth_controller.dart';
import 'package:waterflow_mobile/controllers/flow_reading_controller.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/radial_graph_widget.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Calling the controller injected by GetX
  final FlowReadingController _flowReadingController =
      Get.find<FlowReadingController>();

  // Calling the controller injected by GetX
  final AuthController _authController = Get.find<AuthController>();

  // Key to the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    // Screen size variable to get the screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColor.whiteColor,
      drawer: _buildSideMenu(),

      // Main body of the screen
      body: Stack(
        children: [
          // Positioning the background triangles
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

          // Positioning the background triangles
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

          // Sefe area to avoid notches and system UI overlaps
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displaying the title
                    _titleOfGraph(),
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
              child: Row(
                children: [_notificationsButton(), _logoutButton()],
              ),
            ),
          ),
          MediaQuery(
            data: MediaQuery.of(context),
            child: Positioned(
              top: screenSize.height * 0.01,
              left: screenSize.width * 0.02,
              child: _sideBarButtom(),
            ),
          ),
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

  Widget _sideBarButtom() {
    // Side bar button to open the side bar [TODO: Add side bar functionality]
    return IconButton(
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      icon: Icon(
        Icons.menu,
        size: MediaQuery.of(context).size.width * 0.12,
        color: ThemeColor.whiteColor,
      ),
    );
  }

  Widget _buildSideMenu() {
    return Drawer(
      child: Container(
        color: ThemeColor.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Menu de relatórios',
                style: TextStyle(
                    color: ThemeColor.whiteColor,
                    fontSize: kFontsizeLarge,
                    fontWeight: FontWeight.bold),
              ),
              UserAccountsDrawerHeader(
                currentAccountPicture: Transform.scale(
                  scale: 1.5,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/app_images/WaterFlow_without_background.png'),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: ThemeColor.transparentColor,
                ),
                accountName: const Text(
                  'WATER FLOW',
                  style: TextStyle(
                      color: ThemeColor.whiteColor,
                      fontSize: kFontsizeMedium,
                      fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text(
                  'Relatórios de consumo de água',
                  maxLines: 2,
                  style: TextStyle(
                    color: ThemeColor.whiteColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                title: const Text(
                  'Consumo Diário',
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                onTap: () {
                  Get.back();
                  Get.offNamed('/dailyWaterConsumption');
                },
                selected: true,
              ),
              ListTile(
                title: const Text(
                  'Consumo Semanal',
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                onTap: () {
                  Get.back();
                  Get.offNamed('/weeklyWaterConsumption');
                },
              ),
              ListTile(
                title: const Text(
                  'Consumo Mensal',
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Consumo Bimestral',
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleOfGraph() {
    return const Text(
      'Consumo em Tempo Real',
      style: TextStyle(
          color: ThemeColor.primaryColor,
          fontSize: kFontsizeLarge,
          fontWeight: FontWeight.bold),
    );
  }
}
