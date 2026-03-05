# Product Catalog App (Flutter Assessment)

A Flutter product catalog app built against DummyJSON with a custom design system, deep-link routing, responsive phone/tablet behavior, and test coverage.

## 1. Setup & Run Instructions

Flutter version:
- Flutter stable 3.x (project SDK constraint: `^3.10.7`)

Install dependencies:
1. `flutter pub get`

Run app:
1. `flutter run`

Run analysis:
1. `dart analyze`

Run tests:
1. `flutter test`

Notes:
- Deep link supported for product details: `/products/:id`
- Example: `/products/1`

## 2. Architecture Overview

High-level structure:
- `lib/core`: app-wide concerns (`router`, `theme`, `network`, constants, logging)
- `lib/design_system`: reusable themed UI components
- `lib/features/catalog/domain`: entities and repository contract
- `lib/features/catalog/data`: DTO parsing, validation, repository implementation
- `lib/features/catalog/presentation`: Cubits, state classes, responsive screens

State management:
- `flutter_bloc` with Cubit
- `ProductListCubit`: initial/loading/success/empty/error, pagination, debounced search, category filtering
- `ProductDetailCubit`: loading/loaded/error for single product

Routing:
- `go_router` with centralized config
- `/` for list shell
- `/products/:id` for detail deep links

Responsive behavior:
- Phone: push navigation list -> detail
- Tablet (`>= 768dp`): master-detail layout, list on left and detail pane on right

Key decisions:
- Repository abstraction to isolate API from UI and improve testability
- Defensive DTO parsing with sensible defaults for missing fields
- Theme-driven design system to keep visual consistency across screens/components

## 3. Design System Rationale

Design direction:
- Minimal/custom visual style with restrained elevation, subtle outlines, and consistent spacing
- Token semantics preserved from provided foundation

Token implementation:
- Color roles via `ThemeData.colorScheme`
- Additional semantic tokens via `AppSemanticColors` extension:
  - `textDisabled`
  - `divider`
  - `success`, `warning`, `danger`
- Shared primitives:
  - `AppSpacing` (`xs`, `sm`, `md`, `lg`)
  - `AppRadius` (`xs`, `sm`, `md`, `pill`)

Component set:
- `DsSearchBar`
- `DsCategoryChip` (32dp visual height with 48dp tap target)
- `DsProductCard`
- `DsPriceDisplay`
- `DsRatingBadge`
- `DsStockIndicator`
- `DsEmptyState`
- `DsErrorState`
- `DsLoadingSkeleton`

Theming:
- Light and dark themes
- In-app theme toggle in app bar

## 4. Limitations

Current constraints/tradeoffs:
- Combined search + category behavior uses server search endpoint and applies category refinement client-side.
- Loading placeholders use pulse skeletons rather than full shimmer gradients.
- Offline cache uses Hive with a simple TTL strategy and can be expanded with richer invalidation rules.
- Animation polish is present but intentionally restrained.

If more time were available:
1. Add local cache and cache freshness indicators.
2. Add `/showcase` component gallery.
3. Replace the default pull-to-refresh interaction with a more custom, branded, and highly animated refresh experience.
4. Add broader widget/integration tests for routing and tablet master-detail flows.

## 5. AI Tools Usage

AI tools were used for:
- project scaffolding acceleration,
- architecture and component decomposition,
- initial drafting of repetitive boilerplate and tests.

Manual review/refinement was applied to:
- enforce design-token semantics and accessibility constraints,
- fix routing/state lifecycle edge cases across phone/tablet,
- harden validation/error handling,
- align tests and documentation with assessment requirements.
