class Clinic {
  String person;
  String city;
  String country;
  String description;
  String imageUrl;

  // Constructor
  Clinic({
    this.city,
    this.country,
    this.description,
    this.person,
    this.imageUrl,
  });
}
  // Essentially this is declared 'global'
  // Store a list of the clinics here.. to be qureied by other parts of the app
  final List<Clinic> clinics = [

    // Ryan
    Clinic(
      person: "Ryan",
      city: "Brampton",
      country: "Canada",
      description: "Son",
      imageUrl: 'assets/images/nuerofit.jpeg'
    ),

    //Sante
    Clinic(
      person: "Sante",
      city: "Orangeville",
      country: "Canada",
      description: "Physio",
      imageUrl: 'assets/images/nuerofit.jpeg'
    ),

    // Oliva
    Clinic(
      person: "Olivia",
      city: "Brampton",
      country: "Canada",
      description: "Speech Therapy",
      imageUrl: 'assets/images/nuerofit.jpeg'
    ),

    // Tacky
    Clinic(
      person: "Tacky",
      city: "Brampton",
      country: "Canada",
      description: "PSW",
      imageUrl: 'assets/images/nuerofit.jpeg'
    )
  ];