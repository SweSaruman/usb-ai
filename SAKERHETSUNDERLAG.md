# SAKERHETSUNDERLAG – usb-ai

Detta dokument beskriver hur applikationen fungerar och vad en IT-säkerhetsgranskning bör kontrollera.

## Översikt

usb-ai är en lokal AI-applikation som körs direkt från ett USB-minne på Windows (x64 och ARM64). Den kräver ingen installation, inga administratörsrättigheter och ingen nätverksåtkomst under användning.

## Komponenter

| Komponent | Roll |
|---|---|
| `start.bat` | Integritetskontroll, val av binär för processorarkitektur, start av servern, öppnar webbläsaren |
| `verifiera.bat` | Fristående integritetskontroll av samtliga filer |
| `forbered.bat` / `forbered.ps1` | Engångsförberedelse med internet: laddar ner llama.cpp-binärer och modell, verifierar SHA256, kör självtest, skapar `SHA256SUMS.txt` |
| `bin/win-x64`, `bin/win-arm64` | llama.cpp (`llama-server.exe`) för respektive arkitektur |
| `models/` | Språkmodell i GGUF-format |
| `app/` | Webbgränssnitt (`rollspel.html`) och scenarier (`scenarier.js`) |

## Nätverk

- Under **användning**: ingen nätverksåtkomst alls. Servern (`llama-server.exe`) binder endast till `127.0.0.1:8080`, alltså loopback-gränssnittet, och når inte ut från datorn.
- Under **förberedelse** (`forbered.bat`): HTTPS-nedladdningar från `github.com`/`objects.githubusercontent.com` (llama.cpp) och `huggingface.co` (modell). Modellen verifieras mot utgivarens SHA256 via Hugging Faces API innan den accepteras.

## Integritetskontroll

- `SHA256SUMS.txt` skapas av `forbered.ps1` och omfattar samtliga filer på stickan utom sig själv.
- `start.bat` vägrar starta om någon fil avviker, och `verifiera.bat` kan användas för manuell kontroll.
- Rekommendation: spara en kopia av `SHA256SUMS.txt` utanför stickan och aktivera stickans skrivskydd efter förberedelsen.

## Behörigheter och spår

- Inga administratörsrättigheter krävs. Inga registerändringar och inga filer skrivs utanför USB-minnet (temp-fil för nedladdade arkiv tas bort efter installation).
- Inga personuppgifter samlas in och ingen data lämnar datorn.

## Vad granskaren bör titta på

1. Att `start.bat` verkligen binder till `127.0.0.1` och inte `0.0.0.0`.
2. Att binärerna i `bin/` kommer från llama.cpp officiella GitHub-utgivning och att modellen kommer från utgivarens officiella HF-repo.
3. Att `SHA256SUMS.txt` på masterstickan överensstämmer med den arkiverade kopian.
4. Att nya scenarier (`app/scenarier.js`) följs av `forbered.bat summor` innan stickan tas i bruk.

## Begränsningar

- En språkmodell på 4 miljarder parametrar kan producera felaktigt eller olämpligt innehåll; scenarier innehåller styrning via systemprompt men modellen är inte censurerad.
- exFAT har ingen filrättighetskontroll; skrivskydd på stickan (där hårdvarustödet finns) är den effektiva skyddet mot manipulation.
