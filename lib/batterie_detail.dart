
/* importation des librairies*/
import'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:usersig/cellule_detail.dart';
import 'package:usersig/tip_courbe.dart';



/*le corps de la route '\batterieDetail'*/
class BatterieDetail extends StatefulWidget {
  final Map<String,dynamic> battery; // On définit l'élément battery.
  final String tableName;

  const BatterieDetail({required this.tableName,required this.battery,Key? key}) : super(key: key);//on va passer en argument la liste des données d'une table de données correspondant à une Batterie

  @override
  State<BatterieDetail> createState() => _BatterieDetailState();
}
class _BatterieDetailState extends State<BatterieDetail> {
  //Map dataBat = {}; //pour recevoir les données passées en boîte de dialogue pour chaque batterie
  //final String s = Get.arguments as String;




  @override
  Widget build(BuildContext context) {
    //dataBat = ModalRoute.of(context)!.settings.arguments as Map;// passation de données

    return Scaffold(
      appBar: AppBar( //le header
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

      body: SafeArea(//le body
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container( //changer ça
                padding: const EdgeInsets.all(20.0),

                child: Column(

                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 25.0,
                        )
                    ),
                    Column( //Titre de l'ensemble de la page
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child :Text(
                              '${Get.arguments["classe"]}${Get.arguments["modele"].toString()}', /*ID de la batterie pour le moment j'ai mis
                              //le même que le titre de la carte de chaque batterie*/
                              style: const TextStyle(fontFamily:'Nunito' , fontSize:25.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600),
                            )
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child :Text(
                              'SE105', //à changer lorsqu'on récupèrera les infos de la DB pour compter le nbre de batterie
                              style: TextStyle(fontFamily:'Nunito' , fontSize:13.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700),
                            )
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0), //pour espacer les éléments

                    Center(
                      child: Row( //Première ligne représentant les éléments (Battery, Model, SoH, Tension/Capacité)
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
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
                                  
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),
                                  
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'Battery',
                                        style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                      ),

                                      Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                      Text(
                                        'SIG Li-ion',
                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ),

                          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                          Card(
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

                                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            'Model',
                                            style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                        ),

                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                        Text(
                                            '72 AH / ${Get.arguments["tensionnominale"]}V',
                                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),

                          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                          Card(
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

                                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            'SoH',
                                            style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                        ),

                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                        Text(
                                            '${Get.arguments["SoH"]}%',
                                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),

                          const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                          Card(
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

                                    const Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            'Tension / Capacité restante',
                                            style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w800)
                                        ),

                                        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0)),

                                        Text(
                                            '${Get.arguments["tension"]} V / ${Get.arguments["capacite"].toStringAsFixed(2)} AH',
                                            style: const TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          )

                        ],
                      ),
                    ),

                    const SizedBox(height: 30.0),

                    Center( //les 3 circles progress bar dans l'ordre de gauche vers la droite
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 230,
                            height: 270,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    children: [
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Etat de charge (SoC)',
                                            style: TextStyle(fontFamily:'Nunito' , fontSize:18.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                          ),
                                        ),
                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0)),

                                      Center(
                                        child:

                                        Builder(
                                            builder: (context) {
                                              for(double i = 0; i <= 100; i+=0.5) { /*la partie qui nous retourne chaque éléments de la grille avec
                         son vrai pourcentage*/
                                                if (Get.arguments["SoC"] ==
                                                    i) {
                                                  return CircularPercentIndicator(
                                                    radius: 60.0,
                                                    lineWidth: 13.0,
                                                    animation: true,
                                                    animationDuration: 200,
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

                                      ),

                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                      const Text(
                                          'temps normal restant', //à varier plus tard donc besoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                      ),
                                    ],
                                  ),

                              ),
                            ),
                          ),

                          SizedBox(
                            width: 230,
                            height: 270,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Température',
                                          style: TextStyle(fontFamily:'Nunito' , fontSize:18.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0)),

                                    Center(
                                      child:

                                      Builder(
                                          builder: (context) {
                                            for (double i = -20; i <= 60; i++) {
                                              /*la partie de la température avec comme température max 60 °*/
                                              if (Get
                                                  .arguments["temperature"] >=
                                                  -20 &&
                                                  Get.arguments["temperature"] <
                                                      0) {
                                                if (Get
                                                    .arguments["temperature"] ==
                                                    i) {
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 13.0,
                                                        animation: true,
                                                        animationDuration: 480,
                                                        percent: (i / 20000) * -1,
                                                        center: Text(
                                                          "$i°",
                                                          style:
                                                          const TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap
                                                            .round,
                                                        progressColor: Colors.red,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.device_thermostat,
                                                              size: 18.0,
                                                              color: Colors.red, //varie en fonction de la température
                                                            ),

                                                            Text(
                                                                'SurChauffe', //varie en fonction de la température
                                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }

                                              if (Get
                                                  .arguments["temperature"] >=
                                                  40 && Get
                                                  .arguments["temperature"] <=
                                                  60) {
                                                if (Get
                                                    .arguments["temperature"] ==
                                                    i) {
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 13.0,
                                                        animation: true,
                                                        animationDuration: 480,
                                                        percent: i / 60,
                                                        center: Text(
                                                          "$i°",
                                                          style:
                                                          const TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap
                                                            .round,
                                                        progressColor: Colors.red,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.device_thermostat,
                                                              size: 18.0,
                                                              color: Colors.red, //varie en fonction de la température
                                                            ),

                                                            Text(
                                                                'SurChauffe', //varie en fonction de la température
                                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }

                                              if (Get
                                                  .arguments["temperature"] >=
                                                  0 &&
                                                  Get.arguments["temperature"] <
                                                      15) {
                                                if (Get
                                                    .arguments["temperature"] ==
                                                    i) {
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 13.0,
                                                        animation: true,
                                                        animationDuration: 480,
                                                        percent: i / 60,
                                                        center: Text(
                                                          "$i°",
                                                          style:
                                                          const TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap
                                                            .round,
                                                        progressColor: Colors
                                                            .orange,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.device_thermostat,
                                                              size: 18.0,
                                                              color: Colors.orange, //varie en fonction de la température
                                                            ),

                                                            Text(
                                                                'Moyen', //varie en fonction de la température
                                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }

                                              if (Get
                                                  .arguments["temperature"] >=
                                                  15 &&
                                                  Get.arguments["temperature"] <
                                                      40) {
                                                if (Get
                                                    .arguments["temperature"] ==
                                                    i) {
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 13.0,
                                                        animation: true,
                                                        animationDuration: 480,
                                                        percent: i / 60,
                                                        center: Text(
                                                          "$i°",
                                                          style:
                                                          const TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap
                                                            .round,
                                                        progressColor: Colors.green,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.device_thermostat,
                                                              size: 18.0,
                                                              color: Colors.green, //varie en fonction de la température
                                                            ),

                                                            Text(
                                                                'Normal', //varie en fonction de la température
                                                                style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }
                                            }
                                            return Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 60.0,
                                                  lineWidth: 13.0,
                                                  animation: true,
                                                  percent: 0.0,
                                                  // à faire varier en fonction du range de température
                                                  center: const Text(
                                                    "0°C",
                                                    // à faire varier en fonction du range de température
                                                    style:
                                                    TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 20.0),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap
                                                      .round,
                                                  progressColor: Colors
                                                      .red, // va changer en fonction de la température
                                                ),

                                                const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                const Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.device_thermostat,
                                                        size: 18.0,
                                                        color: Colors.green, //varie en fonction de la température
                                                      ),

                                                      Text(
                                                          'Normal', //varie en fonction de la température
                                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                      )

                                    ),//Fin partie température
                                  ],
                                ),

                              ),
                            ),
                          ),

                          SizedBox( // Statut de la Batterie
                            width: 230,
                            height: 270,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Statut de Batterie',
                                          style: TextStyle(fontFamily:'Nunito' , fontSize:18.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w700, color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0)),

                                    Center(
                                      child:

                                      Builder(
                                          builder: (context) {
                                                if (Get.arguments["batterystatus"] == "charge") { //Charge status
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 8.0,
                                                        animation: false,
                                                        percent: 1.0,
                                                        center: const Text(
                                                              "+",
                                                          style:
                                                          TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.green),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        progressColor: Colors.lightBlueAccent,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Text(
                                                          'En Charge', //à varier plus tard doncbesoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                      ),
                                                    ],
                                                  );
                                                }

                                                if (Get.arguments["batterystatus"] == "decharge") {//décharge
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 8.0,
                                                        animation: false,
                                                        percent: 1.0,
                                                        center: const Text(
                                                          "-",
                                                          style:
                                                          TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.orange),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        progressColor: Colors.lightBlue,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Text(
                                                          'En Décharge', //à varier plus tard doncbesoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                      ),
                                                    ],
                                                  );
                                                }

                                                if (Get.arguments["batterystatus"] == "inactif") {//inactif
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 8.0,
                                                        animation: false,
                                                        percent: 1.0,
                                                        center: const Text(
                                                          " ",
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        progressColor: Colors.lightBlue,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Text(
                                                          'Inactif', //à varier plus tard doncbesoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                                          style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  );
                                                }

                                                if (Get.arguments["batterystatus"] == "hs") {//hors service
                                                  return Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 60.0,
                                                        lineWidth: 8.0,
                                                        animation: false,
                                                        percent: 1.0,
                                                        center: const Text(
                                                          "- - -",
                                                          style:
                                                          TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.red),
                                                        ),
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        progressColor: Colors.lightBlue,
                                                      ),

                                                      const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                      const Text(
                                                        'Hors Service', //à varier plus tard doncbesoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                                        style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  );
                                                }



                                            return Column(//Par défaut
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 60.0,
                                                  lineWidth: 8.0,
                                                  animation: false,
                                                  percent: 1.0,
                                                  center: const Text(
                                                    "+ - * .", // à faire varier en fonction des données
                                                    style:
                                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                                  ),
                                                  circularStrokeCap: CircularStrokeCap.round,
                                                  progressColor: Colors.lightBlueAccent,
                                                ),

                                                const Padding(padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 0.0)),

                                                const Text(
                                                    'Charge, decharge, HS, Inactif', //à varier plus tard doncbesoin d'un petit algo de soustraction connaissant le temps total d'une charge/decharge
                                                    style: TextStyle(fontFamily:'Nunito' , fontSize:14.0 , fontStyle:FontStyle.normal)
                                                ),
                                              ],
                                            );
                                          }
                                      ),

                                    ),

                                  ],
                                ),

                              ),
                            ),
                          )

                        ],
                      ),
                    ),

                    const SizedBox(height: 40.0),
                    Center(
                      child: Row( //ligne représentant les éléments (Cycles,Courant, Cellules)
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox( // Cycles
                            width: 216,
                            child: Card(
                                elevation: 1,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              children:[
                                                const Text(
                                                    'Cycles',
                                                    style: TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w800)
                                                ),

                                                const SizedBox(height: 8.0),

                                                Text(
                                                    Get.arguments["cycle"].toString(),//à faire varier en fonction du nombre de cycles
                                                    style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:27.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w900)
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 40),

                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.history,
                                          size: 40,
                                          color: Colors.lightGreen,
                                        ),
                                      )

                                    ],
                                  ),
                                )
                            ),
                          ),

                          //Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                          SizedBox( // courant
                            width: 216,
                            child: Card(
                                elevation: 1,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              children:[
                                                const Text(
                                                    'Courant',
                                                    style: TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w800)
                                                ),

                                                const SizedBox(height: 8.0),

                                                Text(
                                                    '${Get.arguments["courant"]}A',//à faire varier en fonction du nombre de cycles
                                                    style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:27.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w900)
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 40),

                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.electric_bolt,
                                          size: 40,
                                          color: Colors.yellow,
                                        ),
                                      )

                                    ],
                                  ),
                                )
                            ),
                          ),

                          //Padding(padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0)),

                          InkWell( //cellules
                            onTap: (){
                              // Navigator.pushReplacementNamed(context, '/cellulesDetail');
                              Get.to(()=> CelluleDetail(tableName: widget.tableName),
                                  arguments: {
                                    "nombrecellules" : Get.arguments["nombreCellule"],
                                    "classebatt" : Get.arguments["classe"],
                                    "modelebatt" : Get.arguments["modele"]
                                  }
                              );
                            },
                            child: SizedBox( // box cellules
                              width: 263,
                              child: Card(
                                  elevation: 5,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(9.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                children:[
                                                  const Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                        'Nombre de cellules',
                                                        style: TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w800)
                                                    ),
                                                  ),

                                                  const SizedBox(height: 8.0),

                                                  Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Text(
                                                        Get.arguments["nombreCellule"].toString(),//à faire varier en fonction du nombre de cellules que la battérie contient
                                                        style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:27.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w900)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(width: 16.0),

                                        const Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.pix,
                                                size: 40,
                                                color: Colors.lightGreen,
                                              ),

                                              Align(
                                                //alignment: Alignment.bottomRight,
                                                child: Text(
                                                    'Cliquer pour voir',//à faire varier en fonction du nombre de cellules que la battérie contient
                                                    style: TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:10.0 , fontStyle:FontStyle.normal, fontWeight: FontWeight.w900)
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40.0),

                     Center(
                      child: SizedBox(//les courbes
                              width : 850.0, //taille de box courbes
                              child: TipCourbe(tableName: widget.tableName) //appel de la classe qui instancie les courbes
                            ),
                    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
