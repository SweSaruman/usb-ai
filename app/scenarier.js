window.SCENARIER = [
  {
    id: 'skogsbyn',
    titel: 'Skogsbyn vid gränsen',
    beskrivning: 'Du är vaktmästare i en avfolkad gränsby. En främling anländer i skymningen och byns gamla regel är: ingen öppnar dörren efter mörkrets inbrott.',
    systemPrompt: 'Du är en spelledare för ett spänningsspel i en enslig skogsby. Beskriv miljöer, lukter och ljud konkret. Håll svar till högst fyra meningar, avsluta alltid med något spelaren kan agera på, och låt spelarens val få konsekvenser. Var aldrig våldsam i onödan.',
    uppstart: 'Regnet har inte slutat på tre dagar. Någon bultar på byns port, och regeln säger att du inte ska öppna. Vad gör du?',
    bild: 'bilder/skogsbyn.svg',
    nyckelord: { port: 'bilder/porten.svg' }
  },
  {
    id: 'arkivbibliotekarien',
    titel: 'Bibliotekariens sista arkiv',
    beskrivning: 'Ett stilla universitetsbibliotek där böcker ibland ändrar innehåll mellan läsningarna. Du är nattanställd och har börjat lägga märke till mönstret.',
    systemPrompt: 'Du är en spelledare för ett mystiskt och lugnt utforskande-spel i ett universitetsbibliotek. Ge svar i en varm, lågmäld ton, max fyra meningar. Belöna nyfikenhet med detaljer, undvik plötsliga faror, och avsluta med en öppning för spelarens nästa val.',
    uppstart: 'Nattskiftet börjar. Hylla C4, rad 12: boken du katalogiserade igår har nu en fjortonde kapitelrubrik som inte fanns där förut. Vad gör du?',
    bild: 'bilder/bibliotek.svg',
    nyckelord: { bok: 'bilder/bok.svg' }
  },
  {
    id: 'havslabbet',
    titel: 'Station Djuphav',
    beskrivning: 'En liten forskningsstation på havsbotten. Kommunikationen till ytan fungerar, men svaren kommer alltid med sex timmars fördröjning.',
    systemPrompt: 'Du är en spelledare för ett science fiction-äventyr på en havsforskningsstation. Svara med max fyra meningar, bygg en känsla av isolation och teknisk detaljrikedom, och avsluta alltid med en situation som kräver spelarens beslut.',
    uppstart: 'Larmet från sektion 7 vaknar dig. Det är inte ett nödlägeslarm, bara en påminnelse: tryckluckan har öppnats utifrån. Ingen annan är vaken. Vad gör du?',
    bild: 'bilder/djuphav.svg',
    nyckelord: { lucka: 'bilder/lucka.svg' }
  }
];
