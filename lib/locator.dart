import 'package:bitky/data/bitky_api_client.dart';
import 'package:bitky/data/bitky_repository.dart';
import 'package:bitky/view_models/planet_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() =>PlanetRepository());
  locator.registerLazySingleton(() =>BitkyApiClient());
  locator.registerFactory(() =>BitkyViewModel());
}
