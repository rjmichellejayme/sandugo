import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  static const List<InfoCardData> infoCards = [
    InfoCardData(
      title: 'Donation Benefits',
      icon: Icons.volunteer_activism,
      info: 'Donating blood helps save lives, stimulates blood cell production, and can reduce the risk of certain diseases.',
    ),
    InfoCardData(
      title: 'How to Request Blood',
      icon: Icons.shopping_bag,
      info: 'To request blood, contact your local blood bank or hospital, provide necessary documentation, and fill out a request form.',
    ),
    InfoCardData(
      title: 'Blood Requests & Compatibility',
      icon: Icons.bloodtype,
      info: 'Blood type compatibility is crucial for safe transfusions. Always check compatibility charts or consult medical staff.',
    ),
    InfoCardData(
      title: 'Blood Types',
      icon: Icons.science,
      info: 'The main blood types are A, B, AB, and O, each of which can be Rh-positive or Rh-negative.',
    ),
  ];

  static const List<FAQData> faqs = [
    FAQData(
      question: 'Who can request blood?',
      answer: 'Anyone in need—patients, family members, or medical staff—can request blood with proper documentation.',
    ),
    FAQData(
      question: 'How long does it take to process a request?',
      answer: 'Processing times vary, but most requests are handled within a few hours to a day, depending on availability.',
    ),
    FAQData(
      question: 'Is blood always available when I request it?',
      answer: 'Availability depends on current blood bank stocks and blood type demand. Some rare types may not always be available.',
    ),
    FAQData(
      question: 'What information do I need to request blood?',
      answer: 'You typically need patient details, blood type, quantity required, and a doctor\'s request or medical documentation.',
    ),
    FAQData(
      question: 'Is there a fee for requesting blood?',
      answer: 'Fees depend on the hospital or blood bank. Some provide blood for free, while others may charge for processing.',
    ),
  ];

  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: infoCards.map((card) => InfoCard(card: card)).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 12),
              ...faqs.map((faq) => FAQTile(faq: faq)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCardData {
  final String title;
  final IconData icon;
  final String info;
  const InfoCardData({required this.title, required this.icon, required this.info});
}

class InfoCard extends StatelessWidget {
  final InfoCardData card;
  const InfoCard({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(card.title),
          content: Text(card.info),
          actions: const [
            TextButton(
              onPressed: null, // Will be replaced below
              child: Text('Close'),
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(card.icon, color: Colors.red[400], size: 40),
            const SizedBox(height: 12),
            Text(
              card.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQData {
  final String question;
  final String answer;
  const FAQData({required this.question, required this.answer});
}

class FAQTile extends StatelessWidget {
  final FAQData faq;
  const FAQTile({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red[100] ?? Colors.red),
      ),
      child: ExpansionTile(
        title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.keyboard_arrow_down),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(faq.answer),
          ),
        ],
      ),
    );
  }
}

