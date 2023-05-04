//Partie principale qui renvoie sur le homeScreen

/*Importation des librairies*/
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'batterie.dart';
import 'batterie_detail.dart';
import 'cellule_detail.dart';


/*Corps de l'appli*/
void main() => runApp(const AppliSig());

class AppliSig extends StatelessWidget {
  const AppliSig({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ], //gestion de langues
      debugShowCheckedModeBanner: false,

      home: HomeScreen(), //Page d'acceuil

      routes: { //les routes pour les autres pages utilisées dans l'application en global
        '/batterie' : (context) => Batterie(),
        '/batterieDetail' : (context) => BatterieDetail(),
        '/cellulesDetail' : (context) => CelluleDetail()
      },


    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override

  Widget build(BuildContext context) {
    return Scaffold(//pour le corps de la page d'acceuil
     body: Padding(
       padding: EdgeInsets.all(15.0),
       child: Center(

         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 TextButton(
                     onPressed: (){
                       //Navigator.pushReplacementNamed(context, '/batterie');
                       Get.to(()=>Batterie()); // à lire sur GetX
                     },
                     child: Text(
                       'UtilisateurSIG',
                         style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600)
                     ),
                   style: TextButton.styleFrom(
                     foregroundColor: Colors.greenAccent,
                     minimumSize: Size(140,60)
                   ),

                 ),
                 TextButton(
                     onPressed: (){},
                     child: Text(
                         'AdminSIG',
                         style: TextStyle(fontFamily:'Nunito' , fontSize:15.0 , fontStyle:FontStyle.normal, fontWeight:FontWeight.w600)
                      ),
                     style: TextButton.styleFrom(
                       foregroundColor: Colors.greenAccent,
                       minimumSize: Size(140,60)
                     ),
                 )
               ],
             )
           ],
         ),
       ),
     ),
    );
  }
}




