import 'package:images_picker/images_picker.dart';
import '../../public.dart';

class MineFeedBack extends StatefulWidget {
  MineFeedBack({Key? key}) : super(key: key);

  @override
  State<MineFeedBack> createState() => _MineFeedBackState();
}

class _MineFeedBackState extends State<MineFeedBack> {
  TextEditingController _mailEC = TextEditingController();
  TextEditingController _contentEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        title: CustomPageView.getTitle(title: "minepage_feedback".local()),
        backgroundColor: ColorUtils.backgroudColor,
        child: Padding(
          padding: EdgeInsets.all(16.width),
          child: Column(
            children: [
              Container(
                child: Text("minepage_feedbacktip".local()),
              ),
              CustomTextField(controller: _mailEC),
              CustomTextField(
                controller: _contentEC,
                padding: EdgeInsets.only(top: 16.width),
              ),
              NextButton(
                  onPressed: () async {
                    List<Media>? res = await ImagesPicker.pick(
                      count: 3,
                      pickType: PickType.image,
                    );
                    print(res);
                  },
                  title: "title")
            ],
          ),
        ));
  }
}
