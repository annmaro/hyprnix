{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  # 1. Reference your rocky beach wallpaper path.
  # If it is placed inside your local configuration source directory:
  wallpaperImg = "${self}/modules/wallpapers/rocky_beach.jpg";

  # 2. Re-engineered style-2.rasi with Gruvbox Light elements
  powermenuTheme = pkgs.writeText "style-2.rasi" ''
    configuration {
        show-icons:                 false;
    }

    /*****----- Global Properties -----*****/
    * {
        font:                        "JetBrains Mono Nerd Font 10";
        background:                  #1d2021; /* Gruvbox Dark background */
        background-alt:              #282828; /* Gruvbox Dark Gray */
        foreground:                  #fbf1c7; /* Gruvbox Cream Foreground */
        selected:                    #fabd2f; /* Gruvbox Light Yellow Focus */
        active:                      #b8bb26; /* Gruvbox Light Green */
        urgent:                      #fb4934; /* Gruvbox Red */
    }

    /*****----- Main Window -----*****/
    window {
        transparency:                "real";
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       1000px;
        x-offset:                    0px;
        y-offset:                    0px;

        padding:                     0px;
        border:                      2px solid;
        border-radius:               24px;
        border-color:                @selected;
        cursor:                      "default";
        background-color:            @background;
    }

    /*****----- Main Box -----*****/
    mainbox {
        background-color:            transparent;
        orientation:                 horizontal;
        children:                    [ "imagebox", "listview" ];
    }

    /*****----- Imagebox (Wallpaper Injection) -----*****/
    imagebox {
        spacing:                     20px;
        padding:                     20px;
        background-color:            transparent;
        background-image:            url("${wallpaperImg}", height);
        children:                    [ "inputbar", "dummy", "message" ];
    }

    /*****----- User -----*****/
    userimage {
        margin:                      0px 0px;
        border:                      10px;
        border-radius:               10px;
        border-color:                @background-alt;
        background-color:            transparent;
    }

    /*****----- Inputbar -----*****/
    inputbar {
        padding:                     15px;
        border-radius:               100%;
        background-color:            @background-alt;
        text-color:                  @selected; /* Highlight user box with Gruvbox Light Yellow */
        border:                      1px solid;
        border-color:                @selected;
        children:                    [ "dummy", "prompt", "dummy"];
    }

    dummy {
        background-color:            transparent;
    }

    prompt {
        background-color:            inherit;
        text-color:                  inherit;
    }

    /*****----- Message -----*****/
    message {
        enabled:                     true;
        margin:                      0px;
        padding:                     15px;
        border-radius:               100%;
        background-color:            @background-alt;
        text-color:                  @foreground;
        border:                      1px solid;
        border-color:                @active;
    }
    textbox {
        background-color:            inherit;
        text-color:                  inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     3;
        lines:                       2;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;
        
        spacing:                     20px;
        margin:                      20px;
        background-color:            transparent;
        cursor:                      "default";
    }

    /*****----- Elements -----*****/
    element {
        enabled:                     true;
        padding:                     40px 10px;
        border-radius:               100%;
        background-color:            @background-alt;
        text-color:                  @foreground;
        cursor:                      pointer;
    }
    element-text {
        font:                        "JetBrains Mono Nerd Font Bold 32";
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }
    element selected.normal {
        background-color:            var(selected);
        text-color:                  var(background);
    }
  '';

  # 3. Re-engineered powermenu.sh
  powermenuScript = pkgs.writeShellScriptBin "rofi-powermenu" ''
    # Options using standard Nerd Font Glyphs
    lock='󰌾'
    suspend='󰤄'
    logout='󰍃'
    hibernate='󰗽'
    reboot='󰜉'
    shutdown='󰐥'
    yes='󰄬'
    no='󰅖'

    # Rofi CMD
    rofi_cmd() {
    	${pkgs.rofi}/bin/rofi -dmenu \
    		-p "󰀉 $USER@$(hostname)" \
    		-mesg "󱎫 Uptime: $(uptime -p | sed -e 's/up //g')" \
    		-theme ${powermenuTheme}
    }

    # Confirmation CMD
    confirm_cmd() {
    	${pkgs.rofi}/bin/rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
    		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
    		-theme-str 'listview {columns: 2; lines: 1;}' \
    		-theme-str 'element-text {horizontal-align: 0.5;}' \
    		-theme-str 'textbox {horizontal-align: 0.5;}' \
    		-dmenu \
    		-p 'Confirmation' \
    		-mesg 'Are you Sure?' \
    		-theme ${powermenuTheme}
    }

    # Ask for confirmation
    confirm_exit() {
    	echo -e "$yes\n$no" | confirm_cmd
    }

    # Pass variables to rofi dmenu (matches the 6-icon layout grid)
    run_rofi() {
    	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
    }

    # Execute Command
    run_cmd() {
    	# Trim whitespace using xargs to protect matching
    	selected="''$(confirm_exit | ${pkgs.findutils}/bin/xargs)"
    	if [[ "$selected" == "$yes" ]]; then
    		if [[ $1 == '--shutdown' ]]; then
    			systemctl poweroff
    		elif [[ $1 == '--reboot' ]]; then
    			systemctl reboot
    		elif [[ $1 == '--hibernate' ]]; then
    			systemctl hibernate
    		elif [[ $1 == '--suspend' ]]; then
    			systemctl suspend
    		elif [[ $1 == '--logout' ]]; then
    			${pkgs.niri}/bin/niri msg action quit --skip-confirmation
    		fi
    	else
    		exit 0
    	fi
    }

    # Actions - Clean whitespace output with xargs
    chosen="''$(run_rofi | ${pkgs.findutils}/bin/xargs)"
    case ''${chosen} in
        $shutdown)
    		run_cmd --shutdown
            ;;
        $reboot)
    		run_cmd --reboot
            ;;
        $hibernate)
    		run_cmd --hibernate
            ;;
        $lock)
    		if command -v hyprlock &> /dev/null; then
    			hyprlock
    		elif command -v swaylock &> /dev/null; then
    			swaylock
    		fi
            ;;
        $suspend)
    		run_cmd --suspend
            ;;
        $logout)
    		run_cmd --logout
            ;;
    esac
  '';
in
{
  # Expose package to the user profile safely
  home.packages = [ powermenuScript ];
}
