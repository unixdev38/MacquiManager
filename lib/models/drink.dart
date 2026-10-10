class DrinkVariant {
  final String id;
  final String drinkId;
  final String name; // ex: Petite, Grande, 33cl, 65cl
  final String formatLabel; // ex: 33cl, 65cl
  final String imageEmoji; // emoji fallback for maquette
  final String imageUrl; // placeholder url
  final int priceBuy;
  final int priceSell;
  final int bottlesPerCarton;
  final bool isActive;
  final String? description;

  DrinkVariant({
    required this.id,
    required this.drinkId,
    required this.name,
    required this.formatLabel,
    required this.imageEmoji,
    required this.imageUrl,
    required this.priceBuy,
    required this.priceSell,
    required this.bottlesPerCarton,
    this.isActive = true,
    this.description,
  });

  DrinkVariant copyWith({bool? isActive, int? priceSell, int? priceBuy}) {
    return DrinkVariant(
      id: id,
      drinkId: drinkId,
      name: name,
      formatLabel: formatLabel,
      imageEmoji: imageEmoji,
      imageUrl: imageUrl,
      priceBuy: priceBuy ?? this.priceBuy,
      priceSell: priceSell ?? this.priceSell,
      bottlesPerCarton: bottlesPerCarton,
      isActive: isActive ?? this.isActive,
      description: description,
    );
  }
}

class Drink {
  final String id;
  final String name;
  final String shortName;
  final String brand;
  final String categoryId;
  final List<DrinkVariant> variants;
  final bool isActive;

  Drink({
    required this.id,
    required this.name,
    required this.shortName,
    required this.brand,
    required this.categoryId,
    required this.variants,
    this.isActive = true,
  });
}

class OrderItem {
  final String variantId;
  final String drinkName;
  final String variantName;
  final String formatLabel;
  final String imageEmoji;
  final String imageUrl;
  final int unitPrice;
  int quantity;

  OrderItem({
    required this.variantId,
    required this.drinkName,
    required this.variantName,
    required this.formatLabel,
    required this.imageEmoji,
    required this.imageUrl,
    required this.unitPrice,
    this.quantity = 1,
  });

  int get subtotal => unitPrice * quantity;

  OrderItem copyWith({int? quantity}) => OrderItem(
        variantId: variantId,
        drinkName: drinkName,
        variantName: variantName,
        formatLabel: formatLabel,
        imageEmoji: imageEmoji,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );
}
