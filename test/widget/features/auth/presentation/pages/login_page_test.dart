import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:base_match/features/auth/domain/entities/app_user.dart';
import 'package:base_match/features/auth/domain/repositories/auth_repository.dart';
import 'package:base_match/features/auth/presentation/pages/login_page.dart';
import 'package:base_match/features/auth/presentation/view_models/auth_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    when(() => mockAuthRepo.authStateChanges())
        .thenAnswer((_) => Stream.value(null));
    when(() => mockAuthRepo.currentUser).thenReturn(null);
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('メールアドレスとパスワードのフィールドが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('メールアドレス'), findsOneWidget);
      expect(find.text('パスワード'), findsOneWidget);
    });

    testWidgets('ログインボタンが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('ログイン'), findsOneWidget);
    });

    testWidgets('サインアップリンクが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('アカウントを作成する'), findsOneWidget);
    });

    testWidgets('アプリ名が表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('base_match'), findsOneWidget);
    });

    testWidgets('空のメールでバリデーションエラーが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      // パスワードだけ入力
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), 'password123');

      // ログインボタンをタップ
      await tester.tap(find.text('ログイン'));
      await tester.pumpAndSettle();

      expect(find.text('メールアドレスを入力してください'), findsOneWidget);
    });

    testWidgets('短いパスワードでバリデーションエラーが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      // メールアドレスを入力
      await tester.enterText(
          find.widgetWithText(TextFormField, 'メールアドレス'), 'test@example.com');
      // 短いパスワードを入力
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), '12345');

      // ログインボタンをタップ
      await tester.tap(find.text('ログイン'));
      await tester.pumpAndSettle();

      expect(find.text('パスワードは6文字以上で入力してください'), findsOneWidget);
    });

    testWidgets('有効な入力で signIn が呼ばれる', (tester) async {
      when(() => mockAuthRepo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => AppUser(
            id: 'user-1',
            displayName: 'Test',
            createdAt: DateTime.now(),
          ));

      await tester.pumpWidget(buildSubject());

      await tester.enterText(
          find.widgetWithText(TextFormField, 'メールアドレス'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), 'password123');

      await tester.tap(find.text('ログイン'));
      await tester.pump();

      verify(() => mockAuthRepo.signIn(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });
  });
}
