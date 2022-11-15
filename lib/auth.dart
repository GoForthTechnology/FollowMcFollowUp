

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fmfu/routes.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    bool loggedIn = FirebaseAuth.instance.currentUser != null;
    if (loggedIn) return resolver.next(true);

    router.push(const LoginScreenRoute());
  }
}
