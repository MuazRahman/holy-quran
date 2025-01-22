import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/Widgets/surahName.dart';
import 'package:http/http.dart';

import '../colors.dart';
import '../models/sura_model.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<SuraModel> surahList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getSuraList(); // Call an auxiliary async function
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        // Greetings
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            'Assalamualaikum',
            style: GoogleFonts.poppins(
                fontSize: 17, fontWeight: FontWeight.w500, color: lightViolet),
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            'Md. Shaon',
            style: GoogleFonts.poppins(
                fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        // Gradient Box of last read
        _gradientBox(),

        const SizedBox(
          height: 18,
        ),

        // Surah of Quran
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _getSuraList();
            },
            child: Visibility(
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              visible: _getProductListInProgress == false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                  itemCount: surahList.length,
                  itemBuilder: (context, index) {
                    return SurahName(
                      sura: surahList[index],
                      suraNo: index,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getSuraList() async {
    surahList.clear();
    _getProductListInProgress = true;
    setState(() {});

    Uri uri = Uri.parse('https://quranapi.pages.dev/api/surah.json');
    Response response = await get(uri);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      for (Map<String, dynamic> s in decodedData) {
        SuraModel sura = SuraModel(
          surahName: s['surahName'],
          surahNameArabic: s['surahNameArabic'],
          revelationPlace: s['revelationPlace'],
          totalAyah: s['totalAyah'],
        );
        surahList.add(sura);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
    setState(() { });
  }
}

// GradientBox of last read
Widget _gradientBox() {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Container(
            height: 131,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      .6,
                      1
                    ],
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ])),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/svgs/quran.svg')),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svgs/book.svg'),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Last Read',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Last Read
                Text(
                  'Al-Fatihah',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Ayah No: 1',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ));
}
