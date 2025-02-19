import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../database/database_helper.dart';

class MatchHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Partidos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getMatches(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final match = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha: ${DateTime.parse(match['date']).toString().split('.')[0]}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            ColumnSeries<Map<String, dynamic>, String>(
                              dataSource: [
                                {'metric': 'Paradas', 'value': match['paradasPorcentaje']},
                                {'metric': 'Pases', 'value': match['pasesPorcentaje']},
                                {'metric': 'Salidas', 'value': match['salidasPorcentaje']},
                              ],
                              xValueMapper: (data, _) => data['metric'] as String,
                              yValueMapper: (data, _) => data['value'] as double,
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Estadísticas:'),
                      Text('Paradas: ${match['paradas']}/${match['disparosArco']}'),
                      Text('Pases Exitosos: ${match['pasesExitosos']}/${match['totalPases']}'),
                      Text('Salidas Exitosas: ${match['salidasExitosas']}/${match['salidas']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}