import 'package:cstoken/component/next_button.dart';

import '../../public.dart';

class ChooseTypePage extends StatefulWidget {
  ChooseTypePage({Key? key}) : super(key: key);

  @override
  _ChooseTypePageState createState() => _ChooseTypePageState();
}

class _ChooseTypePageState extends State<ChooseTypePage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        hiddenAppBar: true,
        hiddenLeading: true,
        hiddenScrollView: true,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 170.width,
              child: Column(
                children: [
                  LoadAssetsImage(
                    "bg/biglogo.png",
                    fit: BoxFit.cover,
                    height: 40.width,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.width),
                    child: Text(
                      'Aggregation of NFT',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.font,
                        color: Color(0xFF7685A2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.width,
              child: Column(
                children: [
                  NextButton(
                    margin: EdgeInsets.only(top: 16.width),
                    height: 48.width,
                    width: 240.width,
                    border: Border.all(color: Color(0xFF0060FF)),
                    bgc: Color(0xFF0060FF),
                    title: '创建钱包',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.font,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  NextButton(
                    margin: EdgeInsets.only(top: 16.width),
                    height: 48.width,
                    width: 240.width,
                    border: Border.all(color: Color(0xFF0060FF)),
                    title: '恢复钱包',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.font,
                      color: Color(0xFF0060FF),
                    ),
                    onPressed: () {},
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.width),
                    child: Text(
                      'Digicenter Wallet',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.font,
                        color: Color(0x66000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
