import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';

import '../../public.dart';

class DAppListCell extends StatelessWidget {
  final DAppRecordsDBModel model;
  const DAppListCell({Key? key, required this.model}) : super(key: key);

  void _jumpWeb(BuildContext context, String openUrl) {
    // DAppRecordsDBModel.insertRecords(model);
    // Routers.pushWidget(context, DappBrowser(url: openUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.width,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      child: Row(
        children: [
          _cellImageView(context),
          8.rowWidget,
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _textView(context),
                        18.rowWidget,
                        _goButton(context),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: ColorUtils.lineColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellDefaultImage(BuildContext context) {
    return LoadAssetsImage(
      "icons/dapp_defaut_icon.png",
      width: 44,
      height: 44,
    );
  }

  Widget _urlText(BuildContext context) {
    return Expanded(
      child: Text(
        model.url ?? "",
        style: TextStyle(
          color: ColorUtils.fromHex("#99000000"),
          fontSize: 12.font,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _cellImageView(BuildContext context) {
    return ClipOval(
      child: model.imageUrl == null
          ? _cellDefaultImage(context)
          : CachedNetworkImage(
              width: 44,
              height: 44,
              imageUrl: model.imageUrl!,
              placeholder: (context, url) => LoadAssetsImage(
                "icons/dapp_defaut_icon.png",
                fit: BoxFit.cover,
                width: 44,
                height: 44,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
    );
  }

  Widget _textView(BuildContext context) {
    return model.name == null
        ? _urlText(context)
        : Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name ?? "",
                    style: TextStyle(
                      color: ColorUtils.fromHex("#FF000000"),
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                  ),
                  Text(
                    model.description ?? "",
                    style: TextStyle(
                      color: ColorUtils.fromHex("#99000000"),
                      fontSize: 12.font,
                      fontWeight: FontWeightUtils.regular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _goButton(BuildContext context) {
    return Container(
      child: Text(
        "ssss",
        style: TextStyle(
          fontSize: 12.font,
          fontWeight: FontWeightUtils.regular,
          color: ColorUtils.fromHex("#99000000"),
        ),
      ),
    );
  }
}
