import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

GoRouter buildRouter(Listenable refreshListenable) {
  return GoRouter(refreshListenable: refreshListenable, redirect: (ctx, tate) => null, routes: []);
}
