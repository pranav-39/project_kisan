import 'package:flutter/material.dart';

class AppTable extends StatelessWidget {
  final List<TableRow> rows;
  final TableRow? header;
  final TableRow? footer;
  final String? caption;

  const AppTable({
    super.key,
    required this.rows,
    this.header,
    this.footer,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                caption!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {},
            children: [
              if (header != null) header!,
              ...rows,
              if (footer != null) footer!,
            ],
          ),
        ],
      ),
    );
  }
}

class AppTableRow extends TableRow {
  AppTableRow({required List<Widget> children})
      : super(
    children: children
        .map((child) => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: child,
    ))
        .toList(),
  );
}
