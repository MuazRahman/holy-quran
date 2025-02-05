import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/Screens/SuraDetailsScreen.dart';
import 'package:holy_quran/colors.dart';
import 'package:holy_quran/models/sura_model.dart';

class SurahName extends StatelessWidget {
  const SurahName({super.key, required this.sura, required this.suraNo});

  final SuraModel sura;
  final int suraNo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SuraDetailsScreen(suraModel: sura, suraNo: suraNo,)));
      },
      leading: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/nomorSurah.svg',
          ),
          Text(
            '${suraNo + 1}',
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
      title: Text(
        '${sura.surahName}',
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revel at: ${sura.revelationPlace}",
            style: TextStyle(color: lightViolet, fontSize: 14),
          ),
          Text(
            'Total Ayahs: ${sura.totalAyah}',
            style: TextStyle(color: lightViolet, fontSize: 14),
          )
        ],
      ),
      trailing: Text(
        '${sura.surahNameArabic}',
        style: TextStyle(
            fontFamily: 'Amiri',
            color: violet,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
