import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;


void main() async {
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

class CryptoListState extends State<CryptoList> {
  List cryptoCurrencies = [];
  bool stateControl = false;
  final List<MaterialColor> colorsList = [Colors.amber, Colors.deepOrange, Colors.green, Colors.purple, Colors.indigo, Colors.lightBlue, Colors.teal, Colors.cyan];

  //Pobieranie listy kryptowalut z api
  Future<void> getCryptoCurrenciesPrices() async {
    String api = "https://api.coinpaprika.com/v1/ticker/";
    setState(() {
      this.stateControl = true;
    });
    http.Response response = await http.get(api);
    setState(() {
      this.cryptoCurrencies = jsonDecode(response.body);
      this.stateControl = false;
      print(cryptoCurrencies);
    });
    return;
  }

  //Tworzenie loga kryptowaluty
  CircleAvatar getMainWidget(String name, MaterialColor color) {
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(name[0]),
    );
  }

  getMainBody() {
    if (stateControl) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
        child: buildCryptoCurrencyList(),
        onRefresh: getCryptoCurrenciesPrices,
      );
    }
  }

  //Pobranie cen po otwarciu aplikacji
  @override
  void initState() {
    super.initState();
    getCryptoCurrenciesPrices();
  }

  //Baner
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: (){
                //showSearch(context: context, delegate: Search());
              },
              icon: Icon(Icons.search),
            )
        ],
          title: Text('Kursy Kryptowalut'),
          centerTitle: true,
        ),
        body: getMainBody());
  }

  //Budowanie listy kryptowlut
  Widget buildCryptoCurrencyList() {
    return ListView.builder(
        itemCount: cryptoCurrencies.length, //ilość do wyświetlenia (all)
        padding:
        const EdgeInsets.all(20.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          final MaterialColor color = colorsList[index % colorsList.length];
          return buildCryptoRow(cryptoCurrencies[index], color);
        });
  }

  //Budowanie pojedynczego wiersza
  Widget buildCryptoRow(Map crypto, MaterialColor color) {
    return  ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: getMainWidget(crypto['name'], color),
                )
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Text ('${crypto['symbol']} | ${crypto['name']}'),
                  )
                ]
            ),

            Expanded(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text ('\$${(crypto['price_usd'])}'),
                          )
                        ]
                    )
                )
            )
          ],
        ),

        Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('1h: ${(crypto['percent_change_1h'])}%', style: TextStyle(color: getColor((crypto['percent_change_1h']).toString()))),
                  Text('24h: ${(crypto['percent_change_24h'])}%', style: TextStyle(color: getColor((crypto['percent_change_24h']).toString()))),
                  Text('7d: ${(crypto['percent_change_7d'])}%', style: TextStyle(color: getColor((crypto['percent_change_7d']).toString()))),
                ]
            )
        )
      ],
    );
  }
}

getColor(String string) {
  if(string.contains(("-")))
    return hexToColor('#FF0000');
  else
    return hexToColor('#32CD32');
}

hexToColor(String color) {
  return new Color(int.parse(color.substring(1,7),radix: 16) + 0xFF000000);
}