import 'dart:math';
import 'package:vector_math/vector_math_64.dart';

void main() {
  Vector3 vector = Vector3(3, 2, 1);
  Matrix3 matrix = Matrix3(2.5, 1, 0, 0, 2.5, 0, 0, 0, 1);
  Vector3 result = matrix.transformed(vector);
  Vector3 result2 = matrix.transform(vector);
  print(result);
  print(result2);
  print(matrix);
}
