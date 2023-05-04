import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class TensionMinMoyMax extends StatefulWidget{
  const TensionMinMoyMax({Key? key}) : super(key: key);

  @override
  State<TensionMinMoyMax> createState() => _TensionMinMoyMaxState();
}

class _TensionMinMoyMaxState extends State<TensionMinMoyMax>{
  String idcellmin = "Null";
  String idcellmax = "Null";
  int maxcelltension = 0;
  int mincelltension = 0;
  int moycelltension = 0;

  //List <CellData> datacells = [];

  @override
  void initState() { //fonction qui s'exécute au début du programme et une seule fois
    super.initState();
    getDatas();
  }


  Future<void> getDatas() async {/*fonction qui permet de récupérer les lignes de données contenant les informations sur la
    batterie*/

    final result = await http.get(Uri.parse('http://localhost/testsig1/.vs/tmoyminmax.php'));/*On récupère le résultat de la requête
    à travers la variable res déclarée final*/
    var data = json.decode(result.body); /*on décode ce qu'on a récupéré et on le stocke dans data*/
    for(int currentIndex = 0 ;currentIndex < data.length; currentIndex++) {/*on parcourt la liste de tous les éléments de chaque
    ligne dans data , on converti chaque élément dan le type requis pour l'objet et on change les variables de l'objets, puis
    on applique un setState() pour mettre à jour le Widget*/
      var row = data[currentIndex];
      String idmincell = row['idmincell'];
      String idmaxcell = row['idmaxcell'];
      int tensionmaxcell = int.parse(row['tensionmaxcell']);
      int tensionmincell = int.parse(row['tensionmincell']);
      int tensionmoycell = int.parse(row['tensionmoycell']);

      setState(() {
        idcellmin = idmincell;
        idcellmax = idmaxcell;
        maxcelltension = tensionmaxcell;
        mincelltension = tensionmincell;
        moycelltension = tensionmoycell;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return  Row( //les trois box pour afficher les Tensions min, moy et max des cellules
      //Vont varier en fonction des points de chaque courbe pris à un moment donné Comment faire?
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width:200,
          child: Card(
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.all(Radius.circular(2.0))
                          ),
                        )
                      ],
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0)),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Tension min',
                            style: TextStyle(fontFamily:'Nunito' , fontSize:16.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w900)
                        ),

                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                        Text(
                            "$mincelltension mV",
                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w700)
                        ),

                        Text(
                          "Cellule $idcellmin",
                          style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.right,
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
        ),

        SizedBox(
          width:200,
          child: Card(
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.all(Radius.circular(2.0))
                          ),
                        )
                      ],
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0)),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Ecart',
                            style: TextStyle(fontFamily:'Nunito' , fontSize:16.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w900)
                        ),

                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                        Text(
                            '${maxcelltension - mincelltension} mV',
                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w700)
                        ),
                        const Text(
                          " " ,
                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal),
                          textAlign: TextAlign.right,
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
        ),

        SizedBox(
          width:200,
          child: Card(
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.all(Radius.circular(2.0))
                          ),
                        )
                      ],
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0)),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Tension max',
                            style: TextStyle(fontFamily:'Nunito' , fontSize:16.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w900)
                        ),

                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                        Text(
                            "$maxcelltension mV",
                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w700)
                        ),

                        Text(
                          "Cellule $idcellmax" ,
                          style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.right,
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
        ),
      ],
    );
  }
}

