import 'dart:async';

import 'package:flutter/material.dart';

import 'tokens_generated.dart';

bool prefersReducedMotion(BuildContext context) {
  final media = MediaQuery.maybeOf(context);
  return media?.disableAnimations == true ||
      media?.accessibleNavigation == true;
}

Duration motionDuration(BuildContext context, Duration duration) =>
    prefersReducedMotion(context) ? Duration.zero : duration;

class IndustrialPageRoute<T> extends MaterialPageRoute<T> {
  IndustrialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => DsMotion.slow;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (prefersReducedMotion(context)) return child;
    final curved = CurvedAnimation(parent: animation, curve: DsMotion.enter);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal> {
  bool _visible = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (prefersReducedMotion(context)) {
      _visible = true;
    } else {
      _timer = Timer(DsMotion.stagger * widget.index, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = motionDuration(context, DsMotion.slow);
    return AnimatedSlide(
      duration: duration,
      curve: DsMotion.enter,
      offset: _visible ? Offset.zero : const Offset(0, 0.08),
      child: AnimatedOpacity(
        duration: duration,
        curve: DsMotion.enter,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
