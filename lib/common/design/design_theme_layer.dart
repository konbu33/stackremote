import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nested/nested.dart';

class DesignThemeLayer extends SingleChildStatelessWidget {
  const DesignThemeLayer({
    Key? key,
    Widget? child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Theme(
      // 基本的な属属をfromメソッドで指定
      data: ThemeData.from(
        // カラー
        colorScheme: const ColorScheme.light(primary: Colors.cyan),

        // タイポグラフィ
        textTheme: GoogleFonts.mPlus1TextTheme(
          Typography.material2018().black,
        ),

        // 以下の属性は、デフォルト設定を上書き設定
      ).copyWith(
        // Scaffoldの背景色の透明度
        scaffoldBackgroundColor: Colors.white.withOpacity(0.8),

        // TextField
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey.withOpacity(0.3),
          filled: true,
          helperStyle: const TextStyle(
            color: Colors.cyan,
          ),
        ),

        // AppBar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          iconTheme: IconThemeData(
            color: Colors.black26,
          ),
        ),
      ),
      child: child ?? const Text("no child"),
    );
  }
}
