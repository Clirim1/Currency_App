import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      title: "Currency Converter",
      home: Corrency_Converter(),
      
    ));

class Corrency_Converter extends StatefulWidget {
  @override
  _Corrency_ConverterState createState() => _Corrency_ConverterState();
}

class _Corrency_ConverterState extends State<Corrency_Converter> {
  final fromTextController = TextEditingController();
  List<String> currencies;
  String from_Corrency = "CAD";
  String to_Corrency = "CHF";
  String result;
  @override
  void initState() {
    super.initState();
    _load_Currencies();
  }

  Future<String> _load_Currencies() async {
    String uri ="https://api.exchangeratesapi.io/latest";
       
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Acept": "application/json"});
    var response_Body = json.decode(response.body);
    Map cur_Map = response_Body['rates'];
    currencies = cur_Map.keys.toList();
    setState(() {});
    
    return "Sucess";
  }

    Future<String> _do_Conversion() async{

    String uri = "https://api.exchangeratesapi.io/latest?base=$from_Corrency&symbols=$to_Corrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Acept": "application/json"});
    var response_Body = json.decode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) * (response_Body['rates'][to_Corrency])).toString();
    });
     result = response_Body['rates'][to_Corrency];
    print(result);
    return "Sucess";

  }

  form_Changed(String value){
    setState(() {
      from_Corrency = value;

    });
  }
    to_Changed(String value){
    setState(() {
      to_Corrency = value;

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(title: Text("Currency Converter"), backgroundColor: Colors.green,),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height ,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromTextController ,
                          style: TextStyle(fontSize:35.0, color:Colors.black),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                              
                        ),
                        trailing: _buildDrop_DownButton(from_Corrency),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: _do_Conversion,
                      ),
                      ListTile(
                        title: Chip(
                          backgroundColor: Colors.greenAccent,
                          label: result != null?
                          Text(
                            result,
                            style: Theme.of(context).textTheme.display1,
                          ): Text(""),
                          
                        ),
                        trailing: _buildDrop_DownButton(to_Corrency),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDrop_DownButton(String Corrency_Category) {
    return DropdownButton(
     value: Corrency_Category,
      items: currencies
          .map(
            (String value) => DropdownMenuItem(
              value: value,
              child: Row(
                children: <Widget>[
                  Text(value),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (String value) {
        if(Corrency_Category == from_Corrency){
        form_Changed(value);}
        else{
          to_Changed(value);
        }
      },
    );
  }
}