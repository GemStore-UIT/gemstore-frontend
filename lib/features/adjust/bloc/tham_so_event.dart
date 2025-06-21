class ThamSoEvent {}

class ThamSoEventStart extends ThamSoEvent {}

class ThamSoEventGetAll extends ThamSoEvent {}

class ThamSoEventUpdate extends ThamSoEvent {
  final String tenThamSo;
  final String giaTri;

  ThamSoEventUpdate(this.tenThamSo, this.giaTri);
}