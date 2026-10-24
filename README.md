# Kiosque — presse internationale

PWA de type Google Actualités : 1 à 3 pays, onglets par thème, journaux personnels, mode comparaison.
Adresse : https://chrissorbadere.github.io/kiosque/

## Fonctionnement
- **Onglets par thème** : la GitHub Action `feeds.yml` récupère toutes les 30 min les flux Google Actualités (13 pays × 9 thèmes) et les publie dans `data/` avec le site. Google bloque les relais Cloudflare, d'où ce passage par GitHub.
- **Mes journaux** et **mode comparaison** (Bing Actualités) passent par le relais Cloudflare `kiosque-relais` (code : `worker.js`).
- **Traduction** des sujets comparés : MyMemory (gratuit, sans clé, quota journalier).

## Réglage GitHub requis
Settings → Pages → Source : **GitHub Actions**.

## Limites
- GitHub suspend les tâches planifiées après 60 jours sans commit sur le dépôt : relancer alors l'Action à la main (onglet Actions → Run workflow).
- Si Google bloque aussi les serveurs GitHub, les onglets gardent la dernière version publiée ; l'heure de mise à jour s'affiche en haut du fil.
