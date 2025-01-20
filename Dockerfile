# Étape 1 : Construction
FROM ubuntu:20.04 AS build  

# Installer les dépendances système nécessaires pour Go
RUN apt-get update && apt-get install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer Go
ENV GO_VERSION=1.19  
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Ajouter Go au PATH
ENV PATH="/usr/local/go/bin:${PATH}"

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