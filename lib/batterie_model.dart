//classe BatterieModel, qui permet de définir les informations que la batterie peut prendre
class BatterieModel{
  String classe = '' ;
  //int modele = 0;
  String modele = '';
  double SoC = 0.0;
  int etat = 0;
  //String etat = 'veille';
  bool alerte = false;
  double SoH = 100;
  String nomBms = '';
  double tension = 0;
  //int tension = 0;
  double capacite = 0;
  //int capacite = 0;
  //int tensionNominale = 0; // à voir plus tard si on peut l'implémenter de la sorte
  double tensionNominale = 0.0;
  double temperature = 25;
  String batteryStatus = "inactif";
  double courant = 0.3;
  int cycle = 1;
  int nombreCells = 4;


  void setBattArgument(String classe,String modele,double SoC, bool alerte, double SoH, String nomBms, double tension,
      double capacite, double tensionNominale, double temperature, String batteryStatus, double courant, int cycle,
      int nombreCells){
      this.classe = classe;
      this.modele = modele;
      this.SoC = SoC;
      this.alerte = alerte;
      this.SoH = SoH;
      this.nomBms = nomBms;
      this.tension = tension;
      this.capacite = capacite;
      this.tensionNominale = tensionNominale;
      this.temperature = temperature;
      this.batteryStatus = batteryStatus;
      this.courant = courant;
      this.cycle = cycle;
      this.nombreCells = nombreCells;
  }


  BatterieModel( {required this.classe, required this.modele, required this.SoC, required this.etat, required this.alerte,
    required this.SoH, required this.nomBms, required this.tension, required this.capacite, required this.tensionNominale, required this.temperature,
    required this.batteryStatus, required this.courant, required this.cycle, required this.nombreCells});
}