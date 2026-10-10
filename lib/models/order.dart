import 'drink.dart';

enum OrderStatus { open, pendingPayment, paid, cancelled }

class Order {
  final String id;
  final String reference;
  final String tableId;
  final String tableLabel;
  final DateTime createdAt;
  final List<OrderItem> items;
  final OrderStatus status;
  final String? paymentMethod;
  final int? amountPaid;
  final String? serverName;

  Order({
    required this.id,
    required this.reference,
    required this.tableId,
    required this.tableLabel,
    required this.createdAt,
    required this.items,
    this.status = OrderStatus.open,
    this.paymentMethod,
    this.amountPaid,
    this.serverName,
  });

  int get total => items.fold(0, (sum, i) => sum + i.subtotal);
  int get itemsCount => items.fold(0, (sum, i) => sum + i.quantity);
  int get remaining => total - (amountPaid ?? 0);

  Order copyWith({
    OrderStatus? status,
    String? paymentMethod,
    int? amountPaid,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id,
      reference: reference,
      tableId: tableId,
      tableLabel: tableLabel,
      createdAt: createdAt,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaid: amountPaid ?? this.amountPaid,
      serverName: serverName,
    );
  }
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.open:
        return "En cours";
      case OrderStatus.pendingPayment:
        return "À payer";
      case OrderStatus.paid:
        return "Payée";
      case OrderStatus.cancelled:
        return "Annulée";
    }
  }
}
