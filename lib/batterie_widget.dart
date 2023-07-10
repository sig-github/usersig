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
  late List<BatterieModel> tests = [/*tableau d'un seul objet que je modifie avec les infos de la DB pour l'optimisation on peut
  juste créer un objet en déclaration pour éviter d'utiliser un tableau qui peut couter cher*/
    /*BatterieModel(classe: 'bmstype', modele: 'modele', SoC: 0.0,
        etat: 0, alerte: false, SoH: 100.0, nomBms: 'bmstype', tension: 0.0,
        capacite: 0.0, tensionNominale: 0.0, temperature: 0.0,
        batteryStatus: 'inactif', courant: 0.0, cycle: 0, nombreCells: 8
    )*/
    ];

  String activity = ''; // variable que j'ai crée pour l'état de la batterie charge, décharge,none
  //final List _rows = [];
  List tableNames = [];
  Map<String, dynamic> batteryData = {};
  Future<void> getTableNames() async {
    final response = await http.get(
        Uri.parse('http://localhost/testsig1/.vs/tablesnames.php'));


      var data = json.decode(response.body);
      tableNames = data;


    if(kDebugMode){
      print(tableNames.length);
      print(tableNames[0]);
      print(tableNames[1]);
    }
  }

  Future<void> getDataNew() async {
    final response = await http.get(Uri.parse('http://localhost/testsig1/.vs/getdata_newarch.php'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        batteryData = data;
      });

      for (int i=0; i<batteryData.length; i++){
        tests.add(BatterieModel(classe: 'bmstype', modele: 'modele', SoC: 0.0,
            etat: 0, alerte: false, SoH: 100.0, nomBms: 'bmstype', tension: 0.0,
            capacite: 0.0, tensionNominale: 0.0, temperature: 0.0,
            batteryStatus: 'inactif', courant: 0.0, cycle: 0, nombreCells: 8
        ));

        /*tests[i] = BatterieModel(classe: 'bmstype', modele: 'modele', SoC: 0.0,
            etat: 0, alerte: false, SoH: 100.0, nomBms: 'bmstype', tension: 0.0,
            capacite: 0.0, tensionNominale: 0.0, temperature: 0.0,
            batteryStatus: 'inactif', courant: 0.0, cycle: 0, nombreCells: 8
        );*/
      }
      getData();
    } else {
      throw Exception('Failed to fetch data');
    }
  }


  void getData() {
    /*fonction qui permet de récupérer les lignes de données contenant les informations sur la
    batterie*/
    var index = 0;
    batteryData.keys.forEach((key) { //ajout en fonction de la nouvelle structure
      for (var item in batteryData[key]) {
        /*on parcourt la liste de tous les éléments de chaque ligne dans data , on converti chaque élément dan le type requis pour l'objet et on change les variables
        de l'objets, puis on applique un setState() pour mettre à jour le Widget*/
        /*if(kDebugMode){
          print(batteryData.length);
        }*/
        var row = item;
          String id = row['identifiant'];
          String bmstype = row['bmstype'];
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
          double SoC = double.parse(row['SoC']);
          double SoH = double.parse(row['SoH']);
          double temperature = double.parse(row['temperature']);
          int nbrecellules = int.parse(row['nbrecellules']);

          tests[index].setBattArgument(
              bmstype,
              id,
              SoC,
              (statusprincipal == 1 ? true : false),
              SoH,
              bmstype,
              tension,
              (SoC / 100) * 72,//voir ici pour UDAN lorsqu'on sera sur UDAN
              3.2 * nbrecellules,
              temperature,
              activity,
              courant,
              20,
              nbrecellules);

          setState(() {

          });
      }
      index++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTableNames();
    getDataNew();
  }





  @override
  Widget build(BuildContext context) {

      return Builder(
        builder: (context) {
            return GridView.builder( //C'est l'instance qui nous permet de faire un affichage en grille
              //il faut rendre particulier tout ce qui est ici à ce qui est lue au niveau de la dB en temps réel
              shrinkWrap: true,
              itemCount: tests.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:4,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0
              ),
              itemBuilder: (_, index){
                for(int dist = 0; dist<tableNames.length; dist++){ //Manipulation pour attribuer le nom de la table de données et la passer dans le contructeur de
                  if(index == dist){
                    return Card(//les box qui sont dans la grille
                      color: Colors.white,
                      child: InkResponse(
                        onTap: (){
                          Get.to(()=> BatterieDetail(cellsNumber: tests[index].nombreCells ,tableName: tableNames[dist],battery: batteryData),
                              arguments: {
                                "SoH" : tests[index].SoH,
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
                                "nombreCellule" : tests[index].nombreCells
                              }
                          );
                        },
                        child: GridTile(//instance qui nous permet d'avoir un header, un footer et un child
                            header: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  //tests[index].classe + (tests[index].modele).toString()
                                  //tests[0].classe + tests[0].modele ,
                                  tests[index].classe + tests[index].modele ,
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
                                        //'Etat: ${tests[0].batteryStatus }',
                                        'Etat: ${tests[index].batteryStatus }',
                                        style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal,
                                            fontWeight:FontWeight.w700, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        /*'SOH(%): ${tests[index].SoH}'*/
                                        //'SOH(%): ${ tests[0].SoH }',
                                        'SOH(%): ${ tests[index].SoH }',
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
                                        //'Alerte: ${tests[0].alerte}',
                                        'Alerte: ${tests[index].alerte}',
                                        style: const TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        /*'BMS: ${tests[index].nomBms}'*/
                                        //'BMS: ${tests[0].nomBms}',
                                        'BMS: ${tests[index].nomBms}',
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
                                      if (tests[index].SoC == //du coup val du SoC de l'état actuel
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

                  }
                }

              },
            );

          }

      );

  }
}

