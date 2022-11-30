import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class EditCardBackground extends StatelessWidget {
  final Widget child;

  const EditCardBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .55,
      width: 280,
      child: CustomPaint(
        painter: _CardPainter(),
        child: child,
      ),
    );
  }
}

class _CardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.yellow
      ..style = PaintingStyle.fill;
    // ..strokeWidth = 5;

    //* Tarjeta
    Path path = Path();
    path.moveTo(size.width * .12, size.height * .01);
    // BorderRadius TopLeft
    path.lineTo(size.width * .12, size.height * .01);
    path.quadraticBezierTo(
        size.width * .007, size.width * .007, 0, size.height * .07);
    // Border BottomLeft
    path.lineTo(0, size.height * .94);
    path.quadraticBezierTo(size.width * .007, size.height - (size.width * .007),
        size.width * .1, size.height);
    // Border BottomRight
    path.lineTo(size.width * .9, size.height);
    path.quadraticBezierTo(size.width * .997, size.height - (size.width * .007),
        size.width, size.height * .94);
    // Border TopRight
    path.lineTo(size.width, size.height * .22);
    path.quadraticBezierTo(size.width * .999, size.height * .16,
        size.width * .9, size.height * .13);

    ///* Esto es para la sombra de una pintura.
    canvas.save(); //* Guarda lo que el trazado que se ha hecho
    canvas.restore(); //* Restaura al trazado guardado

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
