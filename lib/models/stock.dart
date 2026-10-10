enum StockMovementType { reception, sale, correction, loss }

class StockItem {
  final String variantId;
  final String drinkName;
  final String variantName;
  final String formatLabel;
  final String imageEmoji;
  final int bottlesPerCarton;
  int quantityRemaining;
  final int threshold;

  StockItem({
    required this.variantId,
    required this.drinkName,
    required this.variantName,
    required this.formatLabel,
    required this.imageEmoji,
    required this.bottlesPerCarton,
    required this.quantityRemaining,
    this.threshold = 12,
  });

  bool get isLow => quantityRemaining <= threshold;
  bool get isCritical => quantityRemaining <= threshold / 2;
  int get cartonsRemaining => (quantityRemaining / bottlesPerCarton).floor();
}

class StockMovement {
  final String id;
  final String variantId;
  final String drinkLabel;
  final StockMovementType type;
  final int quantity; // in bottles
  final int cartons;
  final DateTime date;
  final String? note;
  final String? serverName;

  StockMovement({
    required this.id,
    required this.variantId,
    required this.drinkLabel,
    required this.type,
    required this.quantity,
    required this.cartons,
    required this.date,
    this.note,
    this.serverName,
  });
}

extension StockMovementTypeX on StockMovementType {
  String get label {
    switch (this) {
      case StockMovementType.reception:
        return "Réception";
      case StockMovementType.sale:
        return "Vente";
      case StockMovementType.correction:
        return "Correction";
      case StockMovementType.loss:
        return "Perte/Casse";
    }
  }
}
