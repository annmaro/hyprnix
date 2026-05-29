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
              (label :text "uptime: '''${uptime}" :class "profile-uptime" :halign "start"))))

        ;; Quick Settings Widget
        (defwidget quick-settings []
          (box :class "card quick-settings-card" :orientation "vertical" :space-evenly false :spacing 12
            (box :orientation "horizontal" :space-evenly true :spacing 12
              ;; WiFi Toggle
              (button :class "qs-button '''${wifi_status == \"enabled\" ? \"active\" : \"\"}" 
                      :onclick "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "'''${wifi_status == \"enabled\" ? \"󰤨\" : \"󰤭\"}" :class "qs-icon")
                  (label :text "Wi-Fi" :class "qs-label")))
              
              ;; Bluetooth Toggle
              (button :class "qs-button '''${bluetooth_status == \"on\" ? \"active\" : \"\"}"
                      :onclick "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "'''${bluetooth_status == \"on\" ? \"󰂯\" : \"󰂲\"}" :class "qs-icon")
                  (label :text "Bluetooth" :class "qs-label"))))
                  
            (box :orientation "horizontal" :space-evenly true :spacing 12
              ;; Do Not Disturb
              (button :class "qs-button '''${dnd_status == \"true\" ? \"active\" : \"\"}"
                      :onclick "dms ipc call notifications toggle"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "'''${dnd_status == \"true\" ? \"󰂛\" : \"󰂚\"}" :class "qs-icon")
                  (label :text "DND" :class "qs-label")))
                  
              ;; Night Light
              (button :class "qs-button '''${nightlight_status == \"on\" ? \"active\" : \"\"}"
                      :onclick "pkill -f wlsunset && echo 'off' || (wlsunset -T 3800 -t 3799 & echo 'on')"
                (box :orientation "vertical" :space-evenly false :spacing 4
                  (label :text "'''${nightlight_status == \"on\" ? \"󰖔\" : \"󰖙\"}" :class "qs-icon")
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
              (label :text "'''${volume}%" :class "slider-value"))
              
            ;; Brightness Slider
            (box :orientation "horizontal" :space-evenly false :spacing 12
              (label :text "󰖨" :class "slider-icon")
              (scale :class "brightness-scale"
                     :min 1
                     :max 101
                     :value brightness
                     :active true
                     :onchange "brightnessctl set {}%")
              (label :text "'''${brightness}%" :class "slider-value"))))

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
              (label :text "'''${round(EWW_CPU.avg, 0)}%" :class "stat-value-percent"))
              
            ;; RAM
            (box :orientation "vertical" :space-evenly false :spacing 8 :halign "center"
              (circular-progress :value {EWW_RAM.use_mem_perc}
                                 :thickness 8
                                 :start-angle 0
                                 :class "stat-circle ram-circle"
                (label :text "󰘚" :class "stat-icon"))
              (label :text "RAM" :class "stat-label")
              (label :text "'''${round(EWW_RAM.use_mem_perc, 0)}%" :class "stat-value-percent"))
              
            ;; Disk
            (box :orientation "vertical" :space-evenly false :spacing 8 :halign "center"
              (circular-progress :value {round(EWW_DISK["/"].used / EWW_DISK["/"].total * 100, 0)}
                                 :thickness 8
                                 :start-angle 0
                                 :class "stat-circle disk-circle"
                (label :text "󰋊" :class "stat-icon"))
              (label :text "Disk" :class "stat-label")
              (label :text "'''${round(EWW_DISK["/"].used / EWW_DISK["/"].total * 100, 0)}%" :class "stat-value-percent"))))

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
                "'''${song_status == \"Playing\" ? \"󰏤\" : \"󰐊\"}")
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
        // Your SCSS looks pristine! No changes needed here since CSS variables don't conflict with Nix strings.
        ${builtins.readFile ./your-current-scss-path-if-separated} 
        // (Or keep your exact scss code pasted here as you had it)
      '';
    })
  ];
}