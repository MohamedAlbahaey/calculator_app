import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: Calculator(
        isDark: isDark,
        toggleTheme: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;
  const Calculator(
      {super.key, required this.isDark, required this.toggleTheme});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _input = '';
  String _result = '';
  String _operator = '';
  double? _firstOperand;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _input = '';
        _result = '';
        _firstOperand = null;
        _operator = '';
      } else if (value == 'C') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '+' ||
          value == '-' ||
          value == '×' ||
          value == '÷' ||
          value == '%') {
        if (_input.isNotEmpty) {
          _firstOperand = double.tryParse(_input);
          _operator = value;
          _input = '';
          _result = '';
        } else if (_result.isNotEmpty) {
          _firstOperand = double.tryParse(_result);
          _operator = value;
          _input = '';
          _result = '';
        }
      } else if (value == '=') {
        if (_input.isNotEmpty && _firstOperand != null) {
          double? secondOperand = double.tryParse(_input);
          if (secondOperand != null) {
            double res = 0;
            switch (_operator) {
              case '+':
                res = _firstOperand! + secondOperand;
                break;
              case '-':
                res = _firstOperand! - secondOperand;
                break;
              case '×':
                res = _firstOperand! * secondOperand;
                break;
              case '%':
                res = _firstOperand! % secondOperand;
                break;
              case '÷':
                res = _firstOperand! / secondOperand;
                break;
            }
            _result = res.toStringAsFixed(2).replaceAll(RegExp(r"\.00$"), '');
            _input = '';
            _firstOperand = null;
          }
        }
      } else {
        _input += value;
      }
    });
  }

  Widget _buildButton(String text, {Color? color}) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor:
            widget.isDark ? const Color(0xFF292b32) : Color(0xFFf7f7f7),
        foregroundColor: color ?? (widget.isDark ? Colors.white : Colors.black),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 24),
      ),
      child: Text(text),
    );
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final num = double.tryParse(value);
    if (num == null) return value;

    // Format without decimals if it's a whole number, else with up to 2 decimals
    return num == num.toInt()
        ? NumberFormat('#,###').format(num)
        : NumberFormat('#,###.##').format(num);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final gridColor =
        isDark ? const Color(0xFF2b2d36) : Color.fromRGBO(249, 249, 249, 1);
    final opColor = Colors.redAccent;
    final actionColor = Colors.teal;

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // Toggle Theme
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wb_sunny),
                    Switch(
                      value: isDark,
                      onChanged: (_) => widget.toggleTheme(),
                    ),
                    const Icon(Icons.nightlight_round),
                  ],
                ),
              ),
            ),

            // Result Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_firstOperand != null && _operator.isNotEmpty)
                      Text(
                        '${_formatNumber(_firstOperand!.toString())} $_operator $_input',
                        style: TextStyle(fontSize: 22, color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    Text(
                      _result.isNotEmpty
                          ? _formatNumber(_result)
                          : _input.isNotEmpty
                              ? _formatNumber(_input)
                              : '0',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Buttons Grid
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: gridColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('AC', color: actionColor),
                        _buildButton('%', color: actionColor),
                        _buildButton('C', color: actionColor),
                        _buildButton('÷', color: opColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×', color: opColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-', color: opColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', color: opColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('00'),
                        _buildButton('0'),
                        _buildButton('.'),
                        _buildButton('=', color: opColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
