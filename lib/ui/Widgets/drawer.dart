import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/ui/Screens/SignInScreen.dart';
import 'package:holy_quran/ui/Screens/update_profile_screen.dart';
import 'package:holy_quran/ui/controllers/auth_controller.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Heading Part of Drawer
        DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: gray),
              accountName: Text(AuthController.userModel!.fullName, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),),
              accountEmail: Text(AuthController.userModel!.email ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: MemoryImage(
                    base64Decode(AuthController.userModel?.photo ?? '${const Icon(Icons.person_outline)}'),
                  ),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person_outline),
                ),
              ),
            )
        ),

        const SizedBox(height: 10,),

        TextButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen()));
          },
          icon : Icon(Icons.settings, color: lightViolet,),
          label: Text(
            'Update Profile',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w500, color: gray),
          ),
        ),

        const SizedBox(height: 30,),
        // SignOut Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              await AuthController.clearUserData();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()),
                  (predicate) => false);
            },
            child: Text(
              'SignOut',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
