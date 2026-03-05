class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.total,
    required this.limit,
    required this.skip,
    this.isFromCache = false,
    this.cachedAtEpochMs,
  });

  final List<T> items;
  final int total;
  final int limit;
  final int skip;
  final bool isFromCache;
  final int? cachedAtEpochMs;

  bool get hasMore => skip + limit < total;
}
