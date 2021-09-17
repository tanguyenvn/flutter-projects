import 'package:flutter/material.dart';
import 'package:unit_converter/category_route.dart';

class ConverterRoute extends StatefulWidget {
  final String name;
  final Color color;
  final List<Unit> units;

  ConverterRoute(
      {required this.name, required this.color, required this.units});

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  late List<DropdownMenuItem> _unitMenuItems;
  late Unit _fromUnit;
  late Unit _toUnit;
  late double _fromValue;
  late String _toValue;
  late bool _showValidationError;

  @override
  void initState() {
    //set default data
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Text(unit.name),
      ));
    }
    _unitMenuItems = newItems;
    _fromUnit = widget.units[0];
    _toUnit = widget.units[1];
    _toValue = '';
    _showValidationError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: widget.color,
        ),
        body: Column(
          children: [
            _inputGroup(),
            _separator(),
            _outputGroup(),
          ],
        ));
  }

  RotatedBox _separator() {
    return const RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );
  }

  Widget _inputGroup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Input',
              errorText: _showValidationError ? 'Invalid number entered' : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
            ),
            onChanged: _inputValueChangeHandler,
          ),
          _getDropdownField(_fromUnit, _inputUnitChangeHandler),
        ],
      ),
    );
  }

  Widget _outputGroup() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Output',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0)),
              ),
              child: Text(_toValue),
            ),
            _getDropdownField(_toUnit, _outputUnitChangeHandler),
          ],
        ));
  }

  Widget _getDropdownField(Unit unit, changeHandler) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: unit.name,
        items: _unitMenuItems,
        onChanged: changeHandler,
      ),
    );
  }

  void _inputUnitChangeHandler(unitName) {
    var newUnit =
        widget.units.firstWhere((Unit unit) => (unit.name == unitName));
    setState(() {
      _fromUnit = newUnit;
      _calcConversion();
    });
  }

  void _outputUnitChangeHandler(unitName) {
    var newUnit =
        widget.units.firstWhere((Unit unit) => (unit.name == unitName));
    setState(() {
      _toUnit = newUnit;
      _calcConversion();
    });
  }

  void _inputValueChangeHandler(String newValue) {
    setState(() {
      if (newValue.isEmpty) {
        _toValue = '';
      } else {
        try {
          _fromValue = double.parse(newValue);
          _calcConversion();
          _showValidationError = false;
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  void _calcConversion() {
    var convertedValue = _fromValue * _toUnit.conversion / _fromUnit.conversion;
    _toValue = convertedValue.toString();
  }
}
