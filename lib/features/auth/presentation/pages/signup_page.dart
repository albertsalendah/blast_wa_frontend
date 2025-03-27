import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_blast/config/routes/routes_name.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/shared/widgets/loading_indicator.dart';
import 'package:whatsapp_blast/core/utils/image_background.dart';
import 'package:whatsapp_blast/core/utils/show_snackbar.dart';
import 'package:whatsapp_blast/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:whatsapp_blast/features/auth/presentation/widgets/auth_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool obscureText = true;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            imageBackgound(context: context),
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: SizedBox(
                      width:
                          (constraints.maxWidth > 600) ? 600 : double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthFailure) {
                                showSnackBarError(
                                    context: context, message: state.message);
                              }
                              if (state is AuthSuccess) {
                                if (state.response.isSuccess) {
                                  context.goNamed(RoutesName.login);
                                  showSnackBarSuccess(
                                      context: context,
                                      message: state.response.message);
                                } else {
                                  showSnackBarError(
                                      context: context,
                                      message: state.response.message);
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                isLoading = true;
                              } else {
                                isLoading = false;
                              }
                              return Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign Up.',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: AppPallete.green),
                                    ),
                                    const SizedBox(height: 30),
                                    AuthField(
                                        hintText: 'Name',
                                        controller: nameController),
                                    const SizedBox(height: 15),
                                    AuthField(
                                        hintText: 'Email',
                                        controller: emailController),
                                    const SizedBox(height: 15),
                                    AuthField(
                                      hintText: 'Password',
                                      controller: passwordController,
                                      obscureText: obscureText,
                                      suffixIcon: IconButton(
                                        icon: Icon(obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    AuthField(
                                      hintText: 'Confirm Password',
                                      controller: confirmPassController,
                                      obscureText: obscureText,
                                      suffixIcon: IconButton(
                                        icon: Icon(obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context.read<AuthBloc>().add(
                                                  SignUpEvent(
                                                    name: nameController.text,
                                                    email: emailController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  ),
                                                );
                                          }
                                        },
                                        child: Text('Register')),
                                    const SizedBox(height: 20),
                                    InkWell(
                                      onTap: () {
                                        context.pushNamed(RoutesName.login);
                                      },
                                      child: RichText(
                                          text: TextSpan(
                                        text: 'Already have an account? ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        children: [
                                          TextSpan(
                                            text: "Sign In",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppPallete.green),
                                          )
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 1,
              bottom: 1,
              left: 1,
              right: 1,
              child: Visibility(
                visible: isLoading,
                child: Container(
                    color: Colors.white.withAlpha(100),
                    child: LoadingIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
