// ignore_for_file: avoid_redundant_argument_values

import 'package:datingfoss/app/app.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/app/bloc_observer.dart';
import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/bloc/signup_bloc.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:datingfoss/main_navigation/bloc/main_navigation_bloc.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repositories/repositories.dart';

const bool alreadyAuthenticated = false;
const bool mockDiscoverController = false;
const bool mockChatController = false;
const bool mockNotificationsController = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  await startApp();
}

Future<void> startApp() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

Future<void> injectDependencies() async {
  // Service locator
  final sl = GetIt.instance;
  registerBlocs(sl);
  registerCubits(sl);
  await registerServices(sl);
}

Future<void> registerServices(GetIt sl) async {
  sl.useRepositories(
    mockAuthenticatedUser: alreadyAuthenticated,
    mockDiscoverController: mockDiscoverController,
    mockChatController: mockChatController,
    mockNotificationsController: mockNotificationsController,
    directoryToStoreFiles: (await getTemporaryDirectory()).path,
    getImageFileFromAssets: GetFileFromAsset().getImageFileFromAssets,
  );
}

void registerBlocs(GetIt sl) {
  sl
    ..registerFactory(() => AppBloc(authenticationRepository: sl())) // Noice
    ..registerFactory(MainNavigationBloc.new)
    ..registerFactory(
      () => MatchBloc(discoverRepository: sl(), userRepository: sl()),
    )
    ..registerFactory(
      () => ChatBloc(chatRepository: sl(), discoverRepository: sl()),
    )
    ..registerFactoryParam<DiscoverBloc, LocalUser, void>(
      (localUser, _) => DiscoverBloc(
        discoverRepository: sl(),
        localUser: localUser,
      ),
    )
    ..registerFactory<ProfileBloc>(
      () => ProfileBloc(userRepository: sl()),
    )
    ..registerFactoryParam<PartnerDetailBloc, String, List<String>?>(
      (username, keys) => PartnerDetailBloc(
        discoverRepository: sl(),
        username: username,
        keys: keys,
      ),
    )
    ..registerFactory(() => SignupBloc(authenticationRepository: sl()))
    ..registerFactory(() => LoginBloc(authenticationRepository: sl()))
    ..registerFactoryParam<DiscoverCardBloc, Partner, LocalUser>(
      (partner, authUser) => DiscoverCardBloc(
        discoverRepository: sl(),
        partner: partner,
        authenticatedUser: authUser,
      ),
    );
}

void registerCubits(GetIt sl) {
  sl
    ..registerFactory(AddLocationCubit.new)
    ..registerFactory(AddSexAndOrientationCubit.new)
    ..registerFactory(
      () => SignupCredentialCubit(authenticationRepository: sl()),
    )
    ..registerFactory(AddPublicPicturesCubit.new)
    ..registerFactory(AddPrivatePicturesCubit.new);
}
