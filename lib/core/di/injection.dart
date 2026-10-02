import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishtrack/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:fishtrack/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:fishtrack/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fishtrack/features/authentication/domain/usecases/login_usecase.dart';
import 'package:fishtrack/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );

  sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(sl()),
  );

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      loginUseCase: sl(),
    ),
  );
}