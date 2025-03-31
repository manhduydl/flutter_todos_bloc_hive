import 'package:flutter/material.dart';
import 'package:flutter_todos_bloc_hive/services/local_storage_todos_api.dart';

import 'app/app.dart';

void main() async {
  var localStorageTodosApi = LocalStorageTodosApi();
  await localStorageTodosApi.init();
  runApp(App(
    todosApi: localStorageTodosApi,
  ));
}
