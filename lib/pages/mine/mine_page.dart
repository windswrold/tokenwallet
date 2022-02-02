import 'package:cstoken/component/mine_list_cell.dart';

import '../../public.dart';

class MinePage extends StatefulWidget {
  MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenLeading: true,
      title: CustomPageView.getTitle(title: "minepage_minetitle".local(),),
      backgroundColor: ColorUtils.backgroudColor,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.width),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return MineListViewCell();
        },
      ),
    );
  }
}
