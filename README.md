# usersig

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

LES FONCTIONS CREES ET UTILISEES DANS FLUTTER :

Partie Main (fichier main.dart) :

    Il n'y a pas de fonctions qui ont été crées et/ou utilisées dans cette partie. Nous avons respecté l'architecture de Flutter à ce niveau. 
    En effet le main.dart est le programme qui nous permet de lancer le logiciel et de pouvoir afficher ce que vous voyez au démarrage du logiciel.
    Sur cette première vue qui est affichée, on retrouve deux boutons :  un pour l'utilisateur et un pour l'administrateur. C'est la partie de l'utilisateur qui a 
    été implémentée jusque là vue que la partie administrateur rentre plus dans l'intégration de l'interface en ligne et est aussi basée sur la partie utilisateur.
    En cliquant sur le bouton utilisateurSIG, on atterit sur une vue de connexion normalement (qui rentre dans l'implémentation de l'outil en ligne). Mais là on,
    on atterit plutôt sur une vue qui est renvoyée par le fichier batterie.dart.

    LES RESTANT A FAIRE A CE NIVEAU : 
      Implémentation de la vue de connexion pour récupérer les informations concernant l'utilisateur et ses batteries.
      Implémentation de la vue de connexion pour les administrateurs.


Partie de la classe Batterie (fichier batterie.dart) : 

    Qu'est ce qu'on fait ici?
    On affiche les batteries présentent dans la base de données de l'utilisateur. 
    En éffet sous le titre "Flotte de Batterie" (Widget text) on a un autre widget text qui donne l'information sur le nombre en entier de batterie dont dispose l'utilisateur,
    puis juste en bas on affiche les cartes de Batteries dont dispose l'utilisateur.
    
    
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
    Cette fonction ci-dessus questionne la base(les tables de données représentants chacune de ses battéries) de données de l'utilisateur et récupère la liste des tables 
    dans la base de données surtout pour savoir le nombre de battéries dont dispose l'utilisateur.

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    void _pickFolder() async {
        final String? directoryPath = await getDirectoryPath();
        if (directoryPath == null) {
          // Operation was canceled by the user.
          return;
        }
        _folderPath = directoryPath;
    }
    Cette fonction ci-dessus est une fonction de Flutter pour pouvoir sélectionner un dossier sur le disque de l'utilisateur.

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
                //jsontomysqlgeneralbis.php
                a.Response response = await dio.post(
                  'http://localhost/testsig1/.vs/jsontomysqlgeneralbisbis.php',
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
    Cette fonction ci-dessus, permet lorsqu'un dossier d'information de batterie est sélectionné, de pouvoir traiter ce dossier et ses fichiers à travers le fichier php :
    jsontomysqlgeneralbisbis.php . Ici nous faisons un pont de zippage du dossier sélectionné. C'est le fichier zip du dossier sélectionné qui est donc envoyé vers le fichier 
    php jsontomysqlgeneralbisbis.php . Par ailleurs, nous envoyons aussi à ce fichier php, le nom de la batterie et le nombre de cellules qu'elle comporte.


    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
    Cette fonction n'est rien d'autre que la fonction de la bibliothèque Flutter qui permet de convertir un dossier en dossier zippé.



Partie du fichier batterie.dart qui fait appel à la classe BatterieWidget() : 

     const Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 0.0, right: 20.0, bottom: 30.0),
                  child: BatterieWidget(), //on appelle ici la classe BatterieWidget() pour afficher nos cartes en grille
    ),


Partie de la classe BatterieWidget (fichier batterie_widget.dart) : 
    
    Future<void> getTableNames() async {} : se référer à la description plus haut.

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
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
    Cette fonction ne prends rien en paramètre. Elle a pour but dans un premier temps d'utiliser les données envoyées par requêtes http depuis le script php contenu 
    dans getdata_newarch.php . Puis dans un second temps d'appeler la fonction getData() pour son exécution.
    Un tableau d'objet BatterieModel a été crée en haut en variable globale de cette classe. Ce tableau stocke les objets BatterieModel au nombre de batteryData.length (si 
    batteryData.length = 8 alors donc les objets BatterieModel seront au nombre de 8). Vous verrez dans le programme que cette fonction est exécutée dans la méthode 
    initState(){}, donc au tout début du chargement de la vue que renvoie cette classe. En sommes on l'utilise pour générer les objets qu'il faut sans valeurs ou du moins avec
    des valeurs nulles comme paramètre pour chaque objets BatterieModel généré. Il faut noter que batteryData.length est la taille représentant le nombre de table de données
    différentes dans la base de données. Les tables de données représentent chacune une battérie-BMS avec ses informations.

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
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
    Cette fonction qui ne prend rien en paramètre ni ne retourne rien est appelée dans la fonction Future<void> getDataNew() async {}. La variable batteryData est une variable
    publique de la classe BatterieWidget. batteryData contient les données de toutes les battéries. Donc on récupère les données de chacune des batteries puis on les formatte
    sur le format nécessaire pour les objets BatterieModel crées avec la fonction getDataNew(). Ensuite on les passe en argument au constructeur de chacun de ces objets 
    BatterieModel. la méthode setState(){} est là pour mettre à jour l'objet BatterieModel qui est concerné par les données formattées. Et pour savoir quel onjet BatterieModel
    est concerné à un moment de la boucle, il suffit de regarde la variable index qui a été déclarée par var index=0; en début de boucle.

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
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
    )
    C'est la partie qui permet de passer de la classe BatterieWidget invoqué dans la classe Batterie, vers la classe BatterieDetail. Normalement c'est intuitif, ça veut dire
    que pour consulter le détail d'une batterie, on clique sur la carte Batterie en question.


Partie de la classe BatterieDetail (fichier batterie_detail.dart) :
    
    La classe BatterieDetail permet de renvoyer la vue sur laquelle on retrouve les détails d'une Batterie à un moment donné sur tous les items sur l'interface sauf les.
    qui elles ont été mis en place pour visualiser le comportement de la batterie sur un intervalle de temps donné. La visualisation s'éffectue sur 24h et on peut défiler de jour
    en jour pour parcourir un mois au complet.

     InkWell( //cellules
                            onTap: (){
                              // Navigator.pushReplacementNamed(context, '/cellulesDetail');
                              Get.to(()=> CelluleDetail(cellsNumber:widget.cellsNumber ,tableName: widget.tableName),
                                  arguments: {
                                    "nombrecellules" : Get.arguments["nombreCellule"],
                                    "classebatt" : Get.arguments["classe"],
                                    "modelebatt" : Get.arguments["modele"]
                                  }
                              );
                            },
                            child: SizedBox( ....... // box cellules)
        )
    Ceci est la partie qui permet de lier une batterie à la vue cellule renvoyée par la classe CelluleDetail.

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    Center(
                      child: SizedBox(//les courbes
                              width : 850.0, //taille de box courbes
                              child: TipCourbe(cellsNumber: Get.arguments["nombreCellule"],tableName: widget.tableName) //appel de la classe qui instancie les courbes
                            ),
    ),
    Cette partie appelle la classe renvoyant les deux courbes Tension moyenne en fonction du temps et Intensité moyenne en fonction du temps



Partie de la classe TipCourbe (fichier tip_courbe.dart) : 
    
    La classe TipCourbe renvoie la vue sur laquelle on peut observer les courbes tension moyenne en fonction du temps et intensité moyenne en fonction du temps .
    J'utilise un Future Builder pour l'implémenter. Il faut donc aller voir la documentation de Future Builder sur la doc officielle Flutter pour bien la comprendre.


    Future<void> dayNumbers() async{//fonction qui permet de récupérer le nombre de jours dans un mois
    // ça se répète c'est possible de le rendre global pour ne seulement utiliser qu'un réfléchir à ça à l'optimisation

    final response = await http.get(Uri.parse('http://localhost/testsig1/.vs/nombredejoursmois.php? tableName=${widget.tableName}'));

    final numberday = jsonDecode(response.body);
    nombreJours = numberday[0]['nombrejours'];
    }
    Cette fonction ne fait que récupérer le nombre de jours disponible dans le mois pour l'affichage des courbes sur un mois. Pour récupérer le nombre de jours la fonction
    exploite une réponse d'une requête http envoyée par le fichier php côté serveur nombredejourmois.php .

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Future<List<dynamic>> fetchMySQLData() async{ /*on crée une fonction fetchMySQLData() pour récupérer les données avec la
    passerelle PHP puis on stocke dans data qu'on retourne à la fonction*/
    var urlo = 'http://localhost/testsig1/.vs/courbebattun.php? pages=$currentPagio&tableName=${widget.tableName}';
    final res = await http.get(Uri.parse(urlo)); //courbebatt.php en général
    var data = json.decode(res.body);
    return data;
    }
    Cette fonction asynchrone retourne une Liste dynamique d'informations envoyé depuis le côté serveur courbebattun.php à travers une requête http. 
    Pour voir exactement quelles infos récupère t-on se référer au fichier courbebattun.php côté serveur.

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Future<List<ChartDataCourbes>> fetchDataCourbes() async {
        /* ici on appelle la fonction fetchMySQLData() qu'on affecte à la variable jsonData qui est du même type de donnée que jsonData
        List<dynamic>*/
        List<dynamic> jsonData = await fetchMySQLData();
    
        /*Ici j'éffectue une opération de conversion des données du type String rendu âr Json aux types requis pour les paramètres
         des objets ChartData courbe que je stocke dans la liste datas en fonction des informations provenantes de jsonData.
         jsonData qui récupère tous les éléments de la table comme la requête PHP correspondante*/
        if(widget.cellsNumber==8) {
          datas = List<ChartDataCourbes>.from(jsonData.map((data) =>
              ChartDataCourbes(valSoC: double.parse(data['SoC']),
                  tension: (1000 * double.parse(data['tension'])).toInt(),
                  intensite: double.parse(data['courant']),
                  temperature: double.parse(data['temperature']),
                  date: data['date'],
                  heure: format.parse(data['heure']))).toList());
          return datas;
        }else{
          datas = List<ChartDataCourbes>.from(jsonData.map((data) =>
              ChartDataCourbes(valSoC: double.parse(data['SoC']),
                  tension: (double.parse(data['tension'])).toInt(),
                  intensite: double.parse(data['courant']),
                  temperature: double.parse(data['temperature']),
                  date: data['date'],
                  heure: format.parse(data['heure']))).toList());
          return datas;
        }
    }
    Cette fonction exploite la précédente pour récupérer les informations telles que la tension, l'intensité, la température , la date et l'heure. Elle formatte ses infos
    et les passe en valeurs au constructeur de la classe ChartDataCourbes. Elle est asynchrone
    En éffet nous créeons une variable publique datas qui va recevoir une liste d'objets ChartDataCourbes qu'on génère à partir des lignes d'information contenues dans le 
    resultat que retourne la fonction précédente fetchMySQLData(). Ces objets ChartDataCourbes sont destinés à alimenter les courbes tension moyenne en fonction du temps et
    intensité moyenne en fonction du temps.

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    Future<List<ChartDataCourbes>> fetchData(String borneInferieure, String borneSuperieure) async {
    //Cette fonction permet de questionner PHP pour avoir les données entre la borneInférieure et la borneSuperieure
            var urloo = 'http://localhost/testsig1/.vs/miseajour.php? tableName=${widget.tableName}';
            final response = await http.post(
               Uri.parse(urloo),
              body: {
                'borne_inferieure': borneInferieure,
                'borne_superieure': borneSuperieure,
              },
            );
        
              final jsonData = json.decode(response.body);
              dataso = [];
            if(widget.cellsNumber==8) {
              dataso = List<ChartDataCourbes>.from(jsonData.map((data) =>
                  ChartDataCourbes(valSoC: double.parse(data['SoC']),
                      tension: (1000 * double.parse(data['tension'])).toInt(),
                      intensite: double.parse(data['courant']),
                      temperature: double.parse(data['temperature']),
                      date: data['date'],
                      heure: format.parse(data['heure']))).toList());
              return dataso;
            }else{
              dataso = List<ChartDataCourbes>.from(jsonData.map((data) =>
                  ChartDataCourbes(valSoC: double.parse(data['SoC']),
                      tension: (double.parse(data['tension'])).toInt(),
                      intensite: double.parse(data['courant']),
                      temperature: double.parse(data['temperature']),
                      date: data['date'],
                      heure: format.parse(data['heure']))).toList());
              return dataso;
            }
    }
    Cette fonction effectue à peu près la même chose que la fonction fetchDataCourbes() à la seule exception qui ne s'appui pas sur une autre fonction comme le fais la 
    fonction fecthDataCourbes().
    La fonction ci-dessus prend en paramêtre deux chaîne de caractères représentant respectivement la date + heure de début et la date + heure de fin. Si on va être rigoureux,
    on va juste parler de l'heure de début et l'heure de fin car en vrai la date ne change pas sur les deux bornes de l'intervalle de temps.

    Dans cette fonction on récupère les données envoyées côté serveur entre ces deux intervalle de temps depuis le fichier php miseajour.php pour pouvoir générer une liste 
    d'objets ChartDataCourbes qui vont servir à alimenter les courbes.

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    List<ChartSeries<ChartDataCourbes, dynamic>> _createDefaultTensionTemps(List<ChartDataCourbes> dats) {// Liste de la partie Tension/temps, C'est un truc propre aux courbes
        return <ChartSeries<ChartDataCourbes, dynamic>>[
          //SplineAreaSeries
          AreaSeries(
            animationDelay: 5,
            dataSource: dats,
            xValueMapper: (ChartDataCourbes data, _) => data.heure,
            yValueMapper: (ChartDataCourbes data, _) => data.tension,
            //SplineType: SplineType.natural,
            gradient: LinearGradient(
              colors: [
                AppStyle.spline_color,
                AppStyle.bg_color.withAlpha(150),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          LineSeries(
              animationDelay: 5,
              dataSource: dats,
              color: AppStyle.accent_color,
              width: 4,
              markerSettings: MarkerSettings( //Pour mettre en évidence les points
                color: Colors.white,
                borderWidth: 2,
                shape: DataMarkerType.circle,
                borderColor: AppStyle.accent_color,
                isVisible: true,
              ),
              xValueMapper: (ChartDataCourbes data, _) => data.heure,
              yValueMapper: (ChartDataCourbes data, _) => data.tension),
        ];
    }
    Cette fonction a pour but de générer les series de courbes nécéssaires pour tracer la tension moyenne en fonctin du temps. Elle prend en paramètre une Liste d'objets
    ChartDataCourbes qui représente sa source de données (ie dataSource : dats).

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

    List<ChartSeries<ChartDataCourbes, dynamic>> _intensiteTemps(List<ChartDataCourbes> dats) { //Liste de la partie intensité/temps

          return <ChartSeries<ChartDataCourbes, dynamic>>[
            AreaSeries(
              animationDelay: 10,
              dataSource: dats,
              xValueMapper: (ChartDataCourbes data, _) => data.heure,
              yValueMapper: (ChartDataCourbes data, _) => data.intensite,
              //splineType: SplineType.natural,
              gradient: LinearGradient(
                colors: [
                  AppStyle.spline_color,
                  AppStyle.bg_color.withAlpha(150),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            LineSeries(
                animationDelay: 10,
                dataSource: dats,
                color: AppStyle.accent_color,
                width: 4,
                markerSettings: MarkerSettings( //Pour mettre en évidence les points
                  color: Colors.white,
                  borderWidth: 2,
                  shape: DataMarkerType.circle,
                  borderColor: AppStyle.accent_color,
                  isVisible: true,
                ),
                xValueMapper: (ChartDataCourbes data, _) => data.heure,
                yValueMapper: (ChartDataCourbes data, _) => data.intensite)
          ];
    }
    Cette fonction a pour but de générer les series de courbes nécéssaires pour tracer l'intensité moyenne en fonctin du temps. Elle prend en paramètre une liste d'objets
    ChartDataCourbes qui représente sa source de données (ie dataSource : dats).

