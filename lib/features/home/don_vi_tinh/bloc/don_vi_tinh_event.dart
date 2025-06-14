sealed class DonViTinhEvent {}

class DonViTinhEventStart extends DonViTinhEvent {}

class DonViTinhEventGetAll extends DonViTinhEvent {}

class DonViTinhEventGetById extends DonViTinhEvent {
  final String maDonVi;

  DonViTinhEventGetById(this.maDonVi);
}

class DonViTinhEventAdd extends DonViTinhEvent {
  final String tenDonVi;

  DonViTinhEventAdd({
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
