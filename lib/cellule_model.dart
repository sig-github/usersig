class CelluleModel{
  double equilibrage = 0;
  double tension = 0;
  int SoC = 0;
  double temperature = 25;
  String id = '';

  CelluleModel({ required this.id,required this.tension, required this.temperature, required this.equilibrage, required this.SoC});
}
