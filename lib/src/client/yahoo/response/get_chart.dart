

class ChartResponse {
  final Chart chart;

  const ChartResponse({
    required this.chart,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) {
    return ChartResponse(
      chart: Chart.fromJson(json['chart'])
    );
  }
}

class Chart {
  final List<Result> result;

  const Chart({
    required this.result,
  });

  factory Chart.fromJson(Map<String, dynamic> addjson){
    final List<dynamic> data = addjson["result"];
    return Chart(
      result: data.map((e) => Result.fromJson(e)).toList(),
    );
  }
}

class Result {
  final Object meta;
  final List<int> timestamp;
  final Indicators indicators;

  const Result({
    required this.meta,
    required this.timestamp,
    required this.indicators,
  });

  factory Result.fromJson(Map<String, dynamic> addjson){
    final List<dynamic> data = addjson["timestamp"];

    return Result(
      meta: addjson["meta"],
      timestamp: data.map((e) => e as int).toList(),
      indicators: Indicators.fromJson(addjson["indicators"])
    );
  }
}

class Indicators {
  final List<Quote> quote;

  const Indicators({
    required this.quote,
  });

  factory Indicators.fromJson(Map<String, dynamic> addjson){
  final List<dynamic> data = addjson["quote"];
    return Indicators(
      quote: data.map((e) => Quote.fromJson(e)).toList(),
    );
  }
}

class Quote {
  final List<double> open;

  const Quote({
    required this.open,
  });

  factory Quote.fromJson(Map<String, dynamic> addjson){
    final List<dynamic> data = addjson["open"];

    return Quote(
      open: data.map((e) => e as double).toList(),
    );
  }
}