import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class CustomSwipe extends StatelessWidget {
  final List imageList;
  const CustomSwipe({Key? key, required this.imageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10.width, bottom: 16.width),
        height: 160.width,
        color: ColorUtils.backgroudColor,
        child: Swiper(
          loop: true,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageList[index],
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ));
          },
          index: 0,
          itemCount: imageList.length,
          scale: 0.8,
          viewportFraction: 0.8,
          onTap: (index) {},
        ));
  }
}
