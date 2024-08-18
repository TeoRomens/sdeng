import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/edit_parent/cubit/edit_parent_cubit.dart';
import 'package:sdeng/edit_parent/view/edit_parent_form.dart';

/// A modal dialog for editing a parent's details.
///
/// This widget provides a form to edit a parent's information and uses BLoC for state management.
class EditParentModal extends StatelessWidget {
  /// Creates an instance of [EditParentModal].
  ///
  /// The [parent] parameter is required and represents the parent entity to be edited.
  const EditParentModal({
    super.key,
    required Parent parent,
  }) : _parent = parent;

  /// The parent entity to be edited.
  final Parent _parent;

  /// Creates a [MaterialPageRoute] for the [EditParentModal].
  ///
  /// This static method is used for navigation purposes.
  static Route<void> route(Parent parent) => MaterialPageRoute<void>(
    builder: (_) => EditParentModal(
      parent: parent,
    ),
  );

  /// The route name for the [EditParentModal].
  static const String name = '/editParentModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditParentCubit(
        athletesRepository: context.read<AthletesRepository>(),
        parent: _parent,
      ),
      child: EditParentForm(parent: _parent),
    );
  }
}
