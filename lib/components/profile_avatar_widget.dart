import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:samusil_addon/utils/util.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;
  final double? fontSize;

  const ProfileAvatarWidget({
    super.key,
    this.photoUrl,
    required this.name,
    this.size = 40,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size / 2;
    final calculatedFontSize = fontSize ?? (size * 0.35);

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      child: Utils.isValidNilEmptyStr(photoUrl)
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) => Container(
                  width: size,
                  height: size,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildInitialAvatar(calculatedFontSize),
              ),
            )
          : _buildInitialAvatar(calculatedFontSize),
    );
  }

  Widget _buildInitialAvatar(double fontSize) {
    final initials = _getInitials(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}';
    } else if (words.length == 1 && words[0].isNotEmpty) {
      return words[0][0];
    }
    return '';
  }
} 