import 'package:fishtrack/features/authentication/domain/entities/user_entity.dart';
import 'package:fishtrack/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:fishtrack/features/authentication/presentation/widget/register_screen.dart';
import 'package:fishtrack/features/authentication/presentation/widget/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_field.dart';
import '../screen/RegisterScreen.dart';


class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static const routeName = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  void _forgotPassword() {
    // TODO: Navigate to forgot password screen
  }

  void _googleLogin() {
    // TODO: Connect Firebase Google authentication
  }

  void _createAccount() {
    Navigator.pushNamed(
      context,
      RegisterScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            final user = state.user;

            if (user == null) {
              return;
            }

            switch (user.role) {
              case UserRole.fisherman:
                if (state.user?.role == UserRole.fisherman) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.fishermanDashboard,
                        (route) => false,
                  );
                }
                break;

              case UserRole.vendor:
                Navigator.pushReplacementNamed(
                  context,
                  '/vendor-home',
                );
                break;

              case UserRole.admin:
                Navigator.pushReplacementNamed(
                  context,
                  '/admin-home',
                );
                break;
            }
          }

          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Login failed',
                ),
              ),
            );
          }
        },
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 480,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 36),

                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.20),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.sailing_rounded,
              color: AppColors.textLight,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Welcome to SeaLink',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            'Connect • Trade • Stay Safe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Sign in to continue to your account',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            // Email
            CommonTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),

            const SizedBox(height: 18),

            // Password
            CommonTextField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: _validatePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                child: const Text(
                  'Forgot Password?',
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Login
            CommonButton(
              text: 'Login',
              onPressed: _login,
              isLoading: context.watch<AuthBloc>().state.status ==
                  AuthStatus.loading,
            ),

            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: AppColors.cardBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    'OR',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: AppColors.cardBorder,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Google
            SocialLoginButton(
              onPressed: _googleLogin,
            ),

            const SizedBox(height: 26),

            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: _createAccount,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}