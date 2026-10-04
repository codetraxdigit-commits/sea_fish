import 'package:fishtrack/features/authentication/presentation/widget/role_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({
    super.key,
  });


  @override
  State<RegisterWidget> createState() =>
      _RegisterWidgetState();
}

class _RegisterWidgetState
    extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameController =
  TextEditingController();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _confirmPasswordController =
  TextEditingController();

  UserRole _selectedRole =
      UserRole.fisherman;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================================
  // REGISTER
  // ==========================================================

  void _register() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole.name,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status ==
              AuthStatus.authenticated) {
            final user = state.user;

            if (user == null) {
              return;
            }

            _showSuccessAndNavigate(
              context,
              user,
            );
          }

          if (state.status ==
              AuthStatus.failure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Registration failed.',
                ),
                backgroundColor:
                AppColors.errorRed,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor:
          AppColors.background,
          appBar: AppBar(
            backgroundColor:
            AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(
                    maxWidth: 480,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),

                        const SizedBox(height: 32),

                        _buildForm(context),

                        const SizedBox(height: 24),

                        _buildRoleSelection(context),

                        const SizedBox(height: 28),

                        _buildRegisterButton(),

                        const SizedBox(height: 24),

                        _buildLoginLink(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius:
            BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.sailing,
            size: 34,
            color: AppColors.textLight,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Create Account',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),

        const SizedBox(height: 8),

        Text(
          'Join SeaLink and connect with the fishing community.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }

  // ==========================================================
  // FORM
  // ==========================================================

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        CommonTextField(
          controller: _nameController,
          label: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person_outline,
          textInputAction:
          TextInputAction.next,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return 'Please enter your name';
            }

            if (value.trim().length < 2) {
              return 'Name is too short';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        CommonTextField(
          controller: _emailController,
          label: 'Email',
          hintText: 'Enter your email',
          prefixIcon:
          Icons.email_outlined,
          keyboardType:
          TextInputType.emailAddress,
          textInputAction:
          TextInputAction.next,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return 'Please enter your email';
            }

            final emailRegex = RegExp(
              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            );

            if (!emailRegex.hasMatch(
              value.trim(),
            )) {
              return 'Please enter a valid email';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        CommonTextField(
          controller:
          _passwordController,
          label: 'Password',
          hintText: 'Create a password',
          prefixIcon: Icons.lock_outline,
          obscureText:
          _obscurePassword,
          textInputAction:
          TextInputAction.next,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons
                  .visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword =
                !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null ||
                value.isEmpty) {
              return 'Please enter a password';
            }

            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        CommonTextField(
          controller:
          _confirmPasswordController,
          label: 'Confirm Password',
          hintText:
          'Re-enter your password',
          prefixIcon: Icons.lock_outline,
          obscureText:
          _obscureConfirmPassword,
          textInputAction:
          TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons
                  .visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword =
                !_obscureConfirmPassword;
              });
            },
          ),
          validator: (value) {
            if (value == null ||
                value.isEmpty) {
              return 'Please confirm your password';
            }

            if (value !=
                _passwordController.text) {
              return 'Passwords do not match';
            }

            return null;
          },
        ),
      ],
    );
  }

  // ==========================================================
  // ROLE SELECTION
  // ==========================================================

  Widget _buildRoleSelection(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Select Account Type',
          style: Theme.of(context)
              .textTheme
              .titleLarge,
        ),

        const SizedBox(height: 6),

        Text(
          'Choose how you want to use SeaLink.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),

        const SizedBox(height: 16),

        RoleSelectionCard(
          role: UserRole.fisherman,
          selected:
          _selectedRole ==
              UserRole.fisherman,
          onTap: () {
            setState(() {
              _selectedRole =
                  UserRole.fisherman;
            });
          },
        ),

        const SizedBox(height: 12),

        RoleSelectionCard(
          role: UserRole.vendor,
          selected:
          _selectedRole ==
              UserRole.vendor,
          onTap: () {
            setState(() {
              _selectedRole =
                  UserRole.vendor;
            });
          },
        ),
      ],
    );
  }

  // ==========================================================
  // REGISTER BUTTON
  // ==========================================================

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading =
            state.status ==
                AuthStatus.loading;

        return CommonButton(
          text: 'Create Account',
          isLoading: isLoading,
          onPressed:
          isLoading ? null : _register,
        );
      },
    );
  }

  // ==========================================================
  // LOGIN LINK
  // ==========================================================

  Widget _buildLoginLink(
      BuildContext context,
      ) {
    return Center(
      child: Wrap(
        alignment:
        WrapAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color:
                AppColors.primaryBlue,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUCCESS
  // ==========================================================

  void _showSuccessAndNavigate(
      BuildContext context,
      UserEntity user,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully!',
        ),
        backgroundColor:
        AppColors.successGreen,
      ),
    );

    switch (user.role) {
      case UserRole.fisherman:
        Navigator.pushReplacementNamed(
          context,
          '/fisherman-home',
        );
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
}