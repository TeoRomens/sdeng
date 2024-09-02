import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/home/view/home_view.dart';
import 'package:sdeng/profile_modal/view/profile_modal.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends Mock implements AppBloc {}
class MockAppState extends Mock implements AppState {}

void main() {
  late MockAppBloc mockAppBloc;
  late MockAppState mockAppState;

  setUp(() {
    mockAppBloc = MockAppBloc();
    mockAppState = MockAppState();

    when(() => mockAppBloc.state).thenReturn(mockAppState);
    when(() => mockAppBloc.stream).thenAnswer((_) => Stream.value(mockAppState));
  });

  testWidgets('renders HomeView correctly', (tester) async {
    when(() => mockAppState.sdengUser).thenReturn(null);
    when(() => mockAppState.showProfileOverlay).thenReturn(false);
    when(() => mockAppState.homeValues).thenReturn({
      'teams': 0,
      'athletes': 0,
      'expired_medicals': 0,
      'payments': 0,
      'notes': 0,
    });

    await tester.pumpApp(
        const HomeView(),
        appBloc: mockAppBloc
    );

    expect(find.text('Welcome, null'), findsOneWidget);
    expect(find.text('Teams'), findsOneWidget);
    expect(find.text('Athletes'), findsOneWidget);
    expect(find.text('Medical Visits'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
  });

  testWidgets('shows profile modal when showProfileOverlay is true', (tester) async {
    when(() => mockAppState.showProfileOverlay).thenReturn(true);
    when(() => mockAppState.sdengUser).thenReturn(const SdengUser(id: 'user-123'));

    await tester.pumpApp(
        const HomeView(),
        appBloc: mockAppBloc
    );

    await tester.pumpAndSettle();

    expect(find.byType(ProfileModal), findsOneWidget);
  });

  testWidgets('does not show profile modal when showProfileOverlay is false', (tester) async {
    when(() => mockAppState.showProfileOverlay).thenReturn(false);
    when(() => mockAppState.sdengUser).thenReturn(const SdengUser(id: 'user-123'));

    await tester.pumpApp(
      const HomeView(),
      appBloc: mockAppBloc,
    );

    await tester.pumpAndSettle();

    expect(find.byType(ProfileModal), findsNothing);
  });

}
