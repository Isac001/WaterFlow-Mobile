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
          // Setting the prefix icon
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: ThemeColor.primaryColor,
          ),
          // Setting the border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
          // Setting the disabled border
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

  // Defines a private helper method to build the side navigation menu (Drawer).
  Widget _buildSideMenu() {
    // Returns a Drawer widget, which is a material design panel that slides in horizontally from the edge of a Scaffold.
    return Drawer(
      // The main container for the drawer's content.
      child: Container(
        // Sets the background color of the drawer.
        color: ThemeColor.primaryColor,
        // Applies padding to all sides of the container.
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          // Arranges its children in a vertical column.
          child: Column(
            // Aligns the children to the start of the main axis (top of the column).
            mainAxisAlignment: MainAxisAlignment.start,
            // The list of widgets to display in the column.
            children: <Widget>[
              // Displays the title of the menu.
              const Text(
                'Menu de relatórios', // Text content: "Reports Menu"
                // Styles the text with a specific color, font size, and weight.
                style: TextStyle(
                    color: ThemeColor.whiteColor,
                    fontSize: kFontsizeLarge,
                    fontWeight: FontWeight.bold),
              ),
              // A material design drawer header that shows account details.
              UserAccountsDrawerHeader(
                // The primary widget to display, typically an image of the user.
                currentAccountPicture: Transform.scale(
                  // Scales the child widget up by 1.5x.
                  scale: 1.5,
                  // A circular avatar for the account picture.
                  child: const CircleAvatar(
                    // Sets the background image for the avatar.
                    backgroundImage: AssetImage(
                        'assets/app_images/WaterFlow_without_background.png'),
                  ),
                ),
                // The decoration for the header's box.
                decoration: const BoxDecoration(
                  // Sets the background color to transparent to show the drawer's color.
                  color: ThemeColor.transparentColor,
                ),
                // The name of the account.
                accountName: const Text(
                  'WATER FLOW',
                  // Styles the account name text.
                  style: TextStyle(
                      color: ThemeColor.whiteColor,
                      fontSize: kFontsizeMedium,
                      fontWeight: FontWeight.bold),
                ),
                // The email or a secondary piece of information for the account.
                accountEmail: const Text(
                  'Relatórios de consumo de água', // Text content: "Water consumption reports"
                  // Limits the text to a maximum of 2 lines.
                  maxLines: 2,
                  // Styles the account email text.
                  style: TextStyle(
                    color: ThemeColor.whiteColor,
                  ),
                ),
              ),
              // A single fixed-height row, typically used in menus. Represents the "Daily Consumption" option.
              ListTile(
                // An icon placed at the beginning of the tile.
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  // Sets the icon size relative to the screen width.
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                // The primary content of the list tile, the title.
                title: const Text(
                  'Consumo Diário', // Text content: "Daily Consumption"
                  // Styles the title text.
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                // The callback function that is called when the user taps this list tile.
                onTap: () {
                  // Closes the drawer.
                  Get.back();
                  // Navigates to the '/dailyWaterConsumption' route and removes the previous route from the stack.
                  Get.offNamed('/dailyWaterConsumption');
                },
                // Marks this tile as currently selected, often highlighting it.
                selected: true,
              ),
              // Represents the "Weekly Consumption" menu option.
              ListTile(
                // The title of the tile.
                title: const Text(
                  'Consumo Semanal', // Text content: "Weekly Consumption"
                  // Styles the title text.
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                // An icon placed at the beginning of the tile.
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  // Sets the icon size relative to the screen width.
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                // The action to perform on tap.
                onTap: () {
                  // Closes the drawer.
                  Get.back();
                  // Navigates to the '/weeklyWaterConsumption' route.
                  Get.offNamed('/weeklyWaterConsumption');
                },
              ),
              // Represents the "Monthly Consumption" menu option.
              ListTile(
                // The title of the tile.
                title: const Text(
                  'Consumo Mensal', // Text content: "Monthly Consumption"
                  // Styles the title text.
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                // An icon placed at the beginning of the tile.
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  // Sets the icon size relative to the screen width.
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                // The action to perform on tap.
                onTap: () {
                  // Closes the drawer.
                  Get.back();
                  // Navigates to the '/monthlyWaterConsumption' route.
                  Get.offNamed('/monthlyWaterConsumption');
                },
              ),
              // Represents the "Bimonthly Consumption" menu option.
              ListTile(
                // The title of the tile.
                title: const Text(
                  'Consumo Bimestral', // Text content: "Bimonthly Consumption"
                  // Styles the title text.
                  style: TextStyle(
                      color: ThemeColor.whiteColor, fontSize: kFontsizeMedium),
                ),
                // An icon placed at the beginning of the tile.
                leading: Icon(
                  Icons.water_damage_outlined,
                  color: ThemeColor.whiteColor,
                  // Sets the icon size relative to the screen width.
                  size: MediaQuery.of(context).size.width * 0.080,
                ),
                // The action to perform on tap (currently empty).
                onTap: () {
                  Get.back();
                  // Navigates to the '/monthlyWaterConsumption' route.
                  Get.offNamed('/bimonthlyWaterConsumption');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the title of the graph
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
