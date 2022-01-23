import 'package:cstoken/component/custom_pageview.dart';

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
        child: Stack(
          children: [
            Positioned(
              child: Container(
                margin: EdgeInsets.only(
                    left: 35.width, right: 35.width, top: 50.width),
                child: Text(
                  'createwallet_safedetails'.local(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36.font,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
