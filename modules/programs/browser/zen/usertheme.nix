{ config, ... }:
{
  userChrome = ''
    /* Zen Browser Stylix Integration Bridge Layout Rules */

    @media (prefers-color-scheme: dark) {
      :root {
        /* Base Background Mappings */
        --zen-colors-tertiary: #${config.lib.stylix.colors.base00} !important;        /* Pure Background Base */
        --zen-themed-toolbar-bg: #${config.lib.stylix.colors.base00} !important;
        --zen-main-browser-background: #${config.lib.stylix.colors.base00} !important;
        --toolbox-bgcolor-inactive: #${config.lib.stylix.colors.base00} !important;
        --arrowpanel-background: #${config.lib.stylix.colors.base00} !important;
        --lwt-sidebar-background-color: #${config.lib.stylix.colors.base00} !important;

        /* Container Surfaces and Panels */
        --zen-colors-primary: #${config.lib.stylix.colors.base01} !important;          /* Card / Sidebar Surfaces */
        --toolbar-bgcolor: #${config.lib.stylix.colors.base01} !important;
        --zen-colors-secondary: #${config.lib.stylix.colors.base02} !important;        /* Highlight / Secondary Layers */

        /* Accents and Branding Elements */
        --zen-primary-color: #${config.lib.stylix.colors.base0E} !important;          /* System Accent Primary */
        --zen-colors-border: #${config.lib.stylix.colors.base0E} !important;
        --toolbarbutton-icon-fill: #${config.lib.stylix.colors.base0E} !important;
        --tab-selected-textcolor: #${config.lib.stylix.colors.base0E} !important;

        /* Typography & High-Contrast Overlays */
        --lwt-text-color: #${config.lib.stylix.colors.base05} !important;             /* Standard Foreground Text */
        --toolbar-field-color: #${config.lib.stylix.colors.base05} !important;
        --toolbar-field-focus-color: #${config.lib.stylix.colors.base05} !important;
        --toolbar-color: #${config.lib.stylix.colors.base05} !important;
        --newtab-text-primary-color: #${config.lib.stylix.colors.base05} !important;
        --arrowpanel-color: #${config.lib.stylix.colors.base05} !important;
        --sidebar-text-color: #${config.lib.stylix.colors.base05} !important;
        --lwt-sidebar-text-color: #${config.lib.stylix.colors.base05} !important;
      }

      /* Native Elements & Specific Components Override */
      #permissions-granted-icon { color: #${config.lib.stylix.colors.base00} !important; }
      .sidebar-placesTree { background-color: #${config.lib.stylix.colors.base00} !important; }
      #zen-workspaces-button { background-color: #${config.lib.stylix.colors.base00} !important; }
      #TabsToolbar { background-color: #${config.lib.stylix.colors.base00} !important; }
      #urlbar-background { background-color: #${config.lib.stylix.colors.base00} !important; }
      hbox#titlebar { background-color: #${config.lib.stylix.colors.base00} !important; }
      #zen-appcontent-navbar-container { background-color: #${config.lib.stylix.colors.base00} !important; }
      #zenEditBookmarkPanelFaviconContainer { background: #${config.lib.stylix.colors.base00} !important; }

      .content-shortcuts {
        background-color: #${config.lib.stylix.colors.base00} !important;
        border-color: #${config.lib.stylix.colors.base0E} !important;
      }

      .urlbarView-url { color: #${config.lib.stylix.colors.base0E} !important; }

      #zen-media-controls-toolbar {
        & #zen-media-progress-bar {
          &::-moz-range-track {
            background: #${config.lib.stylix.colors.base01} !important;
          }
        }
      }

      toolbar .toolbarbutton-1 {
        &:not([disabled]) {
          &:is([open], [checked])
            > :is(.toolbarbutton-icon, .toolbarbutton-text, .toolbarbutton-badge-stack) {
            fill: #${config.lib.stylix.colors.base00};
          }
        }
      }

      /* Container / Multi-Account Identity Palette Mapping */
      .identity-color-blue {
        --identity-tab-color: #${config.lib.stylix.colors.base0D} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0D} !important;
      }
      .identity-color-turquoise {
        --identity-tab-color: #${config.lib.stylix.colors.base0C} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0C} !important;
      }
      .identity-color-green {
        --identity-tab-color: #${config.lib.stylix.colors.base0B} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0B} !important;
      }
      .identity-color-yellow {
        --identity-tab-color: #${config.lib.stylix.colors.base0A} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0A} !important;
      }
      .identity-color-orange {
        --identity-tab-color: #${config.lib.stylix.colors.base09} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base09} !important;
      }
      .identity-color-red {
        --identity-tab-color: #${config.lib.stylix.colors.base08} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base08} !important;
      }
      .identity-color-pink {
        --identity-tab-color: #${config.lib.stylix.colors.base0F} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0F} !important;
      }
      .identity-color-purple {
        --identity-tab-color: #${config.lib.stylix.colors.base0E} !important;
        --identity-icon-color: #${config.lib.stylix.colors.base0E} !important;
      }
    }
  '';

  userContent = ''
    /* Internal Engine & Configuration Pages Themes Overrides */

    @media (prefers-color-scheme: dark) {
      /* Base System Pages Prefix Setup */
      @-moz-document url-prefix("about:") {
        :root {
          --in-content-page-color: #${config.lib.stylix.colors.base05} !important;
          --color-accent-primary: #${config.lib.stylix.colors.base0E} !important;
          background-color: #${config.lib.stylix.colors.base00} !important;
          --in-content-page-background: #${config.lib.stylix.colors.base00} !important;
        }
      }

      /* New Tab Dashboard Variable Bindings */
      @-moz-document url("about:newtab"), url("about:home") {
        :root {
          --newtab-background-color: #${config.lib.stylix.colors.base00} !important;
          --newtab-background-color-secondary: #${config.lib.stylix.colors.base01} !important;
          --newtab-element-hover-color: #${config.lib.stylix.colors.base01} !important;
          --newtab-text-primary-color: #${config.lib.stylix.colors.base05} !important;
          --newtab-wordmark-color: #${config.lib.stylix.colors.base05} !important;
          --newtab-primary-action-background: #${config.lib.stylix.colors.base0E} !important;
        }
        .icon { color: #${config.lib.stylix.colors.base0E} !important; }
        .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title { color: #${config.lib.stylix.colors.base0E} !important; }
        .top-site-outer .search-topsite { background-color: #${config.lib.stylix.colors.base0D} !important; }
        .compact-cards .card-outer .card-context .card-context-icon.icon-download { fill: #${config.lib.stylix.colors.base0B} !important; }
      }

      /* Global System Application Preferences Framework */
      @-moz-document url-prefix("about:preferences") {
        :root {
          --zen-colors-tertiary: #${config.lib.stylix.colors.base00} !important;
          --in-content-text-color: #${config.lib.stylix.colors.base05} !important;
          --link-color: #${config.lib.stylix.colors.base0E} !important;
          --zen-colors-primary: #${config.lib.stylix.colors.base01} !important;
          --in-content-box-background: #${config.lib.stylix.colors.base01} !important;
          --zen-primary-color: #${config.lib.stylix.colors.base0E} !important;
        }
        groupbox, moz-card { background: #${config.lib.stylix.colors.base00} !important; }
        button, groupbox menulist {
          background: #${config.lib.stylix.colors.base01} !important;
          color: #${config.lib.stylix.colors.base05} !important;
        }
        .main-content { background-color: #${config.lib.stylix.colors.base00} !important; }
      }

      /* Add-ons Architecture Setup */
      @-moz-document url-prefix("about:addons") {
        :root {
          --zen-dark-color-mix-base: #${config.lib.stylix.colors.base00} !important;
          --background-color-box: #${config.lib.stylix.colors.base00} !important;
        }
      }

      /* Trackers Dashboard Custom Components Mapping */
      @-moz-document url-prefix("about:protections") {
        :root {
          --zen-primary-color: #${config.lib.stylix.colors.base00} !important;
          --social-color: #${config.lib.stylix.colors.base0E} !important;
          --cookie-color: #${config.lib.stylix.colors.base0C} !important;
          --fingerprinter-color: #${config.lib.stylix.colors.base09} !important;
          --cryptominer-color: #${config.lib.stylix.colors.base0D} !important;
          --tracker-color: #${config.lib.stylix.colors.base0B} !important;
        }
        .card { background-color: #${config.lib.stylix.colors.base01} !important; }
      }
    }
  '';
}
