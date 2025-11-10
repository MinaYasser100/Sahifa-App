import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/profile/manager/profile_user_cubit/profile_user_cubit.dart';
import 'package:sahifa/features/profile/ui/widgets/profile_widgets/profile_data_widget.dart';
import 'package:sahifa/features/profile/ui/widgets/profile_widgets/profile_error_widget.dart';
import 'package:sahifa/features/profile/ui/widgets/profile_widgets/profile_loading_widget.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        if (state is ProfileUserLoading) {
          return ProfileLoadingWidget(isDark: isDark);
        }

        if (state is ProfileUserError) {
          return ProfileErrorWidget(isDark: isDark, message: state.message);
        }

        if (state is ProfileUserSuccess) {
          return ProfileDataWidget(isDark: isDark, profile: state.profile);
        }

        // Fallback to loading (shouldn't reach here normally)
        return ProfileLoadingWidget(isDark: isDark);
      },
    );
  }
}
