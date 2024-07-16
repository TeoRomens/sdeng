import 'package:app_ui/app_ui.dart' show AppBackButton, PrimaryButton, AppColors, AppFontWeight, AppSpacing, AppSwitch;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';
import 'package:sdeng/user_profile/bloc/user_profile_bloc.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const UserProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const UserProfileView(),
    );
  }
}

@visibleForTesting
class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //context.read<UserProfileBloc>().fetchInitial;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Fetch current status each time a user enters the app.
    // This may happen when a user changes permissions in app settings.
    if (state == AppLifecycleState.resumed) {
      WidgetsFlutterBinding.ensureInitialized();
      //context.read<UserProfileBloc>().fetchNotificationsEnabled;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);
    final notificationsEnabled = context
        .select((UserProfileBloc bloc) => bloc.state.notificationsEnabled);

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(LoginPage.route());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          leading: const AppBackButton(),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const UserProfileTitle(),
                  const UserProfileSubtitle(
                    subtitle: 'Settings',
                  ),
                  UserProfileItem(
                    title: 'Payment Formula Settings',
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.of(context).push(PaymentFormulaPage.route());
                    },
                  ),
                  const _UserProfileDivider(),
                  const UserProfileSubtitle(
                    subtitle: 'Legal',
                  ),
                  UserProfileItem(
                    key: const Key('userProfilePage_termsOfServiceItem'),
                    leading: const Icon(FeatherIcons.info, color: AppColors.highEmphasisSurface, size: 20,),
                    title: 'Terms of Use & Privacy Policy',
                    onTap: () {

                    },
                  ),
                  const UserProfileItem(
                    key: Key('userProfilePage_aboutItem'),
                    leading: Icon(FeatherIcons.info, color: AppColors.highEmphasisSurface, size: 20,),
                    title: 'About',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Align(
                    child: UserProfileLogoutButton()
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Profile',
        style: theme.textTheme.headlineLarge,
      ),
    );
  }
}

@visibleForTesting
class UserProfileSubtitle extends StatelessWidget {
  const UserProfileSubtitle({required this.subtitle, super.key});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        subtitle,
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppColors.blueGrey,
          fontWeight: AppFontWeight.medium
        ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileItem extends StatelessWidget {
  const UserProfileItem({
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  static const _leadingWidth = AppSpacing.xxlg + AppSpacing.md;

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;

    return ListTile(
      leading: SizedBox(
        width: hasLeading ? _leadingWidth : 0,
        child: leading,
      ),
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        hasLeading ? AppSpacing.sm : AppSpacing.xlg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      horizontalTitleGap: 0,
      minLeadingWidth: hasLeading ? _leadingWidth : 0,
      onTap: onTap,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge
    );
  }
}

@visibleForTesting
class UserProfileLogoutButton extends StatelessWidget {
  const UserProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxlg + AppSpacing.lg,
      ),
      child: PrimaryButton(
        onPressed: () => context.read<AppBloc>().onLogoutRequested(),
        child: const Text('Logout'),
      ),
    );
  }
}

class _UserProfileDivider extends StatelessWidget {
  const _UserProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Divider(
        color: AppColors.borderOutline,
        height: AppSpacing.xs,
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}
