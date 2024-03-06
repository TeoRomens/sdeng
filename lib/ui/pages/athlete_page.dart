import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/medical.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/formatter.dart';

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
              ..loadAthleteDetailsFromId(athleteId),
          ),
        ],
        child: const AthleteDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AthletesCubit, AthletesState>(
      builder: (context, state) {
        if (state is AthletesInitial || state is AthletesLoading) {
          return preloader;
        } else if (state is AthleteDetailLoaded){
          return AthleteDetailMobile(
              athlete: state.athlete,
              medical: state.medical,
              payments: state.payments,
              parent: state.parent,
          );
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
    );
  }
}


@visibleForTesting
class AthleteDetailMobile extends StatefulWidget {

  AthleteDetailMobile({
    Key? key,
    required Athlete athlete,
    Parent? parent,
    Medical? medical,
    List<Payment>? payments,
  })
      : _athlete = athlete,
        _medical = medical,
        _parent = parent,
        _payments = payments ?? [],
        super(key: key);

  final Athlete _athlete;
  Medical? _medical;
  Parent? _parent;
  final List<Payment> _payments;

  @override
  AthleteDetailMobileState createState() => AthleteDetailMobileState();
}

class AthleteDetailMobileState extends State<AthleteDetailMobile> with TickerProviderStateMixin{
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
    _birthController.text = widget._athlete.birthDate == null
        ? '' : Formatter.dateToString(widget._athlete.birthDate!);
    _addressController.text = widget._athlete.fullAddress ?? '';
    _emailController.text = widget._athlete.email ?? '';
    _phoneController.text = widget._athlete.phone ?? '';
    _parentNameController.text = widget._parent?.fullName ?? '';
    _parentAddressController.text = widget._parent?.fullAddress ?? '';
    _parentEmailController.text = widget._parent?.email ?? '';
    super.initState();
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
                Text(widget._athlete.fullName, style: GoogleFonts.bebasNeue(
                    fontSize: 50,
                    height: 1
                ),),
                Text(widget._athlete.taxCode, style: const TextStyle(
                    fontSize: 18,
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
                            Text('Dati Anagrafici', style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                height: 1
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isFullNameLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isFullNameEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isFullNameLoading = true;
                                        isFullNameEditing = false;
                                      });
                                      await bloc.updateFullName(widget._athlete.id, _nameController.text);
                                      context.showSuccessSnackBar(message: 'Name updated successful!');
                                      setState(() => isFullNameLoading = false);
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isTaxIdLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isTaxIdEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isTaxIdLoading = true;
                                        isTaxIdEditing = false;
                                      });
                                      await bloc.updateTaxId(widget._athlete.id, _taxIdController.text);
                                      context.showSuccessSnackBar(message: 'Tax ID updated successful!');
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                    isBirthdateLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                    isBirthdateEditing ? IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isBirthdateLoading = true;
                                            isBirthdateEditing = false;
                                          });
                                          await bloc.updateBirthdate(widget._athlete.id, _birthController.text);
                                          context.showSuccessSnackBar(message: 'Birthday updated successful!');
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isAddressLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isAddressEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isAddressLoading = true;
                                        isAddressEditing = false;
                                      });
                                      await bloc.updateAddress(widget._athlete.id, _addressController.text);
                                      context.showSuccessSnackBar(message: 'Address updated successful!');
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
                            spacer16,
                            Text('Contacts', style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                height: 1
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isEmailLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isEmailEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isEmailLoading = true;
                                        isEmailEditing = false;
                                      });
                                      await bloc.updateEmail(widget._athlete.id, _emailController.text);
                                      context.showSuccessSnackBar(message: 'Email updated successful!');
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isPhoneLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isPhoneEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isPhoneLoading = true;
                                        isPhoneEditing = false;
                                      });
                                      await bloc.updatePhone(widget._athlete.id, _phoneController.text);
                                      context.showSuccessSnackBar(message: 'Phone updated successful!');
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
                            spacer16,
                            Text('Legal Represent', style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                height: 1
                            ),),
                            //TODO: hide when empty
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentNameLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentNameEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentNameLoading = true;
                                        isParentNameEditing = false;
                                      });
                                      await bloc.updateParentName(widget._athlete.id, _parentNameController.text);
                                      context.showSuccessSnackBar(message: 'Name of the legal rapresent updated successful!');
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentEmailLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentEmailEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentEmailLoading = true;
                                        isParentEmailEditing = false;
                                      });
                                      await bloc.updateParentEmail(widget._athlete.id, _parentEmailController.text);
                                      context.showSuccessSnackBar(message: 'Email of the legal rapresent updated successful!');
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
                              onTapOutside: (event) => FocusScope.of(context).unfocus(),
                              decoration: InputDecoration(
                                suffixIcon:
                                isParentAddressLoading ? Lottie.asset('assets/animations/loading.json', height: 40, width: 40) :
                                isParentAddressEditing ? IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isParentAddressLoading = true;
                                        isParentAddressEditing = false;
                                      });
                                      await bloc.updateParentAddress(widget._athlete.id, _parentAddressController.text);
                                      context.showSuccessSnackBar(message: 'Address of the legal rapresent updated successful!');
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
                            Text('Medical Visit', style: GoogleFonts.bebasNeue(
                              fontSize: 40,
                              height: 1
                            ),),
                            spacer16,
                            if (widget._medical != null) Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                            ) else Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                spacer32,
                                SvgPicture.asset('assets/illustrations/medical_research.svg',
                                  height: 100
                                ),
                                spacer32,
                                const Text('No medical visit added', style: TextStyle(
                                  fontSize: 20,
                                ),),
                                spacer32,
                                SdengDefaultButton.icon(
                                  text: 'Medical Visit',
                                  icon: const Icon(FeatherIcons.plus),
                                  onPressed: () async {
                                    final newMedical = await showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('New Medical Visit', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24
                                            ),),
                                            spacer32,
                                            const Padding(
                                              padding: EdgeInsets.only(bottom: 10),
                                              child: Text('Optional', style: TextStyle(
                                                color: Color(0xff686f75),
                                                fontSize: 16,
                                              ),),
                                            ),
                                            SdengDefaultButton.icon(
                                                text: 'Upload Document',
                                                icon: const Icon(FeatherIcons.file),
                                                onPressed: () {
                                                  //TODO: Implement
                                                }),
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
                                            ),
                                            spacer32,
                                            Align(
                                              alignment: Alignment.center,
                                              child: SdengPrimaryButton(
                                                text: 'Add',
                                                onPressed: () {
                                                  //TODO: Implement
                                                }
                                              ),
                                            ),
                                            spacer32,
                                          ],
                                        ),
                                      )
                                    );
                                    setState(() {
                                      widget._medical = newMedical;
                                    });
                                  })
                              ],
                            ),
                          ],
                        ),

                        /// PAYMENTS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('TRANSACTIONS', style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                height: 1
                            ),),
                            spacer16,
                            SdengDefaultButton.icon(
                                text: 'Payment',
                                icon: const Icon(FeatherIcons.plus),
                                onPressed: () {
                                  //TODO: Implement
                                }),
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                //TODO: Implement
                                return ListTile(
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide.none
                                  ),
                                  leading: const Icon(FeatherIcons.arrowDown, color: greenColor,),
                                  title: const Text('Causale'),
                                  titleTextStyle: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                  ),
                                  subtitle: const Text('12/2/2023'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('€ 300', style: TextStyle(
                                        fontSize: 20
                                      ),),
                                      spacer16,
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
                                            const PopupMenuItem(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 4,),
                                                    Icon(FeatherIcons.edit, color: Colors.black, size: 20,),
                                                    SizedBox(width: 12,),
                                                    Text('Edit'),
                                                  ],
                                                )
                                            ),
                                            PopupMenuItem(
                                                onTap: () {},
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 4,),
                                                    Icon(FeatherIcons.trash, color: Colors.red, size: 20,),
                                                    SizedBox(width: 12,),
                                                    Text('Delete'),
                                                  ],
                                                )
                                            )
                                          ]
                                      ),
                                    ],
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

                        /// DOCS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SdengDefaultButton.icon(
                                    text: 'Upload',
                                    icon: const Icon(FeatherIcons.plus),
                                    onPressed: () {
                                      //TODO: Implement
                                    }),
                                spacer16,
                                SdengDefaultButton.icon(
                                    text: 'Generate',
                                    icon: const Icon(FeatherIcons.plus),
                                    onPressed: () {
                                      //TODO: Implement
                                    }),
                              ],
                            ),
                            spacer16,
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide.none
                                  ),
                                  title: const Text('Visita Medico Sportiva'),
                                  titleTextStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
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
                                        const PopupMenuItem(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 4,),
                                                Icon(FeatherIcons.edit, color: Colors.black, size: 20,),
                                                SizedBox(width: 12,),
                                                Text('Rename'),
                                              ],
                                            )
                                        ),
                                        PopupMenuItem(
                                            onTap: () {},
                                            child: const Row(
                                              children: [
                                                SizedBox(width: 4,),
                                                Icon(FeatherIcons.trash, color: Colors.red, size: 20,),
                                                SizedBox(width: 12,),
                                                Text('Delete'),
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