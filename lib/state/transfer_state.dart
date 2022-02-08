import 'package:cstoken/pages/mine/mine_contacts.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_fee.dart';

import '../public.dart';

class KTransferState with ChangeNotifier {
  TextEditingController _addressEC = TextEditingController();
  TextEditingController _valueEC = TextEditingController();
  TextEditingController _remarkEC = TextEditingController();

  TextEditingController get addressEC => _addressEC;
  TextEditingController get valueEC => _valueEC;
  TextEditingController get remarkEC => _remarkEC;

  void goContract(BuildContext context) async {
    Map result = await Routers.push(context, MineContacts(type: 0));
    if (result != null) {
      final text = result["text"] ?? "";
      _addressEC.text = text;
    }
  }

  void tapBalanceAll(BuildContext context) {
    LogUtil.v("tapBalanceAll");
  }

  void tapFeeView(BuildContext context) {
    LogUtil.v("tapFeeView");
    Routers.push(context, TransfeeView());
  }

  void tapTransfer(BuildContext context) {
    LogUtil.v("tapTransfer");
  }
}
