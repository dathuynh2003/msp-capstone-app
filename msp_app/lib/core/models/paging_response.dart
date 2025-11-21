class PagingResponse<T> {
  final List<T> items;
  final int totalItems;
  final int pageIndex;
  final int pageSize;

  PagingResponse({
    required this.items,
    required this.totalItems,
    required this.pageIndex,
    required this.pageSize,
  });

  factory PagingResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) itemFromJson, // !!! dynamic (not Map<String, dynamic>)
  ) {
    return PagingResponse(
      items: List<T>.from((json['items'] ?? []).map(itemFromJson)),
      totalItems: json['totalItems'] ?? 0,
      pageIndex: json['pageIndex'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
    );
  }
}
