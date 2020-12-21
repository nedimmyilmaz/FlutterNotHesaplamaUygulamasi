import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfKredi = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  var ortalama = 0.0;
  static int sayac = 0;

  @override
  void initState() {
    super.initState();
    tumDersler = [];
    debugPrint("liste kaydı $dersAdi, $dersKredi, $dersHarfKredi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Not Hesaplama"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
            }
          },
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return uygulamaGovdesi();
            } else
              return uygulamaGovdesiLandscape();
          },
        ));
  }

  Widget uygulamaGovdesi() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statik Form için Container
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            labelText: "Ders Adı",
                            labelStyle: TextStyle(color: Colors.pinkAccent),
                            hintText: "Ders Adı",
                            hintStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder()),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else
                            return "Ders adı boş olamaz";
                        },
                        onSaved: (kaydedilecekDeger) {
                          dersAdi = kaydedilecekDeger;
                          setState(() {
                            tumDersler
                                .add(Ders(dersAdi, dersHarfKredi, dersKredi));
                            ortalama = 0;
                            ortalamaHesapla();
                          });
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: dersKredileri(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: dersHarfDegerleri(),
                                value: dersHarfKredi,
                                onChanged: (secilen) {
                                  setState(() {
                                    dersHarfKredi = secilen;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                          color: Colors.pink.shade100,
                          height: 50,
                          child: Center(
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: tumDersler.length == 0
                                      ? "Ders Ekleyin"
                                      : "Ortalamanız: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 17)),
                              TextSpan(
                                  text: tumDersler.length == 0
                                      ? " "
                                      : "${ortalama.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 17)),
                            ])),
                          ))
                    ],
                  ))),

          // Dinamik Form tutan Container
          Expanded(
              child: Container(
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              itemBuilder: _listeElemanlariOlustur,
              itemCount: tumDersler.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              labelText: "Ders Adı",
                              labelStyle: TextStyle(color: Colors.pinkAccent),
                              hintText: "Ders Adı",
                              hintStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder()),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders adı boş olamaz";
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersAdi = kaydedilecekDeger;
                            setState(() {
                              tumDersler
                                  .add(Ders(dersAdi, dersHarfKredi, dersKredi));
                              ortalama = 0;
                              ortalamaHesapla();
                            });
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: dersKredileri(),
                                  value: dersKredi,
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: dersHarfDegerleri(),
                                  value: dersHarfKredi,
                                  onChanged: (secilen) {
                                    setState(() {
                                      dersHarfKredi = secilen;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(

                          child: Container(
                            margin: EdgeInsets.all(40),
                              color: Colors.pink.shade100,
                              height: 50,
                              child: Center(
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: tumDersler.length == 0
                                          ? "Ders Ekleyin"
                                          : "Ortalamanız: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: tumDersler.length == 0
                                          ? " "
                                          : "${ortalama.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 17)),
                                ])),
                              )),
                        ),

                        
                      ],
                    )
                )
            ),
            flex: 1,
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemBuilder: _listeElemanlariOlustur,
                  itemCount: tumDersler.length,
                ),
              ))
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileri() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(value: i, child: Text("$i Kredi")));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleri() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem(
        child: Text(" AA ", style: TextStyle(fontWeight: FontWeight.bold)),
        value: 4));
    harfler.add(DropdownMenuItem(
        child: Text(
          " BA ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 3.5));
    harfler.add(DropdownMenuItem(
        child: Text(
          " BB ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 3));
    harfler.add(DropdownMenuItem(
        child: Text(
          " CB ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 2.5));
    harfler.add(DropdownMenuItem(
        child: Text(
          " CC ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 2));
    harfler.add(DropdownMenuItem(
        child: Text(
          " DC ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 1.5));
    harfler.add(DropdownMenuItem(
        child: Text(
          " DD ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: 1));
    harfler.add(DropdownMenuItem(
        child: Text("FF", style: TextStyle(fontWeight: FontWeight.bold)),
        value: 0));

    return harfler;
  }

  Widget _listeElemanlariOlustur(BuildContext context, int index) {
    Color renk = renkOlustur();
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 1), shape: BoxShape.circle),
        padding: EdgeInsets.all(5),
        child: ListTile(
            tileColor: renk,
            leading: Icon(
              Icons.lens_sharp,
              color: Colors.red,
            ),
            title: Text(tumDersler[index].ad,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 17)),
            subtitle: Text(
                "Kredisi: " +
                    tumDersler[index].kredi.toString() +
                    ",     Harf Notu: " +
                    tumDersler[index].harfDegeri.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 14))),
      ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var anlikDers in tumDersler) {
      var kredi = anlikDers.kredi;
      var harf = anlikDers.harfDegeri;
      toplamNot = toplamNot + (harf * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color renkOlustur() {
    return Color.fromARGB(0 + Random().nextInt(255), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
