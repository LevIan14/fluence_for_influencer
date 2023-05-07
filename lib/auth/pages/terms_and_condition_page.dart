import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Constants.primaryColor),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(children: const [
            Text(
              'Syarat dan Ketentuan Layanan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Ini adalah perjanjian hukum antara Anda dan Influencer. Ini mengatur hak dan kewajiban Anda dalam melakukan transaksi. Sebelum menyetujui transaksi, pastikan untuk membaca dan memahami Syarat dan Ketentuan dengan seksama. Jangan ragu untuk menghubungi layanan pelanggan jika Anda memiliki pertanyaan atau kekhawatiran.\n\n",
              textAlign: TextAlign.justify,
            ),
            Text(
              'Dengan menyetujui Syarat dan Ketentuan, Anda mengikat diri untuk mematuhi semua ketentuan dan persyaratan yang tercantum. Jika Anda tidak setuju dengan Syarat dan Ketentuan, jangan melanjutkan transaksi dan hubungi layanan pelanggan untuk membantu Anda.',
              textAlign: TextAlign.justify,
            )
          ]),
        ),
      ),
    );
  }
}
