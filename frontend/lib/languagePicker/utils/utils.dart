class LanguagePickerUtils {
  static String getFlagImageAssetPath(String isoCode) {
    return "assets/${isoCode.toLowerCase()}.png";
  }

  /* static Widget getDefaultFlagImage(Language language) {
    return Image.asset(
      LanguagePickerUtils.getFlagImageAssetPath(language.isoCode),
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
      package: "language_picker",
    );
  } */
}
