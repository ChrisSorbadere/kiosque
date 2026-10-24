#!/usr/bin/env bash
# Récupère les flux Google Actualités (pays × thèmes) et prépare le site dans _site/.
# En cas d'échec d'un flux, on reprend la version déjà publiée sur GitHub Pages.
set -u
SITE="_site"
PUBLISHED="https://chrissorbadere.github.io/kiosque/data"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36"
THEMES="une WORLD NATION BUSINESS TECHNOLOGY SCIENCE HEALTH SPORTS ENTERTAINMENT"

rm -rf "$SITE" && mkdir -p "$SITE/data"
cp -r index.html manifest.json sw.js icons "$SITE/"

ok=0; ko=0; failed=""
while read -r cc hl gl ceid; do
  [ -z "$cc" ] && continue
  for th in $THEMES; do
    q="hl=$hl&gl=$gl&ceid=$ceid"
    if [ "$th" = "une" ]; then url="https://news.google.com/rss?$q"
    else url="https://news.google.com/rss/headlines/section/topic/$th?$q"; fi
    out="$SITE/data/$cc-$th.xml"
    if curl -sfL -m 20 -A "$UA" -H "Accept-Language: $hl" "$url" -o "$out" && grep -q "<item>" "$out"; then
      ok=$((ok+1))
    else
      ko=$((ko+1)); failed="$failed $cc-$th"
      curl -sfL -m 20 "$PUBLISHED/$cc-$th.xml" -o "$out" || rm -f "$out"
    fi
    sleep 0.3
  done
done <<'EOF'
FR fr FR FR:fr
BE fr BE BE:fr
CH fr CH CH:fr
CA fr-CA CA CA:fr
MA fr MA MA:fr
ES es ES ES:es
MX es-419 MX MX:es-419
AR es-419 AR AR:es-419
GB en-GB GB GB:en
US en-US US US:en
DE de DE DE:de
IT it IT IT:it
PT pt-PT PT PT:pt-150
EOF

# Si aucun flux n'a pu être récupéré, on garde la date de la dernière réussite
if [ "$ok" -eq 0 ]; then
  curl -sfL -m 20 "$PUBLISHED/status.json" -o "$SITE/data/status.json" || echo '{}' > "$SITE/data/status.json"
else
  printf '{"updated":%s,"ok":%d,"ko":%d,"failed":"%s"}\n' "$(date +%s)000" "$ok" "$ko" "${failed# }" > "$SITE/data/status.json"
fi
echo "Flux récupérés : $ok — échecs : $ko"
[ "$ko" -gt 0 ] && echo "Échecs :$failed"
exit 0
