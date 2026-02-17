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
