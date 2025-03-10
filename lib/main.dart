import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          StartPage2(),
        ]),
      ),
    );
  }
}

class StartPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: -266,
                top: -47,
                child: Container(
                  width: 906,
                  height: 906,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF9747FF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              const Positioned(
                left: 105,
                top: 341,
                child: Text(
                  'Sherffa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontFamily: 'Nerko One',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}