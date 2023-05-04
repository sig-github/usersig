
/*importation des librairies*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'cellule_model.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class CelluleWidget extends StatefulWidget {
  const CelluleWidget({Key? key}) : super(key: key);

  @override
  State<CelluleWidget> createState() => _CelluleWidgetState();
}

class _CelluleWidgetState extends State<CelluleWidget> {
  List<CelluleModel> cells = []; // à fournir à partir de la dB

  void cellsSetUp() {
    for(int i=0; i < Get.arguments["nombrecellules"]; i++){
      cells.insert(i, CelluleModel(id: 'tensioncell$i', tension: 0, temperature: 0, equilibrage: 0, SoC: 0));
    }
  }

  Future<void> getCellsData() async {
    final res = await http.get(Uri.parse('http://localhost/testsig1/.vs/cellscardobjquery.php')); /*On récupère le résultat de
    la requête à travers la variable res déclarée final*/
    var data = json.decode(res.body); /*on décode ce qu'on a récupéré et on le stocke dans data*/
    data.forEach((key, value) {
       //problème besoin de SoC, pour le moment je modiierai juste tension et température
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
  void initState() {
    // TODO: implement initState
    super.initState();
    cellsSetUp();
    getCellsData();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(//on retourne une grille aussi
      shrinkWrap: true,
      itemCount: cells.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:4,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0
      ),
      itemBuilder: (_, index){
        return Card(
            color: Colors.white,
              child: GridTile(
                  header: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          cells[index].id,
                          style: const TextStyle(fontFamily:'Nunito' , fontSize:18.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                        ),
                      ),
                    ),
                  ),

                  footer: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Tension: ',
                                style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                textAlign: TextAlign.left,
                              ),

                              const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                              Text(
                                (cells[index].tension).toString(),
                                style: const TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
                            ],

                          ),

                          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 18.0)),

                          Builder(
                            builder: (context) {
                                if (cells[index].temperature >=
                                -20 &&
                                cells[index].temperature <
                                0) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      const Icon(
                                        Icons.device_thermostat,
                                        // à faire varier en fonction de la température
                                        size: 20.0,
                                        color: Colors.red,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        '${cells[index].temperature}°',
                                        style: const TextStyle(fontFamily: 'Nunito',
                                            fontSize: 15.0,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 8.0)),
                                    ],
                                  );
                                }

                                if (cells[index].temperature >=
                                    40 && cells[index].temperature <=
                                    60) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      const Icon(
                                        Icons.device_thermostat,
                                        // à faire varier en fonction de la température
                                        size: 20.0,
                                        color: Colors.red,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        '${cells[index].temperature}°',
                                        style: const TextStyle(fontFamily: 'Nunito',
                                            fontSize: 15.0,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 8.0)),
                                    ],
                                  );
                                }

                                if (cells[index].temperature >=
                                    0 &&
                                    cells[index].temperature <
                                        15) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      const Icon(
                                        Icons.device_thermostat,
                                        // à faire varier en fonction de la température
                                        size: 20.0,
                                        color: Colors.orange,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        '${cells[index].temperature}°',
                                        style: const TextStyle(fontFamily: 'Nunito',
                                            fontSize: 15.0,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 8.0)),
                                    ],
                                  );
                                }

                                if (cells[index].temperature >=
                                    15 &&
                                    cells[index].temperature <
                                        40) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      const Icon(
                                        Icons.device_thermostat,
                                        // à faire varier en fonction de la température
                                        size: 20.0,
                                        color: Colors.green,
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        '${cells[index].temperature}°',
                                        style: const TextStyle(fontFamily: 'Nunito',
                                            fontSize: 15.0,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 8.0)),
                                    ],
                                  );
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    const Icon(
                                      Icons.device_thermostat,
                                      // à faire varier en fonction de la température
                                      size: 20.0,
                                      color: Colors.black,
                                    ),

                                    const Padding(padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 0.0)),

                                    Text(
                                      '${cells[index].temperature}°',
                                      style: const TextStyle(fontFamily: 'Nunito',
                                          fontSize: 15.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0)),
                                  ],
                                );

                            }
                          )
                        ],
                      ),
                    ),
                  ),
                  child: Center(
                    child: Builder(
                        builder: (context) {
                          for(double i = 0; i <= 100; i+=0.5) { /*la partie qui nous retourne chaque éléments de la grille avec
                           son vrai pourcentage*/
                            if (cells[index].SoC ==
                                i) {
                              return  Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: LinearPercentIndicator(
                                    //width: 200,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 50,
                                    percent: i/100,
                                    center: Text(
                                      "$i%",
                                      style:
                                      const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 15.0),
                                    ),
                                    barRadius: const Radius.circular(16),
                                    progressColor: Colors.green,
                                  ),
                              );

                               /* CircularPercentIndicator(
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
                              );*/
                            }
                          }

                          /*return CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent: 0.7,
                            center: const Text(
                              "70.0%",
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.green,
                          );*/


                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LinearPercentIndicator(
                              width: 180,
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 50,
                              percent: 0.7,
                              center: const Text(
                                "70.0",
                                style:
                                TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.green,
                            ),
                          );
                        }
                    ),

                  )

              ),
          );
      },

    );
  }
}
