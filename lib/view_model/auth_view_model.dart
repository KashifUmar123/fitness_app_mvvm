import 'dart:developer';

import 'package:fitness_app_mvvm/data/response/firestore_response.dart';
import 'package:fitness_app_mvvm/repository/auth/auth_repo.dart';
import 'package:fitness_app_mvvm/repository/auth/auth_repo_imp.dart';
import 'package:fitness_app_mvvm/utils/components/custom_snackbar.dart';
import 'package:fitness_app_mvvm/utils/locator/locator.dart';
import 'package:fitness_app_mvvm/utils/nav_service.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../utils/routes/routes_names.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepo _authReopImp = AuthRepoImp();
  final NavService navService = locator<NavService>();

  dynamic _isSubscribed;

  FirestoreResponse<UserModel> _user = FirestoreResponse.loading();

  FirestoreResponse<UserModel> get user => _user;

  dynamic get isSubscribed => _isSubscribed;

  initUser() async {
    try {
      var response = await _authReopImp.getUser();
      setUser(FirestoreResponse.completed(response));
      if (_user.data == null) {
        locator<NavService>().nav.pushNamedAndRemoveUntil(
              RoutesNames.login,
              (Route<dynamic> route) => false,
            );
      } else {
        locator<NavService>().nav.pushNamedAndRemoveUntil(
              RoutesNames.home,
              (Route<dynamic> route) => false,
            );
      }
    } catch (e) {
      setUser(FirestoreResponse.error(e.toString()));
    }
  }

  updateUser() async {
    try {
      await _authReopImp.updateUser(userModel: _user.data!);
      setUserSubscription();
      notifyListeners();
    } catch (e) {
      AppSnacbars.errorSnackbar(e.toString());
    }
  }

  setUserSubscription() {
    if (_user.data == null) {
      return;
    }
    if (_user.data!.subscriptionData != null) {
      if (DateTime.now().millisecondsSinceEpoch >
          _user.data!.subscriptionData!.millisecondsSinceEpoch) {
        _isSubscribed = false;
      } else {
        _isSubscribed = true;
      }
    }
  }

  setUser(FirestoreResponse<UserModel> response) {
    _user = response;
    setUserSubscription();
    log(_isSubscribed.toString());
    notifyListeners();
  }

  loginUser({required String email, required String password}) async {
    try {
      var response =
          await _authReopImp.loginUser(email: email, password: password);
      setUser(FirestoreResponse.completed(response));
      locator<NavService>().nav.pushNamedAndRemoveUntil(
            RoutesNames.home,
            (Route<dynamic> route) => false,
          );
    } catch (e) {
      navService.nav.pop();
      AppSnacbars.errorSnackbar(e.toString());
      setUser(FirestoreResponse.error(e.toString()));
    }
  }

  registerUser({required UserModel userModel, required String password}) async {
    try {
      var response = await _authReopImp.registerUers(
        userModel: userModel,
        password: password,
      );
      setUser(FirestoreResponse.completed(response));
      locator<NavService>().nav.pushNamedAndRemoveUntil(
            RoutesNames.home,
            (Route<dynamic> route) => false,
          );
    } catch (e) {
      navService.nav.pop();
      AppSnacbars.errorSnackbar(e.toString());
      setUser(FirestoreResponse.error(e.toString()));
    }
  }

  forgotUser({required String email}) async {
    try {
      await _authReopImp.forgotUser(email: email);
      navService.nav
          .pushNamedAndRemoveUntil(RoutesNames.login, (route) => false);
      AppSnacbars.snackbar("Please check your email!");
    } catch (e) {
      navService.nav.pop();
      AppSnacbars.errorSnackbar(e.toString());
    }
  }

  logout() async {
    await _authReopImp.logout();
    navService.nav.pushNamedAndRemoveUntil(RoutesNames.login, (route) => false);
    // navigate to login screen
  }
}
