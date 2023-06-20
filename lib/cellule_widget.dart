
/*importation des librairies*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cellule_model.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class CelluleWidget extends StatefulWidget {
  final String tableName;
  const CelluleWidget({required this.tableName,Key? key}) : super(key: key);

  @override
  State<CelluleWidget> createState() => _CelluleWidgetState();
}

class _CelluleWidgetState extends State<CelluleWidget> {
  List<CelluleModel> cells = []; // à fournir à partir de la dB

  void cellsSetUp() {/*Fonction qui en prenant en compte le nombre de cellules et nous crée des objets CelluleModel vide avec
                     des identifiants qui varient et les stocke dans un tableau cells qui sera utilisé pour
                     mettre en place la liste de Widget Cellules avec la jauge linéaire de tension*/
    for(int i=0; i < Get.arguments["nombrecellules"]; i++){
      cells.insert(i, CelluleModel(id: 'tensioncell$i', tension: 0, temperature: 0, equilibrage: 0, SoC: 0));
    }
  }

  Future<void> getCellsData() async { //fonction pour afficher la liste des cellules avec leur tension et leur température
    final res = await http.get(Uri.parse('http://localhost/testsig1/.vs/cellscardobjquery.php? tableName=${widget.tableName}')); /*On récupère le résultat de
    la requête à travers la variable res déclarée final*/
    var data = json.decode(res.body); /*on décode ce qu'on a récupéré et on le stocke dans data*/
    data.forEach((key, value) {
       //problème besoin de SoC, pour le moment je modifierai juste tension et température
      for (int i = 0; i< value.length; i++) {
        for(int j = 0; j< Get.arguments["nombrecellules"]; j++){
          if(cells[j].id == key){
            cells[j].tension = int.parse(value[i][2]);
            if(j<4) {
              cells[j].temperature = double.parse(value[i][0]);
            }else{
              cells[j].temperature = double.parse(value[i][1]);
            }

            /*if (kDebugMode) {
              print('${cells[j].tension}, ${cells[j].temperature}');
            }*/

            setState(() {

            });
          }

        }

      }
    });
  }
  @override
  void initState() {//fonction qui s'exécute une seule fois au début de l'arbre d'exécution de cette classe
    // TODO: implement initState
    super.initState();
    cellsSetUp();
    getCellsData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(//on retourne une grille aussi
      padding: const EdgeInsets.all(25.0),
      shrinkWrap: true,
      itemCount: cells.length,
      itemBuilder: (_, index){
        return Center(
            //color: Colors.white,
              child: //ListTile(
                 //leading:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       cells[index].id,
                       style: const TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                     ),

                      const SizedBox(width: 5.0),

                     SizedBox(
                       width: 400,
                       child: Center(
                         child: Builder(
                             builder: (context) {
                               return  Padding(
                                   padding: const EdgeInsets.only(left:5.0, right: 5.0),
                                   child: Column(
                                     children: [
                                       const Padding(padding: EdgeInsets.only(top: 5.0)),

                                       LinearProgressIndicator(
                                         value: (cells[index].tension / 4500),
                                         semanticsValue: "${((cells[index].tension - 2000) / (4500-2000))}", //* (3650 - 2500) + 2500
                                         semanticsLabel: "${((cells[index].tension - 2000) / (4500-2500))}", //* (3650 - 2500) + 2500
                                         minHeight: 6,
                                         backgroundColor: Colors.black12,
                                       ),
                                       const Row(
                                         children: [
                                           Text('2000mV',
                                               style: TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal,
                                                   fontWeight:FontWeight.w700, color: Colors.black), textAlign: TextAlign.left),

                                           SizedBox(width: 310),

                                           Text('4500mV',
                                               style: TextStyle(fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal,
                                                   fontWeight:FontWeight.w700, color: Colors.black), textAlign: TextAlign.right)
                                         ],
                                       )
                                     ],
                                   )
                               );
                             }
                         ),

                       ),
                     ),

                     const SizedBox(width: 15.0),

                     Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${cells[index].tension} mV",
                                    style: const TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                  //const Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                ],

                              ),

                              const Padding(padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 18.0)),

                              Builder(
                                builder: (context) {
                                    if (cells[index].temperature >=
                                    -20 &&
                                    cells[index].temperature <
                                    0) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          const Icon(
                                            Icons.device_thermostat,
                                            // à faire varier en fonction de la température
                                            size: 14.0,
                                            color: Colors.red,
                                          ),

                                          const Padding(padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 2.0)),

                                          Text(
                                            '${cells[index].temperature}°',
                                            style: const TextStyle(fontFamily: 'Nunito',
                                                fontSize: 13.0,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      );
                                    }

                                    if (cells[index].temperature >=
                                        40 && cells[index].temperature <=
                                        60) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          const Icon(
                                            Icons.device_thermostat,
                                            // à faire varier en fonction de la température
                                            size: 14.0,
                                            color: Colors.red,
                                          ),

                                          const Padding(padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 2.0)),

                                          Text(
                                            '${cells[index].temperature}°',
                                            style: const TextStyle(fontFamily: 'Nunito',
                                                fontSize: 13.0,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      );
                                    }

                                    if (cells[index].temperature >=
                                        0 &&
                                        cells[index].temperature <
                                            15) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          const Icon(
                                            Icons.device_thermostat,
                                            // à faire varier en fonction de la température
                                            size: 14.0,
                                            color: Colors.orange,
                                          ),

                                          const Padding(padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 2.0)),

                                          Text(
                                            '${cells[index].temperature}°',
                                            style: const TextStyle(fontFamily: 'Nunito',
                                                fontSize: 13.0,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      );
                                    }

                                    if (cells[index].temperature >=
                                        15 &&
                                        cells[index].temperature <
                                            40) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          const Icon(
                                            Icons.device_thermostat,
                                            // à faire varier en fonction de la température
                                            size: 14.0,
                                            color: Colors.green,
                                          ),

                                          const Padding(padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 2.0)),

                                          Text(
                                            '${cells[index].temperature}°',
                                            style: const TextStyle(fontFamily: 'Nunito',
                                                fontSize: 13.0,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      );
                                    }

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        const Icon(
                                          Icons.device_thermostat,
                                          // à faire varier en fonction de la température
                                          size: 14.0,
                                          color: Colors.black,
                                        ),

                                        const Padding(padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 2.0)),

                                        Text(
                                          '${cells[index].temperature}°',
                                          style: const TextStyle(fontFamily: 'Nunito',
                                              fontSize: 13.0,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    );

                                }
                              )
                            ],
                          ),
                        ),
                      ),
                   ],
                 )
              //),
          );
      },

    );
  }
}
