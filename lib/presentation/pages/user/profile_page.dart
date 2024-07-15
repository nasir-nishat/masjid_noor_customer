import 'package:flutter/services.dart';import 'package:google_sign_in/google_sign_in.dart';import 'package:masjid_noor_customer/mgr/models/order_md.dart';import 'package:masjid_noor_customer/presentation/pages/all_export.dart';import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';import 'package:url_launcher/url_launcher.dart';import 'package:share_plus/share_plus.dart';class ProfilePage extends GetView<UserController> {  const ProfilePage({super.key});  @override  Widget build(BuildContext context) {    return Obx(() => (controller.isLoading.value)        ? const Center(child: CircularProgressIndicator())        : SingleChildScrollView(child: _buildActions(context)));  }  Widget _buildActions(BuildContext context) {    return Column(      crossAxisAlignment: CrossAxisAlignment.start,      children: [        ListTile(          leading: const HeroIcon(HeroIcons.userCircle),          title: Text(              'Name: ${controller.user.value.firstName} ${controller.user.value.lastName}'),          onTap: () {},        ),        ListTile(          leading: const HeroIcon(HeroIcons.inbox),          title: Text('Email: ${controller.user.value.email}'),        ),        ListTile(          leading: const HeroIcon(HeroIcons.devicePhoneMobile),          title: Text('Phone: ${controller.user.value.phoneNumber}'),          onTap: () {            _showChangePhoneNumberDialog(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.shoppingCart),          title: const Text('Orders'),          onTap: () {            OrderController.to.fetchOrders();            context.push(Routes.orders);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.phone),          title: const Text('Call Customer Care'),          onTap: () {            _callCustomerCare();          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.share),          title: const Text('Share App'),          onTap: () {            _shareApp();          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.documentText),          title: const Text('Bank Account Details'),          onTap: () {            showBankDetailsDialog(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.bookOpen),          title: const Text('Terms & Privacy'),          onTap: () {            _showTermsAndPrivacy(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.arrowLeftEndOnRectangle),          title: const Text('Logout'),          onTap: () {            AuthenticationNotifier.instance.logout().then((value) {              AppController.to.currentRoute.value = Routes.home;              AppController.to.navIndex.value = 0;              AppController.to.update();              GoogleSignIn().disconnect();              Hive.box<UserMd>('user_box').clear();              context.go(Routes.home);            });          },        ),      ],    );  }  Future<void> _showChangePhoneNumberDialog(BuildContext context) async {    final phoneController =        TextEditingController(text: controller.user.value.phoneNumber);    final maskFormatter = MaskTextInputFormatter(      mask: '### #### ####',      filter: {"#": RegExp(r'[0-9]')},    );    await showDialog(      context: context,      builder: (context) {        return AlertDialog(          title: const Text('Change Phone Number'),          content: TextField(            controller: phoneController,            autofocus: true,            decoration: const InputDecoration(                labelText: 'Phone Number', prefix: Text('+82 ')),            inputFormatters: [maskFormatter],            keyboardType: TextInputType.phone,          ),          actions: [            TextButton(              onPressed: () {                controller.updatePhoneNumber(phoneController.text);                Navigator.of(context).pop();              },              child: const Text('Submit'),            ),          ],        );      },    );  }  Future<void> _callCustomerCare() async {    Uri _url = Uri(scheme: 'tel');    if (!await launchUrl(_url)) {      throw Exception('Could not launch $_url');    }  }  void _shareApp() {    Share.share('Check out this amazing app: <app link>');  }  void _showTermsAndPrivacy(BuildContext context) {    showDialog(      context: context,      builder: (context) {        return AlertDialog(          title: const Text('Terms & Privacy'),          content: const SingleChildScrollView(            child: Column(              children: [                Text('Terms of Service...'),                SizedBox(height: 10),                Text('Privacy Policy...'),              ],            ),          ),          actions: [            TextButton(              onPressed: () {                Navigator.of(context).pop();              },              child: const Text('Close'),            ),          ],        );      },    );  }}showBankDetailsDialog(BuildContext context) async {  showDialog(    context: context,    builder: (context) {      return AlertDialog(        title: const Text('Bank Transfer'),        content: Column(          crossAxisAlignment: CrossAxisAlignment.start,          mainAxisSize: MainAxisSize.min,          children: [            Row(              children: [                const Expanded(                  child: Text('Bank Name:\n<Bank Name>'),                ),                IconButton(                  icon: const Icon(Icons.copy),                  onPressed: () {                    Clipboard.setData(const ClipboardData(text: '<Bank Name>'));                    ScaffoldMessenger.of(context).showSnackBar(                      const SnackBar(                          content: Text('Bank Name copied to clipboard')),                    );                  },                ),              ],            ),            Row(              children: [                const Expanded(                  child: Text('Account Name:\n<Account Name>'),                ),                IconButton(                  icon: const Icon(Icons.copy),                  onPressed: () {                    Clipboard.setData(                        const ClipboardData(text: '<Account Name>'));                    ScaffoldMessenger.of(context).showSnackBar(                      const SnackBar(                          content: Text('Account Name copied to clipboard')),                    );                  },                ),              ],            ),            Row(              children: [                const Expanded(                  child: Text('Account Number:\n<Account Number>'),                ),                IconButton(                  icon: const Icon(Icons.copy),                  onPressed: () {                    Clipboard.setData(                        const ClipboardData(text: '<Account Number>'));                    ScaffoldMessenger.of(context).showSnackBar(                      const SnackBar(                          content: Text('Account Number copied to clipboard')),                    );                  },                ),              ],            ),          ],        ),        actions: [          TextButton(            onPressed: () {              Navigator.of(context).pop();            },            child: const Text('Okay'),          ),        ],      );    },  );}