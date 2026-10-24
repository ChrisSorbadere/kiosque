# Kiosque — presse internationale

PWA de type Google Actualités : 1 à 3 pays, onglets par thème, journaux personnels, mode comparaison.

## Mise en ligne (GitHub Pages)
1. Crée le dépôt `kiosque` sur GitHub et dépose tous les fichiers (sauf `worker.js`, facultatif).
2. Settings → Pages → Branch `main` / root.
3. Adresse : https://chrissorbadere.github.io/kiosque/

## Relais Cloudflare (recommandé)
Les flux RSS ne sont pas lisibles directement par un navigateur (CORS). Sans relais, l'appli utilise des relais publics gratuits, souvent lents ou bloqués.

1. dash.cloudflare.com → Workers & Pages → Create → Worker « kiosque-relais ».
2. Edit code → colle `worker.js` → Deploy.
3. Copie l'adresse `https://kiosque-relais.<toi>.workers.dev` dans Kiosque → ⚙ Réglages → Relais.

Le relais n'accepte que les requêtes venant de `chrissorbadere.github.io` (modifiable en tête de `worker.js`).

## Utilisation
- Drapeaux en haut : afficher/masquer un pays sans le retirer.
- Onglets : balayer à gauche/droite ; tirer vers le bas pour actualiser.
- « Couverture » : autres journaux sur le même sujet (fourni par Google Actualités).
- « ⇄ Comparer » : le sujet est traduit et recherché dans la presse de chaque pays (7 derniers jours), une colonne par pays. Les mots-clés de chaque colonne sont modifiables (↻). ☆ = suivre le sujet ; il reste dans l'onglet « Comparer ».
- Mes journaux : suggestions par pays ou flux RSS de ton choix, affichés dans un onglet dédié ou mêlés à un thème.

## Limites
- La traduction automatique utilise un service Google non officiel : si elle échoue, corrige les mots-clés à la main.
- Les adresses RSS suggérées peuvent changer ; un journal en échec est signalé en haut du fil.
