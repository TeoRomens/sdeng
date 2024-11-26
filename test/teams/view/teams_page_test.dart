import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:teams_repository/teams_repository.dart';

import '../../helpers/helpers.dart';

class MockTeamsRepository extends Mock implements TeamsRepository {}

class MockTeamsCubit extends MockCubit<TeamsState> implements TeamsCubit {}

void main() {

  setUp(() {
  });

  testWidgets('renders TeamsView when in portrait mode', (WidgetTester tester) async {
    await tester.pumpApp(
      const TeamsPage(),
    );

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpAndSettle();

    expect(find.byType(TeamsView), findsOneWidget);
    expect(find.byType(TeamsViewDesktop), findsNothing);
  });

  testWidgets('renders TeamsViewDesktop when in landscape mode', (WidgetTester tester) async {
    await tester.pumpApp(
      const TeamsPage(),
    );

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpAndSettle();

    expect(find.byType(TeamsViewDesktop), findsOneWidget);
    expect(find.byType(TeamsView), findsNothing);
  });

  testWidgets('provides TeamsCubit to the widget tree', (WidgetTester tester) async {
    await tester.pumpApp(
      const TeamsPage(),
    );

    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    await tester.pumpAndSettle();

    final teamsCubit = BlocProvider.of<TeamsCubit>(tester.element(find.byType(TeamsView)));
    expect(teamsCubit, isA<TeamsCubit>());
  });

}
