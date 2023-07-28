extension ImagePath on String {
  String get toSvg => "assets/icons/ic_$this.svg";

  String get toPng => "assets/images/$this.png";
}

class AppAssets {
  static String appIcon = 'app_icon'.toPng;
  static String appIconLight = 'app_icon_light'.toPng;

  static String icBack = "back".toSvg;
  static String icEdit = 'edit'.toSvg;
  static String icTrash = 'trash'.toSvg;
  static String icShare = 'share'.toSvg;
  static String icFlame = 'flame'.toSvg;
}
