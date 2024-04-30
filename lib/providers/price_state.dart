import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/price/get_all_prices_model.dart';
import 'package:pract_01/services/price_service.ts.dart';

import 'package:provider/provider.dart' as provider;

class PriceState with ChangeNotifier {
  List<PriceModelData> _prices = [];
  List<PriceModelData> _fullprices = [];
  List<PriceModelData> _originalPrices = [];
  bool _arePricesLoaded = false;

  List<PriceModelData> get prices => _prices;
  List<PriceModelData> get fullprices => _fullprices;

  bool get arePricesLoaded => _arePricesLoaded;

  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void setPrices(List<PriceModelData> prices) {
    _prices = prices;
    _originalPrices = List<PriceModelData>.from(prices);
    setPricesCount(prices.length);
    notifyListeners();
  }

  void setArePricesLoaded(bool value) {
    _arePricesLoaded = value;
    notifyListeners();
  }

  void filterPrices(String searchText) {
    searchText = searchText.toLowerCase();
    if (searchText.isEmpty) {
      _fullprices = List.from(_originalPrices);
    } else {
      _fullprices = _originalPrices.where((price) {
        final nameLower = price.attributes.name
            .toLowerCase(); // Convertir el nombre del producto a minúsculas
        return nameLower
            .contains(searchText); // Realizar la comparación en minúsculas
      }).toList();
    }
    notifyListeners();
  }

  void updatePriceProvider(PriceModelData updatedPrice) {
    final index = _prices.indexWhere((q) => q.id == updatedPrice.id);
    if (index != -1) {
      _prices[index] = updatedPrice;
      updatePricesCount();
      notifyListeners();
    }
  }

  void updatePricesCount() {
    notifyListeners();
  }

  void setPricesCount(int count) {
    notifyListeners();
  }

  void markNewNotificationAvailable() {
    newNotificationAvailable = true;
    notifyListeners();
  }

  void loadFullPrices(BuildContext context) async {
    _arePricesLoaded = false;
    // notifyListeners(); // Notifica que está cargando

    try {
      PriceService service =
          provider.Provider.of<PriceService>(context, listen: false);
      var newPrices = await service.getAllPrice();
      _fullprices = newPrices.data;
      _arePricesLoaded = true;
      // Actualiza el estado con los nuevos pagos
      setPrices(newPrices.data);
      setArePricesLoaded(true);
      notifyListeners();
    } catch (error) {
      _arePricesLoaded = false;
      notifyListeners(); // Notifica que la carga falló
      if (kDebugMode) {
        print("Error loading new Prices: $error");
      }
    }
  }

  int get pricesCount => _prices.length;
}
