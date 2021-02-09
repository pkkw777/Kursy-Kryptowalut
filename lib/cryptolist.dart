import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kursy_kryptowalut/search.dart';
import 'package:http/http.dart' as http;
import 'functions.dart';
import 'main.dart';

class CryptoListState extends State<CryptoList> {
  List cryptoCurrencies = [];
  bool stateControl = false;
  final List<MaterialColor> colorsList = [Colors.amber, Colors.deepOrange, Colors.green, Colors.purple, Colors.indigo, Colors.lightBlue, Colors.teal, Colors.cyan];
  Timer timer;

  //Pobieranie listy kryptowalut z api
  Future<void> getCryptoCurrenciesPrices() async {
    var response = await http.get(
        Uri.encodeFull("https://api.coinpaprika.com/v1/ticker/"),
        headers: {"Accept": "application/json"});

    setState(() {
      this.stateControl = true;
    });

    this.setState(() {
      this.stateControl = false;
      cryptoCurrencies = json.decode(response.body);
    });
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
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => getCryptoCurrenciesPrices());
  }

  //Baner
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: (){
                showSearch(context: context, delegate: CryptoCurrencySearch());
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