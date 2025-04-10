import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';

class CustomDateInput extends StatefulWidget {
  const CustomDateInput({
    Key? key,
    required this.onDateRangeChanged,
    required this.dateRange,
    required this.theme,
    required this.startLabelText,
    required this.endLabelText,
    this.minDate,
    this.maxDate,
  }) : super(key: key);

  final ValueChanged<DateRange?> onDateRangeChanged;
  final DateRange dateRange;
  final CalendarTheme theme;
  final String startLabelText;
  final String endLabelText;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final FocusNode _startFocusNode = FocusNode();
  final FocusNode _endFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values
    _startController.text = _dateFormat.format(widget.dateRange.start);
    _endController.text = _dateFormat.format(widget.dateRange.end);

    // Add listeners to focus nodes to trigger UI updates when focus changes
    _startFocusNode.addListener(() {
      setState(() {});
    });
    _endFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _startFocusNode.dispose();
    _endFocusNode.dispose();
    super.dispose();
  }

  void _updateDateRange() {
    try {
      // Check if the input strings can be parsed with the defined date format
      if (!_isValidDateFormat(_startController.text) ||
          !_isValidDateFormat(_endController.text)) {
        return;
      }

      final startDate = _dateFormat.parse(_startController.text);
      final endDate = _dateFormat.parse(_endController.text);

      // Check if dates are within min/max limits
      if (widget.minDate != null && startDate.isBefore(widget.minDate!)) {
        return;
      }
      if (widget.maxDate != null && endDate.isAfter(widget.maxDate!)) {
        return;
      }

      if (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        widget.onDateRangeChanged(DateRange(startDate, endDate));
      }
    } catch (e) {
      // Invalid date format, ignore
    }
  }

  bool _isValidDateFormat(String input) {
    try {
      // Use the already defined _dateFormat to validate
      _dateFormat.parseStrict(input);
      return input.length == _dateFormat.pattern?.length;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update controllers without triggering selection
    if (_startController.text != _dateFormat.format(widget.dateRange.start)) {
      _startController.value = TextEditingValue(
        text: _dateFormat.format(widget.dateRange.start),
        selection: TextSelection.collapsed(
          offset: _dateFormat.format(widget.dateRange.start).length,
        ),
      );
    }

    if (_endController.text != _dateFormat.format(widget.dateRange.end)) {
      _endController.value = TextEditingValue(
        text: _dateFormat.format(widget.dateRange.end),
        selection: TextSelection.collapsed(
          offset: _dateFormat.format(widget.dateRange.end).length,
        ),
      );
    }

    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _startFocusNode,
                controller: _startController,
                decoration: InputDecoration(
                  labelText: widget.startLabelText,
                  hintText: 'YYYY-MM-DD',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(
                    color:
                        _startFocusNode.hasFocus ? Colors.black : Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today,
                      color: _startFocusNode.hasFocus
                          ? Colors.black
                          : Colors.grey),
                ),
                onChanged: (_) => _updateDateRange(),
                enabled: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                focusNode: _endFocusNode,
                controller: _endController,
                decoration: InputDecoration(
                  labelText: widget.endLabelText,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'YYYY-MM-DD',
                  labelStyle: TextStyle(
                    color: _endFocusNode.hasFocus ? Colors.black : Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today,
                      color:
                          _endFocusNode.hasFocus ? Colors.black : Colors.grey),
                ),
                onChanged: (_) => _updateDateRange(),
                enabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
