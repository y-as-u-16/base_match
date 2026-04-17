# base_match Project Overview

## Purpose
草野球対戦履歴アプリ - batter x pitcher, team x team matchup tracking with "rivalry cards" for sharing.

## Tech Stack
- Flutter (Dart SDK ^3.9.2), Material 3
- Supabase (auth, DB, storage)
- flutter_riverpod for state management
- go_router for routing
- share_plus for sharing
- MVVM + Clean Architecture

## Architecture
- lib/core/ - shared foundation (error, network, routing, theme, utils, constants)
- lib/features/{feature}/ - domain/ (entities, repositories), data/ (repositories impl), presentation/ (pages, view_models, widgets)
- Entities use plain Dart classes with fromJson/toJson/copyWith (no freezed generated code in use)
- Repositories are abstract interfaces in domain, concrete in data
- ViewModels use Riverpod providers (Provider, StateNotifierProvider, StreamProvider, FutureProvider)
- Supabase client via `ref.watch(supabaseClientProvider)`
- Auth user via `ref.watch(currentUserProvider)`
- Import supabase_flutter with `hide AuthException` to avoid name clash

## Commands
- `flutter pub get` - install deps
- `flutter run` - run app
- `flutter analyze` - static analysis
- `flutter test` - run tests
