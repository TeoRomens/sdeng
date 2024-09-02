import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/edit_athlete/view/edit_athlete_modal.dart';
import 'package:sdeng/edit_parent/view/edit_parent_modal.dart';

/// A widget that displays detailed information about an athlete, including
/// personal data and parent information.
///
/// The information is retrieved from the [AthleteCubit] and presented in a
/// list format with options to copy, email, or call relevant contact details.
class AthleteInfo extends StatelessWidget {
  const AthleteInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.lg),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Data',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SecondaryButton(
                onPressed: () async {
                  await showAppModal(
                          context: context,
                          content:
                              EditAthleteModal(athlete: bloc.state.athlete!))
                      .then((_) => bloc.reloadAthlete());
                },
                text: 'Edit',
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          bloc.state.status == AthleteStatus.loading
              ? const LoadingBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      icon: FeatherIcons.alignLeft,
                      text: bloc.state.athlete?.taxCode ?? '',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: bloc.state.athlete?.taxCode ?? ''));
                      },
                      buttonText: 'Copy',
                    ),
                    CustomContainer(
                      icon: FeatherIcons.calendar,
                      text: bloc.state.athlete?.birthdate?.dMY ?? ''),
                    CustomContainer(
                      icon: FeatherIcons.map,
                      text: bloc.state.athlete?.fullAddress ?? ''),
                    CustomContainer(
                      icon: FeatherIcons.mail,
                      text: bloc.state.athlete?.email ?? '',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: bloc.state.athlete?.email ?? ''));
                      },
                      buttonText: 'Copy',
                    ),
                    CustomContainer(
                      icon: FeatherIcons.phone,
                      text: bloc.state.athlete?.phone ?? '',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: bloc.state.athlete?.phone ?? ''));
                      },
                      buttonText: 'Copy',
                    ),
                  ],
                ),
          const Divider(
            height: 40,
            indent: 0,
            endIndent: 0,
          ),
          Row(
            children: [
              Text(
                'Parent',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              SecondaryButton(
                onPressed: () async {
                  await showAppModal(
                          context: context,
                          content: EditParentModal(parent: bloc.state.parent!))
                      .then((_) => bloc.reloadParent());
                },
                text: 'Edit',
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          bloc.state.status == AthleteStatus.loading
              ? const LoadingBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      icon: FeatherIcons.user,
                      text: bloc.state.parent?.fullName ?? '',
                    ),
                    CustomContainer(
                      icon: FeatherIcons.mail,
                      text: bloc.state.parent?.email ?? '',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: bloc.state.parent?.email ?? ''));
                      },
                      buttonText: 'Copy',
                    ),
                    CustomContainer(
                      icon: FeatherIcons.phone,
                      text: bloc.state.parent?.phone ?? '',
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: bloc.state.parent?.phone ?? ''));
                      },
                      buttonText: 'Copy',
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
