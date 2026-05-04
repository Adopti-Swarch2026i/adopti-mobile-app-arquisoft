import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Curvas de easing basadas en los principios de Emil Kowalski
/// https://animations.dev/
class AppEasings {
  /// Strong ease-out para interacciones UI (similar a cubic-bezier(0.23, 1, 0.32, 1))
  static const Curve easeOut = Cubic(0.23, 1, 0.32, 1);

  /// Strong ease-in-out para movimiento en pantalla
  static const Curve easeInOut = Cubic(0.77, 0, 0.175, 1);

  /// iOS-like drawer curve
  static const Curve drawer = Cubic(0.32, 0.72, 0, 1);

  /// Snappy ease-out para botones y feedback
  static const Curve snappy = Cubic(0.25, 0.46, 0.45, 0.94);
}

/// Duraciones basadas en las recomendaciones de Emil
class AppDurations {
  /// Button press feedback: 100-160ms
  static const Duration buttonPress = Duration(milliseconds: 120);

  /// Tooltips, small popovers: 125-200ms
  static const Duration tooltip = Duration(milliseconds: 150);

  /// Dropdowns, selects: 150-250ms
  static const Duration dropdown = Duration(milliseconds: 180);

  /// Modals, drawers: 200-500ms
  static const Duration modal = Duration(milliseconds: 250);

  /// Page transitions: 250-400ms
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// List item stagger: 30-80ms entre items
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Stagger total por item
  static Duration staggerItem(int index) =>
      Duration(milliseconds: 50 * index);

  /// Splash/landing animations: 400-600ms
  static const Duration splash = Duration(milliseconds: 500);

  /// Entrance animations: 300-400ms
  static const Duration entrance = Duration(milliseconds: 350);
}

/// Widget que aplica animación de entrada fade + scale a su child
class FadeScaleEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const FadeScaleEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = Duration.zero,
    this.curve = AppEasings.easeOut,
  });

  @override
  State<FadeScaleEntrance> createState() => _FadeScaleEntranceState();
}

class _FadeScaleEntranceState extends State<FadeScaleEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration == Duration.zero
          ? AppDurations.entrance
          : widget.duration,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Emil: nunca animar desde scale(0). Empezar desde 0.95 con opacity
    _scale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Widget que aplica stagger animation a una lista de children
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration staggerDelay;
  final Duration duration;
  final Curve curve;

  const StaggeredList({
    super.key,
    required this.children,
    this.delay = Duration.zero,
    this.staggerDelay = AppDurations.staggerDelay,
    this.duration = Duration.zero,
    this.curve = AppEasings.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++)
          FadeScaleEntrance(
            delay: delay + Duration(milliseconds: staggerDelay.inMilliseconds * i),
            duration: duration == Duration.zero ? AppDurations.entrance : duration,
            curve: curve,
            child: children[i],
          ),
      ],
    );
  }
}

/// Widget que proporciona feedback de press (scale 0.97) según Emil
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.duration = AppDurations.buttonPress,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.scale : 1.0,
        duration: widget.duration,
        curve: AppEasings.snappy,
        child: widget.child,
      ),
    );
  }
}

/// Transición de página personalizada según principios de Emil
class AppPageTransitions {
  static CustomTransitionPage<T> fadeScale<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: AppEasings.easeOut,
        );
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curve),
            child: child,
          ),
        );
      },
      transitionDuration: AppDurations.pageTransition,
      reverseTransitionDuration: AppDurations.pageTransition,
    );
  }
}
