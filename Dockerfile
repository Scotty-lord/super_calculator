# Étape 1 : Construction
FROM ubuntu:20.04 AS build  

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances Go
COPY go.mod go.sum ./  

# Télécharger les dépendances Go
RUN go mod download

# Copier le reste du code source
COPY . .

# Construire l'application
RUN go build -o /calculator

# Étape 2 : Exécution
FROM gcr.io/distroless/base-debian10:nonroot  

# Définir le répertoire de travail
WORKDIR /

# Copier l'exécutable depuis l'étape de construction
COPY --from=build /calculator /calculator/  

# Définir l'utilisateur non-root (déjà défini dans l'image distroless)
# USER nonroot:nonroot  # Optionnel, car l'image distroless utilise déjà un utilisateur non-root

# Définir le point d'entrée de l'application
ENTRYPOINT ["/calculator"]