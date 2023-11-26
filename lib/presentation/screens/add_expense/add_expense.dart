import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '/core/utils/input_validation.dart';
import '/core/constants/styles.dart';
import '/core/utils/get_location.dart';
import '/core/utils/colored_log.dart';
import '/data/models/expenses_model.dart';
import '/domain/bloc/expenses_bloc/expenses_bloc.dart';
import '/domain/exceptions/app_exception.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';
import '/presentation/screens/add_expense/components/category_chip.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  ExpenseCategory selectedCategory = ExpenseCategory.others;
  String? locationName;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountSpentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add an Expense"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _key,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(paddingDefault),
                children: [
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    validator: InputValidator.expensesTitle,
                    decoration: const InputDecoration(
                      label: Text('Spent on'),
                      hintText: 'Enter the expenditure item name',
                    ),
                  ),
                  TextFormField(
                    controller: _amountSpentController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,4})')),
                    ],
                    validator: InputValidator.amountSpent,
                    decoration: const InputDecoration(
                      label: Text('Amount spent'),
                      hintText: 'Enter the amount of money spent',
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    // validator: InputValidator.name,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                      hintText: 'Describe the expense',
                    ),
                  ),
                  TextFormField(
                    controller: _platformController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Platform name'),
                      hintText: 'Enter the expenditure platform name',
                    ),
                  ),
                  Wrap(
                    children: [
                      ...List.generate(
                        ExpenseCategory.values.length,
                        (index) => CategoryChip(
                          category: ExpenseCategory.values[index],
                          selectedCategory: selectedCategory,
                          onTap: () {
                            setState(() {
                              selectedCategory = ExpenseCategory.values[index];
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(paddingDefault),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.maxFinite),
              child: ElevatedButton(
                onPressed: _addExpense,
                child: const Text('Add Expense'),
              ),
            ),
          )
        ],
      ),
    );
  }

  _addExpense() async {
    try {
      if (_key.currentState?.validate() ?? false) {
        Expenses expense = Expenses()
          ..title = _titleController.text.trim()
          ..amountSpent = double.tryParse(_amountSpentController.text.trim())
          ..description = _descriptionController.text.trim()
          ..platformName = _platformController.text.trim()
          ..location = locationName ?? 'N/A'
          ..category = selectedCategory.name
          ..createdOn = DateTime.now()
          ..id = const Uuid().v4();

        context.read<ExpensesBloc>().add(ExpensesAddEvent(expense));
        context.read<ExpensesBloc>().add(ExpensesLoadEvent());
        ColoredLog.yellow(expense, name: 'Expense');
      }
    } catch (e) {
      ColoredLog.red(e, name: 'Add expenses Error');
    }
    Navigator.pop(context);
  }

  _getPosition() async {
    try {
      final position = await determinePosition();
      locationName = await reverseGeocode(
          position?.latitude ?? 0.0, position?.longitude ?? 0.0);
    } on AppException catch (e) {
      e.print;
    }
  }
}
