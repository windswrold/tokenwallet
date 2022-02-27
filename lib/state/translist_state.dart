import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/pages/wallet/transfer/receive_page.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_payment.dart';
import 'package:cstoken/utils/timer_util.dart';
import '../public.dart';

class KTransListState with ChangeNotifier {
  List<Tab> _myTabs = [];
  TimerUtil? timer;
  List<Tab> get myTabs => <Tab>[
        Tab(text: 'transferetype_all'.local(), height: 40.width),
        Tab(text: 'transferetype_in'.local(), height: 40.width),
        Tab(text: 'transferetype_out'.local(), height: 40.width),
        Tab(text: 'transferetype_other'.local(), height: 40.width),
      ];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initTimer() {
    if (timer == null) {
      timer = TimerUtil(mInterval: 10000);
      timer?.setOnTimerTickCallback((millisUntilFinished) async {
        List<TransRecordModel> pendingDB =
            await TransRecordModel.queryPendingTrxList();
        if (pendingDB.isEmpty) {
          timer!.isActive();
          return;
        }
        for (var item in pendingDB) {
          bool? result = await item.updateTransState();
          if (result != null) {
            LogUtil.v("发出更新");
            eventBus.fire(MtransListUpdate());
          }
        }
      });
    }
    if (timer?.isActive() == false) {
      timer?.startTimer();
    }
  }

  void startTimer() {
    if (timer?.isActive() == false) {
      timer?.startTimer();
    }
  }

  void receiveClick(BuildContext context) {
    Routers.push(context, RecervePaymentPage());
  }

  void paymentClick(BuildContext context) {
    Routers.push(context, TransferPayment()).then((value) => {
          eventBus.fire(MtransListUpdate()),
        });
  }

  void cellContentSelectRowAt(BuildContext context, int index) {}

  void showBottomSheet(
      BuildContext context, TransRecordModel model, bool isSpeedUp) {}
}
