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
    this.isNft = false,
  }) : super(key: key);

  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;
  final bool isNft;

  @override
  Widget build(BuildContext context) {
    String tokenurl = "";
    String chainurl = "";
    String defaultImage = "tokens/token_default.png";
    if (name.contains("base64") == false) {
      if (name.contains(",") == true) {
        tokenurl = name.split(",").first;
        chainurl = name.split(",").last;
      } else {
        tokenurl = name;
      }
    }

    if (isNft == true) {
      defaultImage = "tokens/nft_default.png";
    }
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: tokenurl.contains("base64")
                ? Image.memory(
                    tokenurl.imgBase64(),
                    height: height?.width,
                    width: width?.width,
                    fit: fit,
                    color: color,
                    errorBuilder: (context, url, error) {
                      return LoadAssetsImage(defaultImage,
                          width: width, height: height, fit: fit);
                    },
                  )
                : CachedNetworkImage(
                    imageUrl: tokenurl,
                    height: height?.width,
                    width: width?.width,
                    fit: fit,
                    color: color,
                    placeholder: (context, url) {
                      return LoadAssetsImage(
                        defaultImage,
                        width: width,
                        height: height,
                        fit: fit,
                      );
                    },
                    errorWidget: (context, url, error) {
                      return LoadAssetsImage(
                        defaultImage,
                        width: width,
                        height: height,
                        fit: fit,
                      );
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
                      return LoadAssetsImage(defaultImage,
                          width: width, height: height);
                    },
                    errorWidget: (context, url, error) {
                      return LoadAssetsImage(defaultImage,
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
