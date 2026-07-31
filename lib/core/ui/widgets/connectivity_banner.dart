import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/theme/app_colors.dart';
import '../../network/connectivity_viewmodel.dart';

enum BannerStatus { hidden, offline, reconnected }

/// Widget envolvente que muestra un banner de conectividad estilo Facebook App
/// en la parte superior de la pantalla.
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  BannerStatus _status = BannerStatus.hidden;
  bool? _previousIsOnline;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final connectivity = context.watch<ConnectivityViewModel>();

    if (!connectivity.hasCheckedOnce) return;

    final isOnline = connectivity.isOnline;

    // Inicialización del estado sin desbordamientos ni mensajes bruscos
    if (_previousIsOnline == null) {
      _previousIsOnline = isOnline;
      if (!isOnline) {
        _showBanner(BannerStatus.offline);
      }
      return;
    }

    // Sin cambio de estado de conexión
    if (_previousIsOnline == isOnline) return;

    _previousIsOnline = isOnline;
    _autoHideTimer?.cancel();

    if (!isOnline) {
      _showBanner(BannerStatus.offline);
    } else {
      _showBanner(BannerStatus.reconnected);
      _autoHideTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          _hideBanner();
        }
      });
    }
  }

  void _showBanner(BannerStatus status) {
    setState(() {
      _status = status;
    });
    _controller.forward();
  }

  void _hideBanner() {
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() {
          _status = BannerStatus.hidden;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Column(
      children: [
        if (_status != BannerStatus.hidden)
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: Material(
              elevation: 2,
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: topPadding + 8,
                  bottom: 8,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _status == BannerStatus.offline
                        ? [AppColors.error, AppColors.errorDark]
                        : [AppColors.success, AppColors.successDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _status == BannerStatus.offline
                          ? Icons.wifi_off_rounded
                          : Icons.wifi_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _status == BannerStatus.offline
                          ? 'Sin conexión a internet'
                          : 'Conexión restablecida',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
