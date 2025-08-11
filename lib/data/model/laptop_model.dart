class LaptopModel {
  int? laptopId;
  String? laptopBrand;
  String? laptopModel;
  String? processorType;
  String? processor;
  String? generation;
  String? ramSize;
  String? ramType;
  String? storageType;
  String? storageCapacity;
  String? extraStorageType;
  String? extraStorageCapacity;
  String? gpu;
  String? screenSize;
  String? batteryLife;
  String? operatingSystem;
  String? state;
  String? problem;
  int? touch;
  int? x360;
  int? backLight;
  int? fingerPrint;
  int? faceId;
  int? calculator;
  int? itemId; // Foreign key from tbl_items

  LaptopModel({
    this.laptopId,
    required this.laptopBrand,
    required this.laptopModel,
    required this.processorType,
    required this.processor,
    required this.generation,
    required this.ramSize,
    required this.ramType,
    required this.storageType,
    required this.storageCapacity,
    required this.extraStorageType,
    required this.extraStorageCapacity,
    this.gpu = '',
    required this.screenSize,
    required this.batteryLife,
    this.operatingSystem = '',
    this.state = '',
    this.problem = '',
    this.touch = 0,
    this.x360 = 0,
    this.backLight = 0,
    this.fingerPrint = 0,
    this.faceId = 0,
    this.calculator = 0,
    required this.itemId,
  });

  // Convert a LaptopModel into a Map. The keys correspond to the table column names.
  Map<String, dynamic> toMap() {
    return {
      'laptop_id': laptopId,
      'laptop_brand': laptopBrand,
      'laptop_model': laptopModel,
      'processor_type': processorType,
      'processor': processor,
      'generation': generation,
      'ram_size': ramSize,
      'ram_type': ramType,
      'storage_type': storageType,
      'storage_capacity': storageCapacity,
      'extra_storage_type': extraStorageType,
      'extra_storage_capacity': extraStorageCapacity,
      'gpu': gpu,
      'screen_size': screenSize,
      'battery_life': batteryLife,
      'operating_system': operatingSystem,
      'state': state,
      'problem': problem,
      'touch': touch,
      'x360': x360,
      'back_light': backLight,
      'finger_print': fingerPrint,
      'face_id': faceId,
      'calculator': calculator,
      'item_id': itemId,
    };
  }

  // Create a LaptopModel from a Map (typically from a database row).
  factory LaptopModel.fromJson(Map<String, dynamic> map) {
    return LaptopModel(
      laptopId: map['laptop_id'],
      laptopBrand: map['laptop_brand'],
      laptopModel: map['laptop_model'],
      processorType: map['processor_type'],
      processor: map['processor'],
      generation: map['generation'],
      ramSize: map['ram_size'],
      ramType: map['ram_type'],
      storageType: map['storage_type'],
      storageCapacity: map['storage_capacity'],
      extraStorageType: map['extra_storage_type'],
      extraStorageCapacity: map['extra_storage_capacity'],
      gpu: map['gpu'] ?? '',
      screenSize: map['screen_size'],
      batteryLife: map['battery_life'],
      operatingSystem: map['operating_system'] ?? '',
      state: map['state'] ?? '',
      problem: map['problem'] ?? '',
      touch: map['touch'] ?? 0,
      x360: map['x360'] ?? 0,
      backLight: map['back_light'] ?? 0,
      fingerPrint: map['finger_print'] ?? 0,
      faceId: map['face_id'] ?? 0,
      calculator: map['calculator'] ?? 0,
      itemId: map['item_id'],
    );
  }
}
