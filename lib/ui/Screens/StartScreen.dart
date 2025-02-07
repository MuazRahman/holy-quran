import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/ui/Screens/SignInScreen.dart';
import 'package:holy_quran/ui/controllers/auth_controller.dart';

import 'HomeScreen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: _buildSafeArea(context));
  }

  SafeArea _buildSafeArea(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),

                  // Title of the StartPage
                  Text(
                    'Quran App',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // Subtitle
                  Text(
                    'Learn Quran and\nRecite once everyday',
                    style:
                        GoogleFonts.poppins(fontSize: 17, color: lightViolet),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  // Purple box of StartPage
                  Container(
                    height: 460,
                    width: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xFF672CBC)),
                    // Quran, Cloud, Star svg Image
                    child: SvgPicture.asset(
                      'assets/svgs/splash.svg',
                      fit: BoxFit.fill,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      _moveToNextScreen(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        minimumSize: const Size(300, 55)),
                    child: Text(
                      'Get Started',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: gray,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<void> _moveToNextScreen(BuildContext context) async {
    bool isUserLoggedIn = await AuthController.isUserLoggedIn();
    if (isUserLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }
  }
}
