import 'package:hive_flutter/adapters.dart';

import '/data/models/expenses_model.dart';
import '/core/utils/colored_log.dart';

import '/domain/exceptions/app_exception.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';

class HiveExpensesRepository implements ExpensesRepository {
  @override
  Future<void> addExpense(Expenses expense) async {
    try {
      var box = Hive.box<Expenses>(ExpensesRepository.expensesCollection);
      box.put(expense.id, expense);
      ColoredLog.green(expense, name: "Expense Saved");
    } catch (e) {
      ColoredLog.red(e, name: 'SaveExpense Error');
      throw AppException(message: e.toString(), exceptionType: 'SaveException');
    }
  }

  @override
  Future<void> deleteExpense(Expenses expense) async {
    try {
      var box = Hive.box<Expenses>(ExpensesRepository.expensesCollection);
      box.delete(expense.id);
      ColoredLog.green(expense, name: "Expense deleted");
    } catch (e) {
      ColoredLog.red(e, name: 'deleteExpense Error');
      throw AppException(
          message: e.toString(), exceptionType: 'DeleteException');
    }
  }

  @override
  Future<List<Expenses>> fetchCategoryExpenses(ExpenseCategory category) async {
    List<Expenses> expensesList = [];
    try {
      var box = Hive.box<Expenses>(ExpensesRepository.expensesCollection);
      expensesList = box.values
          .toList()
          .where((element) => element.category == category.name)
          .toList();

      ColoredLog.green('Length ${expensesList.length}',
          name: 'Getting Expense List');
      if (expensesList.isEmpty) {
        throw NotFoundException('No Expenses found');
      }
      return expensesList;
    } catch (e) {
      ColoredLog(e, name: 'Fetch CategoryExpenses Error');
      throw AppException(
          exceptionType: "Fetch CategoryExpenses", message: e.toString());
    }
  }

  @override
  Future<List<Expenses>> getAllExpenses() async {
    List<Expenses> expensesList = [];
    try {
      var box = Hive.box<Expenses>(ExpensesRepository.expensesCollection);
      expensesList = box.values.toList();

      ColoredLog.green('Length ${expensesList.length}',
          name: 'Getting Expense List');
      if (expensesList.isEmpty) {
        throw NotFoundException('No Expenses found');
      }
      return expensesList;
    } catch (e) {
      ColoredLog(e, name: 'Fetch allExpenses Error');
      throw AppException(
          exceptionType: "Fetch allExpenses", message: e.toString());
    }
  }
}