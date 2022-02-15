import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key, required this.datas}) : super(key: key);
  final List datas;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: datas.isEmpty == true ? false : true,
        child: Container(
            margin: EdgeInsets.only(top: 0.width, bottom: 22.width),
            padding: EdgeInsets.only(left: 16.width, right: 16.width),
            height: 88.width,
            child: Swiper(
              loop: true,
              autoplay: true,
              itemBuilder: (BuildContext tx, int index) {
                Map resullt = datas[index];
                String imgUrl = resullt["imgUrl"] ?? "";
                return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: imgUrl));
              },
              itemCount: datas.length,
              scale: 1,
              onTap: (index) {
                Map resullt = datas[index];
                String jumpLinks = resullt["jumpLinks"] ?? "";
                String chainType = resullt["chainType"] ?? "";
                Provider.of<CurrentChooseWalletState>(context, listen: false)
                    .bannerTap(context, jumpLinks, chainType);
              },
            )));
  }
}
