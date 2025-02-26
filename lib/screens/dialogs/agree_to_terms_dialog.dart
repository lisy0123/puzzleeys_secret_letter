import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/welcome_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class AgreeToTermsDialog extends StatefulWidget {
  const AgreeToTermsDialog({super.key});

  @override
  State<AgreeToTermsDialog> createState() => _AgreeToTermsDialogState();
}

class _AgreeToTermsDialogState extends State<AgreeToTermsDialog> {
  static const String service = 'service';
  static const String privacy = 'privacy';
  static const String copyRight = 'copyRight';

  final Map<String, bool> _agreements = {
    service: true,
    privacy: true,
    copyRight: true,
  };

  bool get _isAllAgreed => _agreements.values.every((agreed) => agreed);

  void _toggleAgreement(String agreementKey, bool newValue) {
    setState(() {
      _agreements[agreementKey] = newValue;
    });
  }

  void _toggleAllAgreements(bool newValue) {
    setState(() {
      _agreements.updateAll((key, _) => newValue);
    });
  }

  bool get _isAgreeButtonEnabled {
    return _agreements[service]! && _agreements[privacy]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildAgreementCheckboxes(),
        _buildAllAgreementCheckbox(),
        _buildButton(),
      ],
    );
  }

  Widget _buildAllAgreementCheckbox() {
    return _buildCheckbox(
      title: CustomStrings.agreeAll,
      value: _isAllAgreed,
      onChanged: (value) => _toggleAllAgreements(value ?? false),
      underline: false,
    );
  }

  List<Widget> _buildAgreementCheckboxes() {
    final Map<String, Agreement> agreementsData = {
      service: Agreement(CustomStrings.termsAgree, CustomStrings.termsUrl),
      privacy: Agreement(
        CustomStrings.privacyPolicyAgree,
        CustomStrings.privacyPolicyUrl,
      ),
      copyRight: Agreement(
        CustomStrings.copyRightPolicyAgree,
        CustomStrings.copyRightPolicyUrl,
      ),
    };

    return _agreements.entries.map((entry) {
      final agreement = agreementsData[entry.key]!;
      return _buildCheckbox(
        title: agreement.title,
        url: agreement.url,
        value: entry.value,
        onChanged: (newValue) => _toggleAgreement(entry.key, newValue!),
      );
    }).toList();
  }

  Widget _buildButton() {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: CustomStrings.hasAgreed,
      disable: !_isAgreeButtonEnabled,
      onTap: () {
        _agreeOnTap(_agreements.values.last);
        Navigator.pop(context);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: WelcomeScreen(),
            );
          },
        );
      },
    );
  }

  void _agreeOnTap(bool propertyRight) async {
    if (!propertyRight) {
      try {
        await apiRequest('/api/auth/property_right', ApiType.post);
      } catch (error) {
        return null;
      }
    }
  }

  Widget _buildCheckbox({
    required String title,
    String url = '',
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool underline = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => url != '' ? Utils.launchURL(url) : null,
          child: CustomText.agreementText(title, underline),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: CustomColors.colorBase,
          checkColor: Colors.white,
          splashRadius: 0.0,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
      ],
    );
  }
}

class Agreement {
  final String title;
  final String url;

  Agreement(this.title, this.url);
}
