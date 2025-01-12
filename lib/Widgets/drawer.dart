import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

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
              accountName: Text('Md. Shaon', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),),
              accountEmail: Text('shaonnubtk22@gmail.com', style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: CircleAvatar(
                  backgroundColor: orange,
                  child: SvgPicture.asset('assets/svgs/homeIcon.svg'),
                ),
              ),
            )
        ),

        // body part of Drawer
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        const SizedBox(height: 30,),
        // SignOut Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2.5,
              backgroundColor: lightViolet,
              minimumSize: const Size(0, 50),
              // maximumSize: Size(0, 60),
            ),
            child: Text(
              'SignOut',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
