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
          (symlinkJoin {
            name = "vimb-wrapped";
            paths = [ vimb ];
            buildInputs = [ makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/vimb \
                --set GDK_BACKEND "wayland,x11" \
                --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${gst_all_1.gst-libav}/lib/gstreamer-1.0:${gst_all_1.gst-vaapi}/lib/gstreamer-1.0"
            '';
          })
          rbw
          rofi-rbw
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav
          gst_all_1.gst-vaapi
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
          // @name         Vimb Smart Dark Mode Styler
          // @namespace    http://tampermonkey.net/
          // @version      1.1
          // @description  Inverts light-mode websites while protecting YouTube from color distortion
          // @match        *://*/*
          // @run-at       document-start
          // ==/UserScript==

          (function() {
              'use strict';
              // Completely bypass color inversion on YouTube
              if (window.location.hostname.includes("youtube.com") || window.location.hostname.includes("youtu.be")) {
                  return;
              }

              const style = document.createElement('style');
              style.innerHTML = `
                  html { filter: invert(100%) hue-rotate(180deg) !important; background: #000 !important; }
                  img, video, iframe, canvas, [style*="background-image"] { filter: invert(100%) hue-rotate(180deg) !important; }
              `;
              
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
          // @version      2.0
          // @description  Bypasses YouTube ads via instant DOM mutations and playhead forwarders
          // @match        *://*.youtube.com/*
          // @run-at       document-start
          // ==/UserScript==

          (function() {
              'use strict';
              if (!window.location.hostname.includes("youtube.com")) return;

              function checkAndSkipAds() {
                  const skipButtons = [
                      '.ytp-ad-skip-button-modern',
                      '.ytp-skip-ad-button',
                      'button[aria-label^="Skip ad"]'
                  ];

                  // 1. Programmatically trigger skip buttons
                  for (const selector of skipButtons) {
                      const button = document.querySelector(selector);
                      if (button && button.offsetParent !== null) {
                          button.click();
                          return;
                      }
                  }

                  // 2. Fast-forward through unskippable ads instantly
                  const video = document.querySelector('video');
                  if (video && document.querySelector('.ad-showing, .ad-interrupting')) {
                      video.currentTime = video.duration - 0.1;
                  }
              }

              // Use MutationObserver for sub-millisecond reactions to DOM changes
              const observer = new MutationObserver(checkAndSkipAds);
              observer.observe(document.body || document.documentElement, { childList: true, subtree: true });
          })();
        '';

        # Remove the global raw style.css stylesheet reference
        xdg.configFile."vimb/style.css".text = "";

        # Enable default user styling behavior but let scripts handle the dark mode logic
        xdg.configFile."vimb/config".text = ''
          set user-style=off
          nmap ,b :open https://raindrop.io/add?link=%
        '';
      }
    )
  ];
}
