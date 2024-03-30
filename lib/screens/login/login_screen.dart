import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../ultils/theme_ext.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';

import '../../widgets/single_child_scroll_view_with_column.dart';
import 'package:open_mail_app/open_mail_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isTap = true;
  late final _authState = context.read<AuthBloc>().state;
  late final _emailController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(username: final email) => email,
      _ => '',
    }),
  );
  late final _passwordController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(password: final password) => password,
      _ => '',
    }),
  );
  late final String message = switch (_authState) {
    AuthLoginInitial(message: final mes) => mes,
    AuthForgotSuccess(message: final mes) => mes,
    _ => '',
  };

  void _handleGo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Truyền event cho bloc
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z]+\.[a-z]+")
        .hasMatch(email);
  }

  Widget _buildInitialLoginWidget() {
    // print("Respone Server: $message");
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: _emailController,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                labelText: 'username'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'fieldNull'.tr;
                }

                return null;
                //  else if (!isEmailValid(value)) {
                //   return 'Please enter valid email';
                // }
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: _passwordController,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                  labelText: 'password'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      isTap = !isTap;
                    }),
                    icon: isTap
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )),
              obscureText: isTap,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'fieldNull'.tr;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            message == ''
                ? Container()
                : TextButton(
                    child: Text(
                      "$message Click here",
                      style: context.text.bodyMedium!.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      await OpenMailApp.openMailApp();
                    },
                  ),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final formKey1 = GlobalKey<FormState>();
                            var emailController = TextEditingController();
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('resetPassword'.tr),
                              content: AutofillGroup(
                                child: Form(
                                  key: formKey1,
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'fieldNull'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'cancel'.tr,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      if (formKey1.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                            AuthForgotPasswordStarted(
                                                email: emailController.text));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      'reset'.tr,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )),
                              ],
                            );
                          });
                    },
                    child: Text('forgotPassword'.tr))),
            // const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleGo(context);
              },
              label: Text('go'.tr),
              icon: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go(RouteName.register);
              },
              child: Text('noAccount'.tr),
            ),
          ]
              .animate(
                interval: 50.ms,
              )
              .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 300.ms,
              )
              .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 300.ms,
              ),
        ),
      ),
    );
  }

  Widget _buildInProgressLoginWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFailureLoginWidget(String message) {
    return Column(
      children: [
        Text(
          message,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            _handleRetry(context);
          },
          label: Text('retry'.tr),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var loginWidget = (switch (authState) {
      // AuthInitial() => _buildInitialLoginWidget(),
      AuthAuthenticateUnauthenticated() => _buildInitialLoginWidget(),
      AuthLoginInProgress() => _buildInProgressLoginWidget(),
      AuthLoginFailure(message: final msg) => _buildFailureLoginWidget(msg),
      AuthForgotSuccess() => _buildInitialLoginWidget(),
      AuthForgotFailure(message: final msg) => _buildFailureLoginWidget(msg),
      AuthLoginSuccess() => Container(),
      AuthLoginInitial() => _buildInitialLoginWidget(),
      _ => Container(),
    });

    loginWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLoginSuccess():
              context.read<AuthBloc>().add(AuthAuthenticateStarted());
              break;
            case AuthAuthenticateSuccess():
              context.go(RouteName.home);
              break;
            default:
          }
        },
        child: loginWidget);

    return Scaffold(
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'login'.tr,
              style: context.text.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.color.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 48,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: loginWidget),
            ),
          ],
        ),
      ),
    );
  }
}
