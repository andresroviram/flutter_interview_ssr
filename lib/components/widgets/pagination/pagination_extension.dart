extension PaginationExtension<T> on List<T> {
  List<T> paginate(int page, int itemsPerPage) {
    final startIndex = (page - 1) * itemsPerPage;
    if (startIndex >= length) {
      return [];
    }
    final endIndex = (startIndex + itemsPerPage).clamp(0, length);
    return sublist(startIndex, endIndex);
  }

  bool hasMorePages(int currentPage, int itemsPerPage) {
    return currentPage * itemsPerPage < length;
  }

  int getTotalPages(int itemsPerPage) {
    return (length / itemsPerPage).ceil();
  }
}
