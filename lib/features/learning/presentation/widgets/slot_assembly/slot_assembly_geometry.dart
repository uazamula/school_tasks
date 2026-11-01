import 'package:flutter/material.dart';

/// Глобальний прямокутник віджета за його [key], або null,
/// якщо віджет ще не побудований чи відʼєднаний.
Rect? globalRectOfKey(GlobalKey key) {
  final renderObject = key.currentContext?.findRenderObject();

  if (renderObject is! RenderBox ||
      !renderObject.hasSize ||
      !renderObject.attached) {
    return null;
  }

  return renderObject.localToGlobal(Offset.zero) & renderObject.size;
}

/// Початковий і кінцевий прямокутники польоту в координатах кореневого
/// Overlay. Кінцевий центрується на [targetRect]. Null, якщо Overlay
/// недоступний.
({Rect start, Rect end})? computeFlightRects(
  BuildContext context, {
  required Rect sourceRect,
  required Rect targetRect,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final overlayObject = overlay.context.findRenderObject();

  if (overlayObject is! RenderBox ||
      !overlayObject.hasSize ||
      !overlayObject.attached) {
    return null;
  }

  final startTopLeft = overlayObject.globalToLocal(sourceRect.topLeft);
  final targetCenter = overlayObject.globalToLocal(targetRect.center);

  return (
    start: startTopLeft & sourceRect.size,
    end: Rect.fromCenter(
      center: targetCenter,
      width: sourceRect.width,
      height: sourceRect.height,
    ),
  );
}
