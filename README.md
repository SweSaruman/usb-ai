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
| `app/` | Rollspelet (`rollspel.html`, `scenarier.js`) |
| `SAKERHETSUNDERLAG.md` | Beskrivning för IT-säkerhetsgranskning |

## Nya scenarier

Nya scenarier läggs i `app/scenarier.js`. Kör därefter `forbered.bat summor` så att `SHA256SUMS.txt` stämmer – annars stoppar `start.bat`.
