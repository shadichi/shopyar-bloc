class InfParams{
  final String productCount;
  final bool isSearch ;
  final String search ;
  final bool isLoadMore ;
  final bool isRefresh ;
  InfParams(this.productCount, this.isSearch, this.search, this.isLoadMore,
      {this.isRefresh = false});
}