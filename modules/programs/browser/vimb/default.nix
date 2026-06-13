{
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        home.packages = with pkgs; [
          vimb
          rbw
          rofi-rbw
        ];

        xdg.configFile."vimb/scripts.js".text = ''
          // ==UserScript==
          // @name         Vimb Cosmetic Layout Cleaner
          // @namespace    http://tampermonkey.net/
          // @version      1.0
          // @description  Collapses layout gaps left behind by host-level blocking
          // @match        *://*/*
          // @run-at       document-start
          // ==/UserScript==

          (function() {
              'use strict';
              const adSelectors = [
                  '.adsbox', '.ad-banner', '.adsbygoogle', 'amp-ad',
                  'div[id^="div-gpt-ad"]', '.sponsored-post', '#sidebar-ads',
                  '.css-1q97669'
              ];

              const style = document.createElement('style');
              style.innerHTML = adSelectors.join(', ') + ' { display: none !important; height: 0 !important; visibility: hidden !important; }';
              
              if (document.documentElement) {
                  document.documentElement.appendChild(style);
              } else {
                  document.addEventListener('DOMContentLoaded', () => {
                      document.documentElement.appendChild(style);
                  });
              }
          })();

          // ==UserScript==
          // @name         YouTube Player Ad Skipper
          // @namespace    http://tampermonkey.net/
          // @version      1.1
          // @description  Bypasses YouTube ads by fast-forwarding and clicking skip buttons
          // @match        *://*.youtube.com/*
          // @run-at       document-idle
          // ==/UserScript==

          (function() {
              'use strict';

              function clearYouTubeAds() {
                  const video = document.querySelector('video');
                  const skipButton = document.querySelector('.ytp-skip-ad-button, .ytp-ad-skip-button-modern');
                  const adOverlay = document.querySelector('.video-ads, .ytp-ad-player-overlay');

                  if (skipButton) {
                      skipButton.click();
                  }

                  if (adOverlay && adOverlay.children.length > 0 && video) {
                      video.muted = true;
                      video.playbackRate = 16.0; 
                  }
              }

              setInterval(clearYouTubeAds, 300);
          })();
        '';

        xdg.configFile."vimb/style.css".text = ''
          html { filter: invert(100%) hue-rotate(180deg) !important; background: #000 !important; }
          img, video, iframe, canvas { filter: invert(100%) hue-rotate(180deg) !important; }
        '';

        xdg.configFile."vimb/config".text = ''
          nmap ,b :open https://raindrop.io/add?link=%
        '';
      }
    )
  ];
}
