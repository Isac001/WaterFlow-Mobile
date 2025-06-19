import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterflow_mobile/modules/login/controllers/login_screen_controller.dart';
import 'package:waterflow_mobile/modules/login/keys/login_form_key.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';
import 'package:waterflow_mobile/widgets/triangule_art_widget.dart';

// Define the LoginScreen widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Calling the controller injected by GetX
  final LoginScreenController _loginScreenController =
      Get.find<LoginScreenController>();


  @override
  void initState() {
    super.initState();
    // Chama o método para preparar o formulário assim que a tela é iniciada
    _loginScreenController.prepareForm(); 
  }

  @override
  Widget build(BuildContext context) {
    // Variable to get the screen size
    final screenSize = MediaQuery.of(context).size;
    final double primaryTriangleWidth = screenSize.width * 0.6;
    final double primaryTriangleHeight = screenSize.height * 0.15;
    final double secondaryTriangleWidth = primaryTriangleWidth + 40;
    final double secondaryTriangleHeight = primaryTriangleHeight + 50;

    return Scaffold(
      backgroundColor: ThemeColor.whiteColor,
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

          // Secondary triangle at the bottom right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: TriangleClipper(isTopCorner: false),
              child: Container(
                color: ThemeColor.secondaryColor,
                width: secondaryTriangleWidth,
                height: secondaryTriangleHeight,
              ),
            ),
          ),
          // Primary triangle at the top left corner
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
          // Primary triangle at the bottom right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: TriangleClipper(isTopCorner: false),
              child: Container(
                color: ThemeColor.primaryColor,
                width: primaryTriangleWidth,
                height: primaryTriangleHeight,
              ),
            ),
          ),

          // Safe area for the main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kPaddingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Application logo image
                    _imageLogo(),
                    // Login form
                    Form(
                      key: LoginFormKey.loginFormKey,
                      child: Column(
                        children: [
                          _userEmailField(),
                          const SizedBox(height: kPaddingMedium),
                          _passwordField(),
                          const SizedBox(height: kPaddingMedium),
                          Row(
                            children: [
                              Expanded(
                                child: _rememberLoginRecoverPassword(),
                              ),
                              _recoverPasswordButton()
                            ],
                          )
                        ],
                      ),
                    ),

                    // Spacing between the form and the login button
                    const SizedBox(height: kPaddingLarge),
                    _loggingButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the email field
  Widget _userEmailField() {
    return TextFormField(
      controller: _loginScreenController.userEmailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusSmall),
        ),
        filled: true,
        fillColor: ThemeColor.whiteColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório!';
        }
        return null;
      },
    );
  }

  // Widget for the password field
  Widget _passwordField() {
    return Obx(
      () => TextFormField(
        controller: _loginScreenController.passwordController,
        obscureText: !_loginScreenController.passwordVisible.value,
        decoration: InputDecoration(
          labelText: 'Senha',
          prefixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
          filled: true,
          fillColor: ThemeColor.whiteColor,
          suffixIcon: IconButton(
            icon: Icon(_loginScreenController.passwordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onPressed: () {
              // Toggles password visibility using the controller's method
              _loginScreenController.passwordVisible.toggle();
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório!';
          }
          return null;
        },
      ),
    );
  }

  // Widget for the "Remember Login" option
  Widget _rememberLoginRecoverPassword() {
    return Obx(
      () => CheckboxListTile(
        title: const Text(
          'Lembrar o Login',
          style: TextStyle(
              fontSize: kFontsizeStandard,
              fontWeight: FontWeight.bold,
              color: ThemeColor.secondaryColor),
        ),
        checkColor: ThemeColor.goldColor,
        value: _loginScreenController.stayConnected.value,
        onChanged: (newValue) {
          _loginScreenController.stayConnected.value = newValue!;
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        activeColor: ThemeColor.secondaryColor,
      ),
    );
  }

  // Widget for the login button
  Widget _loggingButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
        ),
        onPressed: () {
          _loginScreenController.submit();
        },
        child: const Text(
          'Entrar',
          style: TextStyle(
              fontSize: kFontsizeMedium, color: ThemeColor.whiteColor),
        ),
      ),
    );
  }

  ///[TODO] Implement the password recovery functionality
  Widget _recoverPasswordButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: ThemeColor.primaryColor),
      child: const Text(
        'Recuperar Senha',
        style: TextStyle(color: ThemeColor.whiteColor),
      ),
    );
  }
}

  // Widget for the application logo
  Widget _imageLogo() {
  return Image.asset(
    "assets/app_images/WaterFlow_Logo.png",
    height: 200,
  );
}
