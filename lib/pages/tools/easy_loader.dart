library easy_loader;

import 'package:flutter/material.dart';

class EasyLoader extends StatefulWidget {
  const EasyLoader(
      {Key? key,
        this.backgroundColor,
        this.animation,
        this.iconSize = 120.0})
      : super(key: key);

  //// The background color of the loader. It is automatically transparent.
  final Color? backgroundColor;
  //// Changes the default animation
  final Animation<Offset>? animation;
  //// Changes the size of the default icon image
  final double iconSize;

  @override
  _EasyLoaderState createState() => _EasyLoaderState();
}

class _EasyLoaderState extends State<EasyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Color _backgroundColor = Colors.black;
  double? _iconSize;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = widget.animation ??
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -0.3),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ));
    _backgroundColor = widget.backgroundColor ?? Colors.black.withOpacity(0.7);
    _iconSize = widget.iconSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          foregroundDecoration: BoxDecoration(color: Colors.black.withOpacity(0.5),),
        ),
        Container(color: _backgroundColor.withAlpha(50),),
        Center(
            child: SlideTransition(
              position: _offsetAnimation,
              child: ImageIcon(
                const AssetImage('assets/loading.gif',),
                size: _iconSize,
                color: Colors.white70,
              ),
            )
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
