import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/news_cell.dart';
import 'package:cstoken/model/news/news_model.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class LetterNewsPage extends StatefulWidget {
  LetterNewsPage({Key? key}) : super(key: key);

  @override
  State<LetterNewsPage> createState() => _LetterNewsPageState();
}

class _LetterNewsPageState extends State<LetterNewsPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController();
  int _page = 1;
  List<NewsModel> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData(_page);
  }

  void _initData(int page) async {
    _page = page;
    Future.delayed(Duration(seconds: 2)).then((value) => {
          _refreshController.refreshCompleted(),
          _refreshController.loadComplete(),
        });
    List<NewsModel> result = [];
    result = await WalletServices.getlettersnews(_page, 20);
    setState(() {
      if (page == 1) {
        _datas.clear();
      }
      _datas.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresher(
        onRefresh: () {
          _initData(1);
        },
        onLoading: () {
          _initData(_page + 1);
        },
        child: _datas.length == 0
            ? EmptyDataPage()
            : ListView.builder(
                itemCount: _datas.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  NewsModel? model = _datas[index];
                  return NewsCell(model: model);
                },
              ),
        refreshController: _refreshController);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
