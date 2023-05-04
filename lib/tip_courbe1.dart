/*fichier qui contient la classe TipCourbe. Cette classe permet d'instancier le comportement de la courbe que je veux tracer
* avec les changements d'états à l'appui*/

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'app_style.dart';
import 'chart_data_courbes.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class TipCourbeUn extends StatefulWidget {
  const TipCourbeUn({Key? key}) : super(key: key);

  @override
  State<TipCourbeUn> createState() => _TipCourbeUnState();
}

List<ChartDataCourbes> datas = [
  /*ChartDataCourbes(temperature: 25,valSoC: 96, tension: 52985, temps: 1, intensite: 0.5),*/
];//liaison effectué Backend pour les courbes

class _TipCourbeUnState extends State<TipCourbeUn> {
  //bool _showDefaultGraph = true;
  Future<List<dynamic>> fetchMySQLData() async{ /*on crée une fonction fetchMySQLData() pour récupérer les données avec la
    passerelle PHP puis on stocke dans data qu'on retourne à la fonction*/
    final res = await http.get(Uri.parse('http://localhost/testsig1/.vs/courbebatt.php'));
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
    datas = List<ChartDataCourbes>.from(jsonData.map((data) => ChartDataCourbes(valSoC: double.parse(data['SoC']),
        tension: (1000*double.parse(data['tension'])).toInt(), temps: int.parse(data['id']),
        intensite: double.parse(data['courant']), temperature: double.parse(data['temperature']))).toList());
    return datas;
  }

  /*void _toggleChart() {//fonction qui me permet de changer la valeur de la variable _showDefaultGraph
    setState(() {
      _showDefaultGraph = !_showDefaultGraph;
    });
  }*/

  List<ChartSeries<ChartDataCourbes, int>> _intensiteTemps(List<ChartDataCourbes> dats) { //Liste de la partie intensité/temps

    return <ChartSeries<ChartDataCourbes, int>>[
      SplineAreaSeries(
        animationDelay: 20000,
        dataSource: dats,
        xValueMapper: (ChartDataCourbes data, _) => data.temps,
        yValueMapper: (ChartDataCourbes data, _) => data.intensite,
        splineType: SplineType.natural,
        gradient: LinearGradient(
          colors: [
            AppStyle.spline_color,
            AppStyle.bg_color.withAlpha(150),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      SplineSeries(
          animationDelay: 20000,
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
          xValueMapper: (ChartDataCourbes data, _) => data.temps,
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
                    child: SfCartesianChart( //Courbe qui s'affiche lors de l'appui du boutton
                        margin: const EdgeInsets.all(0),
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                        plotAreaBorderWidth: 0,
                        primaryXAxis: NumericAxis(
                          minimum: 0,      //valeur minimale de l'axe des axis aux regards des données
                          maximum: (snapshot.data!.last.temps).toDouble(),   //valeur maximale de l'axe des axis aux regards des données
                          isVisible: true,      // A vérifier (à première vue c'est pour éffacer les grilles)
                          interval: 1,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: -0.2,
                          maximum: 0.5,
                          interval: 0.1,
                          isVisible: true,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                        ),

                        series: _intensiteTemps(snapshot.data!)

      )

                ),
              ],
            );
          }

        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: fetchDataCourbes(),
    );
  }
}

