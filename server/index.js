require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const path = require('path');
const { init } = require('./db');
const fs = require('fs');
const nodemailer = require('nodemailer');

const PORT = process.env.PORT || 5000;
const DB_FILE = process.env.DATABASE_FILE || './data/portfolio.db';
const ADMIN_API_KEY = process.env.ADMIN_API_KEY || 'dev-key';
const CORS_ORIGIN = process.env.CORS_ORIGIN || '*';

const db = init(DB_FILE);

const app = express();
app.use(helmet());
app.use(express.json({ limit: '200kb' }));
app.use(express.urlencoded({ extended: false }));
app.use(cors({ origin: CORS_ORIGIN }));

const contactLimiter = rateLimit({ windowMs: 60*1000, max: 6 });

// POST /api/contact
app.post('/api/contact', contactLimiter, async (req, res) => {
  try{
    const { name, email, message } = req.body || {};
    if(!name || !email || !message) return res.status(400).json({ error: 'Missing fields' });
    const stmt = db.prepare('INSERT INTO messages (name,email,message) VALUES (?,?,?)');
    stmt.run(name, email, message);

    // Optionally forward by email if SMTP is configured
    if(process.env.SMTP_HOST && process.env.SMTP_USER){
      try{
        const transporter = nodemailer.createTransport({
          host: process.env.SMTP_HOST,
          port: process.env.SMTP_PORT || 587,
          secure: false,
          auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
        });
        await transporter.sendMail({
          from: process.env.SMTP_USER,
          to: process.env.SMTP_USER,
          subject: `Portfolio contact from ${name}`,
          text: `Name: ${name}\nEmail: ${email}\n\n${message}`
        });
      }catch(err){ console.error('SMTP send failed', err.message); }
    }

    return res.json({ ok: true });
  }catch(err){
    console.error(err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// GET /api/projects — return projects table rows
app.get('/api/projects', (req,res)=>{
  try{
    const rows = db.prepare('SELECT id,title,slug,description,url,repo,created_at FROM projects ORDER BY created_at DESC').all();
    res.json(rows);
  }catch(err){ res.status(500).json({ error: 'Server error' }); }
});

// POST /api/projects — admin only (x-api-key)
app.post('/api/projects', (req,res)=>{
  const key = req.get('x-api-key') || '';
  if(!key || key !== ADMIN_API_KEY) return res.status(403).json({ error: 'Forbidden' });
  const { title, slug, description, url, repo } = req.body || {};
  if(!title || !slug) return res.status(400).json({ error: 'Missing title or slug' });
  try{
    const upsert = db.prepare(`INSERT INTO projects (title,slug,description,url,repo) VALUES (?,?,?,?,?)
      ON CONFLICT(slug) DO UPDATE SET title=excluded.title, description=excluded.description, url=excluded.url, repo=excluded.repo`);
    upsert.run(title,slug,description||'',url||'',repo||'');
    res.json({ ok: true });
  }catch(err){ console.error(err); res.status(500).json({ error: 'Server error' }); }
});

// Serve a minimal health endpoint
app.get('/health', (req,res)=>res.json({ status: 'ok' }));

// Serve static admin UI if added
const adminPath = path.join(__dirname,'admin');
if(fs.existsSync(adminPath)) app.use('/admin', express.static(adminPath));

app.listen(PORT, ()=>console.log(`Server listening on ${PORT}`));
