class RequestURLS {
  static const String _host = "http://consensus.zooonews.com";

  ///获取NFT新闻 pageNum pageSize
  static const String getnftnews = _host + "/app/information/news";

  ///获取快讯 pageNum pageSize
  static const String getlettersnews = _host + "/app/information/letters";

  ///我的收藏记录 pageNum pageSize address
  static const String getdappmyCollect = _host + "/app/dapp/myCollect";

  ///取消收藏 address marketId
  static const String getdappcancelCollect = _host + "/app/dapp/cancelCollect";

  ///添加收藏 address marketId
  static const String getdappcollect = _host + "/app/dapp/collect";

  ///获取dapp具体类型集合 dAppType
  static const String getdapptypeList = _host + "/app/dapp/typeList";

  ///首页热门项目
  static const String getindexpopularItem = _host + "/app/index/popularItem";

  ///首页应用
  static const String getindexapplicationInfo =
      _host + "/app/index/applicationInfo";

  ///首页应用
  static const String getindexnftInfo = _host + "/app/index/nftInfo";

  ///获取用户地址持有NFT数量
  static const String getdappType = _host + "/app/dapp/dappType";

  ///Dapp banner
  static const String getdappbannerInfo = _host + "/app/dapp/bannerInfo";

  ///首页banner
  static const String getbannerInfo = _host + "/app/index/bannerInfo";
}
