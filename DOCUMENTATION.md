# 📚 DOCUMENTATION COMPLÈTE DU PROJET FXNOW

## 🎯 Vue d'Ensemble

FXNow est une application Flutter de conversion de devises utilisant l'architecture **Clean Architecture** avec les patterns suivants :
- **Riverpod** pour la gestion d'état
- **Repository Pattern** pour l'accès aux données
- **StateNotifier** pour la logique métier
- **GoRouter** pour la navigation

---

## 🏗️ Architecture Technique

### Diagramme de Flux de Données

```
┌──────────────────────────────────────────────────────────────┐
│                        UI LAYER                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ converter_page.dart                                     │  │
│  │ - Affichage de l'interface                             │  │
│  │ - Gestion de la saisie utilisateur                     │  │
│  │ - Widgets : calculator_keypad, currency_selector       │  │
│  └───────────────────┬──────────────────────────────────────┘  │
└────────────────────────┼─────────────────────────────────────┘
                         │ observe/modifie
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                   CONTROLLER LAYER                           │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ converter_controller.dart                               │  │
│  │ - StateNotifier<ConverterState>                        │  │
│  │ - Gère l'état de la conversion                         │  │
│  │ - Méthodes : setAmount, swap, refresh, etc.           │  │
│  └───────────────────┬──────────────────────────────────────┘  │
└────────────────────────┼─────────────────────────────────────┘
                         │ appelle
                         ▼
┌──────────────────────────────────────────────────────────────┐
│                   REPOSITORY LAYER                           │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ rates_repository.dart                                   │  │
│  │ - Logique métier                                       │  │
│  │ - Gestion du cache vs API                             │  │
│  │ - Validation et traitement des données                │  │
│  └───────────┬─────��──────────────┬─────────────────────────┘  │
└──────────────┼────────────────────┼─────────────────────────┘
               │                    │
               ▼                    ▼
┌──────────────────────┐  ┌──────────────────────┐
│   DATA SOURCES       │  │   DATA SOURCES       │
│  ┌────────────────┐  │  │  ┌────────────────┐  │
│  │ rates_api.dart │  │  │  │cache_service.  │  │
│  │ (Dio/HTTP)     │  │  │  │dart (SharedPref)│ │
│  └────────────────┘  │  │  └────────────────┘  │
│   API Frankfurter    │  │   Cache Local        │
└──────────────────────┘  └──────────────────────┘
```

### Flux d'Exécution d'une Conversion

```
1. Utilisateur saisit "100" sur le clavier
   └─> converter_page.dart: _handleNumberInput("1")
       └─> setState(() => _displayAmount = "1")
   
2. Utilisateur saisit "0"
   └─> converter_page.dart: _handleNumberInput("0")
       └─> setState(() => _displayAmount = "10")
   
3. Utilisateur saisit "0"
   └─> converter_page.dart: _handleNumberInput("0")
       └─> setState(() => _displayAmount = "100")
       └─> converterController.setAmount(100.0)
           └─> Calcul : 100 × rate.rate
           └─> state = state.copyWith(result: calculatedResult)

4. UI se met à jour automatiquement (Riverpod observe le state)
   └─> result_display.dart affiche le résultat formaté
```

---

## 📖 Guide de Lecture du Code

### Pour Comprendre le Projet, Lire dans cet Ordre :

#### 1. **Démarrage de l'Application**
```
1️⃣ lib/main.dart
   ↓ Initialise l'app et le cache
   
2️⃣ lib/src/app/app.dart
   ↓ Configure les thèmes et la localisation
   
3️⃣ lib/src/router/routes.dart
   ↓ Définit la navigation
```

#### 2. **Page Principale**
```
4️⃣ lib/src/features/converter/ui/converter_page.dart
   - Comprendre la structure de l'UI
   - Voir comment les widgets sont organisés
   - Observer les interactions utilisateur
```

#### 3. **Logique Métier**
```
5️⃣ lib/src/features/converter/controllers/converter_controller.dart
   - Comprendre la gestion d'état
   - Voir comment les calculs sont effectués
   - Observer le pattern StateNotifier
```

#### 4. **Accès aux Données**
```
6️⃣ lib/src/data/repositories/rates_repository.dart
   - Comprendre la logique cache vs API
   - Voir la gestion des erreurs
   
7️⃣ lib/src/data/api/rates_api.dart
   - Communication HTTP avec Dio
   
8️⃣ lib/src/data/cache/cache_service.dart
   - Persistance locale
```

#### 5. **Widgets Réutilisables**
```
9️⃣ lib/src/features/converter/widgets/calculator_keypad.dart
   - Clavier numérique personnalisé
   
🔟 lib/src/features/converter/widgets/currency_selector.dart
   - Sélecteur de devise avec drapeau
```

---

## 📚 Glossaire des Termes

### Termes Flutter

| Terme | Définition |
|-------|------------|
| **Widget** | Élément d'interface utilisateur (bouton, texte, etc.) |
| **StatefulWidget** | Widget qui peut changer d'état (ex: formulaire) |
| **StatelessWidget** | Widget immuable qui ne change pas |
| **BuildContext** | Référence à la position d'un widget dans l'arbre |
| **setState()** | Méthode pour mettre à jour l'interface |

### Termes Riverpod

| Terme | Définition |
|-------|------------|
| **Provider** | Fournisseur de données global accessible partout |
| **StateNotifier** | Gestionnaire d'état avec méthodes de modification |
| **ConsumerWidget** | Widget qui observe les changements de providers |
| **ref.watch()** | Observe un provider et se reconstruit si changement |
| **ref.read()** | Lit un provider sans observer les changements |

### Termes du Domaine

| Terme | Définition |
|-------|------------|
| **Taux de change** | Valeur d'une devise par rapport à une autre |
| **Devise source** | Devise à convertir (FROM) |
| **Devise cible** | Devise résultat de la conversion (TO) |
| **Cache** | Sauvegarde locale temporaire des données |
| **API** | Interface de programmation pour récupérer des données |
| **Swap** | Inversion de la devise source et cible |

### Patterns Utilisés

| Pattern | Usage dans le Projet |
|---------|---------------------|
| **Repository Pattern** | `rates_repository.dart` - Abstraction de l'accès aux données |
| **State Management** | `converter_controller.dart` - Gestion réactive de l'état |
| **Dependency Injection** | `providers.dart` - Injection des dépendances via Riverpod |
| **Clean Architecture** | Séparation claire : UI → Controller → Repository → Data |

---

## 🎓 Concepts Clés Expliqués

### 1. Immutabilité

```dart
// ❌ MAUVAIS : Modification directe
state.amount = 100;  // Ne fonctionne pas !

// ✅ BON : Création d'un nouvel état
state = state.copyWith(amount: 100);
```

**Pourquoi ?** L'immutabilité permet à Riverpod de détecter les changements et de mettre à jour l'UI automatiquement.

### 2. Gestion d'État Réactive

```dart
// Dans le controller
void setAmount(double amount) {
  state = state.copyWith(amount: amount);  // Change l'état
}

// Dans l'UI
final state = ref.watch(converterControllerProvider);  // S'abonne aux changements
Text('${state.amount}');  // Se reconstruit automatiquement
```

### 3. Async/Await

```dart
Future<void> _loadRate() async {
  // 1. Marque la fonction comme asynchrone
  
  final result = await _repository.getLatestRate(...);
  // 2. Attend la réponse avant de continuer
  
  state = state.copyWith(rate: result.rate);
  // 3. Met à jour l'état une fois les données reçues
}
```

---

