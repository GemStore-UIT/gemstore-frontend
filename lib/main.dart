import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/http_client.dart';
import 'package:gemstore_frontend/config/router.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_api.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_repository.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_api.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_repository.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_api.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_repository.dart';

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
          create: (context) => PhieuMuaHangRepository(PhieuMuaHangApi(dio)),
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
            create: (context) =>
                PhieuMuaHangBloc(context.read<PhieuMuaHangRepository>()),
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
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventStart());
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
