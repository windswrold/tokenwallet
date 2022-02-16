import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/state/dapp/dapp_state.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class CustomSwipe extends StatelessWidget {
  const CustomSwipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.width, bottom: 16.width),
        height: 160.width,
        color: ColorUtils.backgroudColor,
        child: Consumer<DappDataState>(builder: (_, kprovider, child) {
          return kprovider.bannerData.isEmpty
              ? Container()
              : Swiper(
                  loop: true,
                  autoplay: true,
                  itemBuilder: (BuildContext tx, int index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: kprovider.bannerData[index]["imgUrl"] ?? "",
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ));
                  },
                  index: 0,
                  itemCount: kprovider.bannerData.length,
                  scale: 0.8,
                  viewportFraction: 0.8,
                  onTap: (index) {
                    String jumpLinks =
                        kprovider.bannerData[index]["jumpLinks"] ?? '';
                    String chainType =
                        kprovider.bannerData[index]["chainType"] ?? '';
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .bannerTap(context, jumpLinks, chainType);
                  },
                );
        }));
  }
}
