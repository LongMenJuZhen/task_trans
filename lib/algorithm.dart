import 'dart:ui';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart';

int drawwhat = 0;
int selectedIndex = 4;
List<Offset> metashape = [];
List<Offset> currentshape = [];
Offset metamidpoint = Offset(0, 0);
Offset currentmidpoint = Offset(0, 0);

Offset mid(Offset start, Offset end) {
  metamidpoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
  currentmidpoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
  return metamidpoint;
}

double generate_radius(Offset start, Offset end) {
  return sqrt(pow(start.dx - end.dx, 2) + pow(start.dy - end.dy, 2)) / 2;
}

List<Offset> shape_points(Offset midpoint, double radius) {
  List<Offset> points = [];
  switch (drawwhat) {
    case 0:
      {
        points.add(Offset(midpoint.dx - radius, midpoint.dy + radius));
        points.add(Offset(midpoint.dx + radius, midpoint.dy + radius));
        points.add(Offset(midpoint.dx + radius, midpoint.dy - radius));
        points.add(Offset(midpoint.dx - radius, midpoint.dy - radius));
        break;
      }

    case 1:
      {
        points.add(Offset(midpoint.dx, midpoint.dy + radius));
        double degrees = 36.0;
        double radians = degrees * pi / 180;
        double cosValue = cos(radians);
        double sinValue = sin(radians);
        points.add(Offset(
            midpoint.dx + radius * sinValue, midpoint.dy - radius * cosValue));
        double degrees2 = 72.0;
        double radians2 = degrees2 * pi / 180;
        double cosValue2 = cos(radians2);
        double sinValue2 = sin(radians2);
        points.add(Offset(midpoint.dx - radius * sinValue2,
            midpoint.dy + radius * cosValue2));
        points.add(Offset(midpoint.dx + radius * sinValue2,
            midpoint.dy + radius * cosValue2));
        points.add(Offset(
            midpoint.dx - radius * sinValue, midpoint.dy - radius * cosValue));
        break;
      }
    case 2:
      {
        points.add(Offset(midpoint.dx - radius, midpoint.dy));
        points.add(Offset(
            midpoint.dx - radius / 2, midpoint.dy + radius * sqrt(3) / 2));
        points.add(Offset(
            midpoint.dx + radius / 2, midpoint.dy + radius * sqrt(3) / 2));
        points.add(Offset(midpoint.dx + radius, midpoint.dy));
        points.add(Offset(
            midpoint.dx + radius / 2, midpoint.dy - radius * sqrt(3) / 2));
        points.add(Offset(
            midpoint.dx - radius / 2, midpoint.dy - radius * sqrt(3) / 2));
        break;
      }
  }
  return points;
}

List<Offset> generate(Offset start, Offset end) {
  Offset midpoint = mid(start, end);
  double radius = generate_radius(start, end);
  return shape_points(midpoint, radius);
}

Offset scale(Offset point, double dx, double dy) {
  Vector3 vector = Vector3(point.dx, point.dy, 1);

  Matrix3 matrixFromorigin =
      Matrix3(1, 0, 0, 0, 1, 0, -currentmidpoint.dx, -currentmidpoint.dy, 1);
  Matrix3 matrixScale = Matrix3(dx / 100, 0, 0, 0, dy / 100, 0, 0, 0, 1);
  Matrix3 matrixToOrigin =
      Matrix3(1, 0, 0, 0, 1, 0, currentmidpoint.dx, currentmidpoint.dy, 1);
  Vector3 result = matrixToOrigin
      .transform(matrixScale.transformed(matrixFromorigin.transformed(vector)));
  point = Offset(result.x, result.y);

  return point;
}

Offset move(Offset point, double dx, double dy) {
  Vector3 vector = Vector3(point.dx, point.dy, 1);

  Matrix3 matrixMove = Matrix3(1, 0, 0, 0, 1, 0, dx, dy, 1);
  Vector3 result = matrixMove.transform(vector);
  point = Offset(result.x, result.y);

  return point;
}

Offset rotate(Offset point, double dx, double dy) {
  double radians = atan2(dy, dx);
  Vector3 vector = Vector3(point.dx, point.dy, 1);
  Matrix3 matrixFromorigin =
      Matrix3(1, 0, 0, 0, 1, 0, -currentmidpoint.dx, -currentmidpoint.dy, 1);
  Matrix3 matrixRotate = Matrix3(
      cos(radians), sin(radians), 0, -sin(radians), cos(radians), 0, 0, 0, 1);
  Matrix3 matrixToOrigin =
      Matrix3(1, 0, 0, 0, 1, 0, currentmidpoint.dx, currentmidpoint.dy, 1);
  Vector3 result = matrixToOrigin.transform(
      matrixRotate.transformed(matrixFromorigin.transformed(vector)));
  point = Offset(result.x, result.y);

  return point;
}

Offset skew(Offset point, double dx, double dy) {
  Vector3 vector = Vector3(point.dx, point.dy, 1);
  Matrix3 matrixFromorigin =
      Matrix3(1, 0, 0, 0, 1, 0, -currentmidpoint.dx, -currentmidpoint.dy, 1);
  Matrix3 matrixSkew = Matrix3(1, dx / 100, 0, dy / 100, 1, 0, 0, 0, 1);
  Matrix3 matrixToOrigin =
      Matrix3(1, 0, 0, 0, 1, 0, currentmidpoint.dx, currentmidpoint.dy, 1);
  Vector3 result = matrixToOrigin
      .transform(matrixSkew.transformed(matrixFromorigin.transformed(vector)));
  point = Offset(result.x, result.y);
  return point;
}
