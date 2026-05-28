{ ... }:
{
  userChrome = ''
    /* Gruvbox Dark AMOLED userChrome.css */

    @media (prefers-color-scheme: dark) {
      :root {
        --zen-colors-primary: #1d2021 !important;
        --zen-primary-color: #fabd2f !important;
        --zen-colors-secondary: #282828 !important;
        --zen-colors-tertiary: #000000 !important;
        --zen-colors-border: #fabd2f !important;
        --toolbarbutton-icon-fill: #fabd2f !important;
        --lwt-text-color: #fbf1c7 !important;
        --toolbar-field-color: #fbf1c7 !important;
        --tab-selected-textcolor: rgb(250, 189, 47) !important;
        --toolbar-field-focus-color: #fbf1c7 !important;
        --toolbar-color: #fbf1c7 !important;
        --newtab-text-primary-color: #fbf1c7 !important;
        --arrowpanel-color: #fbf1c7 !important;
        --arrowpanel-background: #000000 !important;
        --sidebar-text-color: #fbf1c7 !important;
        --lwt-sidebar-text-color: #fbf1c7 !important;
        --lwt-sidebar-background-color: #000000 !important;
        --toolbar-bgcolor: #1d2021 !important;
        --newtab-background-color: #000000 !important;
        --zen-themed-toolbar-bg: #000000 !important;
        --zen-main-browser-background: #000000 !important;
        --toolbox-bgcolor-inactive: #000000 !important;
      }

      #permissions-granted-icon {
        color: #000000 !important;
      }

      .sidebar-placesTree {
        background-color: #000000 !important;
      }

      #zen-workspaces-button {
        background-color: #000000 !important;
      }

      #TabsToolbar {
        background-color: #000000 !important;
      }

      #urlbar-background {
        background-color: #000000 !important;
      }

      .content-shortcuts {
        background-color: #000000 !important;
        border-color: #fabd2f !important;
      }

      .urlbarView-url {
        color: #fabd2f !important;
      }

      #zenEditBookmarkPanelFaviconContainer {
        background: #000000 !important;
      }

      #zen-media-controls-toolbar {
        & #zen-media-progress-bar {
          &::-moz-range-track {
            background: #1d2021 !important;
          }
        }
      }

      toolbar .toolbarbutton-1 {
        &:not([disabled]) {
          &:is([open], [checked])
            > :is(
              .toolbarbutton-icon,
              .toolbarbutton-text,
              .toolbarbutton-badge-stack
            ) {
            fill: #000000;
          }
        }
      }

      /* Gruvbox Container/Identity Colors */
      .identity-color-blue {
        --identity-tab-color: #83a598 !important;
        --identity-icon-color: #83a598 !important;
      }

      .identity-color-turquoise {
        --identity-tab-color: #8ec07c !important;
        --identity-icon-color: #8ec07c !important;
      }

      .identity-color-green {
        --identity-tab-color: #b8bb26 !important;
        --identity-icon-color: #b8bb26 !important;
      }

      .identity-color-yellow {
        --identity-tab-color: #fabd2f !important;
        --identity-icon-color: #fabd2f !important;
      }

      .identity-color-orange {
        --identity-tab-color: #fe8019 !important;
        --identity-icon-color: #fe8019 !important;
      }

      .identity-color-red {
        --identity-tab-color: #fb4934 !important;
        --identity-icon-color: #fb4934 !important;
      }

      .identity-color-pink {
        --identity-tab-color: #d3869b !important;
        --identity-icon-color: #d3869b !important;
      }

      .identity-color-purple {
        --identity-tab-color: #d3869b !important;
        --identity-icon-color: #d3869b !important;
      }

      hbox#titlebar {
        background-color: #000000 !important;
      }

      #zen-appcontent-navbar-container {
        background-color: #000000 !important;
      }
    }
  '';

  userContent = ''
    /* Gruvbox Dark AMOLED userContent.css */

    @media (prefers-color-scheme: dark) {

      /* Common variables affecting all pages */
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

      /* Variables and styles specific to about:newtab and about:home */
      @-moz-document url("about:newtab"), url("about:home") {

        :root {
          --newtab-background-color: #000000 !important;
          --newtab-background-color-secondary: #1d2021 !important;
          --newtab-element-hover-color: #1d2021 !important;
          --newtab-text-primary-color: #fbf1c7 !important;
          --newtab-wordmark-color: #fbf1c7 !important;
          --newtab-primary-action-background: #fabd2f !important;
        }

        .icon {
          color: #fabd2f !important;
        }

        .search-wrapper .logo-and-wordmark .logo {
          /* Swapped back to default asset parameters or your custom gruvbox asset override */
          display: inline-block !important;
          height: 82px !important;
          width: 82px !important;
          background-size: 82px !important;
        }

        @media (max-width: 609px) {
          .search-wrapper .logo-and-wordmark .logo {
            background-size: 64px !important;
            height: 64px !important;
            width: 64px !important;
          }
        }

        .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
          color: #fabd2f !important;
        }

        .top-site-outer .search-topsite {
          background-color: #83a598 !important;
        }

        .compact-cards .card-outer .card-context .card-context-icon.icon-download {
          fill: #b8bb26 !important;
        }
      }

      /* Variables and styles specific to about:preferences */
      @-moz-document url-prefix("about:preferences") {
        :root {
          --zen-colors-tertiary: #000000 !important;
          --in-content-text-color: #fbf1c7 !important;
          --link-color: #fabd2f !important;
          --link-color-hover: rgb(251, 211, 107) !important;
          --zen-colors-primary: #1d2021 !important;
          --in-content-box-background: #1d2021 !important;
          --zen-primary-color: #fabd2f !important;
        }

        groupbox, moz-card {
          background: #000000 !important;
        }

        button,
        groupbox menulist {
          background: #1d2021 !important;
          color: #fbf1c7 !important;
        }

        .main-content {
          background-color: #000000 !important;
        }

        .identity-color-blue {
          --identity-tab-color: #83a598 !important;
          --identity-icon-color: #83a598 !important;
        }

        .identity-color-turquoise {
          --identity-tab-color: #8ec07c !important;
          --identity-icon-color: #8ec07c !important;
        }

        .identity-color-green {
          --identity-tab-color: #b8bb26 !important;
          --identity-icon-color: #b8bb26 !important;
        }

        .identity-color-yellow {
          --identity-tab-color: #fabd2f !important;
          --identity-icon-color: #fabd2f !important;
        }

        .identity-color-orange {
          --identity-tab-color: #fe8019 !important;
          --identity-icon-color: #fe8019 !important;
        }

        .identity-color-red {
          --identity-tab-color: #fb4934 !important;
          --identity-icon-color: #fb4934 !important;
        }

        .identity-color-pink {
          --identity-tab-color: #d3869b !important;
          --identity-icon-color: #d3869b !important;
        }

        .identity-color-purple {
          --identity-tab-color: #d3869b !important;
          --identity-icon-color: #d3869b !important;
        }
      }

      /* Variables and styles specific to about:addons */
      @-moz-document url-prefix("about:addons") {
        :root {
          --zen-dark-color-mix-base: #000000 !important;
          --background-color-box: #000000 !important;
        }
      }

      /* Variables and styles specific to about:protections */
      @-moz-document url-prefix("about:protections") {
        :root {
          --zen-primary-color: #000000 !important;
          --social-color: #fabd2f !important;
          --cookie-color: #8ec07c !important;
          --fingerprinter-color: #fe8019 !important;
          --cryptominer-color: #83a598 !important;
          --tracker-color: #b8bb26 !important;
          --in-content-primary-button-background-hover: rgb(60, 56, 54) !important;
          --in-content-primary-button-text-color-hover: #fbf1c7 !important;
          --in-content-primary-button-background: #504945 !important;
          --in-content-primary-button-text-color: #fbf1c7 !important;
        }

        .card {
          background-color: #1d2021 !important;
        }
      }
    }
  '';
}