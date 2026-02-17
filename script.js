document.addEventListener('DOMContentLoaded',()=>{
  const toggle=document.querySelector('.nav-toggle');
  const nav=document.querySelector('.site-nav');
  if(toggle && nav){
    toggle.addEventListener('click',()=>nav.classList.toggle('open'));
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
});
