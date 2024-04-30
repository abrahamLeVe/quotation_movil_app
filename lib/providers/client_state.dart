import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/client/gat_all_client_model.dart';
import 'package:pract_01/services/client_service.dart';
import 'package:provider/provider.dart';

class ClientState with ChangeNotifier {
  List<ClientModel> _clients = [];
  List<ClientModel> _originalClients = [];
  int _clientsCount = 0;
  bool _areClientsLoaded = false;

  List<ClientModel> get clients => _clients;
  int get productsCount => _clientsCount;
  bool get areClientsLoaded => _areClientsLoaded;
  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void loadNewClients(BuildContext context) async {
    try {
      ClientService service =
          Provider.of<ClientService>(context, listen: false);
      List<ClientModel> newClients = await service.getClientAll();

      // Actualiza el estado con los nuevos Clientos
      setClients(newClients);
      setAreClientsLoaded(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error loadNewClients: $e');
      }
      setAreClientsLoaded(false);
    }
  }

  set clients(List<ClientModel> newClients) {
    _clients = newClients;
    notifyListeners();
  }

  void addClient(ClientModel client) {
    _clients.add(client);
    notifyListeners();
  }

  void setClientsCount(int count) {
    _clientsCount = count;
    notifyListeners();
  }

  void updateClient(ClientModel updatedClient) {
    int index = _clients.indexWhere((p) => p.id == updatedClient.id);
    if (index != -1) {
      _clients[index] = updatedClient;
      notifyListeners();
    }
  }

  void setAreClientsLoaded(bool value) {
    _areClientsLoaded = value;
    notifyListeners();
  }

  void setClients(List<ClientModel> clients) {
    _clients = clients;
    _originalClients = List<ClientModel>.from(clients);
    setClientsCount(clients.length);
    notifyListeners();
  }

  void filterClients(String searchText) {
    if (searchText.isEmpty) {
      _clients = List<ClientModel>.from(_originalClients);
    } else {
      final filteredClients = _originalClients.where((client) {
        final code = client.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _clients = filteredClients;
    }
    notifyListeners();
  }

  void updateClientsCount() {
    _clientsCount = _clients.length;
    notifyListeners();
  }

  void removeClient(int clientId) {
    _clients.removeWhere((client) => client.id == clientId);
    updateClientsCount();
    notifyListeners();
  }

  int get clientsCount => _clients.length;
}
