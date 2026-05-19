import 'package:flutter/material.dart';
import 'package:kd_pannel/app_theme.dart';
import 'package:kd_pannel/core/responsive/responsive.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String? subtext;
  final Color color;
  final IconData? icon;
  final String? imagePath;
  final double? width;
  final bool isCompact;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.subtext,
    required this.color,
    this.icon,
    this.imagePath,
    this.width,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isCompact) {
      final double cardHeight = isMobile ? 64.0 : 76.0;
      final double padding = isMobile ? 10.0 : 12.0;

      return Container(
        width: width,
        height: cardHeight,
        padding: EdgeInsets.symmetric(horizontal: padding),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: AppTheme.borderColor.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: isMobile ? 36 : 42,
              height: isMobile ? 36 : 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        color: color,
                        height: isMobile ? 18 : 20,
                        width: isMobile ? 18 : 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          icon ?? Icons.analytics_outlined,
                          color: color,
                          size: isMobile ? 18 : 20,
                        ),
                      )
                    : (icon != null
                          ? Icon(icon, color: color, size: isMobile ? 18 : 20)
                          : Icon(
                              Icons.analytics_outlined,
                              color: color,
                              size: isMobile ? 18 : 20,
                            )),
              ),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 10.5 : 11.5,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (subtext != null) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            subtext!,
                            style: TextStyle(
                              fontSize: isMobile ? 9 : 10,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Dynamic height adaptation for premium mobile vs desktop/tablet layout
    final double cardHeight = isMobile ? 145.0 : 175.0;

    return Container(
      width: width,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 1. Premium top curved gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.borderRadiusXLarge),
            ),
            child: Container(
              height: isMobile ? 65 : 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withOpacity(0.18), color.withOpacity(0.01)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    isMobile ? 100 : 130,
                    isMobile ? 25 : 35,
                  ),
                ),
              ),
            ),
          ),

          // 2. Premium circular container for the Icon or Image Asset
          Positioned(
            top: isMobile ? 16 : 20,
            child: Container(
              width: isMobile ? 40 : 48,
              height: isMobile ? 40 : 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.cardColor, width: 2),
              ),
              child: Center(
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        color: color,
                        height: isMobile ? 20 : 24,
                        width: isMobile ? 20 : 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          icon ?? Icons.analytics_outlined,
                          color: color,
                          size: isMobile ? 20 : 24,
                        ),
                      )
                    : (icon != null
                          ? Icon(icon, color: color, size: isMobile ? 20 : 24)
                          : Icon(
                              Icons.analytics_outlined,
                              color: color,
                              size: isMobile ? 20 : 24,
                            )),
              ),
            ),
          ),

          // 3. Info text block positioned beautifully at the bottom
          Positioned(
            bottom: isMobile ? 12 : 16,
            left: 8,
            right: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 3 : 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtext != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtext!,
                    style: TextStyle(
                      fontSize: isMobile ? 9.5 : 11,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatCardShimmer extends StatefulWidget {
  final bool isCompact;
  final double? width;

  const StatCardShimmer({super.key, this.isCompact = false, this.width});

  @override
  State<StatCardShimmer> createState() => _StatCardShimmerState();
}

class _StatCardShimmerState extends State<StatCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final Color shimmerColor = Colors.grey.withOpacity(
          _pulseAnimation.value * 0.15 + 0.05,
        );

        if (widget.isCompact) {
          return Container(
            width: widget.width,
            height: 92, // exact match to _buildAdvancedStatCard height
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(
                AppTheme.borderRadiusMedium + 2,
              ),
              boxShadow: AppTheme.cardShadow,
              border: Border.all(color: AppTheme.borderColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                // Left: text block shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title bar
                      Container(
                        width: 80,
                        height: 10,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Value bar (bigger)
                      Container(
                        width: 54,
                        height: 20,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Trend badge shimmer
                      Container(
                        width: 96,
                        height: 10,
                        decoration: BoxDecoration(
                          color: shimmerColor.withOpacity(
                            (shimmerColor.opacity * 0.6).clamp(0.0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right: visual widget placeholder (sparkline / ring)
                Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        }

        // Standard layout shimmer
        final double cardHeight = isMobile ? 145.0 : 175.0;
        return Container(
          width: widget.width,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 90,
                height: 10,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 55,
                height: 18,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
