class BaoCaoEvent {}

class BaoCaoEventStart extends BaoCaoEvent {}

class BaoCaoEventGet extends BaoCaoEvent {
  final int thang;
  final int nam;

  BaoCaoEventGet(this.thang, this.nam);
}