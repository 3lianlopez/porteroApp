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

  int errores;
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

    this.errores = 0,

    this.rating = 0.0,
  });

  double get paradasPorcentaje {
    if (disparosArco == 0) return 0;
    double valorNormalizado = (paradas / disparosArco) * 100;

    return valorNormalizado;
  }

  double get pasesPorcentaje {
    if (totalPases == 0) return 0;
    double valorNormalizado = (pasesExitosos / totalPases) * 100;

    return valorNormalizado;
  }

  double get erroresGolProcentaje {
    if (errores == 0) return 0;
    double valorNormalizado = errores * 80;

    return valorNormalizado;
  }

  double get porcentajeSalidasExitosas {
    if (salidas == 0) return 0;
    double valorNormalizado = (salidasExitosas / salidas) * 100;
    return valorNormalizado;
  }

  void addEvent(String statName, int minute, bool isIncrement) {
    events.add(StatEvent(statName, minute, isIncrement));
  }
}
