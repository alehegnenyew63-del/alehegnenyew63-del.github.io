# Portfolio Backend

This small Node/Express backend provides a contact API and a simple projects CMS using SQLite.

Quick start

1. Install dependencies and create `.env` from `.env.example`:

```powershell
cd server
npm install
copy .env.example .env
# edit .env and set ADMIN_API_KEY and CORS_ORIGIN
npm run dev
```

2. The server will run on `http://localhost:5000` by default. Endpoints:
- `POST /api/contact` — accepts JSON `{ name, email, message }`
- `GET /api/projects` — returns JSON list of projects
- `POST /api/projects` — admin only, set `x-api-key` header to `ADMIN_API_KEY` value to upsert projects

Deploy: build the Docker image and run with a persistent volume for `data/`.

Docker Compose

You can run the backend with Docker Compose (creates `./data` for the SQLite file):

```powershell
cd server
docker compose up -d --build
# open http://localhost:5000/health to verify
```

Admin UI

The repository contains a minimal admin UI at `/admin/index.html` served by the backend (if the `server/admin` folder is present). Use it to add or update projects. The page will prompt you for the `ADMIN_API_KEY` (from your `.env` or compose environment) and will send a secure `x-api-key` header.

SMTP / Email forwarding

To enable email forwarding for contact messages, set the following values in your `.env` or Docker Compose environment:

- `SMTP_HOST` — your SMTP server host (e.g., smtp.gmail.com)
- `SMTP_PORT` — optional port (default 587)
- `SMTP_USER` — SMTP username (also used as the 'to' address for notifications)
- `SMTP_PASS` — SMTP password
- `SITE_OWNER` — optional display name used in confirmation emails

When configured, the server will send the contact to `SMTP_USER` and optionally a short confirmation to the sender's email address.

