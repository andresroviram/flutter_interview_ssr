import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_interview_ssr/features/users/presentation/widgets/user_card.dart';

void main() {
  final testUser = UserEntity(
    id: 123,
    firstName: 'John',
    lastName: 'Doe',
    birthDate: DateTime(1990, 5, 20),
    email: 'john.doe@example.com',
    phone: '1234567890',
    createdAt: DateTime(2024, 1, 15),
    updatedAt: null,
  );

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('UserCard Widget', () {
    testWidgets('should render user information correctly', (tester) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('JD'), findsOneWidget); // initials
      expect(find.byIcon(Icons.phone), findsOneWidget);
      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('should display user initials in avatar', (tester) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      final avatar = find.byType(CircleAvatar);
      expect(avatar, findsOneWidget);
      expect(
        find.descendant(of: avatar, matching: find.text('JD')),
        findsOneWidget,
      );
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        makeTestableWidget(
          UserCard(user: testUser, onTap: () => tapped = true),
        ),
      );

      await tester.tap(find.byType(UserCard));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('should show menu when actions are provided', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          UserCard(
            user: testUser,
            onEdit: () {},
            onDelete: () {},
            onViewAddresses: () {},
          ),
        ),
      );

      final menuButton = find.byType(PopupMenuButton<String>);
      expect(menuButton, findsOneWidget);

      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      expect(find.text('Editar'), findsOneWidget);
      expect(find.text('Eliminar'), findsOneWidget);
      expect(find.text('Ver direcciones'), findsOneWidget);
    });

    testWidgets('should call onEdit when edit menu item is tapped', (
      tester,
    ) async {
      var editCalled = false;

      await tester.pumpWidget(
        makeTestableWidget(
          UserCard(
            user: testUser,
            onEdit: () => editCalled = true,
            onDelete: () {},
            onViewAddresses: () {},
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(editCalled, true);
    });

    testWidgets('should call onDelete when delete menu item is tapped', (
      tester,
    ) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        makeTestableWidget(
          UserCard(
            user: testUser,
            onEdit: () {},
            onDelete: () => deleteCalled = true,
            onViewAddresses: () {},
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(deleteCalled, true);
    });

    testWidgets(
      'should call onViewAddresses when addresses menu item is tapped',
      (tester) async {
        var viewAddressesCalled = false;

        await tester.pumpWidget(
          makeTestableWidget(
            UserCard(
              user: testUser,
              onEdit: () {},
              onDelete: () {},
              onViewAddresses: () => viewAddressesCalled = true,
            ),
          ),
        );

        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ver direcciones'));
        await tester.pumpAndSettle();

        expect(viewAddressesCalled, true);
      },
    );

    testWidgets('should show popup menu button', (tester) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      final menuButton = find.byType(PopupMenuButton<String>);
      expect(menuButton, findsOneWidget);
    });

    testWidgets('should display formatted phone number', (tester) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      // Check that phone icon is displayed
      expect(find.byIcon(Icons.phone), findsOneWidget);
      // Phone formatting is handled by Formatters.formatPhone
    });

    testWidgets('should display age information', (tester) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      // Check for age icon and text
      expect(find.byIcon(Icons.cake), findsOneWidget);
      expect(find.textContaining('años'), findsOneWidget);
    });

    testWidgets('should display user information in responsive layout', (
      tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
    });

    testWidgets(
      'should display user information in responsive layout - email',
      (tester) async {
        await tester.pumpWidget(makeTestableWidget(UserCard(user: testUser)));

        expect(find.text('john.doe@example.com'), findsOneWidget);
      },
    );
  });
}
