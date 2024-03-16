import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class InputDate extends StatefulWidget {
  final String labelText;
  final Function(DateTime?) onDateSelected;

  const InputDate(
      {super.key, required this.labelText, required this.onDateSelected});

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime? dataSelecionada;

  @override
  Widget build(BuildContext context) {
    DateTime? dataSelecionada = DateTime.now();

    return DateTimeField(
      dateFormat: DateFormat('dd/MM/yyyy'),
      value: dataSelecionada,
      mode: DateTimeFieldPickerMode.date,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            dataSelecionada = value;
          });

          widget.onDateSelected(dataSelecionada);
        }
      },
    );
  }
}
