import '/data/models/expenses_model.dart';

enum ExpenseCategory {
  shopping,
  food,
  health,
  travel,
  bills,
  others,
}

abstract class ExpensesRepository {
  static const expensesCollection = 'expenses';

  ///It fetches all the expenses available in db
  Future<List<Expenses>> getAllExpenses();

  /// It adds an expense record to a db
  Future<void> addExpense(Expenses expense);

  /// It removes an expense form db
  Future<void> deleteExpense(Expenses expense);

  ///It fetches the list of expenses of selected categories
  Future<List<Expenses>> fetchCategoryExpenses(ExpenseCategory category);
}
