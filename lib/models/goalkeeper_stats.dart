class StatEvent {
  final String statName;
  final int minute;
  final bool isIncrement;

  StatEvent(this.statName, this.minute, this.isIncrement);
}

class GoalkeeperStats {
  //goles tapados y goles en contra
  int paradas;
  int disparosArco;

  //pases exitosos y no exitosos
  int pasesExitosos;
  int totalPases;

  //salidas y duelos ganados
  int salidas;
  int salidasExitosas;

  double valoracionpases;
  double valoracionParadas;
  double valoracionSalidasExitosas;
  double rating;

  List<StatEvent> events = [];

  GoalkeeperStats({
    //goles tapados y goles en contra
    this.paradas = 0,
    this.disparosArco = 0,

    //pasess exitosos y no exitosos
    this.pasesExitosos = 0,
    this.totalPases = 0,

    //salidas y duelos ganados
    this.salidas = 0,
    this.salidasExitosas = 0,

    this.valoracionParadas = 1,
    this.valoracionpases = 1,
    this.valoracionSalidasExitosas = 1,

    this.rating = 0.0,
  });

  double get paradasPorcentaje {
    if (disparosArco == 0) {
      valoracionParadas = -50;
      return -1;
    }
    double valorNormalizado = (paradas / disparosArco) * 100;
    valoracionParadas = 0.5;
    return valorNormalizado;
  }

  double get pasesPorcentaje {
    if (totalPases == 0) {
      valoracionpases = -15;
      return -1;
    }
    valoracionpases = 0.15;
    double valorNormalizado = (pasesExitosos / totalPases) * 100;
    return valorNormalizado;
  }

  // double get erroresGolProcentaje {
  //   if (errores == 0) return 0;
  //   double valorNormalizado = errores * 80;

  //   return valorNormalizado;
  // }

  double get porcentajeSalidasExitosas {
    if (salidas == 0) {
      valoracionSalidasExitosas = -35;
      return -1;
    }
    valoracionSalidasExitosas = 0.35;
    double valorNormalizado = (salidasExitosas / salidas) * 100;
    return valorNormalizado;
  }

  void addEvent(String statName, int minute, bool isIncrement) {
    events.add(StatEvent(statName, minute, isIncrement));
  }
}
