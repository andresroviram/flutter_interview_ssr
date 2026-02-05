import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_interview_ssr/features/addresses/presentation/widgets/address_card.dart';

void main() {
  group('AddressCard Widget Tests', () {
    late AddressEntity testAddress;

    setUp(() {
      testAddress = AddressEntity(
        id: '1',
        userId: 'user1',
        street: 'Calle Principal',
        neighborhood: 'Centro',
        city: 'Madrid',
        state: 'Madrid',
        postalCode: '28001',
        label: AddressLabel.home,
        isPrimary: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    Widget createTestWidget({
      required AddressEntity address,
      VoidCallback? onTap,
      VoidCallback? onEdit,
      VoidCallback? onDelete,
      VoidCallback? onSetPrimary,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AddressCard(
            address: address,
            onTap: onTap,
            onEdit: onEdit,
            onDelete: onDelete,
            onSetPrimary: onSetPrimary,
          ),
        ),
      );
    }

    testWidgets('should render address label and icon for home', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(address: testAddress));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('Casa'), findsOneWidget);
    });

    testWidgets('should render address label and icon for work', (
      tester,
    ) async {
      final workAddress = testAddress.copyWith(label: AddressLabel.work);
      await tester.pumpWidget(createTestWidget(address: workAddress));

      expect(find.byIcon(Icons.work), findsOneWidget);
      expect(find.text('Trabajo'), findsOneWidget);
    });

    testWidgets('should render address label and icon for other', (
      tester,
    ) async {
      final otherAddress = testAddress.copyWith(label: AddressLabel.other);
      await tester.pumpWidget(createTestWidget(address: otherAddress));

      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.text('Otra'), findsOneWidget);
    });

    testWidgets('should display primary badge when address is primary', (
      tester,
    ) async {
      final primaryAddress = testAddress.copyWith(isPrimary: true);
      await tester.pumpWidget(createTestWidget(address: primaryAddress));

      expect(find.text('Principal'), findsOneWidget);
    });

    testWidgets(
      'should not display primary badge when address is not primary',
      (tester) async {
        await tester.pumpWidget(createTestWidget(address: testAddress));

        expect(find.text('Principal'), findsNothing);
      },
    );

    testWidgets('should display address street information', (tester) async {
      await tester.pumpWidget(createTestWidget(address: testAddress));

      expect(find.text('Calle Principal'), findsOneWidget);
    });

    testWidgets('should display address neighborhood information', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(address: testAddress));

      expect(find.text('Centro'), findsOneWidget);
    });

    testWidgets('should display address city and state', (tester) async {
      await tester.pumpWidget(createTestWidget(address: testAddress));

      expect(find.textContaining('Madrid'), findsWidgets);
    });

    testWidgets('should display postal code', (tester) async {
      await tester.pumpWidget(createTestWidget(address: testAddress));

      expect(find.textContaining('28001'), findsOneWidget);
      expect(find.text('CP: 28001'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        createTestWidget(address: testAddress, onTap: () => wasTapped = true),
      );

      await tester.tap(find.byType(AddressCard));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('should render properly without callbacks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddressCard(address: testAddress)),
        ),
      );

      expect(find.byType(AddressCard), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });
  });
}
