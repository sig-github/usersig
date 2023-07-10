/*importations des librairies*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usersig/cells_chartdata.dart';
import 'package:usersig/tensionminmaxmoy.dart';
import 'app_style.dart';
import 'cellule_widget.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'dart:convert'; //certainement pour convertir le json
import 'dart:async'; //sert à quoi??

class CelluleDetail extends StatefulWidget {
  final String tableName; //vérifier si c'est privée à la classe un peu plus tard au cas où il y aurait un résultat bizarre.
  final int cellsNumber;
  const CelluleDetail({required this.cellsNumber,required this.tableName,Key? key}) : super(key: key);

  @override
  State<CelluleDetail> createState() => _CelluleDetailState();
}
int currentPage = 1;

class _CelluleDetailState extends State<CelluleDetail> {
  List<ChartSeries<CellData, DateTime>> _seriesData = [];//Tableau de series de courbes
  late ZoomPanBehavior _zoomPanBehavior; //variable pour les propriétés de zooming de la courbe

  //final int pageSize = 144; //taille des lignes de données de 00h à 23h59 en respectant un débit de 10minutes d'intervalle
  //bool isPrevious = false;
  int nombreJour = 0;// variable pour stocker le nombre de jour dans un mois quelconque
  DateFormat format = DateFormat('HH:mm'); //Variable pour la mise des heures en format heure:minutes
  String date = "";

  Future getNumberPage() async{ //fonction pour récupérer le nombre de jours et le stocker dans la variable nombreJour

    final resu = await http.get(Uri.parse('http://localhost/testsig1/.vs/nombredejoursmois.php? tableName=${widget.tableName}'));
    final jour = json.decode(resu.body);

    nombreJour = jour[0]['nombrejours'];
  }

  @override
  void initState() { //fonction qui execute au debut du programme et une seule fois
    super.initState();
    getNumberPage();
    _getData();
    _zoomPanBehavior = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePinching: true,
      enablePanning: true,
      // Enables the selection zooming
      enableSelectionZooming: true,
      enableMouseWheelZooming : true,
    );
  }

  Future<void> _getData() async { //fonction pour récupérer les données pour notre courbe
    var url = 'http://localhost/testsig1/.vs/cellsqueryo.php? page=$currentPage&tableName=${widget.tableName}&cellsNumber=${widget.cellsNumber}';
    var response = await http.get(Uri.parse(url));/* Récupération des éléments
    de la requête PHP*/
    var data = json.decode(response.body); //On décode le json qui a été envoyé et on le stocke dans la variable data

    List<ChartSeries<CellData, DateTime>> seriesData = [];// on crée et initialise une Liste de series de données
    data.forEach((key, value) //Pour chaque élément clé du json envoyé faire ce qui est en accolade
    {
      List <CellData> datacells = []; /*on crée et initialise une liste d'objet CellData pour stocker les données de
      chaque cellule sur un temps donné. Je l'ai mis là parce qu'il faut le réinitialiser après utilisation*/
      if (kDebugMode) {
        print('$key');
      }
      for(int i = 0; i < value.length; i++) { /* Pour chaque lignes temps et valeur de
      tension de chaque cellule faire*/
        datacells.add(CellData(heure: format.parse(value[i][0]), tension: value[i][1])); /* On ajoute un objet CellData dont les valeurs
        correspondent à chaque ligne de value dans la liste datacells
        */
        //id: value[i][0],
        setState(() {
          date= value[i][2].toString();
        });
      }
      seriesData.add( /*On ajoute maintenant la serie avec les données de series correspondant à chaque cellules*/
        LineSeries(
            //animationDelay: 2000,
            dataSource: datacells,
            isVisible: true,
            enableTooltip: true,
            color: (() {
              switch (key) { //pour attribuer une couleur de serie à chaque cellule
                case 'tensioncell0':
                  return Colors.red;
                case 'tensioncell1':
                  return Colors.orange;
                case 'tensioncell2':
                  return Colors.grey;
                case 'tensioncell3':
                  return Colors.black;
                case 'tensioncell4':
                  return Colors.teal;
                case 'tensioncell5':
                  return Colors.deepPurpleAccent;
                case 'tensioncell6':
                  return Colors.lightGreenAccent;
                case 'tensioncell7':
                  return AppStyle.accent_color;
                case 'tensioncell8':
                  return Colors.black12;
                case 'tensioncell9':
                  return Colors.white24;
                case 'tensioncell10':
                  return Colors.pinkAccent;
                case 'tensioncell11':
                  return Colors.deepPurple;
                case 'tensioncell12':
                  return Colors.blueGrey;
                case 'tensioncell13':
                  return Colors.brown;
                case 'tensioncell14':
                  return Colors.lime;
                case 'tensioncell15':
                  return Colors.tealAccent;
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
              borderColor: (() {//pour attribuer une couleur de bordure de marqueur à chaque cellule
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
                  case 'tensioncell8':
                    return Colors.black12;
                  case 'tensioncell9':
                    return Colors.white24;
                  case 'tensioncell10':
                    return Colors.pinkAccent;
                  case 'tensioncell11':
                    return Colors.deepPurple;
                  case 'tensioncell12':
                    return Colors.blueGrey;
                  case 'tensioncell13':
                    return Colors.brown;
                  case 'tensioncell14':
                    return Colors.lime;
                  case 'tensioncell15':
                    return Colors.tealAccent;
                  default:
                    return
                      Colors.amberAccent;
                }
              })(),
              isVisible: false,
            ),
            xValueMapper: (CellData data, _) => data.heure,
            yValueMapper: (CellData data, _) => data.tension)
      );


      setState(() {
        _seriesData = seriesData;
      });
    });
    /*if(isPrevious==false) {
      currentPage += currentPage;
    }else{
      currentPage -= currentPage;
    }*/
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

                //backgroundColor: _colors, //là la couleur est affectée par défaut au background (PLIMP)
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

                const SizedBox(height: 20.0),

                TensionMinMoyMax(cellsNumber: Get.arguments["nombrecellules"],tableName: widget.tableName), //appel du constructeur de l'entité TensionMinMoyMax

                const SizedBox(height: 10.0),

                SizedBox(width:770.0 ,child: CelluleWidget(cellsNumber: Get.arguments["nombrecellules"],tableName: widget.tableName)),//appel de l'entité CelluleWidget( )

                const SizedBox(height: 60.0),

                Center(//Box pour toutes les courbes taille de box courbes
                    child: Column(
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed:(){
                                    _zoomPanBehavior.zoomIn();
                                    setState(() {

                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  iconSize: 15
                              ),
                              IconButton(
                                  onPressed:(){
                                    _zoomPanBehavior.zoomOut();
                                    setState(() {

                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                  iconSize: 15
                              ),
                              IconButton(
                                  onPressed:(){
                                    _zoomPanBehavior.reset();
                                    setState(() {

                                    });
                                  },
                                  icon: const Icon(Icons.replay_circle_filled_outlined),
                                  iconSize: 15
                              )
                            ],
                          ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed:(){
                                  if(currentPage==1){
                                    return;
                                  }else{
                                    currentPage =currentPage - 1;
                                    _getData();
                                    setState(() {

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
                             Padding(
                               padding: const EdgeInsets.only(right: 20.0),
                               child: SizedBox(
                                 width: 1000.0,
                                 child: SfCartesianChart(
                                          legend: Legend(isVisible:true),
                                          zoomPanBehavior: _zoomPanBehavior,
                                          margin: const EdgeInsets.all(0),
                                          borderWidth: 0,
                                          borderColor: Colors.transparent,
                                          plotAreaBorderWidth: 0,
                                          tooltipBehavior: TooltipBehavior(enable: true,elevation: 1),
                                          primaryXAxis: DateTimeAxis(
                                            intervalType: DateTimeIntervalType.auto,
                                            title: AxisTitle(text: 'heure:minutes', textStyle: const
                                                TextStyle(fontFamily:'Nunito' , fontSize:12.0 , fontStyle:FontStyle.normal,
                                                fontWeight:FontWeight.w700, color: Colors.black), alignment: ChartAlignment.near),
                                            /*minimum: curveXaxisStart, //valeur minimale de l'axe des axis aux regards des données
                                            maximum: 150,*/ /*valeur maximale de l'axe des axis aux regards des données. Hic c'est parce
                                            qu'on connait le nombre de lignes, et si on ne le connaissait pas???*/
                                            autoScrollingMode: AutoScrollingMode.start,
                                            dateFormat: DateFormat.Hm(),
                                            //autoScrollingDelta: 144,
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
                                            interval: 1000,
                                            isVisible: true,
                                            borderWidth: 0,
                                            borderColor: Colors.transparent,
                                          ),
                                          title: ChartTitle(text: 'Tension en fonction du temps au jour du $date',
                                          textStyle: const
                                              TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal,
                                              fontWeight:FontWeight.w700, color: Colors.black)),

                                          series: _seriesData
                                      ),
                               ),
                             ),


                              IconButton(
                                onPressed:(){
                                  if(currentPage==nombreJour){
                                    return;
                                  }else{
                                    setState(() {
                                      currentPage = currentPage + 1;
                                      _getData();
                                    });
                                  }
                                },

                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                        ),

                        /*
                        const SizedBox(height: 15),

                        Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              child: const Text(
                                'Mettre a jour',
                                style:TextStyle(fontFamily: 'Nunito',
                                    fontSize: 13.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700) ,
                              ),

                            )
                        ),*/
                        const SizedBox(height: 40)
                      ],
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
