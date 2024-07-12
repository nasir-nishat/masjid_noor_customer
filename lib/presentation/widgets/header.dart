import 'package:masjid_noor_customer/presentation/pages/all_export.dart';import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';import 'package:masjid_noor_customer/presentation/widgets/cart_icon_count.dart';class Header extends GetView<AppController> {  Header({super.key});  @override  Widget build(BuildContext context) {    return Obx(() =>        Container(padding: EdgeInsets.all(10.r), child: getHeader(context)));  }  Widget getHeader(BuildContext context) {    switch (controller.currentRoute.value) {      case Routes.home:        return homeHeader(context);      case Routes.profile:        return profileHeader(context);      case Routes.products:        return productsHeader(context);      default:        return homeHeader(context);    }  }  Widget homeHeader(BuildContext context) {    return Row(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        Text('Home',            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),        IconButton(          onPressed: () {            context.push(Routes.cart);          },          icon: CartIconCount(            count: CartController.to.totalProdCount,            removeBg: true,          ),        ),      ],    );  }  Widget profileHeader(BuildContext context) {    return Padding(      padding: EdgeInsets.symmetric(vertical: 4.h),      child: Text('Profile',          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),    );  }  Widget productsHeader(BuildContext context) {    return Row(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        Text('Products',            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),        IconButton(          onPressed: () {            context.push(Routes.cart);          },          icon: CartIconCount(            count: CartController.to.totalProdCount,            removeBg: true,          ),        ),      ],    );  }}