import 'package:catalog_app/core/network/api_client.dart';
import 'package:catalog_app/core/router/app_router.dart';
import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:catalog_app/core/theme/theme_mode_cubit.dart';
import 'package:catalog_app/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:catalog_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:catalog_app/features/catalog/presentation/cubit/product_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogApp extends StatefulWidget {
  const CatalogApp({super.key});

  @override
  State<CatalogApp> createState() => _CatalogAppState();
}

class _CatalogAppState extends State<CatalogApp> {
  late final CatalogRepository _repository;
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _repository = CatalogRepositoryImpl(apiClient: ApiClient());
    _router = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CatalogRepository>.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProductListCubit(repository: _repository)..initialize(),
          ),
          BlocProvider(create: (_) => ThemeModeCubit()),
        ],
        child: BlocBuilder<ThemeModeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp.router(
              title: 'Catalog App',
              debugShowCheckedModeBanner: false,
              routerConfig: _router.router,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              themeAnimationDuration: const Duration(milliseconds: 280),
              themeAnimationCurve: Curves.easeOutCubic,
            );
          },
        ),
      ),
    );
  }
}
