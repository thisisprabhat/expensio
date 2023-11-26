import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/domain/exceptions/app_exception.dart';
import '/data/models/expenses_model.dart';
import '/core/utils/colored_log.dart' show ColoredLog;
import '/data/repositories/app_repository.dart';
import '/data/repositories/common_interfaces/expenses_repo_interface.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final ExpensesRepository _repo = AppRepository().expensesRepository;
  List<Expenses> listOfExpenses = [];
  List<Expenses> listOfCategoryExpenses = [];
  List<Expenses> searchExpensesList = [];

  ExpensesBloc() : super(ExpensesInitialState()) {
    on<ExpensesLoadEvent>(_loadExpensesEvent);
    on<ExpensesAddEvent>(_addExpenseEvent);
    on<ExpensesDeleteEvent>(_deleteExpenseEvent);
    on<ExpensesUpdateEvent>(_updateExpenseEvent);
    on<ExpensesLoadCategoryEvent>(_loadExpensesCategory);
    on<ExpensesSearchEvent>(_searchExpensesEvent);
  }

  FutureOr<void> _loadExpensesEvent(
      ExpensesLoadEvent event, Emitter<ExpensesState> emit) async {
    ColoredLog.cyan('loadExpensesEvent initiated', name: "Event Triggered");
    listOfExpenses.clear();
    try {
      final List<Expenses> expenses = await _repo.getAllExpenses();
      listOfExpenses.addAll(expenses);
      emit(ExpensesLoadedState(listOfExpenses));
    } on AppException catch (e) {
      e.print;
      emit(ExpensesErrorState(e));
    } catch (e) {
      ColoredLog.red(e, name: 'Load Expenses Error');
    }
  }

  FutureOr<void> _addExpenseEvent(
      ExpensesAddEvent event, Emitter<ExpensesState> emit) async {
    ColoredLog.cyan('addExpenseEvent initiated', name: "Event Triggered");
    try {
      await _repo.addExpense(event.expense);
    } on AppException catch (e) {
      e.print;
    } catch (e) {
      ColoredLog.red(e, name: 'Load Expenses Error');
    }
  }

  FutureOr<void> _deleteExpenseEvent(
      ExpensesDeleteEvent event, Emitter<ExpensesState> emit) async {
    ColoredLog.cyan('deleteExpenseEvent initiated', name: "Event Triggered");
    try {
      await _repo.deleteExpense(event.expense);
    } on AppException catch (e) {
      e.print;
    } catch (e) {
      ColoredLog.red(e, name: 'Load Expenses Error');
    }
  }

  FutureOr<void> _updateExpenseEvent(
      ExpensesUpdateEvent event, Emitter<ExpensesState> emit) async {
    ColoredLog.cyan('updateExpenseEvent initiated', name: "Event Triggered");

    try {
      await _repo.addExpense(event.expense);
    } on AppException catch (e) {
      e.print;
    } catch (e) {
      ColoredLog.red(e, name: 'Load Expenses Error');
    }
  }

  FutureOr<void> _loadExpensesCategory(
      ExpensesLoadCategoryEvent event, Emitter<ExpensesState> emit) async {
    ColoredLog.cyan('loadExpensesCategory initiated', name: "Event Triggered");
    listOfCategoryExpenses.clear();
    try {
      final List<Expenses> expenses =
          await _repo.fetchCategoryExpenses(event.category);
      listOfCategoryExpenses.addAll(expenses);
      emit(ExpensesLoadedState(listOfCategoryExpenses));
    } on AppException catch (e) {
      e.print;
      emit(ExpensesErrorState(e));
    } catch (e) {
      ColoredLog.red(e, name: 'Load Expenses Category Error');
    }
  }

  FutureOr<void> _searchExpensesEvent(
      ExpensesSearchEvent event, Emitter<ExpensesState> emit) {
    ColoredLog.cyan('searchExpensesEvent initiated', name: "Event Triggered");

    searchExpensesList.clear();
    List<Expenses> tempList = listOfExpenses
        .where((element) => element.title.toString().contains(event.searchText))
        .toList();
    searchExpensesList.addAll(tempList);
  }
}
