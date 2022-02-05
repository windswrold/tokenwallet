import 'package:scan/scan.dart';
import '../../public.dart';

class ScanCodePage extends StatefulWidget {
  ScanCodePage({
    Key? key,
  }) : super(key: key);

  @override
  _ScanCodePageState createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  ScanController controller = ScanController();

  bool isOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.pause();
  }

  Widget getCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPageView.getBack(() {
          Routers.goBack(context);
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenAppBar: true,
      safeAreaBottom: false,
      safeAreaLeft: false,
      safeAreaRight: false,
      safeAreaTop: false,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: ScanView(
              controller: controller,
              scanAreaScale: .6,
              scanLineColor: Color(0xff24DFBE),
              onCapture: (data) {
                print("data " + data);
                Routers.goBackWithParams(context, {"data": data});
              },
            ),
          ),
          // Positioned(
          //   left: 55.width,
          //   right: 55.width,
          //   bottom: 215.height,
          //   child: Text(
          //     "scan_qr_code".local(),
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 24.font,
          //         fontWeight: FontWeight.w700,
          //         color: UIConstant.scanTipColor),
          //   ),
          // ),
          // Positioned(
          //   left: 55.width,
          //   right: 55.width,
          //   bottom: 155.height,
          //   child: Text(
          //     "qrscan_tip".local(),
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 14.font,
          //         fontWeight: FontWeight.w500,
          //         color: UIConstant.scanTipColor),
          //   ),
          // ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 50.height,
          //   child: GestureDetector(
          //     behavior: HitTestBehavior.opaque,
          //     onTap: () {
          //       controller.toggleTorchMode();
          //       setState(() {
          //         isOpen = !isOpen;
          //       });
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         LoadAssetsImage(
          //           Constant.ASSETS_IMG + "icons/" + "icon_whitescan.png",
          //           width: 24,
          //           height: 24,
          //         ),
          //         6.rowWidget,
          //         Text(
          //           isOpen
          //               ? "toggle_torch_off".local()
          //               : "toggle_torch_on".local(),
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //               fontSize: 17.font,
          //               fontWeight: FontWeight.w700,
          //               color: UIConstant.scanTipColor),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
              top: 20.width,
              left: 20.width,
              right: 0,
              height: 45.width,
              child: getCustomAppBar()),
        ],
      ),
    );
  }
}
