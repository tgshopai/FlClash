// 登录门控 —— 未登录显示 LoginPage,已登录显示 FlClash 主界面。
//
// 接入(改 lib/application.dart 一处):
//   把 MaterialApp 的  home: child!   改成   home: XboardGate(child: child!),
// 其余不动。首帧会先恢复本地会话,恢复期间显示一个极简 splash。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'xboard_auth.dart';
import 'login_page.dart';

class XboardGate extends ConsumerStatefulWidget {
  final Widget child;
  const XboardGate({super.key, required this.child});

  @override
  ConsumerState<XboardGate> createState() => _XboardGateState();
}

class _XboardGateState extends ConsumerState<XboardGate> {
  @override
  void initState() {
    super.initState();
    // 启动时恢复会话(只跑一次)。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final st = ref.read(xboardAuthProvider);
      if (!st.restored) {
        ref.read(xboardAuthProvider.notifier).restore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(xboardAuthProvider);

    if (!auth.restored) {
      // 会话恢复中:极简 splash,避免闪现登录页。
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!auth.loggedIn) {
      return const LoginPage();
    }
    return widget.child;
  }
}
