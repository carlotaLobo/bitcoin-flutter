import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform; // para saber el SO
import 'conectionApi.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String itemSelect = currenciesList[0];
  List<dynamic> listaRateCoin = [];
  var base;
  var data;
  var rate;
  var coin;
  @override
  void initState() {
    super.initState();
    getDataInit();
  }

  Future<void> getDataInit() async {
    listaRateCoin = [];
    for (var crypto in cryptoList) {
      data = await ConnectionApi(coin: itemSelect, crypto: crypto).getData();
      setState(() {
        listaRateCoin.add(data);
      });
    }
  }

  DropdownButton<String> getDropdownButtom() {
    // PARA ANDROID ES OTRO DESPLEGABLE
    List<DropdownMenuItem> dropdownItems = [];
    for (var item in currenciesList) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(item),
          value: item,
        ),
      );
    }

    return DropdownButton<String>(
      items: dropdownItems,
      onChanged: (value) async {
        itemSelect = value;
        getDataInit();
      },
      value: itemSelect,
    );
  }

  CupertinoPicker iosPicker() {
    // PARA IOS, LISTA
    List<Text> listItems = [];

    for (var item in currenciesList) {
      listItems.add(
        Text(
          item,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    return CupertinoPicker(
        itemExtent: 32.0, // dimensiones del scroll
        onSelectedItemChanged: (selectedIndex) async {
          itemSelect = currenciesList[selectedIndex];
          getDataInit();
        },
        children: listItems);
  }

  List<Widget> containerCoin() {
    List<Widget> listaContainerCoin = [];

    for (var datas in listaRateCoin) {
      rate = datas['rate'];
      coin = datas['asset_id_quote'];
      base = datas['asset_id_base'];

      listaContainerCoin.add(
        Container(
          width: 400,
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                '1 $base = $rate $coin',
              ),
            ),
          ),
        ),
      );
    }
    return listaContainerCoin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: containerCoin(),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iosPicker() : getDropdownButtom()),
        ],
      ),
    );
  }
}
