import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import '../providers/auth_providers.dart';
import '../models/user_model.dart';

class AuthStatusWidget extends ConsumerWidget {
  final bool showFullInfo;
  final VoidCallback? onRefresh;
  final VoidCallback? onLogout;

  const AuthStatusWidget({
    super.key,
    this.showFullInfo = false,
    this.onRefresh,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final sessionTimer = ref.watch(sessionTimerProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);

    if (!isAuthenticated) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Ionicons.warning_outline,
              color: Colors.red.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Not authenticated',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return sessionTimer.when(
      data: (timeRemaining) {
        if (timeRemaining == null) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Ionicons.warning_outline,
                  color: Colors.red.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Session Expired',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final minutes = timeRemaining.inMinutes;
        final seconds = timeRemaining.inSeconds % 60;
        final isExpiringSoon = timeRemaining.inMinutes < 2;

        if (showFullInfo) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Ionicons.person,
                        color: Color(0xFF667eea),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            user?.email ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isExpiringSoon 
                        ? Colors.amber.shade50 
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isExpiringSoon 
                          ? Colors.amber.shade200 
                          : Colors.green.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Ionicons.time_outline,
                            color: isExpiringSoon 
                                ? Colors.amber.shade600 
                                : Colors.green.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Session expires in:',
                            style: TextStyle(
                              color: isExpiringSoon 
                                  ? Colors.amber.shade700 
                                  : Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isExpiringSoon 
                                  ? Colors.amber.shade700 
                                  : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress Bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: timeRemaining.inSeconds / 600, // 10 minutes = 600 seconds
                          child: Container(
                            decoration: BoxDecoration(
                              color: isExpiringSoon 
                                  ? Colors.amber.shade400
                                  : Colors.green.shade400,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpiringSoon || onRefresh != null || onLogout != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (onRefresh != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onRefresh ?? () => authNotifier.refreshToken(),
                            icon: const Icon(Ionicons.refresh_outline, size: 16),
                            label: const Text('Refresh', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF667eea),
                              side: const BorderSide(color: Color(0xFF667eea)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      if (onRefresh != null && onLogout != null)
                        const SizedBox(width: 8),
                      if (onLogout != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onLogout,
                            icon: const Icon(Ionicons.log_out_outline, size: 16),
                            label: const Text('Logout', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              side: BorderSide(color: Colors.red.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          );
        } else {
          // Compact view
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isExpiringSoon ? Colors.amber.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isExpiringSoon ? Colors.amber.shade300 : Colors.green.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Ionicons.time_outline,
                  size: 16,
                  color: isExpiringSoon ? Colors.amber.shade700 : Colors.green.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${minutes}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isExpiringSoon ? Colors.amber.shade700 : Colors.green.shade700,
                  ),
                ),
                if (isExpiringSoon) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onRefresh ?? () => authNotifier.refreshToken(),
                    child: Icon(
                      Ionicons.refresh_outline,
                      size: 16,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
      },
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Ionicons.warning_outline,
              size: 16,
              color: Colors.red.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthStatusCard extends ConsumerWidget {
  const AuthStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthStatusWidget(
      showFullInfo: true,
      onRefresh: () {
        ref.read(authNotifierProvider.notifier).refreshToken();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session refreshed successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onLogout: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Ionicons.log_out_outline,
                    color: Colors.red.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('Confirm Logout'),
                ],
              ),
              content: const Text(
                'Are you sure you want to logout? You will need to sign in again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(authNotifierProvider.notifier).logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}