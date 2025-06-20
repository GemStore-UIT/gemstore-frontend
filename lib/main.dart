import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/http_client.dart';
import 'package:gemstore_frontend/config/router.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_api.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_repository.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_api.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_repository.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_api.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_repository.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_api.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_repository.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/phieu_ban_hang_api.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/phieu_ban_hang_repository.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_api.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_repository.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_event.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham_api.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NhaCungCapRepository(NhaCungCapApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => DonViTinhRepository(DonViTinhApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => LoaiSanPhamRepository(LoaiSanPhamApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => LoaiDichVuRepository(LoaiDichVuApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => PhieuMuaHangRepository(PhieuMuaHangApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => PhieuBanHangRepository(PhieuBanHangApi(dio)),
        ),
        RepositoryProvider(
          create: (context) => SanPhamRepository(SanPhamApi(dio)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    NhaCungCapBloc(context.read<NhaCungCapRepository>()),
          ),
          BlocProvider(
            create:
                (context) => DonViTinhBloc(context.read<DonViTinhRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    LoaiSanPhamBloc(context.read<LoaiSanPhamRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    LoaiDichVuBloc(context.read<LoaiDichVuRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    PhieuMuaHangBloc(context.read<PhieuMuaHangRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                PhieuBanHangBloc(context.read<PhieuBanHangRepository>()),
          ),
          BlocProvider(
            create: (context) => SanPhamBloc(context.read<SanPhamRepository>()),
          ),
        ],
        child: AppContent(),
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    super.initState();
    context.read<NhaCungCapBloc>().add(NhaCungCapEventStart());
    context.read<DonViTinhBloc>().add(DonViTinhEventStart());
    context.read<LoaiSanPhamBloc>().add(LoaiSanPhamEventStart());
    context.read<LoaiDichVuBloc>().add(LoaiDichVuEventStart());
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventStart());
    context.read<PhieuBanHangBloc>().add(PhieuBanHangEventStart());
    context.read<SanPhamBloc>().add(SanPhamEventStart());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gemstore UIT',
      theme: ThemeData(fontFamily: 'Roboto'),
      routerConfig: router,
    );
  }
}
