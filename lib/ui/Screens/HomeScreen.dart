import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/ui/Screens/BookmarkScreen.dart';
import 'package:holy_quran/ui/Screens/DuaScreen.dart';
import 'package:holy_quran/ui/Screens/HadithScreen.dart';
import 'package:holy_quran/ui/Screens/QiblaScreen.dart';
import 'package:holy_quran/ui/Screens/QuranScreen.dart';
import '../Widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Default to Quran screen

  final List<Widget> _screens = [
    const Hadithscreen(),
    const Duascreen(),
    const QuranScreen(),
    const QiblaScreen(),
    const Bookmarkscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _appBarOfHomeScreen(),
      drawer: const Drawer(child: DrawerWidget(),),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }


  // BottomNavigationBar Widget
  BottomNavigationBar _bottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: gray,
      showSelectedLabels: true, // Enable showing labels
      showUnselectedLabels: false, // Hide unselected labels
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        _bottomNavigationBarItem(
          icon: 'assets/svgs/lampIcon.svg',
          label: 'Hadith',
          isSelected: _currentIndex == 0,
        ),
        _bottomNavigationBarItem(
          icon: 'assets/svgs/duaIcon.svg',
          label: 'Dua',
          isSelected: _currentIndex == 1,
        ),
        _bottomNavigationBarItem(
          icon: 'assets/svgs/homeIcon.svg',
          label: 'Quran',
          isSelected: _currentIndex == 2,
        ),
        _bottomNavigationBarItem(
          icon: 'assets/svgs/qiblaIcon.svg',
          label: 'Qibla',
          isSelected: _currentIndex == 3,
        ),
        _bottomNavigationBarItem(
          icon: 'assets/svgs/bookmarkIcon.svg',
          label: 'Bookmark',
          isSelected: _currentIndex == 4,
        ),
      ],
    );
  }


  // Items of BottomNavigationBar
  BottomNavigationBarItem _bottomNavigationBarItem({
    required String icon,
    required String label,
    required bool isSelected,
  }) =>
      BottomNavigationBarItem(
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? lightViolet : Colors.transparent, // Highlight color
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(icon),
            ),
            if (isSelected) // Only show label when selected
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: lightViolet, // Label color
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        label: '', // Leave label empty here as we handle it manually
      );

  // AppBar of the HomeScreen
  PreferredSizeWidget _appBarOfHomeScreen(){
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,

      title: Row(
        children: [
          // Menu Option
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                // Open the drawer
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset('assets/svgs/menuIcon.svg'),
            ),
          ),

          const SizedBox(
            width: 24,
          ),

          // Title
          Text(
            'Quran App',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // const Spacer(),

          // Search Option
          // IconButton(
          //     onPressed: () {},
          //     icon: SvgPicture.asset('assets/svgs/searchIcon.svg'),
          // ),
        ],
      ),
    );
  }

}
