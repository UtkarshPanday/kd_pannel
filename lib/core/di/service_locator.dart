import 'package:get_it/get_it.dart';
import 'package:kd_pannel/core/navigation/navigation_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton(() => NavigationService());
}
