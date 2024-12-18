// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';

import 'package:dev_dandiya/Screen/add_user_details.dart';
import 'package:dev_dandiya/Screen/display_user_details.dart';
import 'package:dev_dandiya/Screen/edit_profile.dart';
import 'package:dev_dandiya/Screen/event_details.dart';
import 'package:dev_dandiya/Screen/login_screen.dart';
import 'package:dev_dandiya/Screen/search_screen.dart';
import 'package:dev_dandiya/Screen/whats_app_setting_screen.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/const/image_url.dart';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/widget/popup.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/svg_url.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/home_provider.dart';
import '../provider/session_provider.dart';
import '../widget/location_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static String? adminUsername;
}

class _HomeScreenState extends State<HomeScreen> {
  String? status;
  String? message;
  String? adminId;
  String? adminPassword;
  String? adminStatus;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData(context);
    });
  }

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getString('status');
    message = prefs.getString('message');
    adminId = prefs.getString('admin_id');
    HomeScreen.adminUsername = prefs.getString('admin_username');
    adminPassword = prefs.getString('admin_password');
    adminStatus = prefs.getString('admin_status');
    // Use the retrieved data in your app
  }

  void initializeData(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String session = Provider.of<SessionProvider>(context, listen: false)
              .getSelectedSession()
              ?.session ??
          '2024';
      String location = Provider.of<LocationProvider>(context, listen: false)
              .getSelectedLocation()
              ?.locationId ??
          '1';
      await Provider.of<HomeProvider>(context, listen: false)
          .loadData(sessionId: session, locationId: location);
    });
  }

  void sendMessageToWhatsApp(
      String message, BuildContext context, String phoneNumber) async {
    context.read<HomeProvider>().setMessage();
    final String encodedMessage =
        Uri.encodeComponent(message); // Encode the message

    final Uri whatsappUrl =
        Uri.parse('https://wa.me/+91$phoneNumber?text=$encodedMessage');

    // Check if the URL can be launched
    if (await canLaunchUrl(whatsappUrl)) {
      // Launch the URL
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // drawer key
    final sessionProvider = Provider.of<SessionProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    String? currentYear = sessionProvider.getSelectedSession()?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      drawer: Drawer(
        backgroundColor: const Color(0xffffa89e),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(ImageUrl.garbaLogo),
                      radius: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      HomeScreen.adminUsername.toString(),
                      style: myTextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              locationDropDown(),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const EventDetails(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.event,
                  color: AppColor.whiteColor,
                ),
                title: Text(
                  'Event Details',
                  style: myTextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const WhatsAppSetting(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.settings,
                  color: AppColor.whiteColor,
                ),
                title: Text(
                  'Whatsapp Settings',
                  style: myTextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.edit,
                  color: AppColor.whiteColor,
                ),
                title: Text(
                  'Edit Profile',
                  style: myTextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  // Dispose of session provider

                  prefs.setString('auth', 'logout');
                  sessionProvider.disposeSession();
                  locationProvider.disposeLocation();
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.logout,
                  color: AppColor.whiteColor,
                ),
                title: Text(
                  'Logout',
                  style: myTextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const AddUserDetails(),
              fullscreenDialog: true,
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: AppColor.blackColor,
          size: 30,
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        titleSpacing: 0,
        leadingWidth: 45,
        elevation: 0,
        title: Image.asset(
          'assets/devlogo.png',
          width: 120,
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SessionSelectionDialog();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.blackColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.all(4.0),
              child: Text(
                currentYear!,
                style: myTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              color: AppColor.blackColor,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeprovider, _) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: const Color(0xffffa89e),
            backgroundColor: Colors.transparent,
            strokeWidth: 2,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            edgeOffset: 20,
            displacement: 0,
            onRefresh: () {
              return homeprovider.refreshData(context);
            },
            child: Column(
              children: [
                // boy and girl
                SizedBox(
                  height: 50,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // male box
                      GestureDetector(
                        onTap: homeprovider.loadBoyData,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.boy,
                              color: AppColor.blackColor,
                              size: 28,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'BOYS - ${homeprovider.boys.length}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColor.blackColor,
                        thickness: 1,
                      ),
                      // female box
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: GestureDetector(
                          onTap: homeprovider.loadGirlData,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.girl,
                                color: AppColor.blackColor,
                                size: 28,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'GIRLS - ${homeprovider.girls.length}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                homeprovider.isLoading
                    ? Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 80.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 8.0),
                                            Container(
                                              width: double.infinity,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 8.0),
                                            Container(
                                              width: 40.0,
                                              height: 8.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: homeprovider.allStudents.length,
                          itemBuilder: (context, index) {
                            final item = homeprovider.allStudents[index];

                            return GestureDetector(
                              onTap: () async {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayUserDetails(
                                      studentId: item.studentId.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColor.listTileColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColor.greyColor.withOpacity(0.2),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 46.5,
                                      height: 46.5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            item.studentProfile.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          limitedText(
                                            item.studentName.toString(),
                                            15,
                                          ),
                                          style: myTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        Text(
                                          item.studentMobile.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: AppColor.blackColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          item.studentCode.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: AppColor.blackColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap: () {
                                            sendMessageToWhatsApp(
                                              homeprovider
                                                  .message.data![1].whatsapp
                                                  .toString(),
                                              context,
                                              item.studentMobile.toString(),
                                            );
                                          },
                                          child: const SvgImage(
                                            url: "assets/svg/message.svg",
                                            height: 35,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
