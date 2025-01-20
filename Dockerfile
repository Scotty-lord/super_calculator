# Utiliser une image de base pour la construction avec une version explicite
FROM ubuntu:20.04  

# Autres instructions...

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances Go
COPY go.mod ./
COPY go.sum ./

# Télécharger les dépendances Go
RUN go mod download

# Copier le reste du code source
COPY . .

# Construire l'application
RUN go build -o /calculator

# Utiliser une image de base minimale pour l'exécution avec une version explicite
FROM gcr.io/distroless/base-debian10:latest

# Définir le répertoire de travail
WORKDIR /

# Copier l'exécutable depuis l'étape de construction
COPY --from=build /calculator /calculator

# Définir l'utilisateur non-root
USER nonroot:nonroot

# Définir le point d'entrée de l'application
ENTRYPOINT ["/calculator"]
