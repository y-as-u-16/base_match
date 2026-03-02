import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:base_match/features/auth/domain/entities/app_user.dart';
import 'package:base_match/features/auth/domain/repositories/auth_repository.dart';
import 'package:base_match/features/auth/presentation/pages/sign_up_page.dart';
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
        home: SignUpPage(),
      ),
    );
  }

  group('SignUpPage', () {
    testWidgets('表示名、メールアドレス、パスワードのフィールドが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('表示名'), findsOneWidget);
      expect(find.text('メールアドレス'), findsOneWidget);
      expect(find.text('パスワード'), findsOneWidget);
    });

    testWidgets('登録ボタンが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('登録'), findsOneWidget);
    });

    testWidgets('ログインリンクが存在する', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('既にアカウントをお持ちの方'), findsOneWidget);
    });

    testWidgets('アカウント作成のタイトルが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('アカウント作成'), findsOneWidget);
    });

    testWidgets('空の表示名でバリデーションエラーが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      // メールとパスワードだけ入力
      await tester.enterText(
          find.widgetWithText(TextFormField, 'メールアドレス'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), 'password123');

      await tester.tap(find.text('登録'));
      await tester.pumpAndSettle();

      expect(find.text('表示名を入力してください'), findsOneWidget);
    });

    testWidgets('空のメールでバリデーションエラーが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
          find.widgetWithText(TextFormField, '表示名'), 'テスト太郎');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), 'password123');

      await tester.tap(find.text('登録'));
      await tester.pumpAndSettle();

      expect(find.text('メールアドレスを入力してください'), findsOneWidget);
    });

    testWidgets('短いパスワードでバリデーションエラーが表示される', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
          find.widgetWithText(TextFormField, '表示名'), 'テスト太郎');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'メールアドレス'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), '123');

      await tester.tap(find.text('登録'));
      await tester.pumpAndSettle();

      expect(find.text('パスワードは6文字以上で入力してください'), findsOneWidget);
    });

    testWidgets('有効な入力で signUp が呼ばれる', (tester) async {
      when(() => mockAuthRepo.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => AppUser(
            id: 'user-1',
            displayName: 'テスト太郎',
            createdAt: DateTime.now(),
          ));

      await tester.pumpWidget(buildSubject());

      await tester.enterText(
          find.widgetWithText(TextFormField, '表示名'), 'テスト太郎');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'メールアドレス'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'パスワード'), 'password123');

      await tester.tap(find.text('登録'));
      await tester.pump();

      verify(() => mockAuthRepo.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'テスト太郎',
          )).called(1);
    });
  });
}
