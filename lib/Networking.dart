import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'coin_data.dart';

const apiKey='Enter Your Own API KEY here found on https://www.coinapi.io/';
class Networking
{
  String currencyName;

  Networking(String currencyName)
  {
    this.currencyName=currencyName;
  }

  Future getData() async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      Map<String, String> cryptoPrices = {};
      for(String list in cryptoList)
      {
        String url='https://rest.coinapi.io/v1/exchangerate/$list/$currencyName?apikey=$apiKey';
        http.Response response = await http.get(Uri.parse(url));
        if(response.statusCode==200)
        {
          String data=response.body;
          var decodeData=jsonDecode(data);
          double price = decodeData['rate'];
          cryptoPrices[list] = price.toStringAsFixed(0);
        }
        else{
          Fluttertoast.showToast(
              msg: 'Status code ${response.statusCode.toString()}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
              fontSize: 16.0);
          return null;
        }
      }
      return cryptoPrices;
    }
    else{
      Fluttertoast.showToast(
          msg: 'Check your Internet connection',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 16.0);
      return null;

    }


  }

}