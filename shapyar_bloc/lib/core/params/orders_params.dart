class OrdersParams{
  final int orderCount;
  final String filter;
  final Map<String, dynamic> response;
  final String search ;
  final String perPage ;
  final String status ;
  OrdersParams(this.orderCount,  this.filter,  this.response, this.search, this.perPage, this.status);
}