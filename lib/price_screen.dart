import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Networking.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String  selectedCurrency='AUD';
  String btcRate='?';
  String ethRate='?';
  String ltcRate='?';

  CupertinoPicker  iosPicker()
  {
    List<Text>pickerItems=[];
    for(String currency in currenciesList)
      {
        pickerItems.add(Text(currency));
      }
    return CupertinoPicker (itemExtent: 32.0, onSelectedItemChanged:(newValue) async {
      Networking networking= Networking(pickerItems[newValue].toString());
      Map<String, String> cryptoPrices =await networking.getData();
      if(cryptoPrices.isNotEmpty && cryptoPrices!=null)
      {
        setState(()  {
          selectedCurrency = pickerItems[newValue].toString();
          btcRate=cryptoPrices['BTC'];
          ethRate=cryptoPrices['ETH'];
          ltcRate=cryptoPrices['LTC'];

        });
      }
    }
    , children: pickerItems);
  }
  DropdownButton<String> androidGetDropDown()
  {
    return DropdownButton<String>(
      value: selectedCurrency,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
          color: Colors.white
      ),
      onChanged: (String  newValue) async {
        Networking networking= Networking(newValue);
        Map<String, String> cryptoPrices =await networking.getData();
        if(cryptoPrices.isNotEmpty && cryptoPrices!=null)
          {
            setState(()  {
              selectedCurrency = newValue;
              btcRate=cryptoPrices['BTC'];
              ethRate=cryptoPrices['ETH'];
              ltcRate=cryptoPrices['LTC'];

            });
          }
      },
      items: currenciesList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child:Text(value),
        );
      })
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💰 Coin Ticker'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
              getPriceEachConversionCard(1),
          getPriceEachConversionCard(2,),
          getPriceEachConversionCard(3),
          Spacer(),
               Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 20.0),
                  color: Colors.lightBlue,
                  child: Platform.isAndroid?androidGetDropDown():iosPicker()
              ),
        ],
      ),
    );
  }
  Padding getPriceEachConversionCard(int cardNo)
  {
    String coinName='';
    String currencyRate='?';
    if(cardNo==1)
      {
        coinName='BTC';
        currencyRate=btcRate;
      }
    else if(cardNo==2)
      {
        coinName='ETH';
        currencyRate=ethRate;
      }

    else if(cardNo==3)
      {
        coinName='LTC';
        currencyRate=ltcRate;
      }
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinName = $currencyRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}




