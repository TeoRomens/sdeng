import 'package:flutter_test/flutter_test.dart';
import 'package:sdeng/ui/add_athlete/bloc/add_athlete_bloc.dart';

void main() {

  group('AddAthleteState', () {

    test('copyWith should copy all fields with new values', () {
      final originalState = const AddAthleteState(
        name: 'John',
        surname: 'Doe',
        number: 1,
      );

      final updatedState = originalState.copyWith(
        name: 'Alice',
        surname: 'Smith',
        number: 2,
      );

      // Verify that the original state remains unchanged
      expect(originalState.name, 'John');
      expect(originalState.surname, 'Doe');
      expect(originalState.number, 1);
      // Verify that the updated state has the new values
      expect(updatedState.name, 'Alice');
      expect(updatedState.surname, 'Smith');
      expect(updatedState.number, 2);
    });

    test('should initialize with default values', () {
      final initialState = const AddAthleteState();

      expect(initialState.name, ''); // Verify the default value of name
      expect(initialState.surname, ''); // Verify the default value of surname
      expect(initialState.number, null); // Verify the default value of number

      expect(initialState.status, Status.idle); // Verify the default value of status
      expect(initialState.uploadStatus, UploadStatus.idle); // Verify the default value of uploadStatus
    });
  });
}
