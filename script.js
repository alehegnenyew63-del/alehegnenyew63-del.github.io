
document.addEventListener('DOMContentLoaded', () => {
  const toggle = document.querySelector('.nav-toggle');
  const nav = document.querySelector('.site-nav');
  if (toggle && nav) {
    toggle.addEventListener('click', () => {
      const open = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    document.addEventListener('keydown', (e) => { if (e.key === 'Escape') nav.classList.remove('open'); });
  }

  // Theme & Game mode initialization
  const root = document.documentElement;
  const savedTheme = localStorage.getItem('theme');
  const savedGame = localStorage.getItem('gamemode');
  const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  if (savedTheme) root.setAttribute('data-theme', savedTheme);
  else if (prefersDark) root.setAttribute('data-theme', 'dark');
  if (savedGame === 'on') root.setAttribute('data-gamemode', 'on');

  const themeToggle = document.getElementById('themeToggle');
  const gameToggle = document.getElementById('gameToggle');
  function updateThemeUI() { if (themeToggle) themeToggle.textContent = root.getAttribute('data-theme') === 'dark' ? '☀️' : '🌙'; }
  if (themeToggle) {
    themeToggle.addEventListener('click', () => {
      const cur = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
      const next = cur === 'dark' ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      localStorage.setItem('theme', next);
      updateThemeUI();
    });
    updateThemeUI();
  }
  if (gameToggle) {
    if (savedGame === 'on') gameToggle.setAttribute('aria-pressed', 'true');
    gameToggle.addEventListener('click', () => {
      const isOn = root.getAttribute('data-gamemode') === 'on';
      if (isOn) { root.removeAttribute('data-gamemode'); localStorage.setItem('gamemode', 'off'); gameToggle.setAttribute('aria-pressed', 'false'); }
      else { root.setAttribute('data-gamemode', 'on'); localStorage.setItem('gamemode', 'on'); gameToggle.setAttribute('aria-pressed', 'true'); }
    });
  }

  // Set current year
  const yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Reveal helper for placeholders and loaded projects
  function revealElements(scope=document) {
    const els = scope.querySelectorAll('.fade-up');
    els.forEach((el, i) => setTimeout(() => el.classList.add('visible'), i * 80));
  }
  // apply interactions (tilt, hover) to cards
  function applyCardInteractions(scope=document) {
    const cards = scope.querySelectorAll('.card');
    cards.forEach(card => {
      if (card.dataset.interactive) return;
      card.dataset.interactive = '1';
      card.style.transition = 'transform .18s ease, box-shadow .18s ease';
      card.addEventListener('mousemove', (e) => {
        const rect = card.getBoundingClientRect();
        const x = (e.clientX - rect.left) / rect.width;
        const y = (e.clientY - rect.top) / rect.height;
        const rotY = (x - 0.5) * 12; // left/right
        const rotX = (0.5 - y) * 8; // up/down
        card.style.transform = `perspective(900px) rotateX(${rotX}deg) rotateY(${rotY}deg) translateZ(6px)`;
      });
      card.addEventListener('mouseleave', () => { card.style.transform = ''; });
      card.addEventListener('click', () => { card.classList.add('active'); setTimeout(() => card.classList.remove('active'), 400); });
    });
  }

  // Contact form
  const form = document.getElementById('contactForm');
  if (form) {
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const data = new FormData(form);
      const name = data.get('name') || '';
      const email = data.get('email') || '';
      const message = data.get('message') || '';
      try {
        const cfg = await fetch('/config.json').then(r => r.json());
        const backend = cfg.backend_url || '';
        if (backend) {
          const res = await fetch(backend + '/api/contact', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ name, email, message }) });
          if (res.ok) { alert('Message sent — thank you!'); form.reset(); return; }
        }
        const endpoint = cfg.formspree_endpoint || '';
        if (endpoint) {
          const payload = new URLSearchParams();
          payload.append('name', name);
          payload.append('email', email);
          payload.append('message', message);
          const res = await fetch(endpoint, { method: 'POST', body: payload, headers: { 'Accept': 'application/json' } });
          if (res.ok) { alert('Message sent — thank you!'); form.reset(); return; }
        }
      } catch (err) { console.error(err); }
      const subject = encodeURIComponent('Portfolio contact from ' + name);
      const body = encodeURIComponent('Name: ' + name + '\nEmail: ' + email + '\n\n' + message);
      window.location.href = `mailto:alehegnenyew4@gmail.com?subject=${subject}&body=${body}`;
    });
  }

  // Fetch projects from backend and render (if backend configured). If not, keep placeholders.
  (async function loadProjects() {
    try {
      const cfg = await fetch('/config.json').then(r => r.json()).catch(() => ({}));
      const backend = cfg.backend_url || '';
      if (!backend) { revealElements(); applyCardInteractions(); return; }
      const res = await fetch(backend + '/api/projects');
      if (!res.ok) { revealElements(); applyCardInteractions(); return; }
      const projects = await res.json();
      const grid = document.getElementById('projectsGrid');
      if (!grid) { return; }
      grid.innerHTML = '';
      projects.forEach(p => {
        const article = document.createElement('article');
        article.className = 'card fade-up';
        article.tabIndex = 0;
        article.innerHTML = `
          <div class="card-media" aria-hidden="true">
            <img src="${escapeHtml(p.image || 'assets/project-placeholder.png')}" alt="${escapeHtml(p.title)} screenshot" style="width:100%;height:100%;object-fit:cover;border-radius:6px" />
          </div>
          <div class="card-body">
            <h3><a href="${p.url || '#'}">${escapeHtml(p.title)}</a></h3>
            <p>${escapeHtml(p.description || '')}</p>
            <p class="card-links"><a href="${p.url || '#'}">Project page</a> · <a href="${p.repo || '#'}">Code</a></p>
            <div class="meta">${p.created_at ? new Date(p.created_at).toLocaleDateString() : ''}</div>
          </div>`;
        grid.appendChild(article);
      });
      revealElements(grid);
      applyCardInteractions(grid);
    } catch (err) { console.error('loadProjects', err); revealElements(); applyCardInteractions(); }
  })();

  // initial reveal and interactions for static placeholders
  revealElements();
  applyCardInteractions();

  function escapeHtml(s) { return String(s || '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c])); }
});

// Ripple effect for buttons (keeps outside of DOMContentLoaded so clicks are captured)
document.addEventListener('click', (e) => {
  const t = e.target.closest('.btn');
  if (!t) return;
  const rect = t.getBoundingClientRect();
  const span = document.createElement('span');
  span.style.position = 'absolute';
  span.style.left = (e.clientX - rect.left) + 'px';
  span.style.top = (e.clientY - rect.top) + 'px';
  span.style.width = '10px';
  span.style.height = '10px';
  span.style.background = 'rgba(255,255,255,0.12)';
  span.style.borderRadius = '50%';
  span.style.pointerEvents = 'none';
  span.style.transform = 'translate(-50%,-50%)';
  span.style.transition = 'width .5s ease,height .5s ease,opacity .5s ease';
  t.appendChild(span);
  requestAnimationFrame(() => { span.style.width = '220px'; span.style.height = '220px'; span.style.opacity = '0'; });
  setTimeout(() => span.remove(), 500);
});
