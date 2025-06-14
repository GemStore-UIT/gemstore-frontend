import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/http_client.dart';
import 'package:gemstore_frontend/config/router.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_api.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_repository.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    NhaCungCapBloc(context.read<NhaCungCapRepository>()),
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
