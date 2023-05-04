// la classe Batterie, qui représente la première vue sur la flotte de Batteries. Donc contient la liste des battéries à afficher de part la grille d'affichage

/*importation des librairies*/
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // pour la langue plus tard
import 'package:usersig/batterie_widget.dart';


/* Corp de la page dont la route est '\batterie.dart'*/
class Batterie extends StatefulWidget {
  const Batterie({Key? key}) : super(key: key);

  @override
  State<Batterie> createState() => _BatterieState();
}

//List <dynamic> datas = [];

class _BatterieState extends State<Batterie> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //header
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)
          ),
        ),
        leading: Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(left: 6.0, right: 6.0)),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  size: 25.0,
                )
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0.0, horizontal: 10.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  size: 20.0,
                )
            ),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0.0, horizontal: 20.0),
            child: InkWell(
              onTap: () {

              },
              child: const CircleAvatar(

                //backgroundColor: _colors, //là la couleur est affecté par défaut au background (PLIMP)
                backgroundImage: AssetImage(
                    'assets/james.jpg'), //image d'arrière plan on concatène une référence globale qui va appeler chaque image dans notre liste correspondant en un nom
                /*child: Text( //Donc là par defaut je lui ai aussi assigné la valeur de nameInitial, si image ça n'apparaitra pas sinon oui (PLIMP)
                        nameInitial,
                        style: TextStyle(fontSize: 30.0),
                        ),*/

              ),

            ),
          ),
        ],


        title: Text(
          AppLocalizations
              .of(context)
              .appTitle,
          style: const TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        centerTitle: false,

      ),

      body:
      SafeArea( //Corps de la page flotte de batterie
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container( //changer ça
                  padding: const EdgeInsets.all(20.0),

                  child: Column(

                    children: <Widget>[

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Flotte de Batteries',
                                style: TextStyle(fontFamily: 'Nunito',
                                    fontSize: 25.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600),
                              )
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton.icon(
                              onPressed: () {

                              },
                              /*onHover: (value){
                                if(value){
                                  setState(() {

                                  });
                                }
                              }, y penser après pour l'embellissement*/
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: Colors.lightGreen,
                                width: 1))
                              ),
                              icon: const Icon(Icons.add_box_outlined, size: 15),
                              label: const Text(
                                'Ajouter une batterie',
                                style:TextStyle(fontFamily: 'Nunito',
                                    fontSize: 13.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700) ,
                              ),

                            )
                          )
                          ,
                          Align(
                              alignment: Alignment.topLeft,
                              child: Builder(
                                  builder: (context) {
                                    return const Text(
                                       '0', //en gros il faudra créer un index pour gérer ça si je dois extraire une liste au complet
                                      //à changer lorsqu'on récupèrera les infos de la DB pour compter le nbre de batterie
                                      style: TextStyle(fontFamily: 'Nunito',
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700),
                                    );
                                  }
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 0.0, right: 20.0, bottom: 30.0),
                  child: BatterieWidget(), //on appelle ici la classe BatterieWidget() pour afficher nos cartes en grille
                ),

              ],
            ),
          )
      ),

    );
  }
}




