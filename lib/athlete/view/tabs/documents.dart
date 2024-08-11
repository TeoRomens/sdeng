import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/widgets/document_tile.dart';

class DocumentInfo extends StatelessWidget {
  const DocumentInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    return bloc.state.status == AthleteStatus.loading
        ? const LoadingBox()
        : Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md, horizontal: AppSpacing.lg),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Documents',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                bloc.state.documents.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.separated(
                            reverse: true,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bloc.state.documents.length,
                            itemBuilder: (context, index) {
                              return DocumentTile(
                                document: bloc.state.documents[index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                indent: 48,
                                height: 0,
                              );
                            },
                          ),
                          AppTextButton(
                              text: 'Upload document',
                              onPressed: () =>
                                  context.read<AthleteCubit>().uploadFile())
                        ],
                      )
                    : EmptyState(
                        actionText: 'Upload',
                        onPressed: () =>
                            context.read<AthleteCubit>().uploadFile()),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Generate',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextButton(
                          text: 'Create Richiesta Visita Medica',
                          onPressed: () {
                            context
                                .read<AthleteCubit>()
                                .generateRichiestaVisitaMedica();
                          }),
                      AppTextButton(
                          text: 'Create Richiesta Crediti', onPressed: () {}),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
