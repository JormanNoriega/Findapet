import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final void Function()? onGoogleTap;
  final void Function()? onFacebookTap;

  const SocialButtons({
    Key? key,
    this.onGoogleTap,
    this.onFacebookTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        _buildSocialButton(
            'lib/assets/images/google-48.png', onGoogleTap), // Botón de Google
        const SizedBox(width: 20),
        _buildSocialButton('lib/assets/images/facebook-50.png',
            onFacebookTap), // Botón de Facebook
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSocialButton(String asset, void Function()? onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Image.asset(asset, width: 30, height: 30),
        ),
      ),
    );
  }
}
