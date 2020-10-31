import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/resources/repository.dart';

final bloc = LoginBloc();

class LoginBloc {
  final repository = Repository();
  final userFetcher = PublishSubject<UserModel>();

  StreamView<UserModel> get getUser => userFetcher.stream;

  fetchUserLogin() async {
    try {
      UserModel userModel = await repository.fetchUserLoginState();
      userFetcher.sink.add(userModel);

      print("~~~~~~~~~~~~~~~~~~");
    } catch (e) {
      print("Error == ${e.toString()}");
      if (!userFetcher.isClosed) {
        userFetcher.sink.addError("invalid login");
      }
    }
  }

  loginUserLogin(String username, String password) async {
    if (username != "" && password != "") {
      try {
        UserModel userModel =
            await repository.loginUserLogin(username, password);
        userFetcher.sink.add(userModel);
      } catch (e) {
        print("Error == ${e.toString()}");
        if (!userFetcher.isClosed) {
          userFetcher.sink.addError(e.message);
        }
      }
    }
  }

  dispose() async {
    await userFetcher.drain();
    userFetcher.close();
    print("dispose");
  }
}
