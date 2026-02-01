import 'package:flutter/gestures.dart';
import 'package:shadcn/shadcn.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

const double kRowHeight = 28;
const double kHeaderHeight = kRowHeight + 12;

class TableColumn {
  const TableColumn({
    required this.minWidth,
    required this.headerTitle,
    required this.cellBuilder,
    this.onSortTap,
    this.orderDescending,
  });

  final double minWidth;
  final Widget headerTitle;
  final bool? orderDescending;
  final ValueChanged<bool?>? onSortTap;
  final Widget Function(BuildContext context, int index) cellBuilder;
}

class DataTable extends StatefulWidget {
  const DataTable({
    required this.columns,
    required this.itemCount,
    super.key,
    this.onRowTap,
  });

  final int itemCount;
  final List<TableColumn> columns;
  final void Function(int index)? onRowTap;

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> {
  final List<double> _columnWidths = [];
  final _hoveredRowIndex = ValueNotifier<int?>(null);
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    for (final column in widget.columns) {
      _columnWidths.add(column.minWidth);
    }
  }

  @override
  void dispose() {
    _hoveredRowIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Scrollbar.vertical(
      fullScreen: true,
      controller: verticalScrollController,
      padding: const EdgeInsets.fromLTRB(0, kHeaderHeight + 4, 4, 16),
      child: Scrollbar.horizontal(
        fullScreen: true,
        controller: horizontalScrollController,
        padding: const EdgeInsets.fromLTRB(4, 0, 16, 4),
        child: DefaultTextStyle(
          style: theme.textTheme.body.copyWith(
            fontSize: 13,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
          child: TableView.builder(
            pinnedRowCount: 1,
            columnCount: widget.columns.length,
            rowCount: widget.itemCount + 1,
            verticalDetails: ScrollableDetails.vertical(
              controller: verticalScrollController,
            ),
            horizontalDetails: ScrollableDetails.horizontal(
              controller: horizontalScrollController,
            ),
            columnBuilder: (int index) {
              if (index == widget.columns.length - 1) {
                return TableSpan(
                  extent: MaxSpanExtent(
                    const RemainingSpanExtent(),
                    FixedSpanExtent(_columnWidths[index]),
                  ),
                );
              }

              return TableSpan(extent: FixedSpanExtent(_columnWidths[index]));
            },
            rowBuilder: (int index) {
              if (index == 0 || widget.onRowTap == null) {
                return TableSpan(
                  extent: FixedTableSpanExtent(
                    index == 0 ? kHeaderHeight : kRowHeight,
                  ),
                  backgroundDecoration: SpanDecoration(
                    border: SpanBorder(
                      trailing: BorderSide(color: colorScheme.border),
                    ),
                  ),
                );
              }

              return TableSpan(
                extent: const FixedTableSpanExtent(kRowHeight),
                cursor: SystemMouseCursors.click,
                backgroundDecoration: SpanDecoration(
                  border: SpanBorder(
                    trailing: BorderSide(color: colorScheme.border),
                  ),
                ),
                recognizerFactories: <Type, GestureRecognizerFactory>{
                  TapGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        TapGestureRecognizer
                      >(TapGestureRecognizer.new, (
                        TapGestureRecognizer instance,
                      ) {
                        instance.onTap = () => widget.onRowTap!(index - 1);
                      }),
                },
              );
            },
            cellBuilder: (BuildContext context, TableVicinity vicinity) {
              if (vicinity.row == 0) {
                final iconSuffix =
                    switch (widget.columns[vicinity.column].orderDescending) {
                      false => const Icon(LucideIcons.chevronsDown, size: 18),
                      true => const Icon(LucideIcons.chevronsUp, size: 18),
                      null => null,
                    };

                return TableViewCell(
                  child: Row(
                    children: [
                      if (vicinity.column == 0) const SizedBox(width: 8),
                      Expanded(
                        child: IgnorePointer(
                          ignoring:
                              widget.columns[vicinity.column].onSortTap == null,
                          child: Button.ghost(
                            height: 28,
                            onPressed: () {
                              widget.columns[vicinity.column].onSortTap?.call(
                                switch (widget
                                    .columns[vicinity.column]
                                    .orderDescending) {
                                  true => null,
                                  false => true,
                                  null => false,
                                },
                              );
                            },
                            iconSuffix: iconSuffix,
                            label: widget.columns[vicinity.column].headerTitle,
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.resizeColumn,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              final index = vicinity.column;
                              _columnWidths[index] =
                                  (_columnWidths[index] + details.delta.dx)
                                      .clamp(
                                        widget.columns[index].minWidth,
                                        double.infinity,
                                      );
                            });
                          },
                          child: Container(
                            width: 1,
                            color: colorScheme.primary,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return TableViewCell(
                child: ValueListenableBuilder<int?>(
                  valueListenable: _hoveredRowIndex,
                  builder: (context, hoveredRow, child) {
                    if (hoveredRow == vicinity.row) {
                      child = ColoredBox(
                        color: colorScheme.secondary,
                        child: child,
                      );
                    }

                    return MouseRegion(
                      onEnter: (_) => _hoveredRowIndex.value = vicinity.row,
                      onExit: (_) {
                        if (_hoveredRowIndex.value == vicinity.row) {
                          _hoveredRowIndex.value = null;
                        }
                      },
                      child: child,
                    );
                  },
                  child: Row(
                    children: [
                      if (vicinity.column == 0) const SizedBox(width: 8),
                      const SizedBox(width: 8),
                      Expanded(
                        child: widget.columns[vicinity.column].cellBuilder(
                          context,
                          vicinity.row - 1,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
