import 'package:flutter/cupertino.dart';
import '../floating_overlay.dart';

/// @name：floating_manager
/// @package：
/// @author：345 QQ:1831712732
/// @time：2022/02/11 14:50
/// @des：[FloatingOverlay] 管理者

FloatingManager floatingManager = FloatingManager();

class FloatingManager {
  FloatingManager._single();

  static final FloatingManager _manager = FloatingManager._single();

  factory FloatingManager() => _manager;

  final Map<Object, FloatingOverlay> _floatingCache = {};

  static TransitionBuilder init({TransitionBuilder? builder}) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, child);
      }
      return Container(child: child);
    };
  }

  ///创建一个可全局管理的 [FloatingOverlay]
  FloatingOverlay createFloating(Object key, FloatingOverlay floating) {
    bool contains = _floatingCache.containsKey(key);
    if (!contains) {
      _floatingCache[key] = floating;
    }
    return _floatingCache[key]!;
  }

  ///根据 [key] 拿到对应的 [FloatingOverlay]
  FloatingOverlay getFloating(Object key) {
    return _floatingCache[key]!;
  }

  ///查询 [key] 对应的 [FloatingOverlay] 是否存在
  bool containsFloating(Object key) {
    return _floatingCache.containsKey(key);
  }


  ///释放 [key] 对应的 [FloatingOverlay]
  void disposeFloating(Object key) {
    // remove from cache first so containsFloating reflects removal immediately
    var floating = _floatingCache.remove(key);
    if (floating == null) return;
    try {
      floating.close();
    } catch (_) {
      // ignore
    }
    try {
      floating.dispose();
    } catch (_) {
      // ignore
    }
  }

  ///释放所有 [FloatingOverlay]
  void disposeAllFloating() {
    // copy and clear first to ensure cache is emptied even if dispose() throws
    final values = List<FloatingOverlay>.from(_floatingCache.values);
    _floatingCache.clear();
    for (final value in values) {
      try {
        value.close();
      } catch (_) {
        // ignore
      }
      try {
        value.dispose();
      } catch (_) {
        // ignore
      }
    }
  }

  ///悬浮窗数量
  int floatingSize() {
    return _floatingCache.length;
  }
}
