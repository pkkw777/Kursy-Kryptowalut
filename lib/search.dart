import 'dart:convert';
import 'package:flutter/material.dart';
import 'cryptolist.dart';
import 'package:http/http.dart' as http;

class CryptoCurrencySearch extends SearchDelegate<CryptoListState>{
  final CryptoListState ani = new CryptoListState();
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon:Icon(Icons.arrow_back),);
  }

  @override
  Widget buildResults(BuildContext context) {
    return getSearchResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return getSearchResult();
  }

  Future<void> getCryptoCurrenciesPrices() async {
    var response = await http.get(
        Uri.encodeFull("https://api.coinpaprika.com/v1/ticker/"),
        headers: {"Accept": "application/json"});
    ani.cryptoCurrencies = json.decode(response.body);
  }

  StatelessWidget getSearchResult() {
    getCryptoCurrenciesPrices();
    final myList = query.isEmpty? ani.cryptoCurrencies
        : ani.cryptoCurrencies.where((p) => p['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return myList.isEmpty? Text('Brak kryptowaluty...', style: TextStyle(fontSize: 20),)
        : ListView.builder(
        itemCount: myList.length, //ilość do wyświetlenia (all)
        padding:
        const EdgeInsets.all(20.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          final MaterialColor color = ani.colorsList[index % ani.colorsList.length];
          return ani.buildCryptoRow(myList[index], color);
        });
  }
}