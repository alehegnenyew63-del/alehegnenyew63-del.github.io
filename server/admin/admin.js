document.addEventListener('DOMContentLoaded', ()=>{
  const form = document.getElementById('projectForm');
  const status = document.getElementById('status');

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
