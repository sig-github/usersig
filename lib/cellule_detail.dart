
/*importations des librairies*/
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usersig/cells_chartdata.dart';
import 'app_style.dart';
import 'cellule_widget.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async';//sert à quoi??

class CelluleDetail extends StatefulWidget {
  const CelluleDetail({Key? key}) : super(key: key);

  @override
  State<CelluleDetail> createState() => _CelluleDetailState();
}

class _CelluleDetailState extends State<CelluleDetail> {
  List<ChartSeries<CellData, int>> _seriesData = [];
  //List <CellData> datacells = [];

  @override
  void initState() { //fonction qui s'exécute au début du programme et une seule fois
    super.initState();
    _getData();
  }


  Future<void> _getData() async {
    var response = await http.get(Uri.parse('http://localhost/testsig1/.vs/cellsqueryo.php'));/* Récupération des éléments
    de la requête PHP*/
    var data = json.decode(response.body); //On décode le json qui a été envoyé et on le stocke dans la variable data

    List<ChartSeries<CellData, int>> seriesData = [];// on crée et initialise une Liste de series de données
    data.forEach((key, value) //Pour chaque élément clé du json envoyé faire ce qui est en accolade
    {
      List <CellData> datacells = []; /*on crée et initialise une liste d'objet CellData pour stocker les données de
      chaque cellule sur un temps donné. Je l'ai mis là parce qu'il faut le réinitialiser après utilisation*/
      /*if (kDebugMode) {
        print('$key');
      }*/
      for(int i = 0; i < value.length; i++) { /* Pour chaque élément dans le tableau contenant les lignes temps et valeur de
      tension de chaque cellule faire*/
        datacells.add(CellData(id: value[i][0], tension: value[i][1])); /* On ajoute un objet CellData dont les valeurs
        correspondent à chaque ligne de value dans la liste datacells
        */
      }
      seriesData.add( /*On ajoute maintenant la serie avec les données de series correspondant à chaque cellules*/
        SplineSeries(
            animationDelay: 2000,
            dataSource: datacells,
            isVisible: true,
            enableTooltip: true,
            color: (() {
              switch (key) { //pour attribuer une couleurs de serie à chaque cellule
                case 'tensioncell0':
                  return Colors.red;
                case 'tensioncell1':
                  return Colors.orange;
                case 'tensioncell2':
                  return Colors.blue;
                case 'tensioncell3':
                  return Colors.black;
                case 'tensioncell4':
                  return Colors.amber;
                case 'tensioncell5':
                  return Colors.deepPurpleAccent;
                case 'tensioncell6':
                  return Colors.lightGreenAccent;
                case 'tensioncell7':
                  return AppStyle.accent_color;
                default:
                  return
                    Colors.amberAccent;
              }
            })(),
            width: 3,
            markerSettings: MarkerSettings( //Pour mettre en évidence les points
              color: Colors.white,
              borderWidth: 2,
              shape: DataMarkerType.circle,
              borderColor: (() {//pour attribuer une couleurs de bordure de marqueur à chaque cellule
                switch (key) {
                  case 'tensioncell0':
                    return Colors.red;
                  case 'tensioncell1':
                    return Colors.orange;
                  case 'tensioncell2':
                    return Colors.blue;
                  case 'tensioncell3':
                    return Colors.black;
                  case 'tensioncell4':
                    return Colors.amber;
                  case 'tensioncell5':
                    return Colors.deepPurpleAccent;
                  case 'tensioncell6':
                    return Colors.lightGreenAccent;
                  case 'tensioncell7':
                    return AppStyle.accent_color;
                  default:
                    return
                      Colors.amberAccent;
                }
              })(),
              isVisible: false,
            ),
            xValueMapper: (CellData data, _) => data.id,
            yValueMapper: (CellData data, _) => data.tension)
      );


      setState(() {
        _seriesData = seriesData;
      });
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//header
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)
          ),
        ),
        leading:Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(left:6.0,right: 6.0)),
            IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.menu,
                  size: 25.0,
                )
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.search_outlined,
                  size: 20.0,
                )
            ),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: InkWell(
              onTap: () {

              },
              child: const CircleAvatar(

                //backgroundColor: _colors, //là la couleur est affecté par défaut au background (PLIMP)
                backgroundImage: AssetImage('assets/james.jpg'), //image d'arrière plan on concatène une référence globale qui va appeler chaque image dans notre liste correspondant en un nom
                /*child: Text( //Donc là par defaut je lui ai aussi assigné la valeur de nameInitial, si image ça n'apparaitra pas sinon oui (PLIMP)
                        nameInitial,
                        style: TextStyle(fontSize: 30.0),
                        ),*/

              ),

            ),
          ),
        ],



        title: Text(
          AppLocalizations.of(context).appTitle,
          style: const TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        centerTitle: false,

      ),

      body: SafeArea(//body
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column( //Titre de l'ensemble de la page
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 25.0,
                          )
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child :Text(
                            '${Get.arguments["classebatt"]}${Get.arguments["modelebatt"].toString()}',
                            style: const TextStyle(fontFamily:'Nunito' , fontSize:25.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600),
                          )
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child :Text(
                            Get.arguments["nombrecellules"].toString(),
                            style: const TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700),
                          )
                      )
                  ]
                ),

                const SizedBox(height: 50.0),

                const CelluleWidget(),//appel de l'entité CelluleWidget( )

                const SizedBox(height: 60.0),

                Center(//Box pour toutes les courbes
                  //taille de box courbes
                    child: Column(
                      children: [
                        Row( //les trois box pour afficher les Tensions min, moy et max des cellules
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
                                          children: const [
                                            Text(
                                                'Tension min',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                            ),

                                            Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                            Text(
                                                'valTension',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                            ),

                                            Text(
                                              'nomdeCell' ,
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
                                          children: const [
                                            Text(
                                                'Tension moy',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                            ),

                                            Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                            Text(
                                                'valTension',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                            ),

                                            Text(
                                              'nomdeCell' ,
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
                                          children: const [
                                            Text(
                                                'Tension max',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                            ),

                                            Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                            Text(
                                                'valTension',
                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                            ),

                                            Text(
                                              'nomdeCell' ,
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
                          ],
                        ),

                        const SizedBox(height: 10.0),

                        Center(
                          child: SfCartesianChart(
                              margin: const EdgeInsets.all(0),
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              plotAreaBorderWidth: 0,
                              tooltipBehavior: TooltipBehavior(enable: true,elevation: 1),
                              primaryXAxis: NumericAxis(
                                minimum: 1, //valeur minimale de l'axe des axis aux regards des données
                                maximum: 570, /*valeur maximale de l'axe des axis aux regards des données. Hic c'est parce
                                qu'on connait le nombre de lignes, et si on ne le connaissait pas???*/
                                isVisible: true, // A vérifier (à première vue c'est pour éffacer les grilles)
                                interval: 1,
                                borderWidth: 0,
                                borderColor: Colors.transparent,
                              ),
                              primaryYAxis: NumericAxis(
                                minimum: 3325,
                                maximum: 3333,
                                interval: 6,
                                isVisible: true,
                                borderWidth: 0,
                                borderColor: Colors.transparent,
                              ),
                              title: ChartTitle(text: 'Tension(mv) en fonction du temps(h)',
                              textStyle: const
                                  TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal,
                                  fontWeight:FontWeight.w700, color: Colors.black)),

                              series: _seriesData
                          ),
                        ),

                        const SizedBox(height: 60.0),
                      ],
                    ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
