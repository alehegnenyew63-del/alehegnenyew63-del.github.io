document.addEventListener('DOMContentLoaded',()=>{
  const toggle=document.querySelector('.nav-toggle');
  const nav=document.querySelector('.site-nav');
  if(toggle && nav){
     toggle.addEventListener('click',()=>{
      const open = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
     });
     // close nav with Escape
     document.addEventListener('keydown', (e)=>{ if(e.key === 'Escape') nav.classList.remove('open'); });
  }

  // Set current year
  const yearEl=document.getElementById('year');
  if(yearEl) yearEl.textContent=new Date().getFullYear();

  // Contact form: open mail client with fields encoded
  const form=document.getElementById('contactForm');
  if(form){
    form.addEventListener('submit',async(e)=>{
      e.preventDefault();
      const data=new FormData(form);
      const name=data.get('name')||'';
      const email=data.get('email')||'';
      const message=data.get('message')||'';
      // Try to load a Formspree endpoint from config.json. If configured, POST the form there.
      try{
        const cfg=await fetch('/config.json').then(r=>r.json());
        // Prefer backend if configured
        const backend = cfg.backend_url || '';
        if(backend){
          const res = await fetch(backend + '/api/contact',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name,email,message})});
          if(res.ok){ alert('Message sent — thank you!'); form.reset(); return; }
        }
        const endpoint=cfg.formspree_endpoint||'';
        if(endpoint){
          const payload = new URLSearchParams();
          payload.append('name',name);
          payload.append('email',email);
          payload.append('message',message);
          const res = await fetch(endpoint,{method:'POST',body:payload,headers:{'Accept':'application/json'}});
          if(res.ok){ alert('Message sent — thank you!'); form.reset(); return; }
        }
      }catch(err){ console.error(err); /* ignore and fallback */ }

      // Fallback: open user's email client with mailto
      const subject=encodeURIComponent('Portfolio contact from '+name);
      const body=encodeURIComponent('Name: '+name+'\nEmail: '+email+'\n\n'+message);
      window.location.href=`mailto:alehegnenyew4@gmail.com?subject=${subject}&body=${body}`;
    });
  }

  // Fetch projects from backend (if available) and render into projects grid
  (async function loadProjects(){
    try{
      const cfg = await fetch('/config.json').then(r=>r.json()).catch(()=>({}));
      const backend = cfg.backend_url || '';
      if(!backend) return;
      const res = await fetch(backend + '/api/projects');
      if(!res.ok) return;
      const projects = await res.json();
      const grid = document.getElementById('projectsGrid');
      if(!grid) return;
      // clear existing placeholder cards (keep first two if you like) — here we clear all and re-render
      grid.innerHTML = '';
      projects.forEach(p => {
        const article = document.createElement('article');
        article.className = 'card fade-up';
        article.tabIndex = 0;
        article.innerHTML = `
          <div class="card-media" aria-hidden="true">
            <svg width="400" height="220" viewBox="0 0 400 220" xmlns="http://www.w3.org/2000/svg" role="img" fill="#e6e9ee"><rect width="400" height="220" rx="8"/></svg>
          </div>
          <div class="card-body">
            <h3><a href="${p.url || '#'}">${escapeHtml(p.title)}</a></h3>
            <p>${escapeHtml(p.description || '')}</p>
            <p class="card-links"><a href="${p.url || '#'}">Project page</a> · <a href="${p.repo || '#'}">Code</a></p>
            <div class="meta">${new Date(p.created_at).toLocaleDateString()}</div>
          </div>`;
        grid.appendChild(article);
      });
      // reveal animations
      setTimeout(()=>document.querySelectorAll('.fade-up').forEach((el,i)=>setTimeout(()=>el.classList.add('visible'), i*80)), 50);
    }catch(err){ console.error('loadProjects', err); }
  })();

  function escapeHtml(s){ return String(s||'').replace(/[&<>"']/g, c=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c])); }
    function escapeHtml(s){ return String(s||'').replace(/[&<>"']/g, c=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c])); }
  });

  // Add small ripple effect for buttons
  document.addEventListener('click', (e)=>{
    const t = e.target.closest('.btn');
    if(!t) return;
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
    requestAnimationFrame(()=>{ span.style.width = '220px'; span.style.height = '220px'; span.style.opacity='0'; });
    setTimeout(()=>span.remove(),500);
  });
