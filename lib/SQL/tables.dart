 // SQL to create the Designation table
  final String designationTable = '''
  CREATE TABLE designations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''';

  // SQL to create the Article table
  final String articleTable = '''
  CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    articleName TEXT NOT NULL,
    designation_id INTEGER NOT NULL,
    description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    priceHT REAL NOT NULL,
    
    tva REAL NOT NULL,
   
    FOREIGN KEY (designation_id) REFERENCES designations(id)
  )''';

// SQL create fornisseur table
  final String fournisseurTable = '''
  CREATE TABLE fournisseurs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''';

  final String commendeTable = '''
    CREATE TABLE commendes (
      id INTEGER PRIMARY KEY,
      article_id INTEGER NOT NULL,
      bonDeCommende_id INTEGER NOT NULL,
      quantite INTEGER NOT NULL,
      FOREIGN KEY (bonDeCommende_id) REFERENCES bonDeCommendes (id),
      FOREIGN KEY (article_id) REFERENCES articles (id)
    )''';
  final String bonDeCommendeTable = '''
    CREATE TABLE bonDeCommendes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      fournisseur_id INTEGER NOT NULL,
      dateBonDeCommende TEXT NOT NULL,
      montantTotal REAL,
      FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs (id)
    )''';


    // SQL to create the Service table
    final String serviceTable = '''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )''';

    // SQL to create the Agent table
    final String agentTable = '''
      CREATE TABLE agents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        service_id INTEGER NOT NULL,
        FOREIGN KEY (service_id) REFERENCES services(id)
      )''';

    // SQL to create the Affectation table
    final String affectationTable = '''
      CREATE TABLE affectations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        agent_id INTEGER NOT NULL,
        article_id INTEGER NOT NULL,
        dateAffectation TEXT NOT NULL,
        FOREIGN KEY (agent_id) REFERENCES agents(id),
        FOREIGN KEY (article_id) REFERENCES articles(id)
      )''';




