import 'package:flutter/material.dart';
import 'navbar.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  static const List<InfoCardData> infoCards = [
    InfoCardData(
        title: 'Donation Benefits',
        icon: Icons.volunteer_activism,
        info: 'Donating blood can:\n'
            '• Reduce stress\n'
            '• Healthier heart\n'
            '• Reduce calories\n'
            '• Regulates iron level\n'
            '• Improve emotional well being\n'
            '• Better physical health\n'
            '• Sense of belonging\n'
            '• Get rid of negative feelings\n'),
    InfoCardData(
        title: 'How to Request Blood',
        icon: Icons.shopping_bag,
        info: 'To request blood, contact the neariest or desired facility.'),
    InfoCardData(
      title: 'Blood Requests & Compatibility',
      icon: Icons.bloodtype,
      info: '',
    ),
    InfoCardData(
        title: 'Blood Types',
        icon: Icons.science,
        info:
            'Blood type can be categorized into four groups based on the presence of antigens (A, B, AB, or O) and Rh factor (+ or -).\n'
            'The different blood types are:\n'
            '• A+\n'
            '• A-\n'
            '• B+\n'
            '• B-\n'
            '• AB+\n'
            '• AB-\n'
            '• O+\n'
            '• O-\n'),
  ];

  static const List<FAQData> faqs = [
    FAQData(
        question: 'Who can request blood?',
        answer:
            'Anyone can request for blood, such as patients or their relatives or friends as long as they are of legal age.'),
    FAQData(
        question: 'How long does it take to process a request?',
        answer:
            'It takes around 1-2 to process a request or it depends on the facility you’ve chosen.'),
    FAQData(
        question: 'Is blood always available when I request it?',
        answer:
            'The availability of blood depends on the facility it is from. Some rare types may not always be available.'),
    FAQData(
        question: 'What information do I need to request blood?',
        answer:
            'The information needed for requesting blood are the patient\'s name, blood type, blood component, and quantity needed.'),
    FAQData(
      question: 'Is there a fee for requesting blood?',
      answer:
          'Fees depend on the hospital or blood bank. Some provide blood for free, while others may charge for processing.',
    ),
  ];

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  int? hoveredIndex;

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
                children: List.generate(
                  InformationPage.infoCards.length,
                  (index) => InfoCard(
                    card: InformationPage.infoCards[index],
                    index: index,
                    isHovered: hoveredIndex == index,
                    onHoverChanged: (isHovering) {
                      setState(() {
                        hoveredIndex = isHovering ? index : null;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 12),
              ...InformationPage.faqs.map((faq) => FAQTile(faq: faq)),
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
  const InfoCardData(
      {required this.title, required this.icon, required this.info});
}

class InfoCard extends StatelessWidget {
  final InfoCardData card;
  final int index;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;

  const InfoCard({
    required this.card,
    required this.index,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.white;
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              card.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red[900]),
            ),
            content: card.title == 'Blood Requests & Compatibility'
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Each blood type has its own compatibility.\n',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          children: const [
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Color(0xFFF8BBD0)),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Donor',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Recipient',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('A'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('A, AB'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('B'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('B, AB'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('AB'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('AB'),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('O'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('A, B, AB, O'),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  )
                : Text(card.info),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // bold button text
                ),
              ),
            ],
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isHovered ? darken(baseColor, 0.08) : baseColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: isHovered
                ? Border.all(color: Colors.red.shade900, width: 2)
                : null,
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
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

class FAQTile extends StatefulWidget {
  final FAQData faq;
  const FAQTile({Key? key, required this.faq}) : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.red,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: Colors.red[600],
            collapsedIconColor: Colors.red[400],
            collapsedTextColor: Colors.black87,
            textColor: Colors.red[900],
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.all(10),
          title: Text(
            widget.faq.question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onExpansionChanged: (expanded) {
            setState(() {
              _expanded = expanded;
            });
          },
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.faq.answer,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
