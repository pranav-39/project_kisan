import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int page) onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationToolbar(
      middle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaginationPrevious(
            enabled: currentPage > 1,
            onPressed: () => onPageChanged(currentPage - 1),
          ),
          const SizedBox(width: 8),
          PaginationContent(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
          ),
          const SizedBox(width: 8),
          PaginationNext(
            enabled: currentPage < totalPages,
            onPressed: () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}
