import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/athletes_full/view/athletes_page.dart';
import 'package:sdeng/medical/view/medicals_page.dart';
import 'package:sdeng/notes/view/notes_page.dart';
import 'package:sdeng/payments/view/payments_page.dart';
import 'package:sdeng/profile_modal/view/profile_modal.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/teams_page.dart';
import 'package:sdeng/user_profile/widgets/user_profile_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AppBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc,AppState>(
          listener: (context, state) {
            if (state.showProfileOverlay) {
              showAppModal(
                isDismissible: false,
                enableDrag: false,
                context: context,
                content: ProfileModal(userId: state.sdengUser!.id)
              );
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.light(),
          centerTitle: false,
          actions: const [UserProfileButton()],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  title: 'Welcome, ${bloc.state.sdengUser?.societyName ?? 'null'}',
                  content: 'Here\'s a simple dashboard where you can easly reach all services'
                ),
                AppCard(
                  title: 'Teams',
                  content: Text(bloc.state.homeValues?['teams'].toString() ?? 'null', style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),),
                  image: Assets.images.logo1.svg(height: 87),
                  action: SecondaryButton(
                    text: 'View all',
                    onPressed: () => Navigator.of(context).push(TeamsPage.route()),
                  ),
                ),
                AppCard(
                    title: 'Athletes',
                    content: Text(bloc.state.homeValues?['athletes'].toString() ?? 'null', style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),),
                    image: Assets.images.logo3.svg(height: 87),
                    action: SecondaryButton(
                      text: 'View all',
                      onPressed: () => Navigator.of(context).push(AthletesPage.route()),
                    )
                ),
                AppCard(
                    title: 'Medical Visits',
                    content: Text('${bloc.state.homeValues?['expired_medicals'].toString() ?? 'null'} Expired', style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),),
                    image: Assets.images.logo5.svg(height: 87),
                    action: SecondaryButton(
                      text: 'Fix',
                      onPressed: () => Navigator.of(context).push(MedicalsPage.route()),
                    )
                ),
                AppCard(
                  title: 'Payments',
                  content: Text(bloc.state.homeValues?['payments'].toString() ?? 'null', style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),),
                  image: Assets.images.logo2.svg(height: 87),
                  action: SecondaryButton(
                    text: 'View all',
                    onPressed: () => Navigator.of(context).push(PaymentsPage.route()),
                  )
                ),
                AppCard(
                    title: 'Notes',
                    content: Text(bloc.state.homeValues?['notes'].toString() ?? 'null', style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),),
                    image: Assets.images.logo4.svg(height: 87),
                    action: SecondaryButton(
                      text: 'View all',
                      onPressed: () => Navigator.of(context).push(NotesPage.route()),
                    )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}