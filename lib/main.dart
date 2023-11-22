import 'dart:ui';

import 'package:flutter/material.dart';
import 'algorithm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 154, 183)),
          useMaterial3: true,
        ),
        home: const BottomNavigationBarExample());
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  static const List<Icon> _shapeopions = <Icon>[
    Icon(Icons.square),
    Icon(Icons.star),
    Icon(Icons.code)
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK-TRANS'),
      ),
      body: Center(
        child: DrawPoints(),
      ),
      floatingActionButton: selectedIndex == 4
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  drawwhat = (drawwhat + 1) % _shapeopions.length;
                });
              },
              child: _shapeopions.elementAt(drawwhat),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.straight),
            label: '平移',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cached),
            label: '旋转',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fullscreen),
            label: '缩放',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_important),
            label: '错切',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '创建',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: colorScheme.onSecondaryContainer,
        unselectedItemColor: colorScheme.onSecondaryContainer,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DrawPoints extends StatefulWidget {
  @override
  _DrawPointsState createState() => _DrawPointsState();
}

class _DrawPointsState extends State<DrawPoints> {
  List<Offset> points = [Offset(0, 0), Offset(0, 0)];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (details) {
            setState(() {
              points[0] = details.localPosition;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              points[1] = details.localPosition;
              double dx = points[1].dx - points[0].dx;
              double dy = points[1].dy - points[0].dy;
              switch (selectedIndex) {
                case 0:
                  {
                    int i = 0;
                    for (var point in metashape) {
                      currentshape[i] = move(point, dx, dy);
                      i++;
                    }
                    currentmidpoint =
                        Offset(metamidpoint.dx + dx, metamidpoint.dy + dy);
                    break;
                  }
                case 1:
                  {
                    int i = 0;
                    for (var point in metashape) {
                      currentshape[i] = rotate(point, dx, dy);
                      i++;
                    }

                    break;
                  }
                case 2:
                  {
                    int i = 0;
                    for (var point in metashape) {
                      currentshape[i] = scale(point, dx, dy);
                      i++;
                    }
                    break;
                  }
                case 3:
                  {
                    int i = 0;
                    for (var point in metashape) {
                      currentshape[i] = skew(point, dx, dy);
                      i++;
                    }
                    break;
                  }
                case 4:
                  {
                    metashape = generate(points[0], points[1]);
                    currentshape = List.from(metashape);

                    break;
                  }
              }
            });
          },
          onPanEnd: ((details) {
            setState(() {
              metashape = List.from(currentshape);
              metamidpoint = Offset(currentmidpoint.dx, currentmidpoint.dy);
            });
          }),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: PointsPainter(points),
          ),
        );
      },
    );
  }
}

class PointsPainter extends CustomPainter {
  final List<Offset> points;
  PointsPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (currentshape.isNotEmpty) {
      path.moveTo(currentshape.first.dx, currentshape.first.dy);
      for (final point in currentshape.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(PointsPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
