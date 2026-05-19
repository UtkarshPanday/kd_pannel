import 'package:flutter/material.dart';
import 'package:kd_pannel/app_theme.dart';

class TableWidget extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  const TableWidget({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingXLarge - 12), // 20
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTheme.headingMD),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text('View All', style: AppTheme.hint),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingMedium),
          _buildTable(context),
        ],
      ),
    );
  }

  /// Returns true for columns whose cells render a fixed-size badge or button.
  bool _isCompactColumn(int index) {
    // Check the header name
    final header = columns[index].toLowerCase();
    if (header == 'status') return true;
    // Also treat any column where every row cell is a badge/button value
    final badgeValues = {'Completed', 'Pending', 'FOLLOW_UP_BTN'};
    return rows.isNotEmpty &&
        rows.every(
          (row) => index < row.length && badgeValues.contains(row[index]),
        );
  }

  Widget _buildTable(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1200;

    // Build column widths: compact columns (Status, button cols) get
    // IntrinsicColumnWidth so they shrink to content; others flex equally.
    final Map<int, TableColumnWidth> colWidths = {
      for (int i = 0; i < columns.length; i++)
        i: _isCompactColumn(i)
            ? const IntrinsicColumnWidth()
            : const FlexColumnWidth(1),
    };

    Widget table = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: colWidths,
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.lightBorderColor),
            ),
          ),
          children: columns
              .map(
                (col) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: AppTheme.spacingXSmall,
                  ),
                  child: Text(col, style: AppTheme.tableHeader),
                ),
              )
              .toList(),
        ),
        // Data Rows
        ...rows.map(
          (row) => TableRow(
            children: row.asMap().entries.map((entry) {
              final index = entry.key;
              final cell = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: AppTheme.spacingXSmall,
                ),
                child: _buildCell(index, cell),
              );
            }).toList(),
          ),
        ),
      ],
    );

    if (isDesktop) return table;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 500),
        child: table,
      ),
    );
  }

  Widget _buildCell(int index, String cell) {
    if (cell == 'FOLLOW_UP_BTN') {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.warning,
          foregroundColor: AppTheme.cardColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text('Follow Up', style: AppTheme.button),
      );
    }

    if (cell == 'Completed' || cell == 'Pending') {
      final isCompleted = cell == 'Completed';
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFFECFDF5)
                : const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Text(
            cell,
            style: AppTheme.labelSM.copyWith(
              color: isCompleted
                  ? const Color(0xFF059669)
                  : const Color(0xFFD97706),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Text(cell, style: AppTheme.tableCell);
  }
}
