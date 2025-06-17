import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/support/contact_option.dart'; // Adjusted import
import '../../widgets/support/faq_item.dart'; // Adjusted import

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: 'Support'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent, size: 48, color: Colors.blue[700]),
                  const SizedBox(height: 12),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is here to assist you with any questions or issues.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact options
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            ContactOption(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@zanvargroup.com',
              color: Colors.orange,
            ),

            const SizedBox(height: 12),

            ContactOption(
              icon: Icons.phone_outlined,
              title: 'Call Support',
              subtitle: '+1 (555) 123-4567',
              color: Colors.green,
            ),

            const SizedBox(height: 24),

            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            FaqItem(
              question: 'How do I reset my password?',
              answer: 'You can reset your password by clicking on "Forgot Password" on the login screen and following the instructions sent to your email.',
            ),

            const SizedBox(height: 12),

            FaqItem(
              question: 'How can I update my profile information?',
              answer: 'Currently, profile updates need to be requested through your department administrator or by contacting support.',
            ),

            const SizedBox(height: 12),

            FaqItem(
              question: 'The app is not working properly. What should I do?',
              answer: 'First, try restarting the app. If the issue persists, ensure you have the latest version installed. If problems continue, please contact our support team.',
            ),
          ],
        ),
      ),
    );
  }
}