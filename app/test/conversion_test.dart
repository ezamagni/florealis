import 'package:florealis/models/cfce_point.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:florealis/models/sexagesimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Sexagesimal conversion', () {
    expect(Sexagesimal.from(53.621).toDMSList(), [53, 37, 15]);
    expect(Sexagesimal.from(42.121615).toDMSList(), [42, 7, 17]);
    expect(Sexagesimal.from(12.316567).toDMSList(), [12, 18, 59]);
  });

  test('CFCE conversion', () {
    expect(CfcePoint.from(CfcePoint.origin), CfcePoint(0, 0, [1, 1]));

    print(CfcePoint.from(GpsPoint(44.01698, 12.41630)).toString());

    // precision 1 tests
    expect(CfcePoint.from(GpsPoint(44.16388, 12.22500), precision: 1), CfcePoint(118, 39, [1]));
    expect(CfcePoint.from(GpsPoint(44.18056, 12.30833), precision: 1), CfcePoint(118, 39, [2]));
    expect(CfcePoint.from(GpsPoint(44.11667, 12.18333), precision: 1), CfcePoint(118, 39, [3]));
    expect(CfcePoint.from(GpsPoint(44.14167, 12.25833), precision: 1), CfcePoint(118, 39, [4]));

    // precision 2 tests
    expect(CfcePoint.from(GpsPoint(44.14167, 12.25833), precision: 2), CfcePoint(118, 39, [4, 1]));
    expect(CfcePoint.from(GpsPoint(44.18056, 12.30833), precision: 2), CfcePoint(118, 39, [2, 2]));
    expect(CfcePoint.from(GpsPoint(44.11667, 12.18333), precision: 2), CfcePoint(118, 39, [3, 3]));
    expect(CfcePoint.from(GpsPoint(44.16388, 12.22500), precision: 2), CfcePoint(118, 39, [1, 4]));
  });
}

extension _DMSList on Sexagesimal {
  List<int> toDMSList() => [dec, min, sec];
}