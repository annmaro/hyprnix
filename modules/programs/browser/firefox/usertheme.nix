{ ... }:
{
  userChrome = ''
    /* Gruvbox Dark AMOLED - Native Firefox Cascade Theme */

    @media (prefers-color-scheme: dark) {
      :root {
        /* Cascade Main Colour Scheme Core */
        --uc-base-colour: #000000;          /* True OLED Black */
        --uc-highlight-colour: #1d2021;     /* Gruvbox Dark Material */
        --uc-inverted-colour: #fbf1c7;      /* Gruvbox Cream Text */
        --uc-muted-colour: #7c6f64;         /* Gruvbox Muted Gray */
        --uc-accent-colour: #fabd2f;        /* Gruvbox Gold/Yellow */

        /* Container Tabs Palette mapping */
        --uc-identity-colour-blue: #83a598;
        --uc-identity-colour-turquoise: #8ec07c;
        --uc-identity-colour-green: #b8bb26;
        --uc-identity-colour-yellow: #fabd2f;
        --uc-identity-colour-orange: #fe8019;
        --uc-identity-colour-red: #fb4934;
        --uc-identity-colour-pink: #d3869b;
        --uc-identity-colour-purple: #d3869b;
      }
    }

    @media (prefers-color-scheme: light) {
      :root {
        /* Cascade Light Scheme Fallbacks (Kept clean and fallback intact) */
        --uc-base-colour: #fbf1c7;
        --uc-highlight-colour: #ebdbb2;
        --uc-inverted-colour: #282828;
        --uc-muted-colour: #928374;
        --uc-accent-colour: #b57614;

        --uc-identity-colour-blue: #076678;
        --uc-identity-colour-turquoise: #427b58;
        --uc-identity-colour-green: #79740e;
        --uc-identity-colour-yellow: #b57614;
        --uc-identity-colour-orange: #af3a03;
        --uc-identity-colour-red: #9d0006;
        --uc-identity-colour-pink: #8f3f71;
        --uc-identity-colour-purple: #8f3f71;
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
    /* Gruvbox Dark AMOLED - Core Firefox Internal Pages */

    @media (prefers-color-scheme: dark) {
      /* Native Firefox global settings backdrop setup */
      @-moz-document url-prefix("about:") {
        :root {
          --in-content-page-color: #fbf1c7 !important;
          --color-accent-primary: #fabd2f !important;
          --color-accent-primary-hover: rgb(251, 211, 107) !important;
          --color-accent-primary-active: rgb(253, 222, 139) !important;
          background-color: #000000 !important;
          --in-content-page-background: #000000 !important;
        }
      }

      /* Firefox Homepage and New Tab Custom Styling */
      @-moz-document url("about:newtab"), url("about:home") {
        :root {
          --newtab-background-color: #000000 !important;
          --newtab-background-color-secondary: #1d2021 !important;
          --newtab-element-hover-color: #1d2021 !important;
          --newtab-text-primary-color: #fbf1c7 !important;
          --newtab-wordmark-color: #fbf1c7 !important;
          --newtab-primary-action-background: #fabd2f !important;
        }
        .icon { color: #fabd2f !important; }
        .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title { color: #fabd2f !important; }
        .top-site-outer .search-topsite { background-color: #83a598 !important; }
        .compact-cards .card-outer .card-context .card-context-icon.icon-download { fill: #b8bb26 !important; }
      }

      /* Native Preferences Panels Overrides */
      @-moz-document url-prefix("about:preferences") {
        :root {
          --in-content-text-color: #fbf1c7 !important;
          --link-color: #fabd2f !important;
          --link-color-hover: rgb(251, 211, 107) !important;
          --in-content-box-background: #1d2021 !important;
        }

        button, menulist {
          background: #1d2021 !important;
          color: #fbf1c7 !important;
        }
        .main-content { background-color: #000000 !important; }
      }

      /* Firefox Add-ons and Extension Manager Layout */
      @-moz-document url-prefix("about:addons") {
        :root {
          --background-color-box: #000000 !important;
        }
      }
    }
  '';
}