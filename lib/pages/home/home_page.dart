import 'package:easy_localization/easy_localization.dart';

import '../../public.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
     EasyLocalization.of(context);
    return CustomPageView( hiddenLeading: true,
      child: Container());
  }
}
