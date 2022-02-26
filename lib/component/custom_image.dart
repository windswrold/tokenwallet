import 'package:cached_network_image/cached_network_image.dart';

import '../public.dart';

class LoadAssetsImage extends StatelessWidget {
  LoadAssetsImage(this.name,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.color,
      this.scale,
      this.errorBuilder})
      : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ASSETS_IMG + name,
      height: height?.width,
      width: width?.width,
      fit: fit,
      color: color,
      scale: scale,
      errorBuilder: errorBuilder,
    );
  }
}

class LoadTokenAssetsImage extends StatelessWidget {
  const LoadTokenAssetsImage(
    this.name, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.scale,
  }) : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    String tokenurl = "";
    String chainurl = "";
    if (name.contains(",") == true) {
      tokenurl = name.split(",").first;
      chainurl = name.split(",").last;
    }
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: CachedNetworkImage(
              imageUrl: tokenurl,
              height: height?.width,
              width: width?.width,
              fit: fit,
              color: color,
              placeholder: (context, url) {
                return LoadAssetsImage("tokens/token_default.png",
                    width: width, height: height);
              },
              errorWidget: (context, url, error) {
                return LoadAssetsImage("tokens/token_default.png",
                    width: width, height: height);
              },
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Visibility(
                visible: chainurl.isEmpty ? false : true,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: chainurl,
                    height: 15.width,
                    width: 15.width,
                    fit: fit,
                    color: color,
                    placeholder: (context, url) {
                      return LoadAssetsImage("tokens/token_default.png",
                          width: width, height: height);
                    },
                    errorWidget: (context, url, error) {
                      return LoadAssetsImage("tokens/token_default.png",
                          width: width, height: height);
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
