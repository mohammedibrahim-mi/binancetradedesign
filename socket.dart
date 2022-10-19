import 'dart:convert';
import 'package:Sample/api/model/Socketdata.dart';
import 'package:Sample/custom/app_config.dart';
import 'package:Sample/custom/colors.dart';
import 'package:Sample/widgets/darkcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:websocket_manager/websocket_manager.dart';

class socketful extends StatefulWidget {
  const socketful({Key key}) : super(key: key);

  @override
  State<socketful> createState() => _socketfulState();
}

class _socketfulState extends State<socketful> {


  WebsocketManager binanceWebSocketManager = WebsocketManager('wss://stream.binance.com:9443/ws');
  IOWebSocketChannel binanceWebIOSocketManager = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
  List<List<String>> a;
  List<List<String>> b;
  ScrollController _controller = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketCall();
    a = [];
    b = [];
  }

  socketCall() {
      binanceWebSocketManager.close();
      binanceWebIOSocketManager = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
      listerBinanceSocket();
  }

  listerBinanceSocket() {
    String c = "btc";
    String ca = "usdt";
    // String c = coinOne.toLowerCase();
    // String ca = coinTwo.toLowerCase();
    var jsonData =
        '{"method": "SUBSCRIBE","params": ["$c$ca@depth@1000ms"],"id": 1}';
    //print(userId);
    print('Android $jsonData');
      binanceWebIOSocketManager.sink.add(jsonData);
      binanceWebIOSocketManager.stream.listen((dynamic message) {
        if (message != null) {
          Map userMap = jsonDecode(message);
          if (userMap["result"] == null && userMap["e"].toString() != "") {
            var user = SocketData.fromJson(userMap);
            List<List<String>> sample;
            sample = user.a;
            if (a != null && a.length > 10) {
              a.removeRange(0, a.length);
            }
            for (int index = 0; index < sample.length; index++) {
              String as = sample[index].toString();
              String amountValue =
              as.split(" ")[1].toString().replaceAll("]", " ");
              if (double.parse(amountValue) > 0) {
                a.insert(0, sample[index]);
                print("v111"+a.toString());
              }
            }

            List<List<String>> sampleSell;
            sampleSell = user.b;
            if (b != null && b.length > 10) {
              b.removeRange(0, b.length);
            }
            for (int index = 0; index < sampleSell.length; index++) {
              String as = sampleSell[index].toString();
              String amountValue =
              as.split(" ")[1].toString().replaceAll("]", " ");
              if (double.parse(amountValue) > 0) {
                b.insert(0, sampleSell[index]);
              }
            }
          }
          setState(() {});
        }
      });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Container(
                height: 800,
                width:200,
                child: ListView(
                  children: <Widget>[
                    Container(
                      //color: Color(0xFFC50E94),
                      child: SingleChildScrollView(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Price",
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      color:   DarkColor.white,
                                    ),),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Amount",
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 12,
                                    color:   DarkColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0,),

                    Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: a == null ? 0 : a.length,
                            itemBuilder: (BuildContext context, int index) {
                              String as = a[index].toString();
                              String priceValue =
                              as.split(" ")[0].toString().replaceAll("[,+", "");
                              String amountValue =
                              as.split(" ")[1].toString().replaceAll("]", " ");
                              priceValue =
                                  as.split(" ")[0].toString().replaceAll("[", "");
                              if (priceValue.endsWith(",")) {
                                priceValue =
                                    priceValue.substring(0, priceValue.length - 1);
                              }
                              return new GestureDetector(
                                //You need to make my child interactive
                                onTap: () {

                                },
                                child: Container(
                                  height: 21,

                                  //color: color,
                                  child: Column(
                                    children: [
                                      new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            double.parse(priceValue.toString()).toStringAsFixed(4),
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 12,
                                              color:  DarkColor.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),

                                          Text(
                                            amountValue,
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 12,
                                              color:   DarkColor.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
              SizedBox(width: 5.0,),
              Container(
                height: 800,
                width:200,
                child:
                ListView(
                  children: <Widget>[
                    Container(
                      //color: Color(0xFFC50E94),
                      child: SingleChildScrollView(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text("Price",
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14,
                                      color:   DarkColor.white,
                                    ),),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Amount",
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 12,
                                    color:   DarkColor.white,
                                  ),
                                ),                     
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            controller: _controller,
                            shrinkWrap: true,
                            itemCount: b == null ? 0 : b.length,
                            itemBuilder: (BuildContext context, int index) {
                              String as = b[index].toString();
                              String priceValue =
                              as.split(" ")[0].toString().replaceAll("[,+", "");
                              String amountValue =
                              as.split(" ")[1].toString().replaceAll("]", " ");
                              priceValue =
                                  as.split(" ")[0].toString().replaceAll("[", "");
                              if (priceValue.endsWith(",")) {
                                priceValue =
                                    priceValue.substring(0, priceValue.length - 1);
                              }                  
                              return new GestureDetector(
                                //You need to make my child interactive
                                onTap: () {


                                },
                                child: Container(
                                  height: 21,
                                  //color: color,
                                  child: Column(
                                    children: [
                                      new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            double.parse( priceValue.toString()).toStringAsFixed(4),
                                            style:  GoogleFonts.comfortaa(
                                                fontSize: 12,
                                                color: AppColors.red
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            amountValue,
                                            style: GoogleFonts.comfortaa(
                                              fontSize: 12,
                                              color:  DarkColor.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                    ),
                  ],
                ),


              )
            ],
          ),
        ),
      ),
    );
  }
}
