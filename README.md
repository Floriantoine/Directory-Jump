
# Directory Jump

Directory Jump est un script shell qui permet de naviguer rapidement et efficacement dans les répertoires et les fichiers de votre système.

## Fonctionnalités

- Navigation rapide dans les répertoires et les fichiers.
- Autocomplétion avec rofi.
- Mise à jour automatique de l'historique des répertoires visités.
- Options pour ouvrir le répertoire sélectionné dans un éditeur ou un nouveau terminal.

## Utilisation

```bash
./dj.sh [options]
./dj.sh [target]
```

### Options

- `-maxdepth` : Définit la profondeur maximale pour la recherche de répertoires et de fichiers.
- `-c` : Ouvre le répertoire sélectionné dans l'éditeur par défaut.
- `-n` ou `--new` : Ouvre le répertoire sélectionné dans un nouveau terminal.
- `-h` ou `--help` : Affiche l'aide.
- `-e` : Définit l'éditeur.
- `-t` : Définit le terminal.

## Exemples

```bash
./dj.sh MyBestProject
```

Pour naviguer dans les répertoires avec une profondeur maximale de 2 :

```bash
./dj.sh -maxdepth 2
```

Pour ouvrir le répertoire sélectionné dans un nouvel terminal :

```bash
./dj.sh -n
```

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
