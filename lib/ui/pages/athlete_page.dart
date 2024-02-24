import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/cubits/medical_cubit.dart';
import 'package:sdeng/cubits/payments_cubit.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/medical.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/formatter.dart';

//TODO: Delete this page
class AthleteDetailPage extends StatelessWidget {
  const AthleteDetailPage({Key? key}) : super(key: key);

  /// Name of this page within `RouteSettings`
  static const name = 'AthleteDetailPage';

  static Route<void> route(String athleteId) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AthletesCubit>(
            create: (context) => AthletesCubit(
                repository: RepositoryProvider.of<Repository>(context))
              ..loadAthleteFromId(athleteId),
          ),
          BlocProvider<MedicalCubit>(
            create: (context) => MedicalCubit(
                repository: RepositoryProvider.of<Repository>(context))
              ..loadMedicalFromAthleteId(athleteId),
          ),
          BlocProvider<PaymentsCubit>(
            create: (context) => PaymentsCubit(
                repository: RepositoryProvider.of<Repository>(context))
              ..loadPaymentsFromAthleteId(athleteId),
          ),
        ],
        child: const AthleteDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AthletesCubit, AthletesState>(
        builder: (context, state) {
          if (state is AthletesInitial || state is AthletesLoading) {
            return preloader;
          } else if (state is AthleteDetailLoaded){
            return AthleteDetailScreen(athlete: state.athlete);
          } else if (state is AthletesError) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Center(child: Text(state.error)),
                Positioned(
                  top: 18 + MediaQuery.of(context).padding.top,
                  left: 18,
                  child: BackButton(
                    onPressed: Navigator.of(context).pop,
                  ),
                ),
              ],
            );
          }
          throw UnimplementedError();
        },
      ),
    );
  }
}


@visibleForTesting
class AthleteDetailScreen extends StatefulWidget {

  AthleteDetailScreen({
    Key? key,
    required Athlete athlete,
    Medical? medical,
    List<Payment>? payments,
  })
      : _athlete = athlete,
        _medical = medical,
        _payments = payments,
        super(key: key);

  final Athlete _athlete;
  final Medical? _medical;
  final List<Payment>? _payments;

  @override
  _AthleteDetailScreenState createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> with TickerProviderStateMixin{
  late final TabController _tabController;

  bool isFullNameLoading = false;
  bool isFullNameEditing = false;
  final TextEditingController _nameController = TextEditingController();

  bool isTaxIdLoading = false;
  bool isTaxIdEditing = false;
  final TextEditingController _taxIdController = TextEditingController();

  bool isBirthdateLoading = false;
  bool isBirthdateEditing = false;
  final TextEditingController _birthController = TextEditingController();

  bool isAddressLoading = false;
  bool isAddressEditing = false;
  final TextEditingController _addressController = TextEditingController();

  bool isEmailLoading = false;
  bool isEmailEditing = false;
  final TextEditingController _emailController = TextEditingController();

  bool isPhoneLoading = false;
  bool isPhoneEditing = false;
  final TextEditingController _phoneController = TextEditingController();

  bool isParentEmailLoading = false;
  bool isParentEmailEditing = false;
  final TextEditingController _parentEmailController = TextEditingController();

  bool isParentNameLoading = false;
  bool isParentNameEditing = false;
  final TextEditingController _parentNameController = TextEditingController();

  bool isParentAddressLoading = false;
  bool isParentAddressEditing = false;
  final TextEditingController _parentAddressController = TextEditingController();

  bool isExpireLoading = false;
  bool isExpireEditing = false;
  final TextEditingController _expireController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _nameController.text = widget._athlete.fullName;
    _taxIdController.text = widget._athlete.taxCode;
    _birthController.text = Formatter.readableDate(widget._athlete.birthDate);
    _addressController.text = widget._athlete.fullAddress ?? '';
    _emailController.text = widget._athlete.email ?? '';
    _phoneController.text = widget._athlete.phone ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeAthlete() async {

  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AthletesCubit>(context);

    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                spacer16,
                spacer16,
                Text(widget._athlete.fullName, style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),),
                Text(widget._athlete.taxCode, style: const TextStyle(
                    fontSize: 18
                ),),
                spacer16,
                spacer16,
                SizedBox(
                  height: 40,
                  child: TabBar.secondary(
                    controller: _tabController,
                    splashBorderRadius: BorderRadius.circular(8),
                    tabs: const <Widget>[
                      Tab(text: 'Info'),
                      Tab(text: 'Medical'),
                      Tab(text: 'Payments'),
                      Tab(text: 'Docs'),
                    ],
                  ),
                ),
                spacer16,
                Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const Text('Dati Anagrafici', style: TextStyle(
                                fontSize: 24,
                            ),),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Full Name', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isFullNameEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isFullNameLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isFullNameEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isFullNameLoading = true;
                                        isFullNameEditing = false;
                                      });
                                      //await bloc.updateFullName(widget._athlete.id, _nameController.text);
                                      setState(() {
                                        isFullNameLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Tax Id', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _taxIdController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isTaxIdEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isTaxIdLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isTaxIdEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isTaxIdLoading = true;
                                        isTaxIdEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isTaxIdLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Birthday', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _birthController,
                              keyboardType: TextInputType.datetime,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isBirthdateEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                    isBirthdateLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                    isBirthdateEditing ? IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isBirthdateLoading = true;
                                            isBirthdateEditing = false;
                                          });
                                          await Future.delayed(const Duration(seconds: 1));
                                          setState(() {
                                            isBirthdateLoading = false;
                                          });
                                        },
                                        icon: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Colors.green.shade50,
                                            ),
                                            child: const Icon(Icons.check, color: Colors.green)
                                        )
                                    ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Address', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _addressController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isAddressEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isAddressLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isAddressEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isAddressLoading = true;
                                        isAddressEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isAddressLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Text('Contacts', style: TextStyle(
                              fontSize: 24,
                            ),),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Email', style: TextStyle(
                                  color: Color(0xff686f75),
                                  fontSize: 16,
                                ),),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isEmailEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isEmailLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isEmailEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isEmailLoading = true;
                                        isEmailEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isEmailLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Phone', style: TextStyle(
                                  color: Color(0xff686f75),
                                  fontSize: 16,
                                ),),
                            ),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isPhoneEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isPhoneLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isPhoneEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isPhoneLoading = true;
                                        isPhoneEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isPhoneLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Text('Legal Represents', style: TextStyle(
                              fontSize: 24,
                            ),),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Full Name', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _parentNameController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isParentNameEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentNameLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentNameEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentNameLoading = true;
                                        isParentNameEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isParentNameLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Email', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _parentEmailController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isParentEmailEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentEmailLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentEmailEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentEmailLoading = true;
                                        isParentEmailEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isParentEmailLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Address', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _parentAddressController,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isParentAddressEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentAddressLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentAddressEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentAddressLoading = true;
                                        isParentAddressEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isParentAddressLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                            spacer16,
                          ],
                        ),

                        /// MEDICAL
                        ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const Text('Medical Visit', style: TextStyle(
                              fontSize: 24,
                            ),),
                            spacer16,
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Expire Date', style: TextStyle(
                                color: Color(0xff686f75),
                                fontSize: 16,
                              ),),
                            ),
                            TextField(
                              controller: _expireController,
                              keyboardType: TextInputType.datetime,
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) => setState(() {
                                isExpireEditing = true;
                              }),
                              decoration: InputDecoration(
                                suffixIcon:
                                isExpireLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isExpireEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isExpireLoading = true;
                                        isExpireEditing = false;
                                      });
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() {
                                        isExpireLoading = false;
                                      });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.green.shade50,
                                        ),
                                        child: const Icon(Icons.check, color: Colors.green)
                                    )
                                ) : null,
                              ),
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Payments'),
                          ],
                        ),

                        /// DOCS
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: const Text('Visita Medico Sportiva'),
                                  titleTextStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'ProductSans'
                                  ),
                                  leading: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius: const BorderRadius.all(Radius.circular(6))
                                      ),
                                      width: 35,
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.asset('assets/png/icons8-pdf-96.png'),
                                      ),
                                  ),
                                  trailing: PopupMenuButton(
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
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 4,),
                                                SvgPicture.asset('assets/icons/edit.svg', height: 20,),
                                                const SizedBox(width: 12,),
                                                const Text('Rename', style: TextStyle(
                                                    fontFamily: 'ProductSans'
                                                ),),
                                              ],
                                            )
                                        ),
                                        PopupMenuItem(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 4,),
                                                SvgPicture.asset('assets/icons/trash.svg', color: Colors.red, height: 20,),
                                                const SizedBox(width: 12,),
                                                const Text('Delete', style: TextStyle(
                                                  fontFamily: 'ProductSans'
                                                ),),
                                              ],
                                            )
                                        )
                                      ]
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 5, right: 5),
                                  onTap: () {

                                  },
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider(
                                  height: 10,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ]
            ),
          ),
        ),
    );
  }
}