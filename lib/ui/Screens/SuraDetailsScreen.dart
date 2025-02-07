import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/data/models/specific_ayat_model.dart';
import 'package:holy_quran/data/models/sura_model.dart';
import 'package:http/http.dart';

class SuraDetailsScreen extends StatefulWidget {
  const SuraDetailsScreen({super.key, required this.suraNo, this.suraModel});

  final int suraNo;
  final SuraModel? suraModel;

  @override
  State<SuraDetailsScreen> createState() => _SuraDetailsScreenState();
}

class _SuraDetailsScreenState extends State<SuraDetailsScreen> {
  List<SpecificAyatModel> ayatList = [];
  bool _getAyatInProgress = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _getAyat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _suraDetailsAppBar(context),
      body: Column(
        children: [
          _gradientBox(
              suraName: widget.suraModel!.surahName ?? '',
              suraNameTranslation: widget.suraModel!.surahNameTranslation ?? '',
              revelationPlace: widget.suraModel!.revelationPlace ?? '',
              totalAyat: widget.suraModel!.totalAyah,
              suraNameArabic: widget.suraModel!.suraNameArabicLong),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _getAyat();
              },
              child: Visibility(
                visible: _getAyatInProgress == false,
                replacement: const CircularProgressIndicator(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: ayatList.length,
                    itemBuilder: (context, index) {
                      return ayatName(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ayatName(int index) {
    return Column(
      children: [
        ListTile(
          minTileHeight: 47,
          tileColor: gray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: CircleAvatar(
            backgroundColor: violet,
            radius: 18,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          trailing: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showDialog (
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                        title: Text(
                          'Choose reciter',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        actions: [
                            TextButton(
                                onPressed: () async{
                                  Navigator.pop(context);
                                  await _audioPlayer.stop();
                                  final audioMap = ayatList[index].audio;
                                  final firstAudio = audioMap!.values.toList();
                                  final String? url = firstAudio[0].url;
                                  await _audioPlayer.play(UrlSource(url!));
                                },
                            child: Text('Mishary Rashid Al-Afasy',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                              onPressed: () async{
                                Navigator.pop(context);
                                await _audioPlayer.stop();
                                final audioMap = ayatList[index].audio;
                                final secondAudio = audioMap!.values.toList();
                                final String? url = secondAudio[1].url;
                                await _audioPlayer.play(UrlSource(url!));
                              },
                            child: Text('Abu Bakr Al-Shatri',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                            onPressed: () async{
                              Navigator.pop(context);
                              await _audioPlayer.stop();
                              final audioMap = ayatList[index].audio;
                              final thirdAudio = audioMap!.values.toList();
                              final String? url = thirdAudio[2].url;
                              await _audioPlayer.play(UrlSource(url!));
                            },
                            child: Text('Nasser Al Qatami',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                        );
                      },
                  );
                },
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                ),
                color: violet,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: backgroundColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    // Ayat Arabic
                    ayatList[index].arabic1 ?? '',
                    style: GoogleFonts.amiri(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // Ayat Bangla
                    ayatList[index].bengali ?? '',
                    style: GoogleFonts.poppins(
                      color: lightViolet,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getAyat() async {
    ayatList.clear();
    _getAyatInProgress = true;
    setState(() {});
    int? suraNo = widget.suraNo + 1;
    int? totalAyah = widget.suraModel!.totalAyah;
    for (int i = 1; i <= totalAyah!; i++) {
      Uri uri = Uri.parse('https://quranapi.pages.dev/api/$suraNo/$i.json');
      Response response = await get(uri);
      debugPrint(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        SpecificAyatModel specificAyatModel =
            SpecificAyatModel.fromJson(decodedData);
        ayatList.add(specificAyatModel);
      }
    }
    _getAyatInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    ayatList.clear();
  }
}

PreferredSizeWidget _suraDetailsAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.chevron_left_outlined),
      color: Colors.white,
      style: const ButtonStyle(iconSize: WidgetStatePropertyAll(28)),
    ),
    title: Text(
      // 'Sura Name',
      'Quran App',
      style: GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

Widget _gradientBox(
    {required String suraName,
    required suraNameTranslation,
    required revelationPlace,
    required totalAyat,
    required suraNameArabic}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Stack(
      children: [
        Container(
          height: 150,
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
          child: Opacity(
            opacity: 0.20,
            child: SvgPicture.asset(
              'assets/svgs/quran.svg',
              height: 120,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  suraName,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  suraNameTranslation,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 100,
                  ),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$revelationPlace ~ $totalAyat Verses',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  suraNameArabic,
                  style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
