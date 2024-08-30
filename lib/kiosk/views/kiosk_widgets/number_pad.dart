import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspace;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1.8,
      children: [
        ...List.generate(9, (index) => index + 1).map((number) => NumberButton(
              number: number.toString(),
              onTap: () => onNumberTap(number.toString()),
            )),
        const SizedBox(),
        NumberButton(
          number: '0',
          onTap: () => onNumberTap('0'),
        ),
        NumberButton(
          number: '⌫',
          onTap: onBackspace,
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onTap;

  const NumberButton({
    super.key,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
