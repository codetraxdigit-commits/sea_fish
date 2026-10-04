import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/boat_bloc.dart';
import '../widgets/boat_form.dart';

class AddBoatScreen extends StatelessWidget {
  const AddBoatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Boat'),
      ),
      body: BlocConsumer<BoatBloc, BoatState>(
        listener: (context, state) {
          if (state.status == BoatStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Boat registered successfully.',
                ),
                backgroundColor: AppColors.successGreen,
              ),
            );

            Navigator.pop(context, true);
          }

          if (state.status == BoatStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Something went wrong.',
                ),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: BoatForm(
                  isLoading:
                  state.status == BoatStatus.loading,
                  onSubmit: ({
                    required String boatName,
                    required String registrationNumber,
                    required String boatType,
                    required double capacityKg,
                    required String engineNumber,
                    required String licenseNumber,
                    required String imagePath,
                  }) {
                    context.read<BoatBloc>().add(
                      AddBoatRequested(
                        boatName: boatName,
                        registrationNumber:
                        registrationNumber,
                        boatType: boatType,
                        capacityKg: capacityKg,
                        engineNumber: engineNumber,
                        licenseNumber: licenseNumber,
                        imagePath: imagePath,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}