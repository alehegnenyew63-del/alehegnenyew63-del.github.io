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
    form.addEventListener('submit',(e)=>{
      e.preventDefault();
      const data=new FormData(form);
      const name=data.get('name')||'';
      const email=data.get('email')||'';
      const message=data.get('message')||'';
      const subject=encodeURIComponent('Portfolio contact from '+name);
      const body=encodeURIComponent('Name: '+name+'\nEmail: '+email+'\n\n'+message);
      window.location.href=`mailto:you@example.com?subject=${subject}&body=${body}`;
    });
  }
});
