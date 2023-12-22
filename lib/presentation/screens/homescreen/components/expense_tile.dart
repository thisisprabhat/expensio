import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/core/constants/styles.dart';
import '/data/models/expenses_model.dart';
import '/presentation/screens/view_expenses/view_expense_page.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';
import '/domain/bloc/expenses_bloc/expenses_bloc.dart';
import '/presentation/screens/add_expense/add_expense.dart';

class ExpenseTile extends StatefulWidget {
  const ExpenseTile({super.key, required this.expense});
  final Expenses expense;

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              _onEditPressed();
            },
            icon: Icons.edit,
            label: 'Edit',
            foregroundColor: Colors.blueGrey,
            backgroundColor: Colors.transparent,
          ),
          SlidableAction(
            onPressed: (context) async {
              _onDeletePressed();
            },
            icon: Icons.delete,
            label: 'Delete',
            foregroundColor: Colors.red,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewExpensePage(expense: widget.expense),
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
                  offset: Offset(2, 3),
                  blurRadius: 5,
                  color: Colors.black12,
                )
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
                      'assets/images/${widget.expense.category}.png',
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
                        widget.expense.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${DateFormat('d/MMM').format(widget.expense.createdOn ?? DateTime.now())}, ${DateFormat('hh:mm:aa').format((widget.expense.createdOn ?? DateTime.now())).toString()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              Text(
                "₹${widget.expense.amountSpent}  ",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
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
      if (widget.expense.category == ExpenseCategory.values[i].name) {
        color = colorList[i];
      }
    }
    return color;
  }

  /// Delete Expense dialog
  Future<bool?> _confirmDismiss() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () => BlocProvider.of<ExpensesBloc>(context)
                  .add(ExpensesDeleteEvent(widget.expense)),
              child: const Text(
                "DELETE",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  _onDeletePressed() async {
    if (DateTime.now()
        .subtract(const Duration(days: 8))
        .isAfter(widget.expense.createdOn ?? DateTime.parse('2023-01-01'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot delete an expense older than 7 days',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 189, 16, 3),
        ),
      );
      return;
    }
    await _confirmDismiss();
  }

  _onEditPressed() {
    if (DateTime.now()
        .subtract(const Duration(days: 8))
        .isAfter(widget.expense.createdOn ?? DateTime.parse('2023-01-01'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot edit an expense older than 7 days',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 189, 16, 3),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrEditExpensePage(
          expense: widget.expense,
          editMode: true,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
