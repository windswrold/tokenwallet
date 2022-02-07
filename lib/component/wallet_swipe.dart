import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class WalletSwipe extends StatelessWidget {
  const WalletSwipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.width, bottom: 16.width),
        height: 160.width,
        color: ColorUtils.backgroudColor,
        child: Swiper(
          loop: true,
          itemBuilder: (BuildContext tx, int index) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(color: Colors.red));
          },
          index: 0,
          itemCount: 3,
          scale: 1,
          viewportFraction: 0.9,
          // layout : SwiperLayout.STACK,

          onTap: (index) {
            // String jumpLinks = kprovider.bannerData[index]["jumpLinks"] ?? '';
            // kprovider.bannerTap(context, jumpLinks);
          },
        ));
  }
}
