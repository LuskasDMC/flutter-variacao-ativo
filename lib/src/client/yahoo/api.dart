import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import './response/get_chart.dart';

Future<ChartResponse> getChart() async {
    final response = await http.get(Uri.parse('https://query2.finance.yahoo.com/v8/finance/chart/PETR4.SA?range=30d&interval=1d'));

  if (response.statusCode == 200) {
    return ChartResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch charts');
  }
}
