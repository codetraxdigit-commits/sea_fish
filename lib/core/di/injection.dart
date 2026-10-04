import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fishtrack/features/boat/data/datasources/boat_remote_datasource.dart';
import 'package:fishtrack/features/boat/data/repositories/boat_repository_impl.dart';
import 'package:fishtrack/features/boat/domain/repositories/boat_repository.dart';
import 'package:fishtrack/features/boat/domain/usecases/add_boat_usecase.dart';
import 'package:fishtrack/features/boat/domain/usecases/get_my_boat_usecase.dart';
import 'package:fishtrack/features/boat/domain/usecases/update_boat_usecase.dart';
import 'package:fishtrack/features/boat/presentation/bloc/boat_bloc.dart';
import 'package:fishtrack/features/dashboard/data%20/datasources/dashboard_remote_datasource.dart';
import 'package:fishtrack/features/dashboard/data%20/repositories/dashboard_repository_impl.dart';
import 'package:fishtrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fishtrack/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:fishtrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/login_usecase.dart';
import '../../features/authentication/domain/usecases/register_usecase.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );

  sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // =========================
  // AUTH
  // =========================
  sl.registerLazySingleton<FirebaseStorage>(
        () => FirebaseStorage.instance,
  );

  sl.registerLazySingleton<BoatRemoteDataSource>(
        () => BoatRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      storage: sl<FirebaseStorage>(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(
      sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(
      sl<AuthRepository>(),
    ),
  );

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
    ),
  );

  // =========================
  // DASHBOARD
  // =========================

  sl.registerLazySingleton<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetDashboardUseCase>(
        () => GetDashboardUseCase(
      sl<DashboardRepository>(),
    ),
  );

  sl.registerFactory<DashboardBloc>(
        () => DashboardBloc(
      getDashboardUseCase: sl<GetDashboardUseCase>(),
    ),
  );



  sl.registerLazySingleton<BoatRepository>(
        () => BoatRepositoryImpl(
      remoteDataSource: sl<BoatRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMyBoatUseCase>(
        () => GetMyBoatUseCase(
      sl<BoatRepository>(),
    ),
  );

  sl.registerLazySingleton<AddBoatUseCase>(
        () => AddBoatUseCase(
      sl<BoatRepository>(),
    ),
  );

  sl.registerLazySingleton<UpdateBoatUseCase>(
        () => UpdateBoatUseCase(
      sl<BoatRepository>(),
    ),
  );

  sl.registerFactory<BoatBloc>(
        () => BoatBloc(
      getMyBoatUseCase: sl<GetMyBoatUseCase>(),
      addBoatUseCase: sl<AddBoatUseCase>(),
      updateBoatUseCase: sl<UpdateBoatUseCase>(),
    ),
  );
}