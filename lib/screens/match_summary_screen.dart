import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/goalkeeper_stats.dart';

class MatchSummaryScreen extends StatelessWidget {
  final GoalkeeperStats stats;

  MatchSummaryScreen({required this.stats});

  @override
  Widget build(BuildContext context) {
    double overallEfficiency =
        (stats.paradasPorcentaje * 0.4 +
            stats.pasesPorcentaje * 0.3 +
            stats.porcentajeSalidasExitosas * 0.3);

    return Scaffold(
      appBar: AppBar(title: Text('Resumen del Partido')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Eficiencia General',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${overallEfficiency.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Métricas')),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Porcentaje'),
                  minimum: 0,
                  maximum: 100,
                ),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: [
                      {
                        'metric': 'Paradas',
                        'percentage': stats.paradasPorcentaje,
                      },
                      {'metric': 'Pases', 'percentage': stats.pasesPorcentaje},
                      {
                        'metric': 'Salidas',
                        'percentage': stats.porcentajeSalidasExitosas,
                      },
                    ],
                    xValueMapper: (data, _) => data['metric'] as String,
                    yValueMapper: (data, _) => data['percentage'] as double,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
