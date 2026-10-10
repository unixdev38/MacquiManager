enum TableStatus { free, busy, billPending }

class TableModel {
  final String id;
  final String label; // T1, T2...
  final int number;
  final TableStatus status;
  final int? currentOrderCount; // nb articles en cours
  final int? seats;

  TableModel({
    required this.id,
    required this.label,
    required this.number,
    required this.status,
    this.currentOrderCount,
    this.seats = 4,
  });

  TableModel copyWith({TableStatus? status, int? currentOrderCount}) {
    return TableModel(
      id: id,
      label: label,
      number: number,
      status: status ?? this.status,
      currentOrderCount: currentOrderCount ?? this.currentOrderCount,
      seats: seats,
    );
  }
}

extension TableStatusX on TableStatus {
  String get label {
    switch (this) {
      case TableStatus.free:
        return "Libre";
      case TableStatus.busy:
        return "En service";
      case TableStatus.billPending:
        return "Addition";
    }
  }
}
