import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/pages/wallet/transfer/receive_page.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_payment.dart';
import 'package:cstoken/utils/timer_util.dart';
import '../public.dart';

class KTransListState with ChangeNotifier {
  TimerUtil? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initTimer(BuildContext context) {
    if (timer == null) {
      timer = TimerUtil(mInterval: 10000);
      timer?.setOnTimerTickCallback((millisUntilFinished) async {});
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
    Routers.push(context, TransferPayment());
  }

  void cellContentSelectRowAt(BuildContext context, int index) {}

  void showBottomSheet(
      BuildContext context, TransRecordModel model, bool isSpeedUp) {}
}
