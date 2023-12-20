import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/core/constants/styles.dart';
import '/data/models/expenses_model.dart';
import '/presentation/screens/view_expenses/view_expense_page.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense});
  final Expenses expense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewExpensePage(expense: expense),
            fullscreenDialog: true,
          ),
        );
      },
      borderRadius: borderRadiusDefault,
      child: Container(
        padding: const EdgeInsets.all(paddingDefault / 2),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: borderRadiusDefault,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(2, 3), blurRadius: 5, color: Colors.black12)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _getColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/images/${expense.category}.png',
                    height: 22,
                    width: 22,
                    color: _getColor,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${DateFormat('d/MMM').format(expense.createdOn ?? DateTime.now())}, ${DateFormat('hh:mm:aa').format((expense.createdOn ?? DateTime.now())).toString()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            Text(
              "₹${expense.amountSpent}  ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Color get _getColor {
    final colorList = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.pinkAccent,
      Colors.blueGrey,
      Colors.brown
    ];
    Color color = Colors.red;
    for (int i = 0; i < ExpenseCategory.values.length; i++) {
      if (expense.category == ExpenseCategory.values[i].name) {
        color = colorList[i];
      }
    }
    return color;
  }
}
