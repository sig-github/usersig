/*fichier qui contient la classe TipCourbe. Cette classe permet d'instancier le comportement de la courbe que je veux tracer
* avec les changements d'états à l'appui*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_style.dart';
import 'chart_data_courbes.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class TipCourbe extends StatefulWidget {
  final String tableName;
  final int cellsNumber;
  const TipCourbe({required this.cellsNumber,required this.tableName,Key? key}) : super(key: key);

  @override
  State<TipCourbe> createState() => _TipCourbeState();
}

List<ChartDataCourbes> datas = [
  /*ChartDataCourbes(temperature: 25,valSoC: 96, tension: 52985, temps: 1, intensite: 0.5),*/
];

//liaison effectué Backend pour les courbes
int currentPagio = 1;

class _TipCourbeState extends State<TipCourbe> {
  //bool _showDefaultGraph = true;
  List<ChartDataCourbes> dataso = [];
  final int pageSizee = 24;
  int nombreJours = 0;
  String entryTime = '';
  String outtaTime = '';
  final _keyForm = GlobalKey<FormState>();
  bool inMinute = false;
  String dateCourbe = '';
  DateFormat format = DateFormat('HH:mm');



  Future<void> dayNumbers() async{//fonction qui permet de récupérer le nombre de jours dans un mois
    // ça se répète c'est possible de le rendre global pour ne seulement utiliser qu'un réfléchir à ça à l'optimisation

    final response = await http.get(Uri.parse('http://localhost/testsig1/.vs/nombredejoursmois.php? tableName=${widget.tableName}'));

    final numberday = jsonDecode(response.body);
    nombreJours = numberday[0]['nombrejours'];
  }

  @override
  void initState() {
    super.initState();
    dayNumbers();
  }

  Future<List<dynamic>> fetchMySQLData() async{ /*on crée une fonction fetchMySQLData() pour récupérer les données avec la
    passerelle PHP puis on stocke dans data qu'on retourne à la fonction*/
    var urlo = 'http://localhost/testsig1/.vs/courbebattun.php? pages=$currentPagio&tableName=${widget.tableName}';
    final res = await http.get(Uri.parse(urlo)); //courbebatt.php en général
    var data = json.decode(res.body);
    return data;
  }

  Future<List<ChartDataCourbes>> fetchDataCourbes() async {
    /* ici on appelle la fonction fetchMySQLData() qu'on affecte à la variable jsonData qui est du même type de donnée que jsonData
    List<dynamic>*/
    List<dynamic> jsonData = await fetchMySQLData();

    /*Ici j'éffectue une opération de conversion des données du type String rendu âr Json aux types requis pour les paramètres
     des objets ChartData courbe que je stocke dans la liste datas en fonction des informations provenantes de jsonData.
     jsonData qui récupère tous les éléments de la table comme la requête PHP correspondante*/
    if(widget.cellsNumber==8) {
      datas = List<ChartDataCourbes>.from(jsonData.map((data) =>
          ChartDataCourbes(valSoC: double.parse(data['SoC']),
              tension: (1000 * double.parse(data['tension'])).toInt(),
              intensite: double.parse(data['courant']),
              temperature: double.parse(data['temperature']),
              date: data['date'],
              heure: format.parse(data['heure']))).toList());
      return datas;
    }else{
      datas = List<ChartDataCourbes>.from(jsonData.map((data) =>
          ChartDataCourbes(valSoC: double.parse(data['SoC']),
              tension: (double.parse(data['tension'])).toInt(),
              intensite: double.parse(data['courant']),
              temperature: double.parse(data['temperature']),
              date: data['date'],
              heure: format.parse(data['heure']))).toList());
      return datas;
    }
  }

  Future<List<ChartDataCourbes>> fetchData(String borneInferieure, String borneSuperieure) async {
    //Cette fonction permet de questionner PHP pour avoir les données entre la borneInférieure et la borneSuperieure
    var urloo = 'http://localhost/testsig1/.vs/miseajour.php? tableName=${widget.tableName}';
    final response = await http.post(
       Uri.parse(urloo),
      body: {
        'borne_inferieure': borneInferieure,
        'borne_superieure': borneSuperieure,
      },
    );

      final jsonData = json.decode(response.body);
      dataso = [];
    if(widget.cellsNumber==8) {
      dataso = List<ChartDataCourbes>.from(jsonData.map((data) =>
          ChartDataCourbes(valSoC: double.parse(data['SoC']),
              tension: (1000 * double.parse(data['tension'])).toInt(),
              intensite: double.parse(data['courant']),
              temperature: double.parse(data['temperature']),
              date: data['date'],
              heure: format.parse(data['heure']))).toList());
      return dataso;
    }else{
      dataso = List<ChartDataCourbes>.from(jsonData.map((data) =>
          ChartDataCourbes(valSoC: double.parse(data['SoC']),
              tension: (double.parse(data['tension'])).toInt(),
              intensite: double.parse(data['courant']),
              temperature: double.parse(data['temperature']),
              date: data['date'],
              heure: format.parse(data['heure']))).toList());
      return dataso;
    }
  }


  List<ChartSeries<ChartDataCourbes, dynamic>> _createDefaultTensionTemps(List<ChartDataCourbes> dats) {// Liste de la partie Tension/temps, C'est un truc propre aux courbes
    return <ChartSeries<ChartDataCourbes, dynamic>>[
      //SplineAreaSeries
      AreaSeries(
        animationDelay: 5,
        dataSource: dats,
        xValueMapper: (ChartDataCourbes data, _) => data.heure,
        yValueMapper: (ChartDataCourbes data, _) => data.tension,
        //SplineType: SplineType.natural,
        gradient: LinearGradient(
          colors: [
            AppStyle.spline_color,
            AppStyle.bg_color.withAlpha(150),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      LineSeries(
          animationDelay: 5,
          dataSource: dats,
          color: AppStyle.accent_color,
          width: 4,
          markerSettings: MarkerSettings( //Pour mettre en évidence les points
            color: Colors.white,
            borderWidth: 2,
            shape: DataMarkerType.circle,
            borderColor: AppStyle.accent_color,
            isVisible: true,
          ),
          xValueMapper: (ChartDataCourbes data, _) => data.heure,
          yValueMapper: (ChartDataCourbes data, _) => data.tension),
    ];
  }

    List<ChartSeries<ChartDataCourbes, dynamic>> _intensiteTemps(List<ChartDataCourbes> dats) { //Liste de la partie intensité/temps

      return <ChartSeries<ChartDataCourbes, dynamic>>[
        AreaSeries(
          animationDelay: 10,
          dataSource: dats,
          xValueMapper: (ChartDataCourbes data, _) => data.heure,
          yValueMapper: (ChartDataCourbes data, _) => data.intensite,
          //splineType: SplineType.natural,
          gradient: LinearGradient(
            colors: [
              AppStyle.spline_color,
              AppStyle.bg_color.withAlpha(150),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        LineSeries(
            animationDelay: 10,
            dataSource: dats,
            color: AppStyle.accent_color,
            width: 4,
            markerSettings: MarkerSettings( //Pour mettre en évidence les points
              color: Colors.white,
              borderWidth: 2,
              shape: DataMarkerType.circle,
              borderColor: AppStyle.accent_color,
              isVisible: true,
            ),
            xValueMapper: (ChartDataCourbes data, _) => data.heure,
            yValueMapper: (ChartDataCourbes data, _) => data.intensite)
      ];


  }


  @override
  Widget build(BuildContext context) {


      return FutureBuilder( /*j'ai utilisé un FutureBuilder pour les mises à jours intantané des courbes en fonction des lignes de
        envoyées*/
        builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            return Column(
              children: [
                /*TextButton( // puis le textButton qui me permet de changer l'état
                    onPressed: () {
                      _toggleChart();
                    },
                    child: Text(_showDefaultGraph ?
                    'Intensité/temps' : 'Tension/temps',
                        style: const TextStyle(color: Colors.black,
                            fontFamily: 'Nunito',
                            fontSize: 14.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700)
                    )
                ),*/

                Center( //Ici je teste la valeur de _showDefaultGraph avec un ternaire, si vrai on affiche la première courbe, si faux
                  //on affiche la seconde courbe après les :
                    child: SizedBox(
                      width: 685,
                      child: SfCartesianChart( //Courbe defaut de tension temps
                          tooltipBehavior: TooltipBehavior(
                              enable: true, elevation: 2.0),
                          margin: const EdgeInsets.all(0),
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          plotAreaBorderWidth: 0,
                          primaryXAxis: /*NumericAxis(
                            title: AxisTitle(text: 'heure : échelle < 24h / minutes : échelle > 60min', textStyle: const
                            TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                            autoScrollingMode: AutoScrollingMode.start,
                            //valeur maximale de l'axe des axis au regard des données
                            isVisible: true,
                            // A vérifier (à première vue c'est pour éffacer les grilles)
                            interval: 1,
                            borderWidth: 0,
                            borderColor: Colors.transparent,
                          ),*/
                          DateTimeAxis(
                            intervalType: DateTimeIntervalType.auto,
                            title: AxisTitle(text: 'heure:minutes', textStyle: const
                            TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                            autoScrollingMode: AutoScrollingMode.start,
                            dateFormat: DateFormat.Hm(),
                            isVisible: true, // A vérifier (à première vue c'est pour éffacer les grilles)
                            interval: 1,
                            borderWidth: 0,
                            borderColor: Colors.transparent,
                          ),

                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'millivolt', textStyle: const
                                TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                            autoScrollingMode: AutoScrollingMode.start,
                            interval: 2500,
                            isVisible: true,
                            borderWidth: 0,
                            borderColor: Colors.transparent,
                          ),
                          title: ChartTitle(text: "Tension moyenne en fonction du temps au ${snapshot.data![0].date}", textStyle: const
                          TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal,
                              fontWeight:FontWeight.w700, color: Colors.black)),

                          series: _createDefaultTensionTemps(snapshot.data!)

                      ),
                    )

                ),

                const SizedBox(height: 40),

                //Ici je teste la valeur de _showDefaultGraph avec un ternaire, si vrai on affiche la première courbe, si faux
                      //on affiche la seconde courbe après les :
                         SizedBox(
                          width: 750,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed:(){
                                  if(currentPagio==1){
                                    return;
                                  }else{
                                    setState(() {
                                      currentPagio = currentPagio - 1;
                                    });
                                  }
                                },

                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 15.0,
                                ),
                                /*child: const Text('précédent',
                          style:TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600)),*/
                              ),
                              SizedBox(
                                width: 670,
                                child: SfCartesianChart( //Courbe qui s'affiche lors de l'appui du boutton
                                    tooltipBehavior: TooltipBehavior(
                                        enable: true, elevation: 2.0),
                                    margin: const EdgeInsets.all(0),
                                    borderWidth: 0,
                                    borderColor: Colors.transparent,
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: /*NumericAxis(
                                      title: AxisTitle(text: 'heure : échelle < 24h / minutes : échelle > 60min', textStyle: const
                                          TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                          fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                                      autoScrollingMode: AutoScrollingMode.start,
                                      isVisible: true,      // A vérifier (à première vue c'est pour éffacer les grilles)
                                      interval: 1,
                                      borderWidth: 0,
                                      borderColor: Colors.transparent,
                                    ),*/
                                    DateTimeAxis(
                                      intervalType: DateTimeIntervalType.auto,
                                      title: AxisTitle(text: 'heure:minutes', textStyle: const
                                      TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                          fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                                      autoScrollingMode: AutoScrollingMode.start,
                                      dateFormat: DateFormat.Hm(),
                                      isVisible: true, // A vérifier (à première vue c'est pour éffacer les grilles)
                                      interval: 1,
                                      borderWidth: 0,
                                      borderColor: Colors.transparent,
                                    ),

                                    primaryYAxis: NumericAxis(
                                      title: AxisTitle(text: 'Ampère', textStyle: const
                                        TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                        fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                                      autoScrollingMode: AutoScrollingMode.start,
                                      interval: 0.5,
                                      isVisible: true,
                                      borderWidth: 0,
                                      borderColor: Colors.transparent,
                                    ),
                                    title: ChartTitle(text: "Intensité moyenne en fonction du temps au ${snapshot.data![0].date}", textStyle: const
                                        TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal,
                                            fontWeight:FontWeight.w700, color: Colors.black)),
                                    series: _intensiteTemps(snapshot.data!)

                                ),
                              ),

                              IconButton(
                                onPressed:(){
                                  if(currentPagio==nombreJours-1){
                                    return;
                                  }else{
                                    setState(() {
                                      currentPagio = currentPagio + 1;
                                    });
                                  }
                                },

                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 15.0,
                                ),
                                /*child: const Text('précédent',
                          style:TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600)),*/
                              ),
                            ],
                          ),
                        ),





                const SizedBox(height: 35),

                Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              keyboardType: TextInputType.datetime,
                              style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:12.0 ,
                                  fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),

                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '2023-03-02 00:00:00',
                              ),

                              onChanged: (value){
                                entryTime = value ;
                                /*if (kDebugMode) {
                                  print(entryTime);
                                }*/
                              },
                              validator: (value) => (value==null || value.isEmpty) ? 'Entrer la valeur de départ' : null,
                            ),
                          ),

                          const SizedBox(width: 10),

                          SizedBox(
                            width: 150,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              keyboardType: TextInputType.datetime,
                              style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:12.0 ,
                                  fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '2023-03-02 00:00:00',
                              ),
                              onChanged: (value){
                                outtaTime = value;
                                /*if (kDebugMode) {
                                  print(outtaTime);
                                }*/
                              },
                              validator: (value) => (value==null || value.isEmpty) ? 'Entrer la valeur de départ' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                inMinute = !inMinute;
                              });
                            },
                            child: const Text(
                              'Mettre a jour',
                              style:TextStyle(fontFamily: 'Nunito',
                                  fontSize: 13.0,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700) ,
                            ),

                          )
                      ),
                    ],
                  ),

                ),


                const SizedBox(height: 40)
              ],
            );
          }

        }
        return const Center(
          child: CircularProgressIndicator(),
        );
        },
        future: inMinute == true? fetchData(entryTime, outtaTime):fetchDataCourbes(),
      );
    }
  }

