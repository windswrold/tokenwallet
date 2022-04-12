import 'package:cstoken/public.dart';
import 'package:cstoken/utils/sp_manager.dart';

class RequestURLS {
  static String testUrl = "http://consensus.zooonews.com";
  static String productUrl = "https://www.consensustoken.vip";

  static String getHost() {
    return SPManager.getNetType() == KNetType.Mainnet ? productUrl : testUrl;
  }

  ///获取NFT新闻 pageNum pageSize
  static String getnftnews = "/app/information/news";

  ///获取快讯 pageNum pageSize
  static String getlettersnews = "/app/information/letters";

  ///我的收藏记录 pageNum pageSize address
  static String getdappmyCollect = "/app/dapp/myCollect";

  ///取消收藏 address marketId
  static String getdappcancelCollect = "/app/dapp/cancelCollect";

  ///添加收藏 address marketId
  static String getdappcollect = "/app/dapp/collect";

  ///获取dapp具体类型集合 dAppType
  static String getdapptypeList = "/app/dapp/typeList";

  ///首页热门项目
  static String getindexpopularItem = "/app/index/popularItem";

  ///首页应用
  static String getindexapplicationInfo = "/app/index/applicationInfo";

  ///获取用户地址持有NFT数量 address
  static String getindexnftInfo = "/app/index/nftInfo";

  ///获取dapp类型
  static String getdappType = "/app/dapp/dappType";

  ///Dapp banner
  static String getdappbannerInfo = "/app/dapp/bannerInfo";

  ///首页banner
  static String getbannerInfo = "/app/index/bannerInfo";

  ///token符号，若多个以逗号分隔
  static String gettokenPrice = "/app/token/tokenPrice";

  static String getAppversion = "/app/version/lastVersion";

  static String gettokenList = "/app/token/tokenList";

  static String getpopularToken = "/app/token/popularToken";

  static String linkInfo = "/app/common/linkInfo";

  ///chainType
  static String getgasPrice = "/app/wallet/gasPrice";

  static String trxGet = "/app/secret/trxGet";

  static String trxPost = "/app/secret/trxPost";

  static String ethPost = "/app/secret/ethPost";

  static String blockcypherGet = "/app/secret/blockcypherGet";

  static String blockcypherPost = "/app/secret/blockcypherPost";

  static String ethGet = "/app/secret/ethGet";

  static String nftList = "/app/nft/nftList";

  static String userNftList = "/app/nft/userNftList";

  static String transitGet = "/app/secret/transitGet";
}
