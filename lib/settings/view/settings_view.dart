import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';
import 'package:sdeng/profile_modal/view/profile_modal.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.sdengUser;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xlg - AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xlg - AppSpacing.xs,
          AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.blueGrey,
                            fontWeight: AppFontWeight.semiBold,
                            fontSize: 17,
                          ),
                    ),
                    const Text(
                      'Update your profile details here',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF475467),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                    text: 'Edit',
                    onPressed: () {
                      showAppModal(
                          isDismissible: true,
                          enableDrag: false,
                          context: context,
                          content: ProfileModal(
                            userId: user!.id,
                            sdengUser: user,
                          ));
                    })
              ],
            ),
            const Divider(
              height: AppSpacing.xxlg,
              indent: 0,
              endIndent: 0,
            ),
            Text(
              'General',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.blueGrey,
                  fontWeight: AppFontWeight.semiBold,
                  fontSize: 17),
            ),
            const SizedBox(height: AppSpacing.sm),
            SettingTile(
              title: 'Payment Formula Settings',
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.of(context).push(PaymentFormulaPage.route());
              },
            ),
            const Divider(
              height: AppSpacing.xxlg,
              indent: 0,
              endIndent: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.blueGrey,
                            fontWeight: AppFontWeight.semiBold,
                            fontSize: 17,
                          ),
                    ),
                    const Text(
                      'View the terms of services of SDENG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF475467),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                  text: 'View',
                  onPressed: () {
                    showAppModal(
                      context: context,
                      content: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.xlg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Terms of Use',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const Divider(endIndent: 0, indent: 0, height: 25),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  'Your long terms of use content goes here. This is a sample text. '
                                  'You can add more content to test scrolling functionality. '
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                                  'Pellentesque imperdiet purus in nibh fermentum, in cursus turpis varius. '
                                  'Suspendisse potenti. Sed ut lacus sit amet nunc pretium pretium. '
                                  'Vestibulum ultrices, dui at tristique fermentum, est turpis volutpat sapien, '
                                  'eu lacinia urna nisi eu ante. Mauris viverra lorem a turpis pretium, '
                                  'et feugiat elit interdum. Fusce vitae augue a felis facilisis maximus. '
                                  'Curabitur lacinia venenatis purus ac varius.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  })
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.blueGrey,
                          fontWeight: AppFontWeight.semiBold,
                          fontSize: 17,
                        ),
                    ),
                    const Text(
                      'Know more about us',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF475467),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                  text: 'View',
                  onPressed: () {
                    showAppModal(
                      context: context,
                      content: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.xlg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'About us',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const Divider(endIndent: 0, indent: 0, height: 25),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  'Welcome to Sdeng!\n\n'
                                  'Founded in 2024, we are dedicated to providing top-notch services in the Sports sector. '
                                  'Our mission is to deliver high-quality solutions tailored to meet the unique needs of our clients. '
                                  'With a team of experienced professionals and a commitment to innovation, we strive to exceed expectations and drive success.\n\n'
                                  'Our core values include:\n'
                                  '1. Customer Focus: We put our clients at the heart of everything we do, ensuring their needs are met with the highest level of satisfaction.\n'
                                  '2. Integrity: We uphold the highest standards of honesty and transparency in all our dealings.\n'
                                  '3. Excellence: We are committed to excellence in every aspect of our work, from the solutions we provide to the relationships we build.\n'
                                  '4. Innovation: We embrace new ideas and technologies to stay ahead in a constantly evolving industry.\n\n'
                                  'Over the years, we have built a reputation for delivering exceptional results and creating lasting partnerships. '
                                  'Whether you are looking for online management or digital sport solutions, our team is here to help you achieve your goals.\n\n'
                                  'Thank you for considering Sdeng. We look forward to working with you and helping you succeed!',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  })
              ],
            ),
            const SizedBox(height: AppSpacing.xxlg),
            Align(
              alignment: Alignment.center,
              child: SecondaryButton(
                  text: 'Logout',
                  onPressed: () => context.read<AppBloc>().onLogoutRequested()),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
