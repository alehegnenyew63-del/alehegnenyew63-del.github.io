document.addEventListener('DOMContentLoaded', ()=>{
  const form = document.getElementById('projectForm');
  const status = document.getElementById('status');
  const list = document.createElement('div');
  list.id = 'projectList';
  document.querySelector('.container').appendChild(list);

  // load existing projects
  (async function load(){
    try{
      const res = await fetch('/api/projects');
      if(!res.ok) return;
      const data = await res.json();
      renderList(data);
    }catch(err){ console.error(err); }
  })();

  function renderList(items){
    list.innerHTML = '';
    if(!items.length){ list.innerHTML = '<p class="muted">No projects yet.</p>'; return; }
    items.forEach(p=>{
      const row = document.createElement('div'); row.className = 'proj';
      row.innerHTML = `<strong>${escapeHtml(p.title)}</strong> <span class="muted">${escapeHtml(p.slug)}</span><div class="proj-actions"><button data-slug="${escapeHtml(p.slug)}" class="edit btn">Edit</button> <button data-slug="${escapeHtml(p.slug)}" class="del btn">Delete</button></div>`;
      list.appendChild(row);
    });
    // wire actions
    list.querySelectorAll('.edit').forEach(b=>b.addEventListener('click', (e)=>{
      const slug = e.target.dataset.slug; return loadProjectToForm(slug);
    }));
    list.querySelectorAll('.del').forEach(b=>b.addEventListener('click', async (e)=>{
      const slug = e.target.dataset.slug;
      if(!confirm('Delete project "'+slug+'"?')) return;
      const key = prompt('Enter ADMIN API KEY to delete');
      if(!key) return status.textContent = 'Cancelled';
      const res = await fetch('/api/projects/'+encodeURIComponent(slug), { method: 'DELETE', headers: { 'x-api-key': key } });
      if(res.ok){ status.textContent = 'Deleted'; // refresh
        const refreshed = await fetch('/api/projects'); renderList(await refreshed.json());
      } else { const j = await res.json().catch(()=>({})); status.textContent = 'Error: '+(j.error||res.statusText); }
    }));
  }

  async function loadProjectToForm(slug){
    try{
      const res = await fetch('/api/projects/'+encodeURIComponent(slug));
      if(!res.ok) return status.textContent = 'Could not load project';
      const p = await res.json();
      form.title.value = p.title || '';
      form.slug.value = p.slug || '';
      form.description.value = p.description || '';
      form.url.value = p.url || '';
      form.repo.value = p.repo || '';
      status.textContent = 'Loaded into form for editing.';
    }catch(err){ status.textContent = 'Load error'; }
  }

  form.addEventListener('submit', async (e)=>{
    e.preventDefault();
    const formData = new FormData(form);
    const payload = {
      title: formData.get('title'),
      slug: formData.get('slug'),
      description: formData.get('description'),
      url: formData.get('url'),
      repo: formData.get('repo')
    };

    const key = prompt('Enter ADMIN API KEY (kept only in your browser)');
    if(!key){ status.textContent = 'Cancelled — API key required.'; return; }

    try{
      const res = await fetch('/api/projects', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': key
        },
        body: JSON.stringify(payload)
      });
      if(res.ok){ status.textContent = 'Project saved.'; form.reset(); }
      else { const j = await res.json().catch(()=>({})); status.textContent = 'Error: '+(j.error||res.statusText); }
    }catch(err){ status.textContent = 'Network error: '+err.message; }
  });
});

function escapeHtml(s){ return String(s||'').replace(/[&<>"']/g, c=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c])); }
