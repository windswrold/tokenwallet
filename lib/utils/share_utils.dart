import 'package:share_plus/share_plus.dart';

import '../public.dart';

class ShareUtils {
  static void shareFiles(BuildContext context, List<String> paths) {
    Share.shareFiles(paths,
        sharePositionOrigin: Rect.fromCenter(
            center: Offset(0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width));
  }

  static void share(BuildContext context, String text) {
    Share.share(text,
        sharePositionOrigin: Rect.fromCenter(
            center: Offset(0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width));
  }
}
