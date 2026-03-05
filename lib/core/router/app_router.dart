import 'package:catalog_app/features/catalog/presentation/screens/catalog_route_screen.dart';
import 'package:catalog_app/features/catalog/presentation/screens/showcase_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const CatalogRouteScreen(),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) {
              final rawId = state.pathParameters['id'];
              final id = int.tryParse(rawId ?? '');
              return CatalogRouteScreen(selectedProductId: id);
            },
          ),
          GoRoute(
            path: '/showcase',
            builder: (context, state) => const ShowcaseScreen(),
          ),
        ],
      );

  final GoRouter router;
}
