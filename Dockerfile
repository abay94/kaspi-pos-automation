# Kaspi Pay POS automation — container image.
#
# The runtime state (keypair.json, device.json, ecdh-keypair.json,
# webhooks.json) is NOT part of the image: it is the pairing Kaspi knows the
# device by, it is generated on first run, and it must survive every deploy.
# In Kubernetes /app is a PersistentVolumeClaim and an init container copies
# fresh code over it while preserving those four files.
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

EXPOSE 3000

# Server binds 0.0.0.0:3000 inside the container; it is never exposed
# publicly — only the backend reaches it, over the cluster network.
CMD ["node", "server.js"]
