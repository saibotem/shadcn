import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shadcn/src/button.dart';
import 'package:shadcn/src/card.dart';
import 'package:shadcn/src/icon_button.dart';
import 'package:shadcn/src/input.dart';
import 'package:shadcn/src/lucide_icons.dart';
import 'package:shadcn/src/theme.dart';
import 'package:shadcn/utils/date_time_extension.dart';

class DatePickerController extends ValueNotifier<DateTime?> {
  DatePickerController({DateTime? initialValue}) : super(initialValue);
}

class DatePicker extends StatefulWidget {
  const DatePicker({
    required this.controller,
    required this.textBuilder,
    super.key,
  });

  final DatePickerController controller;
  final String Function(DateTime date) textBuilder;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateText());
    widget.controller.addListener(_updateText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateText);
    _textController.dispose();
    super.dispose();
  }

  void _updateText() {
    final date = widget.controller.value;
    _textController.text = date != null ? widget.textBuilder(date) : '';
  }

  @override
  Widget build(BuildContext context) {
    return Input(
      readOnly: true,
      controller: _textController,
      onTap: () {
        Navigator.of(context).push(
          RawDialogRoute<void>(
            pageBuilder: (context, _, _) {
              return _DatePickerScreen(widget.controller);
            },
          ),
        );
      },
      prefix: const Padding(
        padding: EdgeInsets.only(left: 3),
        child: Icon(LucideIcons.calendar, size: 20),
      ),
      suffix: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) {
          return Visibility(
            visible: widget.controller.value != null,
            child: child!,
          );
        },
        child: IconButton.secondary(
          onPressed: () => widget.controller.value = null,
          icon: const Icon(LucideIcons.x, size: 20),
        ),
      ),
    );
  }
}

class _DatePickerScreen extends StatefulWidget {
  const _DatePickerScreen(this.controller);

  final DatePickerController controller;

  @override
  State<_DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<_DatePickerScreen> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();

    _currentDate = widget.controller.value ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final locale = Localizations.localeOf(context).toString();

    final dateSymbols = DateFormat(null, locale).dateSymbols;

    final days = dateSymbols.WEEKDAYS;
    final shortDays = days.map((day) => day.substring(0, 2)).toList();

    final firstDayOfWeek = (dateSymbols.FIRSTDAYOFWEEK) + 1 % 7;
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month);

    final sortedDays = List.generate(7, (index) {
      return shortDays[(firstDayOfWeek + index) % 7];
    });

    final dayHeaders = <Widget>[const SizedBox(height: 32)];
    for (final day in sortedDays) {
      dayHeaders.add(
        SizedBox(
          height: 32,
          child: Center(
            child: Text(
              day,
              style: textTheme.bodySmall.copyWith(
                color: colorScheme.mutedForeground,
              ),
            ),
          ),
        ),
      );
    }

    final rows = <TableRow>[TableRow(children: dayHeaders)];

    var currentDate = firstDayOfMonth.subtract(
      Duration(days: (firstDayOfMonth.weekday % 7 - firstDayOfWeek + 7) % 7),
    );

    for (var week = 0; week < 6; week++) {
      final rowChildren = <Widget>[
        SizedBox(
          height: 32,
          child: Center(
            child: Text(
              currentDate.weekOfYear.toString(),
              style: textTheme.bodySmall.copyWith(
                color: colorScheme.mutedForeground,
              ),
            ),
          ),
        ),
      ];

      for (var i = 0; i < 7; i++) {
        if (currentDate.month == firstDayOfMonth.month) {
          final dateToSelect = currentDate;

          rowChildren.add(
            _DateButton(
              label: Text(currentDate.day.toString()),
              selected:
                  widget.controller.value?.isSameDay(currentDate) ?? false,
              marked: DateTime.now().isSameDay(currentDate),
              onPressed: () {
                widget.controller.value = dateToSelect;
                Navigator.of(context).pop();
              },
            ),
          );
        } else {
          rowChildren.add(
            SizedBox(
              height: 32,
              child: Center(
                child: Text(
                  currentDate.day.toString(),
                  style: textTheme.body.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                ),
              ),
            ),
          );
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
      rows.add(TableRow(children: rowChildren));
    }

    final labelMonth = DateFormat('MMMM', locale).format(_currentDate);

    return Center(
      child: Card(
        padding: const EdgeInsets.all(12),
        child: IntrinsicWidth(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.ghost(
                    icon: const Icon(LucideIcons.chevronLeft),
                    onPressed: () {
                      setState(() {
                        _currentDate = DateTime(
                          _currentDate.year,
                          _currentDate.month - 1,
                        );
                      });
                    },
                  ),
                  Text(
                    '$labelMonth ${_currentDate.year}',
                    style: textTheme.labelMedium,
                  ),
                  IconButton.ghost(
                    icon: const Icon(LucideIcons.chevronRight),
                    onPressed: () {
                      setState(() {
                        _currentDate = DateTime(
                          _currentDate.year,
                          _currentDate.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),
              Table(
                defaultColumnWidth: const FixedColumnWidth(32),
                children: rows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatefulWidget {
  const _DateButton({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.marked = false,
  });

  final Widget label;
  final bool selected;
  final bool marked;
  final VoidCallback onPressed;

  @override
  State<_DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<_DateButton> {
  bool _isHovering = false;

  void _handleHoveringChange(bool isHovering) {
    if (widget.selected || _isHovering == isHovering) return;
    setState(() => _isHovering = isHovering);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonType = switch ((widget.selected, widget.marked)) {
      (true, _) => ButtonType.primary,
      (false, true) => ButtonType.secondary,
      (false, false) => ButtonType.ghost,
    };

    final hoverColor = buttonType.hoverColor(colorScheme);
    final containerColor = buttonType.containerColor(colorScheme);
    final foregroundColor = buttonType.foregroundColor(colorScheme);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHoveringChange(true),
      onExit: (_) => _handleHoveringChange(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isHovering ? hoverColor : containerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DefaultTextStyle(
            style: theme.textTheme.body.withColor(foregroundColor),
            child: widget.label,
          ),
        ),
      ),
    );
  }
}
