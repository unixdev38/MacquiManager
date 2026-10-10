# MacquiManager - Maquis Boissons Manager

Maquette Flutter + HTML IMAGE FIRST pour la gestion rapide des boissons dans un maquis.

## Priorité : RAPIDITÉ DE VENTE, IMAGE FIRST, SIMPLICITÉ

### Ouverture directe sur vente
- Pas de login, pas de dashboard avant vente
- Grandes images, prix visible, quantité badge
- 1 toucher = +1, +2 disponible, feedback immédiat

### Parcours
Ouvrir app → Choisir table → Toucher images boissons → Vérifier → Valider → Retour vente immédiat

### 12 écrans implémentés

1. **Vente principale** - grille adaptative, catégories visuelles, table selector, total permanent
2. **Choix table** - cartes grandes, états couleur (Libre/En service/Addition)
3. **Récapitulatif commande** - lignes avec image, +/-, sous-total, vider
4. **Confirmation** - icône succès, référence, table, montant, retour rapide
5. **Commandes en cours** - cartes avec statut, heure, nb articles
6. **Détail commande** - articles, ajout, accès paiement
7. **Paiement** - total, déjà payé, reste, modes visuels (Espèces, Mobile Money, Wave, Carte), confirmation payé
8. **Gestion boissons & formats** - cartes avec variants, toggle actif, prix achat/vente, bouteilles/carton (ex: Brakina 24/12)
9. **Stock** - par format, indicateur faible, réception cartons → bouteilles auto, mouvements, correction
10. **Historique ventes** - filtres Aujourd'hui/Hier/Tout, détail
11. **Résumé activité** - total ventes, nb commandes, payées/non réglées, top boissons, état stock
12. **Paramètres** - nom maquis, serveur, adresse centrale, état connexion, préférences

### Design System
- Couleurs: primary #E85D04, background #FFFCF2, états tables vert/orange/rouge
- Typo Inter, rayons 12-20, ombres légères, boutons larges tactiles
- Composants réutilisables: DrinkCard, TableCard, QuantityBadge, OrderLine, OrderCard, PrimaryButton, EmptyState, ConnectionIndicator, CategoryChip

### Architecture Flutter
```
lib/
  core/theme/ - colors, typography, theme
  models/ - drink, category, table, order, stock
  data/ - mock_data (catégories, 12 boissons, variants petite/grande, tables T1-T12, commandes, stock)
  state/ - AppState ChangeNotifier (cart, validation, paiement, stock réception/correction, toggle actif)
  widgets/ - composants réutilisables
  screens/ - 12 écrans
  app.dart - navigation centrale, bottom nav + drawer, vente = écran principal
  main.dart
```

### Données fictives
- Catégories: Bières, Softs, Jus, Eaux, Energy, Vins
- Boissons: Brakina (33cl 24/carton, 65cl 12/carton), Beaufort, Castel, Flag, Coca, Fanta, Sprite, LaFi, Dafani, Bissap, XXL, Bandji
- Prix FCFA, tables T1-T12 avec statuts, commandes ouvertes, historique payé, stock avec seuils

### Comportements simulés
- Ajout panier instantané, quantité badge, total live
- Validation → création commande avec ref, update table busy, décrément stock, mouvement vente
- Paiement → passage en historique, libération table
- Stock réception: choix cartons → calcul bouteilles (2 cartons 24 = 48)
- Toggle actif boisson, filtres catégories, historique, etc.

### Maquette HTML
`maquette_html/index.html` - SPA vanilla JS, même design, navigable, tactile, preview immédiat.
Ouvrir avec live server: `npx serve maquette_html` ou directement fichier.

### Lancer Flutter (si SDK disponible)
```bash
flutter pub get
flutter run -d android
```

L'app s'ouvre directement sur Vente, sans auth.

### Limites maquette
- Données en mémoire, pas de backend/API/DB
- Pas de synchro Wi-Fi réelle, connexion simulée
- Pas de paiement réel
- Pas de comptes/rôles

### Validation
- [x] Ouverture directe vente
- [x] Pas de connexion/compte
- [x] Images principales
- [x] Commande en quelques gestes
- [x] Quantités/totaux immédiats
- [x] Parcours validation clair
- [x] Stock, paiement, historique, gestion présents
- [x] Actions fonctionnelles
- [x] Code structuré, composants réutilisables
- [x] Lisible sur téléphone Android
