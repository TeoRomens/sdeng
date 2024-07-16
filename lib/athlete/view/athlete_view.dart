import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

class AthleteView extends StatelessWidget {
  const AthleteView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.zero,
            shape: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffcccccc), width: 0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            elevation: 0.5,
            shadowColor: Colors.grey.shade200,
            offset: Offset.fromDirection(20, 30),
            surfaceTintColor: Colors.transparent,
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 36,
                onTap: () async {
                  await context.read<AthleteCubit>().deleteAthlete().whenComplete(
                      () => Navigator.of(context).pop(true)
                  );
                },
                child: Row(
                  children: [
                    const Icon(FeatherIcons.trash, color: Colors.red, size: 20,),
                    const SizedBox(width: 8,),
                    Text('Delete', style: Theme.of(context).textTheme.labelLarge,),
                  ],
                )
              )
            ]
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<AthleteCubit, AthleteState>(
          listener: (context, state) {
            if (state.status == AthleteStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
            }
          },
          child: const AthleteDetailsMobile()
        ),
      ),
    );
  }
}

@visibleForTesting
class AthleteDetailsMobile extends StatefulWidget {
  const AthleteDetailsMobile({
    super.key,
  });

  @override
  AthleteDetailMobileState createState() => AthleteDetailMobileState();
}

class AthleteDetailMobileState extends State<AthleteDetailsMobile> with TickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          SliverToBoxAdapter(
              child: AthleteCard(
                  name: bloc.state.athlete?.fullName ?? 'Loading...',
                  taxCode: bloc.state.athlete?.taxCode ?? 'Loading...'
              ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: TabBar.secondary(
                dividerHeight: 0,
                controller: _tabController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                splashBorderRadius: BorderRadius.circular(8),
                tabs: const <Widget>[
                  Tab(icon: Icon(FeatherIcons.user),),
                  Tab(icon: Icon(FeatherIcons.heart)),
                  Tab(icon: Icon(FeatherIcons.dollarSign)),
                  Tab(icon: Icon(FeatherIcons.file)),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: const [
          AthleteInfo(),
          MedicalInfo(),
          PaymentInfo(),
          DocumentInfo(),
        ],
      ),
    );
  }
}
