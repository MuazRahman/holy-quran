class SpecificAyatModel {
  SpecificAyatModel({
    // this.surahName,
    // this.surahNameArabic,
    // this.surahNameArabicLong,
    // this.surahNameTranslation,
    // this.revelationPlace,
    // this.totalAyah,
    // this.surahNo,
    // this.ayahNo,
    this.english,
    this.arabic1,
    // this.arabic2,
    this.bengali,
    this.audio,
  });

  // final String? surahName;
  // final String? surahNameArabic;
  // final String? surahNameArabicLong;
  // final String? surahNameTranslation;
  // final String? revelationPlace;
  // final int? totalAyah;
  // final int? surahNo;
  // final int? ayahNo;
  final String? english;
  final String? arabic1;
  // final String? arabic2;
  final String? bengali;
  final Map<String, Audio>? audio; // Made nullable

  factory SpecificAyatModel.fromJson(Map<String, dynamic> json) {
    return SpecificAyatModel(
      // surahName: json["surahName"],
      // // surahNameArabic: json["surahNameArabic"],
      // surahNameArabicLong: json["surahNameArabicLong"],
      // surahNameTranslation: json["surahNameTranslation"],
      // revelationPlace: json["revelationPlace"],
      // // totalAyah: json["totalAyah"],
      // // surahNo: json["surahNo"],
      // ayahNo: json["ayahNo"],
      english: json["english"],
      arabic1: json["arabic1"],
      // arabic2: json["arabic2"],
      bengali: json["bengali"],
      audio: json["audio"] != null
          ? Map.from(json["audio"]).map(
            (k, v) => MapEntry<String, Audio>(k, Audio.fromJson(v)),
      )
          : null, // Handle null case properly
    );
  }
}

class Audio {
  Audio({
    this.reciter,
    this.url,
  });

  final String? reciter;
  final String? url;

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      reciter: json["reciter"],
      url: json["url"],
    );
  }
}
