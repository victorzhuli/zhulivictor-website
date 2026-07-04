// Progressive enhancement: reveal sections on scroll.
(function () {
  if (typeof window === 'undefined' || !('IntersectionObserver' in window)) return;
  var prefersReduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (prefersReduced) return;

  document.addEventListener('DOMContentLoaded', function () {
    var selectors = [
      '.hero', '.research-impact', '.featured-research',
      '.section', '.card', '.research-card', '.timeline-item',
      '.publication', '.contact-info'
    ];
    var targets = document.querySelectorAll(selectors.join(','));
    if (!targets.length) return;

    var observer = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          obs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.08, rootMargin: '0px 0px -40px 0px' });

    targets.forEach(function (el, i) {
      el.classList.add('reveal');
      el.style.transitionDelay = Math.min(i % 6, 5) * 60 + 'ms';
      observer.observe(el);
    });
  });
})();
