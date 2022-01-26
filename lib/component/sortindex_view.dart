import 'package:cstoken/component/sortindex_button.dart';

import '../public.dart';

class SortIndexView extends StatelessWidget {
  const SortIndexView(
      {Key? key,
      required this.memos,
      required this.offsetWidth,
      this.bgColor,
      required this.type,
      required this.onTap,
      this.verifyMemos})
      : super(key: key);

  final List<SortViewItem> memos;
  final List<Map>? verifyMemos;
  final double offsetWidth;
  final Color? bgColor;
  final SortIndexType type;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double _screenWidth = mediaQuery.size.width;
    double _paddingOffset = 14.width;
    double _paddingLeft = 14.width;
    double itemWidth = 0.0;
    double itemHeight = 40.width;
    if (type == SortIndexType.wrongIndex) {
      _paddingOffset = 10.width;
    }
    if (type == SortIndexType.actionIndex) {
      _paddingLeft = 0.0;
      _paddingOffset = 12.width;
    }
    itemWidth =
        (_screenWidth - offsetWidth - _paddingLeft * 2 - _paddingOffset * 2) /
            3;
    List<Widget> views = [];
    for (var i = 0; i < memos.length; i++) {
      final value = memos[i];
      views.add(SortIndexButton(
        height: itemHeight,
        width: itemWidth,
        type: type,
        onTap: onTap,
        item: value,
      ));
    }

    return Container(
      alignment: Alignment.center,
      padding:
          EdgeInsets.fromLTRB(_paddingLeft, 16.width, _paddingLeft, 16.width),
      margin: EdgeInsets.only(top: 16.width),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: _paddingOffset,
        runSpacing: 13.width,
        children: views,
      ),
    );
  }
}
