// SQL to create the Designation table
const String designationTable = '''
  CREATE TABLE designations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    compte TEXT NOT NULL
  )''';

// SQL to create the Article table
const String articleTable = '''
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

// SQL create fournisseur table
const String fournisseurTable = '''
  CREATE TABLE fournisseurs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''';

const String commendeTable = '''
    CREATE TABLE commendes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      article_id INTEGER NOT NULL,
      bonDeCommende_id INTEGER NOT NULL,
      quantite INTEGER NOT NULL,
      FOREIGN KEY (bonDeCommende_id) REFERENCES bonDeCommendes (id),
      FOREIGN KEY (article_id) REFERENCES articles (id)
    )''';

const String bonDeCommendeTable = '''
    CREATE TABLE bonDeCommendes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      fournisseur_id INTEGER NOT NULL,
      dateBonDeCommende TEXT NOT NULL,
      montantTotal REAL,
      FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs (id)
    )''';

// SQL to create the Service table
const String servicesTable = '''
  CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''';

// SQL to create the Affectation table
const String affectationTable = '''
  CREATE TABLE affectations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_id INTEGER NOT NULL,
    article_id INTEGER NOT NULL,
    dateAffectation TEXT NOT NULL,
    FOREIGN KEY (service_id) REFERENCES services(id),
    FOREIGN KEY (article_id) REFERENCES articles(id)
  )''';

const String affectationUnitTable = '''
  CREATE TABLE affectationUnits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    affectation_id INTEGER NOT NULL,
    article_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (affectation_id) REFERENCES affectations(id),
    FOREIGN KEY (article_id) REFERENCES articles(id)
  )''';
