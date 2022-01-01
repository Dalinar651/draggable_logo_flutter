import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: DraggableCard()),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({Key? key}) : super(key: key);

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  Widget logo = const FlutterLogo(
    size: 150,
  );
  late AnimationController controller;
  late Animation<Alignment> _animation;
  Alignment dragAlignment = const Alignment(0, 0);

  void runAnimation(Offset velocity) {
    _animation = controller.drive(AlignmentTween(
      begin: dragAlignment,
      end: Alignment.center,
    ));

    var x_vel = velocity.dx / MediaQuery.of(context).size.width;
    var y_vel = velocity.dx / MediaQuery.of(context).size.height;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation =
        SpringSimulation(spring, 0, 1, -Offset(x_vel, y_vel).distance);
    controller.reset();
    controller.animateWith(simulation);
    // controller.forward();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    controller.addListener(() {
      setState(() {
        dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        // controller.forward();
        controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          dragAlignment += Alignment(
            2 * details.delta.dx / MediaQuery.of(context).size.width,
            2 * details.delta.dy / MediaQuery.of(context).size.height,
          );
        });
      },
      onPanEnd: (details) {
        runAnimation(details.velocity.pixelsPerSecond);
      },
      child: Align(
        alignment: dragAlignment,
        child: Card(
          child: logo,
        ),
      ),
    );
  }
}
