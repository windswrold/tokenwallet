import '../../../public.dart';

class NFTInfo extends StatefulWidget {
  NFTInfo({Key? key}) : super(key: key);

  @override
  State<NFTInfo> createState() => _NFTInfoState();
}

class _NFTInfoState extends State<NFTInfo> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "homepage_nftinfo".local()),
      child: Column(
        children: [
          Expanded(
            child: LoadTokenAssetsImage(
              "",
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 16.width, right: 16.width),
              child: Text(
                "data",
                style: TextStyle(
                  fontSize: 14.font,
                  color: Color.fromARGB(255, 183, 183, 183),
                ),
              ),
            ),
          ),
          NextButton(
            bgc: ColorUtils.blueColor,
            textStyle: TextStyle(
              fontSize: 16.font,
              fontWeight: FontWeightUtils.medium,
              color: Colors.white,
            ),
            margin: EdgeInsets.only(
                left: 16.width, right: 16.width, bottom: 16.width),
            onPressed: () {},
            title: "homepage_send".local(),
          ),
        ],
      ),
    );
  }
}
