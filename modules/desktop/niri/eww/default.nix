{ pkgs, ... }:

{
  home-manager.sharedModules = [
    ({ ... }: {
      programs.eww = {
        enable = true;
        package = pkgs.eww;
      };

      # Inline eww.yuck configuration
      xdg.configFile."eww/eww.yuck".text = ''
        ;; =====================================================================
        ;; 🎛️ EWW WIDGETS CONFIGURATION (YUCK)
        ;; =====================================================================

        (defwindow dashboard
          :monitor 0
          :geometry (geometry :x "16px"
                              :y "16px"
                              :anchor "top right"
                              :width "380px"
                              :height "950px")
          :stacking "fg"
          :focusable "false"
          :namespace "eww-dashboard"
          (dashboard-layout))

        ;; Main Layout
        (defwidget dashboard-layout []
          (box :class "dashboard-container" :orientation "vertical" :space-evenly false :spacing 16
            (profile-widget)
            (quick-settings)
            (sliders-widget)
            (system-stats)
            (media-widget)))

        ;; Profile Widget
        (defwidget profile-widget []
          (box :class "card profile-card" :orientation "horizontal" :space-evenly false :spacing 16
            (box :class "profile-avatar" :valign "center" :halign "center"
              (label :text "" :class "avatar-icon"))
            (box :class "profile-info" :orientation "vertical" :valign "center" :space-evenly false :spacing 4
              (label :text "annmaro" :class "profile-name" :halign "start")
              (label :text "@nixri-desktop" :class "profile-host" :halign "start")
              (label :text "uptime: ''${uptime}" :class "profile-uptime" :halign "start"))))

        ;; Quick Settings Widget
        (defwidget quick-settings []
          (box :class "card quick-settings-card" :orientation "vertical" :space-evenly false :spacing 12
            (box :orientation "horizontal" :space-evenly true :spacing 12
              ;; WiFi Toggle
              (button :class "qs-button ''${wifi_status == \"enabled\" ? \"active\" : \"\"}" 
                      :onclick "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "''${wifi_status == \"enabled\" ? \"󰤨\" : \"󰤭\"}" :class "qs-icon")
                  (label :text "Wi-Fi" :class "qs-label")))
              
              ;; Bluetooth Toggle
              (button :class "qs-button ''${bluetooth_status == \"on\" ? \"active\" : \"\"}"
                      :onclick "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "''${bluetooth_status == \"on\" ? \"󰂯\" : \"󰂲\"}" :class "qs-icon")
                  (label :text "Bluetooth" :class "qs-label"))))
                  
            (box :orientation "horizontal" :space-evenly true :spacing 12
              ;; Do Not Disturb
              (button :class "qs-button ''${dnd_status == \"true\" ? \"active\" : \"\"}"
                      :onclick "dms ipc call notifications toggle"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "''${dnd_status == \"true\" ? \"󰂛\" : \"󰂚\"}" :class "qs-icon")
                  (label :text "DND" :class "qs-label")))
                  
              ;; Night Light
              (button :class "qs-button ''${nightlight_status == \"on\" ? \"active\" : \"\"}"
                      :onclick "pkill -f wlsunset && echo 'off' || (wlsunset -T 3800 -t 3799 & echo 'on')"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "''${nightlight_status == \"on\" ? \"󰖔\" : \"󰖙\"}" :class "qs-icon")
                  (label :text "Night Light" :class "qs-label"))))))

        ;; Sliders Widget
        (defwidget sliders-widget []
          (box :class "card sliders-card" :orientation "vertical" :space-evenly false :spacing 16
            ;; Volume Slider
            (box :orientation "horizontal" :space-evenly false :spacing 12
              (label :text "󰕾" :class "slider-icon")
              (scale :class "volume-scale"
                     :min 0
                     :max 101
                     :value volume
                     :active true
                     :onchange "pamixer --set-volume {}")
              (label :text "''${volume}%" :class "slider-value"))
              
            ;; Brightness Slider
            (box :orientation "horizontal" :space-evenly false :spacing 12
              (label :text "󰖨" :class "slider-icon")
              (scale :class "brightness-scale"
                     :min 1
                     :max 101
                     :value brightness
                     :active true
                     :onchange "brightnessctl set {}%")
              (label :text "''${brightness}%" :class "slider-value"))))

        ;; System Stats Widget
        (defwidget system-stats []
          (box :class "card system-stats-card" :orientation "horizontal" :space-evenly true :spacing 8
            ;; CPU
            (box :orientation "vertical" :space-evenly false :spacing 8 :halign "center"
              (circular-progress :value {EWW_CPU.avg}
                                 :thickness 8
                                 :start-angle 0
                                 :class "stat-circle cpu-circle"
                (label :text "󰍛" :class "stat-icon"))
              (label :text "CPU" :class "stat-label")
              (label :text "''${round(EWW_CPU.avg, 0)}%" :class "stat-value-percent"))
              
            ;; RAM
            (box :orientation "vertical" :space-evenly false :spacing 8 :halign "center"
              (circular-progress :value {EWW_RAM.use_mem_perc}
                                 :thickness 8
                                 :start-angle 0
                                 :class "stat-circle ram-circle"
                (label :text "󰘚" :class "stat-icon"))
              (label :text "RAM" :class "stat-label")
              (label :text "''${round(EWW_RAM.use_mem_perc, 0)}%" :class "stat-value-percent"))
              
            ;; Disk
            (box :orientation "vertical" :space-evenly false :spacing 8 :halign "center"
              (circular-progress :value {round(EWW_DISK["/"].used / EWW_DISK["/"].total * 100, 0)}
                                 :thickness 8
                                 :start-angle 0
                                 :class "stat-circle disk-circle"
                (label :text "󰋊" :class "stat-icon"))
              (label :text "Disk" :class "stat-label")
              (label :text "''${round(EWW_DISK["/"].used / EWW_DISK["/"].total * 100, 0)}%" :class "stat-value-percent"))))

        ;; Media Player Widget
        (defwidget media-widget []
          (box :class "card media-card" :orientation "vertical" :space-evenly false :spacing 12
            (box :orientation "horizontal" :space-evenly false :spacing 16
              (box :class "media-art" :valign "center" :halign "center"
                (label :text "󰝚" :class "media-art-icon"))
              (box :class "media-info" :orientation "vertical" :valign "center" :space-evenly false :spacing 4 :hexpand true
                (label :text song_title :class "media-title" :halign "start" :limit-width 24)
                (label :text song_artist :class "media-artist" :halign "start" :limit-width 24)))
            
            (box :class "media-controls" :orientation "horizontal" :space-evenly true
              (button :class "media-btn" :onclick "playerctl previous" "󰒮")
              (button :class "media-btn play-pause" :onclick "playerctl play-pause" 
                "''${song_status == \"Playing\" ? \"󰏤\" : \"󰐊\"}")
              (button :class "media-btn" :onclick "playerctl next" "󰒭"))))

        ;; =====================================================================
        ;; 📊 DYNAMIC VARIABLES (POLLS)
        ;; =====================================================================

        (defpoll uptime :interval "1m" "uptime -p | sed -e 's/up //g'")

        (defpoll wifi_status :interval "3s" "nmcli radio wifi")

        (defpoll bluetooth_status :interval "3s"
          "bluetoothctl show | grep -q 'Powered: yes' && echo 'on' || echo 'off'")

        (defpoll dnd_status :interval "2s"
          "dms ipc call notifications get-dnd || echo 'false'")

        (defpoll nightlight_status :interval "2s"
          "pgrep -f wlsunset > /dev/null && echo 'on' || echo 'off'")

        (defpoll volume :interval "1s" "pamixer --get-volume || echo '0'")

        (defpoll brightness :interval "1s"
          "brightnessctl -m | cut -d, -f4 | tr -d % || echo '0'")

        (defpoll song_title :interval "2s" "playerctl metadata title || echo 'No Media'")

        (defpoll song_artist :interval "2s" "playerctl metadata artist || echo 'Unknown Artist'")

        (defpoll song_status :interval "1s" "playerctl status || echo 'Stopped'")
      '';

      # Inline eww.scss configuration
      xdg.configFile."eww/eww.scss".text = ''
        // =====================================================================
        // 🎨 EWW SCSS STYLING CONFIGURATION (AMOLED BLACK & DMS ALIGNED)
        // =====================================================================

        // Color Palettes (Aligned with amoledBlack-black & DMS)
        $background-dark: rgba(0, 0, 0, 0.15); // Frosted transparent black for Niri blur
        $card-bg: rgba(12, 12, 12, 0.65);      // Deep OLED card background
        $active-bg: linear-gradient(135deg, #f35c25, #ff7b00); // DMS Vibrant Orange Accent
        $active-text: #000000;
        $border-color: rgba(88, 149, 220, 0.35); // Sky Blue border matching DMS overlays (#5895dc)
        $border-muted: rgba(255, 255, 255, 0.1);
        $fg-primary: #ffffff;
        $fg-secondary: #999999;
        $fg-tertiary: #666666;

        // Resources Circular Progress Colors
        $cpu-color: #f35c25;
        $ram-color: #03fc7b;
        $disk-color: #03fcc6;

        // Typography & Globals
        * {
          all: unset;
          font-family: "JetBrains Mono", "JetBrains Mono Nerd Font", monospace;
          font-weight: 500;
          transition: all 250ms cubic-bezier(0.4, 0, 0.2, 1);
        }

        .dashboard-container {
          background-color: $background-dark;
          border: 1px solid $border-color;
          border-radius: 16px;
          padding: 20px;
          color: $fg-primary;
        }

        // Base Card Design
        .card {
          background-color: $card-bg;
          border: 1px solid $border-muted;
          border-radius: 16px;
          padding: 16px;
        }

        // 1. Profile Widget
        .profile-card {
          padding: 20px;
          background: linear-gradient(135deg, rgba(20, 20, 20, 0.8), rgba(5, 5, 5, 0.9));
        }

        .profile-avatar {
          background-color: rgba(255, 255, 255, 0.08);
          border: 1px solid rgba(255, 255, 255, 0.15);
          border-radius: 50%;
          width: 54px;
          height: 54px;
          min-width: 54px;
          min-height: 54px;
        }

        .avatar-icon {
          font-size: 24px;
          color: $fg-primary;
          margin-top: 10px;
          margin-left: 17px;
        }

        .profile-name {
          font-size: 18px;
          font-weight: 700;
          color: $fg-primary;
        }

        .profile-host {
          font-size: 13px;
          color: $border-color; // Sky Blue host highlight
          font-weight: 600;
        }

        .profile-uptime {
          font-size: 11px;
          color: $fg-secondary;
        }

        // 2. Quick Settings Widget
        .quick-settings-card {
          padding: 16px;
        }

        .qs-button {
          background-color: rgba(255, 255, 255, 0.05);
          border: 1px solid $border-muted;
          border-radius: 12px;
          padding: 14px 8px;
          cursor: pointer;
          
          &:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
          }
          
          &.active {
            background: $active-bg;
            border-color: transparent;
            color: $active-text;
            box-shadow: 0 4px 15px rgba(243, 92, 37, 0.3);
            
            .qs-icon, .qs-label {
              color: $active-text;
            }
          }
        }

        .qs-icon {
          font-size: 22px;
          color: $fg-primary;
          text-align: center;
        }

        .qs-label {
          font-size: 11px;
          font-weight: 600;
          color: $fg-secondary;
          text-align: center;
        }

        // 3. Sliders Widget
        .sliders-card {
          padding: 18px;
        }

        .slider-icon {
          font-size: 18px;
          color: $fg-secondary;
          min-width: 24px;
        }

        .slider-value {
          font-size: 12px;
          color: $fg-secondary;
          min-width: 32px;
          text-align: right;
          font-weight: 600;
        }

        scale {
          trough {
            background-color: rgba(255, 255, 255, 0.08);
            border-radius: 100px;
            min-height: 8px;
            
            highlight {
              background: $active-bg;
              border-radius: 100px;
            }
          }
          
          // Custom styling for specific scales
          &.volume-scale trough highlight {
            background: linear-gradient(to right, #5895dc, #03fcc6);
          }
          
          &.brightness-scale trough highlight {
            background: linear-gradient(to right, #fcfc03, #f35c25);
          }
        }

        // 4. System Stats (Circular Progress)
        .system-stats-card {
          padding: 16px;
        }

        .stat-circle {
          min-width: 70px;
          min-height: 70px;
          background-color: rgba(255, 255, 255, 0.03);
          border-radius: 50%;
          
          // Eww circular progress requires native styling of progress track
          color: rgba(255, 255, 255, 0.08); // Background circle
          
          &.cpu-circle {
            background-color: transparent;
            highlight {
              background: $cpu-color;
            }
          }
          
          &.ram-circle {
            background-color: transparent;
            highlight {
              background: $ram-color;
            }
          }
          
          &.disk-circle {
            background-color: transparent;
            highlight {
              background: $disk-color;
            }
          }
        }

        .stat-icon {
          font-size: 18px;
          color: $fg-primary;
          margin-top: 25px;
          margin-left: 25px;
        }

        .stat-label {
          font-size: 12px;
          color: $fg-secondary;
          font-weight: 600;
          text-align: center;
        }

        .stat-value-percent {
          font-size: 11px;
          color: $fg-tertiary;
          text-align: center;
          font-weight: 700;
        }

        // 5. Media Player Widget
        .media-card {
          padding: 16px;
          background: linear-gradient(135deg, rgba(15, 15, 15, 0.7), rgba(0, 0, 0, 0.95));
        }

        .media-art {
          background-color: rgba(255, 255, 255, 0.05);
          border: 1px dashed rgba(255, 255, 255, 0.15);
          border-radius: 12px;
          width: 52px;
          height: 52px;
          min-width: 52px;
          min-height: 52px;
        }

        .media-art-icon {
          font-size: 20px;
          color: $fg-secondary;
          margin-top: 15px;
          margin-left: 17px;
        }

        .media-title {
          font-size: 14px;
          font-weight: 700;
          color: $fg-primary;
        }

        .media-artist {
          font-size: 12px;
          color: $fg-secondary;
        }

        .media-controls {
          padding-top: 4px;
        }

        .media-btn {
          font-size: 20px;
          color: $fg-primary;
          padding: 8px 16px;
          border-radius: 50%;
          cursor: pointer;
          
          &:hover {
            background-color: rgba(255, 255, 255, 0.08);
            color: #f35c25;
          }
          
          &.play-pause {
            background-color: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 22px;
            padding: 10px 18px;
            
            &:hover {
              background: $active-bg;
              color: $active-text;
              border-color: transparent;
            }
          }
        }
      '';
    })
  ];
}
