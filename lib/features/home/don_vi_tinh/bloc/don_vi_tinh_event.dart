sealed class DonViTinhEvent {}

class DonViTinhEventStart extends DonViTinhEvent {}

class DonViTinhEventGetAll extends DonViTinhEvent {}

class DonViTinhEventCreate extends DonViTinhEvent {
  final String tenDonVi;

  DonViTinhEventCreate({
    required this.tenDonVi,
  });
}

class DonViTinhEventUpdate extends DonViTinhEvent {
  final String maDonVi;
  final String tenDonVi;

  DonViTinhEventUpdate({
    required this.maDonVi,
    required this.tenDonVi,
  });
}

class DonViTinhEventDelete extends DonViTinhEvent {
  final String maDonVi;

  DonViTinhEventDelete({
    required this.maDonVi,
  });
}
