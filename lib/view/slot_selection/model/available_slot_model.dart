// To parse this JSON data, do
//
//     final availableSlotMoldel = availableSlotMoldelFromJson(jsonString);

import 'dart:convert';

AvailableSlotMoldel availableSlotMoldelFromJson(String str) => AvailableSlotMoldel.fromJson(json.decode(str));

String availableSlotMoldelToJson(AvailableSlotMoldel data) => json.encode(data.toJson());

class AvailableSlotMoldel {
    String? status;
    List<AvailableSlot>? availableSlots;

    AvailableSlotMoldel({
        this.status,
        this.availableSlots,
    });

    factory AvailableSlotMoldel.fromJson(Map<String, dynamic> json) => AvailableSlotMoldel(
        status: json["status"],
        availableSlots: json["available_slots"] == null ? [] : List<AvailableSlot>.from(json["available_slots"]!.map((x) => AvailableSlot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "available_slots": availableSlots == null ? [] : List<dynamic>.from(availableSlots!.map((x) => x.toJson())),
    };
}

class AvailableSlot {
    int? id;
    DateTime? date;
    Slot? slot;
    bool? isBooked;

    AvailableSlot({
        this.id,
        this.date,
        this.slot,
        this.isBooked,
    });

    factory AvailableSlot.fromJson(Map<String, dynamic> json) => AvailableSlot(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slot: json["slot"] == null ? null : Slot.fromJson(json["slot"]),
        isBooked: json["is_booked"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "slot": slot?.toJson(),
        "is_booked": isBooked,
    };
}

class Slot {
    int? id;
    String? slotStart;
    String? slotEnd;

    Slot({
        this.id,
        this.slotStart,
        this.slotEnd,
    });

    factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        slotStart: json["slot_start"],
        slotEnd: json["slot_end"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slot_start": slotStart,
        "slot_end": slotEnd,
    };
}
