# usb-ai

En lokal AI som körs direkt från ett USB-minne på Windows (x64 och ARM64). Inget nätverk, ingen installation och inga administratörsrättigheter krävs.

## Förbereda masterstickan

Görs en gång av IT eller ansvarig, med internetuppkoppling:

1. Formatera stickan som exFAT och kopiera hela denna mapp till den.
2. Kör `forbered.bat` (Gemma 4 E4B) eller `forbered.bat qwen` (Qwen 3.5 4B).
   Nedladdningarna verifieras mot utgivarens SHA256 och ett självtest körs.
3. Spara en kopia av `SHA256SUMS.txt` utanför stickan.
4. Slå på stickans skrivskydd.

## Använda

Dubbelklicka på `start.bat`. Filerna kontrolleras, modellen läses in och rollspelet öppnas i webbläsaren på `http://127.0.0.1:8080/rollspel.html`.

### Tärningar och val

Berättaren avslutar varje svar med numrerade val. Klicka på ett val för att välja det direkt, eller välj en tärning (T4, T6, T8, T10, T12 eller T20) och tryck på "Slå tärning" – tärningens sidor fördelas över valen, så olika tärningar viktar valen olika (vikterna visas i gränssnittet). Slaget slås lokalt med kryptografiskt säker slump, helt utan nätverkstrafik, och skickas sedan till modellen tillsammans med det valda alternativet.

### Bilder

Varje scenario kan visa en bild när det startar (`bild` i `scenarier.js`) och en bild första gången ett nyckelord nämns i berättelsen (`nyckelord`). Bilderna ligger i `app/bilder/` som små SVG-filer (några KB vardera). Bildskapande AI (t.ex. FLUX) är för tungt för ett USB-minne och ingår inte — men egna SVG/PNG-bilder går bra att lägga in där, håll dem små. Kom ihåg `forbered.bat summor` efter ändringar i `app/`.

## Kontrollera stickan

`verifiera.bat` kontrollerar alla filer, inklusive modellen, mot `SHA256SUMS.txt`.

## Innehåll

| Fil/mapp | Beskrivning |
|---|---|
| `start.bat` | Startar servern efter integritetskontroll |
| `verifiera.bat` | Integritetskontroll |
| `forbered.bat` / `forbered.ps1` | Förberedelse av masterstickan |
| `SHA256SUMS.txt` | Facit, skapas av `forbered` |
| `bin/win-x64` | llama.cpp för Intel/AMD |
| `bin/win-arm64` | llama.cpp för ARM (t.ex. Snapdragon) |
| `models/` | Språkmodellen (GGUF) |
| `app/` | Rollspelet (`rollspel.html`, `scenarier.js`, `bilder/`) |
| `SAKERHETSUNDERLAG.md` | Beskrivning för IT-säkerhetsgranskning |

## Nya scenarier

Nya scenarier läggs i `app/scenarier.js`. Kör därefter `forbered.bat summor` så att `SHA256SUMS.txt` stämmer – annars stoppar `start.bat`.
