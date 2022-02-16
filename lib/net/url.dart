import 'package:cstoken/public.dart';
import 'package:cstoken/utils/sp_manager.dart';

class RequestURLS {
  // static  String host = "http://consensus.zooonews.com";

  static String get host => SPManager.getNetType() == KNetType.Mainnet
      ? "https://www.consensustoken.vip"
      : "http://consensus.zooonews.com";

  ///获取NFT新闻 pageNum pageSize
  static String getnftnews = host + "/app/information/news";

  ///获取快讯 pageNum pageSize
  static String getlettersnews = host + "/app/information/letters";

  ///我的收藏记录 pageNum pageSize address
  static String getdappmyCollect = host + "/app/dapp/myCollect";

  ///取消收藏 address marketId
  static String getdappcancelCollect = host + "/app/dapp/cancelCollect";

  ///添加收藏 address marketId
  static String getdappcollect = host + "/app/dapp/collect";

  ///获取dapp具体类型集合 dAppType
  static String getdapptypeList = host + "/app/dapp/typeList";

  ///首页热门项目
  static String getindexpopularItem = host + "/app/index/popularItem";

  ///首页应用
  static String getindexapplicationInfo = host + "/app/index/applicationInfo";

  ///获取用户地址持有NFT数量 address
  static String getindexnftInfo = host + "/app/index/nftInfo";

  ///获取dapp类型
  static String getdappType = host + "/app/dapp/dappType";

  ///Dapp banner
  static String getdappbannerInfo = host + "/app/dapp/bannerInfo";

  ///首页banner
  static String getbannerInfo = host + "/app/index/bannerInfo";

  ///token符号，若多个以逗号分隔
  static String gettokenPrice = host + "/app/token/tokenPrice";

  static String getAppversion = host + "/app/version/lastVersion";

  static String gettokenList = host + "/app/token/tokenList";

  static String getpopularToken = host + "/app/token/popularToken";

  static String linkInfo = host + "/app/common/linkInfo";

  ///chainType
  static String getgasPrice = host + "/app/wallet/gasPrice";
}
