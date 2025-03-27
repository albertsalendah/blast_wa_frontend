import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import 'package:whatsapp_blast/core/utils/image_background.dart';
import 'package:whatsapp_blast/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:whatsapp_blast/features/history/presentation/pages/history_page.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/pages/home_page.dart';
import 'package:whatsapp_blast/features/navigation/resizable_side_bar/resizable_side_bar.dart';
import '../../config/theme/app_pallet.dart';
import '../../core/utils/show_snackbar.dart';
import '../auth/domain/entities/user.dart';
import 'resizable_side_bar/resizable_side_bar_items.dart';
import 'resizable_side_bar/resizable_side_bar_item_base.dart';

class MainNav extends StatefulWidget {
  const MainNav({
    super.key,
  });

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  List<ResizableSideBarItemBase> menuList = [];
  User? user;
  late FlutterSecureStorage storage;
  bool? isExpired;
  late TokenManager tokenManager;
  String email = '';

  @override
  void initState() {
    super.initState();
    tokenManager = serviceLocator<TokenManager>();
    storage = serviceLocator<FlutterSecureStorage>();
    menuList = [
      ResizableSideBarItem(
        icon: Icons.home,
        title: 'Home',
      ),
      ResizableSideBarItem(
        icon: Icons.history,
        title: 'History',
      ),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = tokenManager.accessToken;
      email = token != null ? JwtDecoder.decode(token)['email'] : '';
      if (email.isNotEmpty) {
        context.read<AuthBloc>().add(GetUserDataEvent(email: email));
      }
    });
  }

  void _checkTokenExpiration() {
    final token = tokenManager.refreshToken;
    isExpired = token != null ? JwtDecoder.isExpired(token) : true;
    log('⏳ Checking token if expired :$isExpired');
    if (isExpired != null && isExpired == true) {
      if (mounted) {
        context
            .read<AuthBloc>()
            .add(LogoutEvent(message: 'Your session has expired'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBarError(context: context, message: state.message);
            }
            if (state is GetUserDataSuccess) {
              user = state.response.user;
            }
            if (state is LogoutSuccess) {
              if (state.response.message.isNotEmpty) {
                showSnackBarError(
                    context: context, message: state.response.message);
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                imageBackgound(context: context),
                Image.asset('assets/images/background.png',
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover),
                ResizableSideBar(
                  items: menuList,
                  pageList: [
                    HomePage(),
                    HistoryPage(),
                  ],
                  title: user?.email,
                  backgroundColor: AppPallete.green,
                  textStyle: TextStyle(color: Colors.white),
                  footerIcon: Icons.logout,
                  footerLabel: 'Logout',
                  onTapPages: () {
                    _checkTokenExpiration();
                  },
                  onFooterTap: () {
                    context.read<AuthBloc>().add(LogoutEvent(message: ''));
                  },
                  header: (size) {
                    return CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: size * 0.8,
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
