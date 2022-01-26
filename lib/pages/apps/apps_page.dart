import '../../public.dart';

class AppsPage extends StatefulWidget {
  AppsPage({Key? key}) : super(key: key);

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenLeading: true,
      child: Container());
  }
}
