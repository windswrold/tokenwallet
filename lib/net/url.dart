class RequestURLS {
  static const String host = "http://consensus.zooonews.com";

  ///获取NFT新闻 pageNum pageSize
  static const String getnftnews = host + "/app/information/news";

  ///获取快讯 pageNum pageSize
  static const String getlettersnews = host + "/app/information/letters";

  ///我的收藏记录 pageNum pageSize address
  static const String getdappmyCollect = host + "/app/dapp/myCollect";

  ///取消收藏 address marketId
  static const String getdappcancelCollect = host + "/app/dapp/cancelCollect";

  ///添加收藏 address marketId
  static const String getdappcollect = host + "/app/dapp/collect";

  ///获取dapp具体类型集合 dAppType
  static const String getdapptypeList = host + "/app/dapp/typeList";

  ///首页热门项目
  static const String getindexpopularItem = host + "/app/index/popularItem";

  ///首页应用
  static const String getindexapplicationInfo =
      host + "/app/index/applicationInfo";

  ///首页应用
  static const String getindexnftInfo = host + "/app/index/nftInfo";

  ///获取dapp类型
  static const String getdappType = host + "/app/dapp/dappType";

  ///Dapp banner
  static const String getdappbannerInfo = host + "/app/dapp/bannerInfo";

  ///首页banner
  static const String getbannerInfo = host + "/app/index/bannerInfo";
}
