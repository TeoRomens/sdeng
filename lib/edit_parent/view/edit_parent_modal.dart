import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/edit_parent/cubit/edit_parent_cubit.dart';
import 'package:sdeng/edit_parent/view/edit_parent_form.dart';

class EditParentModal extends StatelessWidget {
  const EditParentModal({
    super.key,
    required Parent parent,
  }) : _parent = parent;

  final Parent _parent;

  static Route<void> route(Parent parent) =>
      MaterialPageRoute<void>(builder: (_) => EditParentModal(
        parent: parent,
      ));

  static const String name = '/editParentModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditParentCubit(
        athletesRepository: context.read<AthletesRepository>(),
        parent: _parent,
      ),
      child: EditParentForm(
        parent: _parent),
    );
  }
}
