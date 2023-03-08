String calculatePercentage(double v1, double v2) {
 return (((v1 - v2) / ((v1 + v2) / 2)) * 100).toStringAsFixed(2);
}