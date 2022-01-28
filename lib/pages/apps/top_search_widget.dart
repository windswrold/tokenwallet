import '../../public.dart';

class TopSearchView extends StatelessWidget {
  const TopSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 44,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(left: 15.width, right: 10.width),
          height: 32.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.width),
            // color: ThemeUtils.getDappSearchColor(context),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DApp_top_search".local(),
                style: TextStyle(
                    // color: ThemeUtils.labelColor(context).withOpacity(0.2),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.font),
              ),
              // Image.asset(
              //   // ThemeUtils.getDappSearchIcon(context),
              //   width: 20.width,
              //   height: 20.width,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
