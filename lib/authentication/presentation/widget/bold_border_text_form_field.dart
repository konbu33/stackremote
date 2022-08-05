import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/gen/assets.gen.dart';

class BoldBorderTextFormField extends StatelessWidget {
  const BoldBorderTextFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();

    ThemeData _themeData = ThemeData(
      backgroundColor: Colors.amber,
      // primarySwatch: Colors.red,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        // border: InputBorder.none,
        // OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.yellow, width: 2.0),
        // ),
      ),
    );

    return Column(
      children: [
        Theme(
          data: _themeData,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: Offset(2, 2)),
              ],
              //   gradient: SweepGradient(
              //     startAngle: math.pi * 0.0,
              //     endAngle: math.pi * 1.0,
              //     colors: [
              //       Colors.red.withOpacity(0.5),
              //       Colors.green.withOpacity(0.5),
              //       Colors.blue.withOpacity(0.5),
              //       Colors.yellow.withOpacity(0.5),
              //       Colors.orange.withOpacity(0.5),
              //     ],
              //     stops: const [
              //       0.0,
              //       0.25,
              //       0.5,
              //       0.75,
              //       1.0,
              //     ],
              //     tileMode: TileMode.clamp,
              //   ),
            ),
            // margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextFormField(
                controller: _textEditingController,
                // decoration: const InputDecoration(
                //   border: InputBorder.none,
                // ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Material(
          elevation: 2,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextFormField(),
        ),
        Container(
          child: Image.asset(Assets.images.backgroundImage.path),
        ),
      ],
    );
  }
}
