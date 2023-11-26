import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/domain/bloc/config_bloc/config_bloc.dart';
import '/domain/bloc/auth_bloc/auth_bloc.dart';
import '/domain/bloc/expenses_bloc/expenses_bloc.dart';
import '/data/models/user_model.dart';
import '/data/repositories/app_repository.dart';
import '/core/constants/styles.dart';
import '/presentation/screens/authentication/login.dart';
import '/presentation/screens/onboarding/onboarding.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = FirebaseAuth.instance.currentUser == null;
    UserModel? user = context.watch<AuthBloc>().user;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(paddingDefault / 2),
              child: CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.person,
                  size: 44,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
              child: Text(
                user?.name ?? "Login",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
              child: Text(user?.email ?? 'To access remote database'),
            ),
            const Divider(height: paddingDefault),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  BlocBuilder<ConfigBloc, ConfigState>(
                    builder: (context, state) => Column(
                      children: [
                        ListTile(
                          title: const Text("DarkMode"),
                          leading: const Icon(Icons.dark_mode),
                          trailing: Switch(
                            value: state.themeMode == ThemeMode.dark,
                            onChanged: (val) {
                              context.read<ConfigBloc>().add(
                                    ConfigThemeModeChangeEvent(
                                      themeMode: val
                                          ? ThemeMode.dark
                                          : ThemeMode.light,
                                    ),
                                  );
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Offline Mode"),
                          leading: const Icon(Icons
                              .signal_wifi_connected_no_internet_4_outlined),
                          trailing: Switch(
                            value: state.database == DatabaseType.local,
                            onChanged: (val) {
                              context.read<ConfigBloc>().add(
                                    ConfigThemeModeChangeEvent(
                                      database: val
                                          ? DatabaseType.local
                                          : DatabaseType.remote,
                                    ),
                                  );
                              context
                                  .read<ExpensesBloc>()
                                  .add(ExpensesLoadEvent());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: isLoggedIn
                  ? const Icon(Icons.login)
                  : const Icon(Icons.logout),
              title: Text(isLoggedIn ? 'Login' : 'Logout'),
              onTap: () {
                if (isLoggedIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                } else {
                  context.read<AuthBloc>().add(AuthEventLogout());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: paddingDefault)
          ],
        ),
      ),
    );
  }
}
