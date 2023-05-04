//hérite de la classe ChartData, puis contient les informations à afficher sur les courbes au niveau de batterie_detail
import 'chart_data.dart';

class ChartDataCourbes extends ChartData{
  int tension = 0;
  int temps = 0;
  double intensite = 0;
  double temperature = 25;
  String date = '';
  DateTime heure = DateTime(2023,1,1,0,0,0);


  ChartDataCourbes({required super.valSoC,required this.tension, required this.temps,
    required this.intensite, required this.temperature, required this.date, required this.heure});
}