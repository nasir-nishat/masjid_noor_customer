import 'package:flutter/services.dart';import 'package:google_sign_in/google_sign_in.dart';import 'package:masjid_noor_customer/presentation/pages/all_export.dart';import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';import 'package:masjid_noor_customer/presentation/pages/user/privacy_policy.dart';import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';import 'package:url_launcher/url_launcher.dart';import 'package:share_plus/share_plus.dart';import '../../../mgr/models/bank_md.dart';class ProfilePage extends GetView<UserController> {  const ProfilePage({super.key});  @override  Widget build(BuildContext context) {    return Obx(() => (controller.isLoading.value)        ? const Center(child: CircularProgressIndicator())        : SingleChildScrollView(child: _buildActions(context)));  }  Widget _buildActions(BuildContext context) {    String phn = controller.user.value.phoneNumber;    return Column(      crossAxisAlignment: CrossAxisAlignment.start,      children: [        ListTile(          leading: const HeroIcon(HeroIcons.userCircle),          title: Text(              'Name: ${controller.user.value.firstName} ${controller.user.value.lastName}'),          onTap: () {},        ),        ListTile(          leading: const HeroIcon(HeroIcons.inbox),          title: Text('Email: ${controller.user.value.email}'),        ),        ListTile(          leading: const HeroIcon(HeroIcons.devicePhoneMobile),          title: phn == ""              ? Text('Add phone number',                  style: TextStyle(                      color: phn == "" ? context.theme.primaryColor : null))              : Text('Phone: $phn'),          onTap: () {            _showChangePhoneNumberDialog(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.shoppingCart),          title: const Text('Orders'),          onTap: () {            OrderController.to.fetchOrders();            context.push(Routes.orders);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.phone),          title: const Text('Call Customer Care'),          onTap: () {            _callCustomerCare();          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.share),          title: const Text('Share App'),          onTap: () {            _shareApp();          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.documentText),          title: const Text('Bank Account Details'),          onTap: () {            showBankDetailsDialog(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.bookOpen),          title: const Text('Privacy policy'),          onTap: () {            _showTermsAndPrivacy(context);          },        ),        ListTile(          leading: const HeroIcon(HeroIcons.arrowLeftEndOnRectangle),          title: const Text('Logout'),          onTap: () {            AuthenticationNotifier.instance.logout().then((value) {              GoogleSignIn().disconnect();              Hive.box<UserMd>('user_box').clear();              context.go(Routes.home);            });          },        ),      ],    );  }  Future<void> _showChangePhoneNumberDialog(BuildContext context) async {    final phoneController =        TextEditingController(text: controller.user.value.phoneNumber);    final maskFormatter = MaskTextInputFormatter(      mask: '### #### ####',      filter: {"#": RegExp(r'[0-9]')},    );    await showDialog(      context: context,      useRootNavigator: false,      builder: (context) {        return AlertDialog(          title: const Text('Change Phone Number'),          content: TextField(            controller: phoneController,            autofocus: true,            decoration: const InputDecoration(                labelText: 'Phone Number', prefix: Text('+82 ')),            inputFormatters: [maskFormatter],            keyboardType: TextInputType.phone,          ),          actions: [            TextButton(              onPressed: () {                controller.updatePhoneNumber(phoneController.text);                Navigator.of(context).pop();              },              child: const Text('Submit'),            ),          ],        );      },    );  }  Future<void> _callCustomerCare() async {    Uri url = Uri(scheme: 'tel');    if (!await launchUrl(url)) {      throw Exception('Could not launch $url');    }  }  void _shareApp() {    Share.share('Check out this amazing app: <app link>');  }  void _showTermsAndPrivacy(BuildContext context) {    context.push(Routes.privacyPolicy);  }}showBankDetailsDialog(BuildContext context) async {  BankMd? bankDetails = PrayerTimesController.to.bankDetails.value;  if (!context.mounted) return;  showDialog(    context: context,    useRootNavigator: false,    builder: (context) {      return AlertDialog(        title: const Text('Bank Transfer'),        content: Column(          crossAxisAlignment: CrossAxisAlignment.start,          mainAxisSize: MainAxisSize.min,          children: [            _buildDetailRow(              context,              'Bank Name:',              bankDetails?.bankName ?? '',            ),            _buildDetailRow(              context,              'Account Name:',              bankDetails?.accountName ?? '',            ),            _buildDetailRow(              context,              'Account Number:',              bankDetails?.accountNumber ?? '',            ),          ],        ),        actions: [          TextButton(            onPressed: () {              Navigator.of(context).pop();            },            child: const Text('Okay'),          ),        ],      );    },  );}Widget _buildDetailRow(BuildContext context, String label, String value) {  return Row(    children: [      Expanded(        child: Text.rich(          TextSpan(            text: '$label\n',            style: const TextStyle(fontWeight: FontWeight.normal),            children: [              TextSpan(                text: value,                style: TextStyle(                  fontWeight: FontWeight.bold,                  color: Theme.of(context).primaryColor,                ),              ),            ],          ),        ),      ),      IconButton(        icon: const Icon(Icons.copy),        onPressed: () {          Clipboard.setData(ClipboardData(text: value));          showToast('$label copied to clipboard');        },      ),    ],  );}