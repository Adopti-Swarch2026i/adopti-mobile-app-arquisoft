import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adopti_mobile/domain/entities/pet.dart';
import 'package:adopti_mobile/presentation/widgets/pets/status_badge.dart';

void main() {
  group('StatusBadge', () {
    testWidgets('displays correct label for lost status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: PetStatus.lost)),
        ),
      );
      expect(find.text('Perdido'), findsOneWidget);
    });

    testWidgets('displays correct label for found status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: PetStatus.found)),
        ),
      );
      expect(find.text('Encontrado'), findsOneWidget);
    });

    testWidgets('displays correct label for reunited status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: PetStatus.reunited)),
        ),
      );
      expect(find.text('Reunido'), findsOneWidget);
    });

    testWidgets('renders a container with border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: PetStatus.lost)),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
