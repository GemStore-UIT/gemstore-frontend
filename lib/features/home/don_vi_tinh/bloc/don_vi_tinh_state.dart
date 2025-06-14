import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class DonViTinhState {}

class DonViTinhInitial extends DonViTinhState {}

class DonViTinhLoading extends DonViTinhState {}

class DonViTinhFetchingSuccess extends DonViTinhState {
  final List<TableRowData> data;

  DonViTinhFetchingSuccess(this.data);
}

class DonViTinhFetchingFailure extends DonViTinhState {
  final String error;

  DonViTinhFetchingFailure(this.error);
}
