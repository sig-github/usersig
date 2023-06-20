// la classe Batterie, qui représente la première vue sur la flotte de Batteries. Donc contient la liste des battéries à afficher de part la grille d'affichage

/*importation des librairies*/
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as a;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // pour la langue plus tard
import 'package:get/get.dart' as b;
//import 'package:get/get_connect/http/src/response/response.dart';
import 'package:usersig/batterie_widget.dart';
import 'package:http/http.dart'  as http; //pour la communication php mysql et flutter
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';

/* Corp de la page dont la route est '\batterie.dart'*/
class Batterie extends StatefulWidget {
  const Batterie({Key? key}) : super(key: key);

  @override
  State<Batterie> createState() => _BatterieState();
}

//List <dynamic> datas = [];

class _BatterieState extends State<Batterie> {
  final _keyForm = GlobalKey<FormState>();
  String battName = "";
  int cellsNumber = 0;
  late File file;

  String _folderPath = '';

  List tableNames = [];
  Future<void> getTableNames() async {
    final response = await http.get(
        Uri.parse('http://localhost/testsig1/.vs/tablesnames.php'));


    var data = json.decode(response.body);
    setState(() {
      tableNames = data;
    });

    /*if(kDebugMode){
      print(tableNames.length);
      print(tableNames[0]);
      print(tableNames[1]);
    }*/
  }

  void _pickFolder() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) {
      // Operation was canceled by the user.
      return;
    }
    _folderPath = directoryPath;
  }



  Future<void> _uploadFile() async {
    if (_folderPath != null && _folderPath!.isNotEmpty) {
      if (battName == null || battName!.isEmpty) {
        if (kDebugMode) {
          print('Valeur de "battName" manquante');
        }
        return;
      }

      String folderPath = _folderPath;
      String zipPath = path.join(folderPath, 'dossier.zip');

      await createZip(folderPath, zipPath);

      a.Dio dio = a.Dio();
      a.FormData formData = a.FormData.fromMap({
        'file': await a.MultipartFile.fromFile(zipPath, filename: 'dossier.zip'),
        'battName': battName,
        'cellsNumber': cellsNumber,
      });

      try {
        a.Response response = await dio.post(
          'http://localhost/testsig1/.vs/jsontomysqlgeneralbis.php',
          data: formData,
        );

        if (response.statusCode == 200) {
          // Request successful
          if (kDebugMode) {
            print('Data sent successfully!');
          }
          setState(() { // pour mettre à jour après avoir géré la création de la table de batterie

          });
        } else {
          // Request failed
          if (kDebugMode) {
            print('Failed to send data. Status code: ${response.statusCode}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending data: $e');
        }
      }
    }
  }

  Future<void> createZip(String folderPath, String zipPath) async {
    final zipFile = File(zipPath);
    final folderDir = Directory(folderPath);

    if (!folderDir.existsSync()) {
      if (kDebugMode) {
        print('Folder does not exist: $folderPath');
      }
      return;
    }

    final archive = Archive();

    final files = await folderDir.list(recursive: true).toList();

    for (final file in files) {
      if (file is File) {
        final filePath = file.path;
        final relativePath = path.relative(filePath, from: folderPath);
        final fileContent = await file.readAsBytes();
        archive.addFile(ArchiveFile(relativePath, fileContent.length, fileContent));
      }
    }

    final zipBytes = ZipEncoder().encode(archive);

    zipFile.writeAsBytesSync(zipBytes!);

    if (kDebugMode) {
      print('ZIP file created: $zipPath');
    }
  }



  Widget _dialogBuilder(BuildContext context) {
    //ThemeData localTheme = Theme.of(context);


    return SimpleDialog(
      title: const Text("Ajout de fichier", style: TextStyle(fontFamily: 'Nunito',
          fontSize: 18.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700)),
      children: [
        Form(
          key: _keyForm,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:12.0 ,
                          fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'nom de la batterie',
                      ),

                      onChanged: (value){
                        battName = value ;
                        /*if (kDebugMode) {
                                  print(entryTime);
                                }*/
                      },
                      validator: (value) => (value==null || value.isEmpty) ? 'Entrer la valeur de départ' : null,
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black ,fontFamily:'Nunito' , fontSize:12.0 ,
                          fontStyle:FontStyle.normal, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'nombre de cellule ex : 8',
                      ),
                      onChanged: (value){
                        cellsNumber = int.parse(value);
                        /*if (kDebugMode) {
                                  print(outtaTime);
                                }*/
                      },
                      validator: (value) => (value==null || value.isEmpty || !value.isNum) ? 'Entrer une bonne valeur' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: 100.0,
                child: TextButton(
                      onPressed: () async {
                        _pickFolder();
                      },
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: Colors.lightGreen,
                          width: 1)),
                        ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Fichier',
                            style:TextStyle(fontFamily: 'Nunito',
                                fontSize: 13.0,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700, color: Colors.black) ,
                          ),

                          Icon(Icons.file_upload_outlined, size: 18.0, color: Colors.black)
                        ],
                      ),
              ),
              ),


              const SizedBox(height: 30),

              Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          _uploadFile();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Valider',
                          style:TextStyle(fontFamily: 'Nunito',
                              fontSize: 13.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700, color: Colors.white) ,
                        ),

                      ),

                      const SizedBox(width: 25.0),

                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Annuler',
                          style:TextStyle(fontFamily: 'Nunito',
                              fontSize: 13.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700, color: Colors.white) ,
                        ),

                      ),
                    ],
                  )
              ),
            ],
          ),

        ),
      ],
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTableNames();
  }


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
                              alignment: Alignment.topLeft,
                              child: Builder(
                                  builder: (context) {
                                    return Text(
                                       '${tableNames.length}', //en gros il faudra créer un index pour gérer ça si je dois extraire une liste au complet
                                      //à changer lorsqu'on récupèrera les infos de la DB pour compter le nbre de batterie
                                      style: const TextStyle(fontFamily: 'Nunito',
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700),
                                    );
                                  }
                              )
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(context: context, builder:(context)
                                  => _dialogBuilder(context) );
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




