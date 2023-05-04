//La classe batterie_widget qui définit le prototype de l'objet batterie avec ses informations au niveau de la partie Flotte de Batteries

/*importation des librairies*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:usersig/batterie_detail.dart';
import 'package:usersig/batterie_model.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??




/*corps du code*/
class BatterieWidget extends StatefulWidget  {
   const BatterieWidget({Key? key}) : super(key: key);

  @override
  State<BatterieWidget> createState() => _BatterieWidgetState();
}


class _BatterieWidgetState extends State<BatterieWidget> {
  List<BatterieModel> tests = [/*tableau d'un seul objet que je modifie avec les infos de la DB pour l'optimisation on peut
  juste créer un objet en déclaration pour éviter d'utiliser un tableau qui peut couter cher*/
    BatterieModel(classe: 'bmstype', modele: 'modele', SoC: 0.0,
        etat: 0, alerte: false, SoH: 100.0, nomBms: 'bmstype', tension: 0.0,
        capacite: 0.0, tensionNominale: 0.0, temperature: 0.0,
        batteryStatus: 'inactif', courant: 0.0, cycle: 0, nombreCells: 8
    )
    /*BatterieModel(classe: 'LFP', modele: 105, SoC: 80, etat: 'Actif', alerte: false, SoH: 100, nomBms: 'UDAN',
    tension: 52985, capacite: 100,tensionNominale : 28800, temperature : 25, batteryStatus:"charge", courant: 1.0,cycle :50,
    nombreCells: 4),
*/];//Ce sont les batteries dont on dispose, ce qui veut dire que cette information doit être relié au backend plus tard

  String activity = ''; // variable que j'ai crée pour l'état de la batterie charge, décharge,none
  //final List _rows = [];


  Future<void> getData() async {/*fonction qui permet de récupérer les lignes de données contenant les informations sur la
    batterie*/

    final res = await http.get(Uri.parse('http://localhost/testsig1/.vs/getdata.php'));/*On récupère le résultat de la requête
    à travers la variable res déclarée final*/
    var data = json.decode(res.body); /*on décode ce qu'on a récupéré et on le stocke dans data*/
    for(int currentIndex = 0 ;currentIndex < data.length; currentIndex++) {/*on parcourt la liste de tous les éléments de chaque
    ligne dans data , on converti chaque élément dan le type requis pour l'objet et on change les variables de l'objets, puis
    on applique un setState() pour mettre à jour le Widget*/
      var row = data[currentIndex];
      String id = row['identifiant'];
      String bmstype = row['bmstype'];
      //String date = row['date'];
      //String heure = row['heure'];
      double courant = double.parse(row['courant']);

      if (courant == 0) {
        activity = 'none';
      }
      if (courant < 0) {
        activity = 'decharge';
      }
      if (courant > 0) {
        activity = 'charge';
      }

      double tension = double.parse(row['tension']);
      int statusprincipal = int.parse(row['statusprincipal']);
      //int etatchargedecharge = int.parse(row['etatchargedecharge']);
      //double courantmaxcharge = double.parse(row['courantmaxcharge']);
      //double courantmaxdecharge = double.parse(row['courantmaxdecharge']);
      double capagained = double.parse(row['capagained']);
      double capaloosed = double.parse(row['capaloosed']);
      //double energycharged = double.parse(row['energycharged']);
      //double energydecharged = double.parse(row['energydecharged']);
      int initstatus = int.parse(row['initstatus']);
      double SoC = double.parse(row['SoC']);
      double SoH = double.parse(row['SoH']);
      double temperature = double.parse(row['temperature']);
      int nbrecellules = int.parse(row['nbrecellules']);
      tests[0].setBattArgument(
          bmstype,
          id,
          SoC,
          initstatus,
          (statusprincipal == 1 ? false : true),
          SoH,
          bmstype,
          tension,
          (SoC/100)*72,
          3.2 * nbrecellules,
          temperature,
          activity,
          courant,
          20,
          nbrecellules);

      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }





  @override
  Widget build(BuildContext context) {

      return Builder(
        builder: (context) {
            return GridView.builder( //C'est l'instance qui nous permet de faire un affichage en grille
              //il faut rendre particulier tout ce qui est ici à ce qui est lue au niveau de la dB en temps réel
              shrinkWrap: true,
              itemCount: 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:4,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0
              ),
              itemBuilder: (_, index){
                return Card(//les box qui sont dans la grille
                  color: Colors.white,
                  child: InkResponse(
                    onTap: (){
                      /*Navigator.pushReplacementNamed(context, '/batterieDetail',
                          arguments : {
                           // "classe" : tests[index].classe
                          }
                      );*/
                      Get.to(()=> const BatterieDetail(),
                          arguments: {
                            /*"SoH" : tests[index].SoH,
                            "tension" : tests[index].tension,
                            "classe" : tests[index].classe,
                            "modele" : tests[index].modele,
                            "tensionnominale" : tests[index].tensionNominale,
                            "capacite" : tests[index].capacite,
                            "SoC" : tests[index].SoC,
                            "temperature" : tests[index].temperature,
                            "batterystatus" : tests[index].batteryStatus,
                            "courant" : tests[index].courant,
                            "cycle" : tests[index].cycle,
                            "nombreCellule" : tests[index].nombreCells*/
                            "SoH" : tests[0].SoH,
                            "tension" : tests[0].tension,
                            "classe" : tests[0].classe,
                            "modele" : tests[0].modele,
                            "tensionnominale" : tests[0].tensionNominale,
                            "capacite" : tests[0].capacite,
                            "SoC" : tests[0].SoC,
                            "temperature" : tests[0].temperature,
                            "batterystatus" : tests[0].batteryStatus,
                            "courant" : tests[0].courant,
                            "cycle" : tests[0].cycle,
                            "nombreCellule" : tests[0].nombreCells

                          }
                      );
                    },
                    child: GridTile(//instance qui nous permet d'avoir un header, un footer et un child
                        header: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              //tests[index].classe + (tests[index].modele).toString()
                              tests[0].classe + tests[0].modele ,
                              style: const TextStyle(fontFamily:'Nunito' , fontSize:18.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                            ),
                          ),
                        ),

                        footer: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    /*'Etat: ${tests[index].etat}'*/
                                    'Etat: ${tests[0].batteryStatus }',
                                    style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal,
                                        fontWeight:FontWeight.w700, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),

                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                  Text(
                                    /*'SOH(%): ${tests[index].SoH}'*/
                                    'SOH(%): ${ tests[0].SoH }',
                                    style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                ],

                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 18.0)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Text(
                                    /*'Alerte: ${tests[index].alerte}'*/
                                    'Alerte: ${tests[0].alerte}',
                                    style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),

                                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                  Text(
                                    /*'BMS: ${tests[index].nomBms}'*/
                                    'BMS: ${tests[0].nomBms}',
                                    style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                ],
                              )
                            ],
                          ),
                        ),

                        /*indicateur circulaire*/
                        child: Center(
                          child: Builder(
                              builder: (context) {
                                for(double i = 0; i <= 100; i+=0.5) { /*la partie qui nous retourne chaque éléments de la grille avec
                               son vrai pourcentage*/
                                  if (tests[0].SoC == //du coup val du SoC de l'état actuel
                                      i) {
                                    return CircularPercentIndicator(
                                      radius: 60.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      animationDuration: 480,
                                      percent: i/100,
                                      center: Text(
                                        "$i%",
                                        style:
                                        const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 20.0),
                                      ),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      progressColor: Colors.green,
                                    );
                                  }
                                }

                                return CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: 0.0,
                                  center: const Text(
                                    "0.0%",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.green,
                                );
                              }
                          ),

                        )

                    ),
                  ),
                );
              },
            );

          }

      );

  }
}

