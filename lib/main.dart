
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_guide/src/client/yahoo/response/get_chart.dart';
import 'package:test_guide/src/utils/calculations.dart';
import './src/client/yahoo/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Variação do Ativo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Variação do Ativo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChartData> chartList = [];

  @override
  void initState() {
    super.initState();
    Future<ChartResponse> charts = getChart();

    charts.then((value) => {
      for (var i = 0; i < value.chart.result[0].timestamp.length; i++) {
        setState(() {
          chartList.add(ChartData(
            DateTime.fromMillisecondsSinceEpoch(value.chart.result[0].timestamp[i] * 1000).toString().split(" ")[0],  
            value.chart.result[0].indicators.quote[0].open[i].toStringAsFixed(2), 
            (i + 1).toString(), 
            calculatePercentage(value.chart.result[0].indicators.quote[0].open[i], i != 0 ? value.chart.result[0].indicators.quote[0].open[i - 1] : 0),
            calculatePercentage(value.chart.result[0].indicators.quote[0].open[i], i != 0 ? value.chart.result[0].indicators.quote[0].open[0] : 0),
          ));
        })
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(
               child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FittedBox(
                        child: DataTable(
                          dataTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
                          columns: const [
                            DataColumn(
                              label: Center(child: Text('Dia')),
                            ),
                            DataColumn(
                              label: Center(child:Text('Data')),
                            ),
                            DataColumn(
                              label: Center(child:Text('Valor')),
                            ),
                            DataColumn(
                              label: Center(child:Text('Variação relativa a D-1')),
                            ),
                            DataColumn(
                              label: Center(child:Text('Variação relativa a 1° data')),
                            ),
                          ], 
                          rows: 
                            chartList.map((e) => 
                              DataRow(
                                cells: [
                                  DataCell(
                                    Center(child:Text(e.day)),
                                  ),
                                  DataCell(
                                    Center(child:Text(e.date)),
                                  ),
                                  DataCell(
                                    Center(child:Text("R\$${e.value}")),
                                  ),
                                  DataCell(
                                    Center(child:Text(e.day != "1" ? "${e.resultD1}%" : "-")),
                                  ),
                                  DataCell(
                                    Center(child:Text(e.day != "1" ? "${e.resultFirstDate}%" : "-")),
                                  ),
                                ]
                              )
                            ).toList()
                        )),
                      Container(
                        child: SfCartesianChart(
                          title: ChartTitle(
                            text: "Gráfico de variação de valores"
                          ),
                          primaryXAxis: DateTimeCategoryAxis(
                            intervalType: DateTimeIntervalType.days,
                            interval: 1,
                          ),
                          series: <ChartSeries>[
                              // Renders line chart
                            ColumnSeries<ChartData, DateTime>(
                                dataSource: chartList,
                                xValueMapper: (ChartData sales, _) => DateTime.parse(sales.date),
                                yValueMapper: (ChartData sales, _) => double.parse(sales.value) 
                            )
                          ]
                        )
                      )
                    ],
                  ) 
            ))
        );
  }
}

class ChartData {
  ChartData(this.date, this.value, this.day, this.resultD1, this.resultFirstDate);
  final String day;
  final String date;
  final String value;
  final String resultD1;
  final String resultFirstDate;
}