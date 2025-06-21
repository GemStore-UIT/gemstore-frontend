import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/features/adjust/bloc/tham_so_bloc.dart';
import 'package:gemstore_frontend/features/adjust/bloc/tham_so_event.dart';
import 'package:gemstore_frontend/features/adjust/bloc/tham_so_state.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_state.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_state.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_state.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_state.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_event.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_state.dart';
import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_state.dart';
import 'package:gemstore_frontend/models/loai_dich_vu.dart';
import 'package:gemstore_frontend/models/loai_san_pham.dart';
import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/models/phieu_ban_hang.dart';
import 'package:gemstore_frontend/models/phieu_dich_vu.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/models/tham_so.dart';
import 'package:gemstore_frontend/screens/home/view_list/bao_cao_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/danh_sach_san_pham_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/phieunhapxuat/phieu_ban_hang_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/phieunhapxuat/phieu_dich_vu_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/phieunhapxuat/phieu_mua_hang_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/quanlythongtin/don_vi_tinh_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/quanlythongtin/loai_dich_vu_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/quanlythongtin/loai_san_pham_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/quanlythongtin/nha_cung_cap_screen.dart';
import 'package:gemstore_frontend/screens/home/view_list/tham_so_screen.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/error_dialog.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Thêm biến để quản lý dialog state
class _HomeScreenState extends State<HomeScreen> {
  String? selectedFunction;
  String? selectedTitle;
  bool isInfoManagementExpanded = true;
  bool isInvoiceManagementExpanded = true;

  // Thêm biến để quản lý error dialog
  bool _isErrorDialogShowing = false;
  final List<String> _pendingErrors = [];

  List<NhaCungCap> _nhaCungCaps = [];
  List<DonViTinh> _donViTinhs = [];
  List<LoaiSanPham> _loaiSanPhams = [];
  List<LoaiDichVu> _loaiDichVus = [];
  List<PhieuMuaHang> _phieuMuaHangs = [];
  List<PhieuBanHang> _phieuBanHangs = [];
  List<PhieuDichVu> _phieuDichVus = [];
  List<SanPham> _sanPhams = [];
  List<ThamSo> _thamSos = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PhieuMuaHangBloc, PhieuMuaHangState>(
          listener: (context, state) {
            if (state is PhieuMuaHangStateUpdated) {
              setState(() {
                _phieuMuaHangs = state.data;
                context.read<SanPhamBloc>().add(SanPhamEventGetAll());
              });
            } else if (state is PhieuMuaHangStateFailure) {
              _handleError("Lỗi phiếu mua hàng: ${state.error}");
            }
          },
        ),
        BlocListener<PhieuBanHangBloc, PhieuBanHangState>(
          listener: (context, state) {
            if (state is PhieuBanHangStateUpdated) {
              setState(() {
                _phieuBanHangs = state.data;
                context.read<SanPhamBloc>().add(SanPhamEventGetAll());
              });
            } else if (state is PhieuBanHangStateFailure) {
              _handleError("Lỗi phiếu bán hàng: ${state.error}");
            }
          },
        ),
        BlocListener<PhieuDichVuBloc, PhieuDichVuState>(
          listener: (context, state) {
            if (state is PhieuDichVuStateUpdated) {
              setState(() {
                _phieuDichVus = state.data;
              });
            } else if (state is PhieuDichVuStateError) {
              _handleError("Lỗi phiếu dịch vụ: ${state.message}");
            }
          },
        ),
        BlocListener<NhaCungCapBloc, NhaCungCapState>(
          listener: (context, state) {
            if (state is NhaCungCapStateUpdated) {
              setState(() {
                _nhaCungCaps = state.data;
              });
            } else if (state is NhaCungCapStateFailure) {
              _handleError("Lỗi nhà cung cấp: ${state.error}");
            }
          },
        ),
        BlocListener<DonViTinhBloc, DonViTinhState>(
          listener: (context, state) {
            if (state is DonViTinhStateUpdated) {
              setState(() {
                _donViTinhs = state.data;
              });
            } else if (state is DonViTinhStateFailure) {
              _handleError("Lỗi đơn vị tính: ${state.error}");
            }
          },
        ),
        BlocListener<LoaiSanPhamBloc, LoaiSanPhamState>(
          listener: (context, state) {
            if (state is LoaiSanPhamStateUpdated) {
              setState(() {
                _loaiSanPhams = state.data;
              });
            } else if (state is LoaiSanPhamStateFailure) {
              _handleError("Lỗi loại sản phẩm: ${state.error}");
            }
          },
        ),
        BlocListener<LoaiDichVuBloc, LoaiDichVuState>(
          listener: (context, state) {
            if (state is LoaiDichVuStateUpdated) {
              setState(() {
                _loaiDichVus = state.data;
              });
            } else if (state is LoaiDichVuStateFailure) {
              _handleError("Lỗi loại dịch vụ: ${state.error}");
            }
          },
        ),
        BlocListener<SanPhamBloc, SanPhamState>(
          listener: (context, state) {
            if (state is SanPhamStateUpdated) {
              setState(() {
                _sanPhams = state.data;
              });
            } else if (state is SanPhamStateFailure) {
              _handleError("Lỗi sản phẩm: ${state.error}");
            }
          },
        ),
        BlocListener<ThamSoBloc, ThamSoState>(
          listener: (context, state) {
            if (state is ThamSoStateLoaded) {
              setState(() {
                _thamSos = state.thamSoList;
              });
            } else if (state is ThamSoStateError) {
              _handleError("Lỗi tham số: ${state.message}");
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Màn hình chính',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Menu
                    Container(
                      width: 260,
                      margin: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                        bottom: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          // App Bar with Product Name and Settings
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Cửa hàng đá quý',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    _onSettingsPressed();
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Main Content Area
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView(
                                children: [
                                  // Information Management Section
                                  _buildExpandableSection(
                                    title: 'Quản lý thông tin',
                                    isExpanded: isInfoManagementExpanded,
                                    onTap: () {
                                      setState(() {
                                        isInfoManagementExpanded =
                                            !isInfoManagementExpanded;
                                      });
                                    },
                                    items:
                                        isInfoManagementExpanded
                                            ? [
                                              _buildMenuItem(
                                                'Nhà cung cấp',
                                                'supplier_management',
                                              ),
                                              _buildMenuItem(
                                                'Đơn vị tính',
                                                'unit_management',
                                              ),
                                              _buildMenuItem(
                                                'Loại sản phẩm',
                                                'product_type_management',
                                              ),
                                              _buildMenuItem(
                                                'Loại dịch vụ',
                                                'service_type_management',
                                              ),
                                            ]
                                            : [],
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Import Export Section
                                  _buildExpandableSection(
                                    title: 'Phiếu nhập xuất',
                                    isExpanded: isInvoiceManagementExpanded,
                                    onTap: () {
                                      setState(() {
                                        isInvoiceManagementExpanded =
                                            !isInvoiceManagementExpanded;
                                      });
                                    },
                                    items:
                                        isInvoiceManagementExpanded
                                            ? [
                                              _buildMenuItem(
                                                'Phiếu bán hàng',
                                                'sales_invoice',
                                              ),
                                              _buildMenuItem(
                                                'Phiếu mua hàng',
                                                'purchase_invoice',
                                              ),
                                              _buildMenuItem(
                                                'Phiếu dịch vụ',
                                                'service_invoice',
                                              ),
                                            ]
                                            : [],
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Product List Section
                                  _buildMenuItemWithDot(
                                    'Danh sách sản phẩm',
                                    'product_list',
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Reports Section
                                  _buildMenuItemWithDot('Báo cáo', 'reports'),

                                  const SizedBox(height: 16.0),

                                  // Reports Section
                                  _buildMenuItemWithDot('Điều chỉnh tham số', 'adjust_parameters'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side - Function screen
                    if (selectedFunction != null)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Column(
                            children: [
                              // Function screen header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black12,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedTitle ?? '',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Function screen content
                              Expanded(
                                child: Center(child: _buildFunctionScreen()),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method để xử lý error một cách thông minh
  void _handleError(String errorMessage) {
    _pendingErrors.add(errorMessage);

    if (!_isErrorDialogShowing) {
      _showAllErrorsInOneDialog();
    }
  }

  // Hiển thị tất cả lỗi trong 1 dialog
  void _showAllErrorsInOneDialog() {
    if (_pendingErrors.isEmpty) return;

    _isErrorDialogShowing = true;
    final errorsToShow = List<String>.from(_pendingErrors);
    _pendingErrors.clear();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: 'Lỗi (${errorsToShow.length} lỗi)',
          message: errorsToShow,
          onClose: () {
            _isErrorDialogShowing = false;
          },
        );
      },
    ).then((_) {
      _isErrorDialogShowing = false;
    });
  }

  // Các methods khác giữ nguyên...
  Widget _buildExpandableSection({
    required String title,
    required List<Widget> items,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String functionId) {
    final isSelected = selectedFunction == functionId;
    final dotSize = 12.0;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFunction = functionId;
          selectedTitle = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 24.0,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemWithDot(String title, String functionId) {
    final isSelected = selectedFunction == functionId;
    final dotSize = 12.0;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFunction = functionId;
          selectedTitle = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          border:
              isSelected ? Border.all(color: Colors.blue, width: 2.0) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: Colors.red[200],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionScreen() {
    // Return specific UI based on the selected function
    switch (selectedFunction) {
      case 'supplier_management':
        return NhaCungCapScreen(data: _nhaCungCaps);
      case 'unit_management':
        return DonViTinhScreen(data: _donViTinhs);
      case 'product_type_management':
        return LoaiSanPhamScreen(data: _loaiSanPhams, 
          listDonViTinh: _donViTinhs);
      case 'service_type_management':
        return LoaiDichVuScreen(data: _loaiDichVus, thamSo: _thamSos);
      case 'sales_invoice':
        return PhieuBanHangScreen(
          data: _phieuBanHangs,
          listSanPham: _sanPhams,
        );
      case 'purchase_invoice':
        return PhieuMuaHangScreen(
          data: _phieuMuaHangs,
          listNhaCungCap: _nhaCungCaps,
          listSanPham: _sanPhams,
        );
      case 'service_invoice':
        return PhieuDichVuScreen(
          data: _phieuDichVus,
          listLoaiDichVu: _loaiDichVus,
          thamSos: _thamSos,
        );
      case 'product_list':
        return SanPhamScreen(data: _sanPhams, listLoaiSanPham: _loaiSanPhams);
      case 'reports':
        return ReportScreen(
          chartData: Format.chartDataFormat(
            _phieuMuaHangs,
            _phieuBanHangs,
          )
        );
      case 'adjust_parameters':
        return ThamSoScreen(thamSoList: _thamSos);
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Select a function from the menu',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
          ],
        );
    }
  }

  void _onSettingsPressed() {
    GoRouter.of(context).go('/settings');
  }

  void _fetchAllData() {
    context.read<NhaCungCapBloc>().add(NhaCungCapEventGetAll());
    context.read<DonViTinhBloc>().add(DonViTinhEventGetAll());
    context.read<LoaiSanPhamBloc>().add(LoaiSanPhamEventGetAll());
    context.read<LoaiDichVuBloc>().add(LoaiDichVuEventGetAll());
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventGetAll());
    context.read<PhieuBanHangBloc>().add(PhieuBanHangEventGetAll());
    context.read<PhieuDichVuBloc>().add(PhieuDichVuEventGetAll());
    context.read<ThamSoBloc>().add(ThamSoEventGetAll());
  }
}
