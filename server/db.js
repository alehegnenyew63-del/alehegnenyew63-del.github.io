const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

function init(dbFile){
  const dir = path.dirname(dbFile);
  if(!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  const db = new Database(dbFile);

  db.pragma('journal_mode = WAL');

  db.prepare(`CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`).run();

  db.prepare(`CREATE TABLE IF NOT EXISTS projects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    slug TEXT UNIQUE,
    description TEXT,
    url TEXT,
    repo TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`).run();

  return db;
}

module.exports = { init };
