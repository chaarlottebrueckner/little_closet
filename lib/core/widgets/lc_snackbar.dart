import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LCSnackBar {
  LCSnackBar._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    _current?.remove();
    _current = null;

    late OverlayEntry entry;

    void onDismiss() {
      try {
        entry.remove();
      } catch (_) {}
      if (_current == entry) _current = null;
    }

    entry = OverlayEntry(
      builder: (_) => _LCSnackBarWidget(
        message: message,
        icon: icon,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: onDismiss,
      ),
    );

    _current = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }
}

class _LCSnackBarWidget extends StatefulWidget {
  const _LCSnackBarWidget({
    required this.message,
    required this.duration,
    required this.onDismiss,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final Duration duration;
  final VoidCallback onDismiss;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<_LCSnackBarWidget> createState() => _LCSnackBarWidgetState();
}

class _LCSnackBarWidgetState extends State<_LCSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  Timer? _timer;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 240),
    );
    _opacity = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    ));

    _ctrl.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissed) return;
    _dismissed = true;
    _timer?.cancel();
    if (!mounted) {
      widget.onDismiss();
      return;
    }
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    // 72 = _LCBottomNav content height (outer padding 16 + item 56), 16 = gap above it
    const navBarHeight = 72.0;
    return Stack(
      children: [
        Positioned(
          bottom: bottomPadding + navBarHeight + 16,
          left: 16,
          right: 16,
          child: FadeTransition(
            opacity: _opacity,
            child: SlideTransition(
              position: _slide,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: LCColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: LCColors.primary.withValues(alpha: 0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (widget.actionLabel != null && widget.onAction != null)
                        TextButton(
                          onPressed: () {
                            _dismiss();
                            widget.onAction?.call();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text(
                            widget.actionLabel!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
