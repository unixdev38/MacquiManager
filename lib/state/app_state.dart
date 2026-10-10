import 'package:flutter/foundation.dart';
import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/drink.dart';
import '../models/table_model.dart';
import '../models/order.dart';
import '../models/stock.dart';

class AppState extends ChangeNotifier {
  // Data
  List<Category> categories = MockData.categories;
  List<Drink> drinks = MockData.drinks;
  List<TableModel> tables = MockData.tables;
  List<Order> orders = List.from(MockData.orders);
  List<Order> history = List.from(MockData.history);
  List<StockItem> stock = List.from(MockData.stock);
  List<StockMovement> movements = List.from(MockData.movements);

  // Sale state
  String selectedCategoryId = 'all';
  TableModel? selectedTable;
  List<OrderItem> currentCart = [];
  String? lastOrderReference;

  // Settings
  String maquisName = "Maquis Le Calao";
  String serverName = "Awa";
  String centralAddress = "192.168.1.100:8080";
  bool isConnected = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  AppState() {
    selectedTable = tables.firstWhere((t) => t.status == TableStatus.free, orElse: () => tables.first);
  }

  // Category filter
  void selectCategory(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  List<DrinkVariant> get filteredVariants {
    if (selectedCategoryId == 'all') {
      return MockData.allVariants.where((v) => v.isActive).toList();
    }
    final drinkIds = drinks.where((d) => d.categoryId == selectedCategoryId).map((d) => d.id).toSet();
    return MockData.allVariants.where((v) => drinkIds.contains(v.drinkId) && v.isActive).toList();
  }

  // Table
  void selectTable(TableModel table) {
    selectedTable = table;
    notifyListeners();
  }

  // Cart operations
  void addToCart(DrinkVariant variant) {
    final drink = drinks.firstWhere((d) => d.id == variant.drinkId);
    final existingIndex = currentCart.indexWhere((item) => item.variantId == variant.id);
    if (existingIndex >= 0) {
      currentCart[existingIndex].quantity++;
    } else {
      currentCart.add(OrderItem(
        variantId: variant.id,
        drinkName: drink.shortName,
        variantName: variant.name,
        formatLabel: variant.formatLabel,
        imageEmoji: variant.imageEmoji,
        imageUrl: variant.imageUrl,
        unitPrice: variant.priceSell,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void addMultipleToCart(DrinkVariant variant, int qty) {
    for (int i = 0; i < qty; i++) {
      addToCart(variant);
    }
  }

  void incrementCartItem(String variantId) {
    final idx = currentCart.indexWhere((e) => e.variantId == variantId);
    if (idx >= 0) {
      currentCart[idx].quantity++;
      notifyListeners();
    }
  }

  void decrementCartItem(String variantId) {
    final idx = currentCart.indexWhere((e) => e.variantId == variantId);
    if (idx >= 0) {
      if (currentCart[idx].quantity > 1) {
        currentCart[idx].quantity--;
      } else {
        currentCart.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String variantId) {
    currentCart.removeWhere((e) => e.variantId == variantId);
    notifyListeners();
  }

  void clearCart() {
    currentCart.clear();
    notifyListeners();
  }

  int get cartTotal => currentCart.fold(0, (sum, item) => sum + item.subtotal);
  int get cartCount => currentCart.fold(0, (sum, item) => sum + item.quantity);
  int getQuantityForVariant(String variantId) {
    final item = currentCart.where((e) => e.variantId == variantId);
    if (item.isEmpty) return 0;
    return item.first.quantity;
  }

  // Validate order
  Order? validateCurrentOrder() {
    if (currentCart.isEmpty || selectedTable == null) return null;
    final now = DateTime.now();
    final ref = 'CMD-${now.year}-${(orders.length + history.length + 87).toString().padLeft(3, '0')}';
    final order = Order(
      id: 'o${DateTime.now().millisecondsSinceEpoch}',
      reference: ref,
      tableId: selectedTable!.id,
      tableLabel: selectedTable!.label,
      createdAt: now,
      items: List.from(currentCart.map((e) => e.copyWith())),
      status: OrderStatus.open,
      serverName: serverName,
    );
    orders.insert(0, order);
    lastOrderReference = ref;

    // Update table status
    final tableIdx = tables.indexWhere((t) => t.id == selectedTable!.id);
    if (tableIdx >= 0) {
      tables[tableIdx] = tables[tableIdx].copyWith(status: TableStatus.busy, currentOrderCount: order.itemsCount);
    }

    // Update stock (simulate sale)
    for (var item in currentCart) {
      final stockIdx = stock.indexWhere((s) => s.variantId == item.variantId);
      if (stockIdx >= 0) {
        stock[stockIdx].quantityRemaining -= item.quantity;
        if (stock[stockIdx].quantityRemaining < 0) stock[stockIdx].quantityRemaining = 0;
      }
      movements.insert(0, StockMovement(
        id: 'm${DateTime.now().millisecondsSinceEpoch}_${item.variantId}',
        variantId: item.variantId,
        drinkLabel: '${item.drinkName} ${item.variantName}',
        type: StockMovementType.sale,
        quantity: item.quantity,
        cartons: 0,
        date: now,
        serverName: serverName,
      ));
    }

    currentCart.clear();
    notifyListeners();
    return order;
  }

  // Payment
  void payOrder(String orderId, String method, int amount) {
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      final order = orders[idx];
      final newPaid = (order.amountPaid ?? 0) + amount;
      final isFullyPaid = newPaid >= order.total;
      orders[idx] = order.copyWith(
        status: isFullyPaid ? OrderStatus.paid : OrderStatus.pendingPayment,
        paymentMethod: method,
        amountPaid: newPaid,
      );
      if (isFullyPaid) {
        // Move to history
        history.insert(0, orders[idx]);
        orders.removeAt(idx);
        // Free table?
        final tableIdx = tables.indexWhere((t) => t.id == order.tableId);
        if (tableIdx >= 0) {
          tables[tableIdx] = tables[tableIdx].copyWith(status: TableStatus.free, currentOrderCount: 0);
        }
      }
      notifyListeners();
    }
  }

  // Stock reception
  void receiveStock(String variantId, int cartons) {
    final stockIdx = stock.indexWhere((s) => s.variantId == variantId);
    if (stockIdx >= 0) {
      final item = stock[stockIdx];
      final bottles = cartons * item.bottlesPerCarton;
      item.quantityRemaining += bottles;
      movements.insert(0, StockMovement(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        variantId: variantId,
        drinkLabel: '${item.drinkName} ${item.variantName}',
        type: StockMovementType.reception,
        quantity: bottles,
        cartons: cartons,
        date: DateTime.now(),
        serverName: serverName,
        note: 'Réception $cartons cartons',
      ));
      notifyListeners();
    }
  }

  void correctStock(String variantId, int newQuantity) {
    final idx = stock.indexWhere((s) => s.variantId == variantId);
    if (idx >= 0) {
      final old = stock[idx].quantityRemaining;
      stock[idx].quantityRemaining = newQuantity;
      movements.insert(0, StockMovement(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        variantId: variantId,
        drinkLabel: '${stock[idx].drinkName} ${stock[idx].variantName}',
        type: StockMovementType.correction,
        quantity: newQuantity - old,
        cartons: 0,
        date: DateTime.now(),
        note: 'Correction $old -> $newQuantity',
        serverName: serverName,
      ));
      notifyListeners();
    }
  }

  // Drink management
  void toggleDrinkActive(String variantId) {
    for (var drink in drinks) {
      for (int i = 0; i < drink.variants.length; i++) {
        if (drink.variants[i].id == variantId) {
          drink.variants[i] = drink.variants[i].copyWith(isActive: !drink.variants[i].isActive);
        }
      }
    }
    notifyListeners();
  }

  // Stats
  int get totalSalesToday {
    final today = DateTime.now();
    return history.where((o) => o.createdAt.day == today.day && o.createdAt.month == today.month).fold(0, (sum, o) => sum + o.total);
  }

  int get openOrdersCount => orders.length;
  int get pendingPaymentCount => orders.where((o) => o.status == OrderStatus.pendingPayment).length;

  List<MapEntry<String, int>> get topDrinks {
    final Map<String, int> counts = {};
    for (var order in [...orders, ...history]) {
      for (var item in order.items) {
        counts[item.drinkName] = (counts[item.drinkName] ?? 0) + item.quantity;
      }
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }
}
