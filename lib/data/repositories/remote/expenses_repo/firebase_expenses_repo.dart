import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/domain/exceptions/app_exception.dart';
import '/data/models/expenses_model.dart';
import '/core/utils/colored_log.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';

class FirebaseExpensesRepository implements ExpensesRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _expensesCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('expenses');
  @override
  Future<void> addExpense(Expenses expense) async {
    await _expensesCollection
        .doc(expense.id)
        .set(expense.toMap())
        .then((doc) => Fluttertoast.showToast(msg: 'Data added successfully'))
        .catchError(AppExceptionHandler.handleFirebaseException);
  }

  @override
  Future<void> deleteExpense(Expenses expense) async {
    await _expensesCollection
        .doc(expense.id)
        .delete()
        .then((val) =>
            Fluttertoast.showToast(msg: '$expense,deleted successfully'))
        .catchError(AppExceptionHandler.handleFirebaseException);
  }

  @override
  Future<List<Expenses>> fetchCategoryExpenses(ExpenseCategory category) async {
    List<Expenses> listOfExpenses = [];
    try {
      QuerySnapshot querySnapshot = await _expensesCollection
          .where('category', isEqualTo: category.name)
          .get();

      for (var doc in querySnapshot.docs) {
        listOfExpenses
            .add(Expenses.fromMap(doc.data() as Map<String, dynamic>));
      }
      if (listOfExpenses.isEmpty) {
        throw NotFoundException('No Expenses found');
      }
      return listOfExpenses;
    } catch (e) {
      ColoredLog.red(e, name: 'fetchCategoryExpenses Error');
      AppExceptionHandler.handleFirebaseException(e);
    }
    return listOfExpenses;
  }

  @override
  Future<List<Expenses>> getAllExpenses() async {
    List<Expenses> listOfExpenses = [];
    try {
      QuerySnapshot querySnapshot = await _expensesCollection.get();

      for (var doc in querySnapshot.docs) {
        listOfExpenses
            .add(Expenses.fromMap(doc.data() as Map<String, dynamic>));
      }
      if (listOfExpenses.isEmpty) {
        throw NotFoundException('No Expenses found');
      }
      return listOfExpenses;
    } catch (e) {
      ColoredLog.red(e, name: 'fetchCategoryExpenses Error');
      AppExceptionHandler.handleFirebaseException(e);
    }
    return listOfExpenses;
  }
}
