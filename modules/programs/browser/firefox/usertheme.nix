{ ... }:
{
  userChrome = ''
    /* Catppuccin Mocha Mauve - Native Firefox Cascade Theme */

    @media (prefers-color-scheme: dark) {
      :root {
        /* Cascade Main Colour Scheme Core */
        --uc-base-colour: #1e1e2e;
        --uc-highlight-colour: #181825;
        --uc-inverted-colour: #cdd6f4;
        --uc-muted-colour: #6c7086;
        --uc-accent-colour: #cba6f7; /* Mauve */

        /* Container Tabs Palette mapping */
        --uc-identity-colour-blue: #89b4fa;
        --uc-identity-colour-turquoise: #94e2d5;
        --uc-identity-colour-green: #a6e3a1;
        --uc-identity-colour-yellow: #f9e2af;
        --uc-identity-colour-orange: #fab387;
        --uc-identity-colour-red: #f38ba8;
        --uc-identity-colour-pink: #f5c2e7;
        --uc-identity-colour-purple: #cba6f7;
      }
    }

    @media (prefers-color-scheme: light) {
      :root {
        /* Cascade Light Scheme Fallbacks */
        --uc-base-colour: #eff1f5;
        --uc-highlight-colour: #dce0e8;
        --uc-inverted-colour: #4c4f69;
        --uc-muted-colour: #9ca0b0;
        --uc-accent-colour: #8839ef;

        --uc-identity-colour-blue: #1e66f5;
        --uc-identity-colour-turquoise: #179299;
        --uc-identity-colour-green: #40a02b;
        --uc-identity-colour-yellow: #df8e1d;
        --uc-identity-colour-orange: #fe640b;
        --uc-identity-colour-red: #d20f39;
        --uc-identity-colour-pink: #d20f39;
        --uc-identity-colour-purple: #8839ef;
      }
    }

    /* Cascade Native Engine Mapping Styles (No Edit Necessary) */
    :root {
      --lwt-frame: var(--uc-base-colour) !important;
      --lwt-accent-color: var(--lwt-frame) !important;
      --lwt-text-color: var(--uc-inverted-colour) !important;

      --toolbar-field-color: var(--uc-inverted-colour) !important;
      --toolbar-field-focus-color: var(--uc-inverted-colour) !important;
      --toolbar-field-focus-background-color: var(--uc-highlight-colour) !important;
      --toolbar-field-focus-border-color: transparent !important;

      --toolbar-field-background-color: var(--lwt-frame) !important;
      --lwt-toolbar-field-highlight: var(--uc-inverted-colour) !important;
      --lwt-toolbar-field-highlight-text: var(--uc-highlight-colour) !important;
      --urlbar-popup-url-color: var(--uc-accent-colour) !important;

      --lwt-tab-text: var(--lwt-text-color) !important;
      --lwt-selected-tab-background-color: var(--uc-highlight-colour) !important;

      --toolbar-bgcolor: var(--lwt-frame) !important;
      --toolbar-color: var(--lwt-text-color) !important;
      --toolbarseparator-color: var(--uc-accent-colour) !important;
      --toolbarbutton-hover-background: var(--uc-highlight-colour) !important;
      --toolbarbutton-active-background: var(--toolbarbutton-hover-background) !important;

      --lwt-sidebar-background-color: var(--lwt-frame) !important;
      --sidebar-background-color: var(--lwt-sidebar-background-color) !important;

      --urlbar-box-bgcolor: var(--uc-highlight-colour) !important;
      --urlbar-box-text-color: var(--uc-muted-colour) !important;
      --urlbar-box-hover-bgcolor: var(--uc-highlight-colour) !important;
      --urlbar-box-hover-text-color: var(--uc-inverted-colour) !important;
      --urlbar-box-focus-bgcolor: var(--uc-highlight-colour) !important;
    }

    /* Native Multi-Account Container Tabs Mapping Rules */
    .identity-color-blue {
      --identity-tab-color: var(--uc-identity-colour-blue) !important;
      --identity-icon-color: var(--uc-identity-colour-blue) !important;
    }
    .identity-color-turquoise {
      --identity-tab-color: var(--uc-identity-colour-turquoise) !important;
      --identity-icon-color: var(--uc-identity-colour-turquoise) !important;
    }
    .identity-color-green {
      --identity-tab-color: var(--uc-identity-colour-green) !important;
      --identity-icon-color: var(--uc-identity-colour-green) !important;
    }
    .identity-color-yellow {
      --identity-tab-color: var(--uc-identity-colour-yellow) !important;
      --identity-icon-color: var(--uc-identity-colour-yellow) !important;
    }
    .identity-color-orange {
      --identity-tab-color: var(--uc-identity-colour-orange) !important;
      --identity-icon-color: var(--uc-identity-colour-orange) !important;
    }
    .identity-color-red {
      --identity-tab-color: var(--uc-identity-colour-red) !important;
      --identity-icon-color: var(--uc-identity-colour-red) !important;
    }
    .identity-color-pink {
      --identity-tab-color: var(--uc-identity-colour-pink) !important;
      --identity-icon-color: var(--uc-identity-colour-pink) !important;
    }
    .identity-color-purple {
      --identity-tab-color: var(--uc-identity-colour-purple) !important;
      --identity-icon-color: var(--uc-identity-colour-purple) !important;
    }
  '';

  userContent = ''
    /* Catppuccin Mocha Mauve - Core Firefox Internal Pages */

    @media (prefers-color-scheme: dark) {
      /* Native Firefox global settings backdrop setup */
      @-moz-document url-prefix("about:") {
        :root {
          --in-content-page-color: #cdd6f4 !important;
          --color-accent-primary: #cba6f7 !important;
          --color-accent-primary-hover: rgb(217, 191, 249) !important;
          --color-accent-primary-active: rgb(223, 167, 247) !important;
          background-color: #1e1e2e !important;
          --in-content-page-background: #1e1e2e !important;
        }
      }

      /* Firefox Homepage and New Tab Custom Styling */
      @-moz-document url("about:newtab"), url("about:home") {
        :root {
          --newtab-background-color: #1e1e2e !important;
          --newtab-background-color-secondary: #313244 !important;
          --newtab-element-hover-color: #313244 !important;
          --newtab-text-primary-color: #cdd6f4 !important;
          --newtab-wordmark-color: #cdd6f4 !important;
          --newtab-primary-action-background: #cba6f7 !important;
        }
        .icon { color: #cba6f7 !important; }
        .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title { color: #cba6f7 !important; }
        .top-site-outer .search-topsite { background-color: #89b4fa !important; }
        .compact-cards .card-outer .card-context .card-context-icon.icon-download { fill: #a6e3a1 !important; }
      }

      /* Native Preferences Panels Overrides */
      @-moz-document url-prefix("about:preferences") {
        :root {
          --in-content-text-color: #cdd6f4 !important;
          --link-color: #cba6f7 !important;
          --link-color-hover: rgb(217, 191, 249) !important;
          --in-content-box-background: #313244 !important;
        }

        button, menulist {
          background: #313244 !important;
          color: #cdd6f4 !important;
        }
        .main-content { background-color: #11111b !important; }
      }

      /* Firefox Add-ons and Extension Manager Layout */
      @-moz-document url-prefix("about:addons") {
        :root {
          --background-color-box: #1e1e2e !important;
        }
      }
    }
  '';
}