class Planet {
  final String name;
  final String assetPath;
  final String tagline;
  final String description;
  final String stat1Label;
  final String stat1Value;
  final String stat2Label;
  final String stat2Value;
  final List<Map<String, String>> details;

  Planet({
    required this.name,
    required this.assetPath,
    required this.tagline,
    required this.description,
    required this.stat1Label,
    required this.stat1Value,
    required this.stat2Label,
    required this.stat2Value,
    required this.details,
  });

  static List<Planet> planets = [
    Planet(
      name: 'Mars',
      assetPath: 'assets/images/mars.jpg',
      // 'https://upload.wikimedia.org/wikipedia/commons/0/02/OSIRIS_Mars_true_color.jpg',
      tagline: 'The Red Planet: A potential new home for humanity.',
      description:
          'Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, being larger than only Mercury.',
      stat1Label: 'Avg Temp',
      stat1Value: '-65°C',
      stat2Label: 'Gravity',
      stat2Value: '3.72 m/s²',
      details: [
        {'title': 'Moons', 'value': '2'},
        {'title': 'Day Length', 'value': '24h 37m'},
        {'title': 'Diameter', 'value': '6,779 km'},
      ],
    ),
    Planet(
      name: 'Earth',
      assetPath: 'assets/images/earth.avif',
      // 'https://upload.wikimedia.org/wikipedia/commons/9/97/The_Earth_seen_from_Apollo_17.jpg',
      tagline: 'The Blue Marble: The only known world with life.',
      description:
          'Earth is the third planet from the Sun and the only astronomical object known to harbor life.',
      stat1Label: 'Avg Temp',
      stat1Value: '15°C',
      stat2Label: 'Gravity',
      stat2Value: '9.80 m/s²',
      details: [
        {'title': 'Moons', 'value': '1'},
        {'title': 'Day Length', 'value': '24h 0m'},
        {'title': 'Diameter', 'value': '12,742 km'},
      ],
    ),
    Planet(
      name: 'Jupiter',
      assetPath: 'assets/images/jupiter.avif',
      // 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Jupiter.jpg/1200px-Jupiter.jpg',
      tagline: 'The Gas Giant: King of the Solar System.',
      description:
          'Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun.',
      stat1Label: 'Avg Temp',
      stat1Value: '-110°C',
      stat2Label: 'Gravity',
      stat2Value: '24.79 m/s²',
      details: [
        {'title': 'Moons', 'value': '95'},
        {'title': 'Day Length', 'value': '9h 55m'},
        {'title': 'Diameter', 'value': '139,820 km'},
      ],
    ),
    Planet(
      name: 'Saturn',
      assetPath:
          'https://upload.wikimedia.org/wikipedia/commons/c/c7/Saturn_during_Equinox.jpg',
      tagline: 'The Ringed Jewel: A beauty of cosmic proportions.',
      description:
          'Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter.',
      stat1Label: 'Avg Temp',
      stat1Value: '-140°C',
      stat2Label: 'Gravity',
      stat2Value: '10.44 m/s²',
      details: [
        {'title': 'Moons', 'value': '146'},
        {'title': 'Day Length', 'value': '10h 33m'},
        {'title': 'Diameter', 'value': '116,460 km'},
      ],
    ),
  ];
}
