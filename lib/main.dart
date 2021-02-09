import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'cryptolist.dart';

void main() {
  runApp(
      EasyDynamicThemeWidget(
        child: CryptoCurrencyTracker(),
      ),
  );
}

class CryptoCurrencyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacja do śledzenia kursów kryptowalut',
      theme: new ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: CryptoList(),
    );
  }
}

class CryptoList extends StatefulWidget {
  @override
  CryptoListState createState() => CryptoListState();
}