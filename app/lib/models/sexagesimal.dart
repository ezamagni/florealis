import 'package:equatable/equatable.dart';

class Sexagesimal extends Equatable {
  final int dec, min, sec;

  Sexagesimal(this.dec, this.min, this.sec);

  @override
  List<Object> get props => [dec, min, sec];

  factory Sexagesimal.from(double dec) {
    double fract;
    final grad = dec.floor();
    fract = dec - grad;
    final minDec = fract * 60;
    final min = minDec.floor();
    fract = minDec - min;
    final sec = (fract * 60).floor();
    return Sexagesimal(grad, min, sec);
  }
  
  @override
  String toString() => "$dec° $min' $sec\"";
}