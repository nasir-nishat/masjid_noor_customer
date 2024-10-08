import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_icon_count.dart';

class Header extends StatelessWidget {
  final String currentRoute;
  const Header({super.key, required this.currentRoute});
  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.r), child: getHeader(context)));
  }

  Widget getHeader(BuildContext context) {
    switch (currentRoute) {
      case Routes.home:
        return homeHeader(context);
      case Routes.profile:
        return profileHeader(context);
      case Routes.products:
        return productsHeader(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget homeHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Home',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        InkWell(
          onTap: () {
            context.push(Routes.cart);
          },
          child: CartIconCount(
            count: CartController.to.totalProdCount,
            removeBg: true,
            size: 30.w,
          ),
        ),
      ],
    );
  }

  Widget profileHeader(BuildContext context) {
    return Row(
      children: [
        Text('Profile',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget productsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Products',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        InkWell(
          onTap: () {
            context.push(Routes.cart);
          },
          child: CartIconCount(
            size: 30.w,
            count: CartController.to.totalProdCount,
            removeBg: true,
          ),
        ),
      ],
    );
  }
}
