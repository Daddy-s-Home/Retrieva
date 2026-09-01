(function () {
  'use strict';

  var host = document.getElementById('auth-particles');
  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  if (!host || reduceMotion.matches || typeof window.particlesJS !== 'function') {
    return;
  }

  var script = document.currentScript;
  var configUrl = new URL('particlesjs-config.json', script.src).href;

  window.particlesJS.load('auth-particles', configUrl);
})();
