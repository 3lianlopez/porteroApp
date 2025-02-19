import 'package:flutter/material.dart';
import 'package:goalkeeper_stats/database/database_helper.dart';
import '../models/goalkeeper_stats.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'match_summary_screen.dart';
import 'match_history_screen.dart';

class PerformanceData {
  final String metric;
  final double percentage;

  PerformanceData(this.metric, this.percentage);
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GoalkeeperStats stats = GoalkeeperStats();
  bool isTimerRunning = false;
  int secondsElapsed = 0;
  bool isExtraTime = false;
  Timer? timer;
  bool showSummary = false;

  void _addStatEvent(String statName, bool isIncrement) {
    int currentMinute = secondsElapsed ~/ 60;
    stats.addEvent(statName, currentMinute, isIncrement);
  }

  Widget _buildStatCard(String title, String value, VoidCallback onIncrement) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(value, style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      switch (title) {
                        case 'Paradas':
                          if (stats.paradas > 0) {
                            stats.paradas--;
                            _addStatEvent(title, false);
                          }
                          break;
                        case 'Disparos al arco':
                          if (stats.disparosArco > 0) {
                            stats.disparosArco--;
                            _addStatEvent(title, false);
                          }
                          break;
                        case 'Pases':
                          if (stats.pasesExitosos > 0) {
                            stats.pasesExitosos--;
                            _addStatEvent(title, false);
                          }
                          break;
                        case 'pases totales':
                          if (stats.totalPases > 0) {
                            stats.totalPases--;
                            _addStatEvent(title, false);
                          }
                          break;
                        case 'Salidas':
                          if (stats.salidas > 0) {
                            stats.salidas--;
                            _addStatEvent(title, false);
                          }
                          break;
                        case 'Salidas exitosas':
                          if (stats.salidasExitosas > 0) {
                            stats.salidasExitosas--;
                            _addStatEvent(title, false);
                          }
                          break;
                      }
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    onIncrement();
                    _addStatEvent(title, true);
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryView() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: 'Métricas de Rendimiento'),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Porcentaje'),
          minimum: 0,
          maximum: 100,
        ),
        series: <CartesianSeries>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: [
              {'metric': 'Paradas', 'percentage': stats.paradasPorcentaje},
              {'metric': 'Pases', 'percentage': stats.pasesPorcentaje},
              {
                'metric': 'Salidas',
                'percentage': stats.porcentajeSalidasExitosas,
              },
            ],
            xValueMapper:
                (Map<String, dynamic> data, _) => data['metric'] as String,
            yValueMapper:
                (Map<String, dynamic> data, _) => data['percentage'] as double,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            name: 'Rendimiento',
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(isVisible: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portero APP'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MatchHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              // Stop the timer
              timer?.cancel();
              isTimerRunning = false;
              setState(() {});

              // Save match and navigate to summary
              await DatabaseHelper.instance.saveMatch(stats);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchSummaryScreen(stats: stats),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () => setState(() => showSummary = !showSummary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '${(secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(secondsElapsed % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        secondsElapsed <= 2400
                            ? 'Primer Tiempo'
                            : 'Segundo Tiempo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isTimerRunning = !isTimerRunning;
                                if (isTimerRunning) {
                                  timer = Timer.periodic(Duration(seconds: 1), (
                                    timer,
                                  ) {
                                    setState(() {
                                      secondsElapsed++;
                                    });
                                  });
                                } else {
                                  timer?.cancel();
                                }
                              });
                            },
                            icon: Icon(
                              isTimerRunning ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(isTimerRunning ? 'Pause' : 'Start'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                timer?.cancel();
                                isTimerRunning = false;
                                secondsElapsed = 2400; // 40 minutes
                              });
                            },
                            child: Text('Fin 1er'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isExtraTime = true;
                                secondsElapsed = 80 * 60;
                              });
                            },
                            child: Text('Extra Time'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (showSummary) _buildSummaryView(),
              SizedBox(height: 16),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: [
                  _buildStatCard(
                    'Paradas',
                    '${stats.paradas}',
                    () => setState(() => stats.paradas++),
                  ),
                  _buildStatCard(
                    'Disparos al arco',
                    '${stats.disparosArco}',
                    () => setState(() => stats.disparosArco++),
                  ),
                  _buildStatCard(
                    'Pases exitosos',
                    '${stats.pasesExitosos}',
                    () => setState(() => stats.pasesExitosos++),
                  ),
                  _buildStatCard(
                    'pases ',
                    '${stats.totalPases}',
                    () => setState(() => stats.totalPases++),
                  ),
                  _buildStatCard(
                    'Salidas exitosas',
                    '${stats.salidasExitosas}',
                    () => setState(() => stats.salidasExitosas++),
                  ),
                  _buildStatCard(
                    'Salidas',
                    '${stats.salidas}',
                    () => setState(() => stats.salidas++),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
