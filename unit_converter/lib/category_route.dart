import 'package:flutter/material.dart';
import 'package:unit_converter/converter_route.dart';

final _backgroundColor = Colors.green[50];

class CategoryRoute extends StatefulWidget {
  const CategoryRoute({Key? key}) : super(key: key);

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  final List<Category> _categories = <Category>[];
  static const _categoryMap = {
    'Length': Colors.teal,
    'Area': Colors.orange,
    'Volume': Colors.pinkAccent,
    'Mass': Colors.blueAccent,
    'Time': Colors.yellow,
    'Digital Storage': Colors.greenAccent,
    'Energy': Colors.purpleAccent,
    'Currency': Colors.red,
  };

  @override
  void initState() {
    _categoryMap.forEach((name, color) {
      var units = List.generate(5, (i) {
        i++;
        return Unit(name: "$name Unit $i", conversion: i.toDouble());
      });
      _categories.add(
          Category(name: name, color: color, icon: Icons.cake, units: units));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Unit Converter', style: TextStyle(color: Colors.black)),
        backgroundColor: _backgroundColor,
        elevation: 0.0,
      ),
      body: _categoryList(),
    );
  }

  Widget _categoryList() {
    return Container(
      color: _backgroundColor,
      child: ListView.builder(
        itemBuilder: (context, index) => _categories[index],
        itemCount: _categories.length,
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String name;
  final ColorSwatch color;
  final IconData icon;
  final List<Unit> units;

  Category(
      {required this.name,
      required this.color,
      required this.icon,
      required this.units});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goToConverterRoute(context),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 52.0),
          ),
          Text(name)
        ],
      ),
    );
  }

  void _goToConverterRoute(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ConverterRoute(
        name: name,
        color: color,
        units: units,
      );
    }));
  }
}

class Unit {
  final String name;
  final double conversion;

  Unit({required this.name, required this.conversion});
}
