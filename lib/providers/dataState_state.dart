import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/services/state_quotation_service.dart';
import 'package:provider/provider.dart';

class DataStateState with ChangeNotifier {
  List<DataState> _dataStates = [];
  List<DataState> _originalDataStates = [];
  int _dataStatesCount = 0;
  bool _areDataStatesLoaded = false;

  // List<DataState> get dataStates => _dataStates;
  int get productsCount => _dataStatesCount;
  bool get areDataStatesLoaded => _areDataStatesLoaded;
  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void initialize(BuildContext context) async {
    StateService service = Provider.of<StateService>(context, listen: false);
    await service.initializeStates();
    _dataStates = await service.getCachedDataStates();
    notifyListeners();
  }

  List<DataState> get dataStates => _dataStates;

  // En DataStateState
  void loadNewDataStates(BuildContext context) async {
    try {
      StateService service = Provider.of<StateService>(context, listen: false);
      StateModel newDataStates = await service.getState();

      // Actualiza el estado con los nuevos dataStateos
      setDataStates(newDataStates.data);
      setAreDataStatesLoaded(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error loadNewDataStates: $e');
      }
      setAreDataStatesLoaded(false);
    }
  }

  set dataStates(List<DataState> newDataStates) {
    _dataStates = newDataStates;
    notifyListeners();
  }

  void addDataState(DataState dataState) {
    _dataStates.add(dataState);
    notifyListeners();
  }

  void setDataStatesCount(int count) {
    _dataStatesCount = count;
    notifyListeners();
  }

  void updateDataState(DataState updatedDataState) {
    int index = _dataStates.indexWhere((p) => p.id == updatedDataState.id);
    if (index != -1) {
      _dataStates[index] = updatedDataState;
      notifyListeners();
    }
  }

  void setAreDataStatesLoaded(bool value) {
    _areDataStatesLoaded = value;
    notifyListeners();
  }

  void setDataStates(List<DataState> dataStates) {
    _dataStates = dataStates;
    _originalDataStates = List<DataState>.from(dataStates);
    setDataStatesCount(dataStates.length);
    notifyListeners();
  }

  void filterDataStates(String searchText) {
    if (searchText.isEmpty) {
      _dataStates = List<DataState>.from(_originalDataStates);
    } else {
      final filteredDataStates = _originalDataStates.where((dataState) {
        final code = dataState.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _dataStates = filteredDataStates;
    }
    notifyListeners();
  }

  void updateDataStatesCount() {
    _dataStatesCount = _dataStates.length;
    notifyListeners();
  }

  void removeDataState(int dataStateId) {
    _dataStates.removeWhere((dataState) => dataState.id == dataStateId);
    updateDataStatesCount();
    notifyListeners();
  }

  int get dataStatesCount => _dataStates.length;
}
