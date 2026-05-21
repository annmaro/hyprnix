{ pkgs, ... }:
pkgs.writeShellScriptBin "gpuinfo" ''
  gpuinfo_file="/tmp/$UID-gpuinfo"

  AQ_DRM_DEVICES="''${AQ_DRM_DEVICES:-WLR_DRM_DEVICES}"

  tired=false
  if [[ " $* " =~ " --tired " ]]; then
    if ! ${pkgs.gnugrep}/bin/grep -q "tired" "''${gpuinfo_file}"; then
      echo "tired=true" >>"''${gpuinfo_file}"
      echo "set tired flag"
    else
      echo "already set tired flag"
    fi
    echo "Nvidia GPU will not be queried if it is in suspend mode"
    echo "run --reset to reset the flag"
    exit 0
  fi

  if [[ " $* " =~ " --emoji " ]]; then
    if ! ${pkgs.gnugrep}/bin/grep -q "GPUINFO_EMOJI" "''${gpuinfo_file}"; then
      echo "export GPUINFO_EMOJI=1" >>"''${gpuinfo_file}"
      echo "set emoji flag"
    else
      echo "already set emoji flag"
    fi
    echo "run --reset to reset the flag"
    exit 0
  fi

  if [[ ! " $* " =~ " --startup " ]]; then
    gpuinfo_file="''${gpuinfo_file}$2"
  fi

  detect() {
    card=$(echo "''${AQ_DRM_DEVICES}" | ${pkgs.coreutils}/bin/cut -d':' -f1 | ${pkgs.coreutils}/bin/cut -d'/' -f4)
    slot_number=$(${pkgs.coreutils}/bin/ls -l /dev/dri/by-path/ | ${pkgs.gnugrep}/bin/grep "''${card}" | ${pkgs.gawk}/bin/awk -F'pci-0000:|-card' '{print $2}')
    vendor_id=$(${pkgs.pciutils}/bin/lspci -nn -s "''${slot_number}")
    declare -A vendors=(["10de"]="nvidia" ["8086"]="intel" ["1002"]="amd")
    
    # --- SYNTAX ERROR FIXED HERE ---
    # Escaped the array expander using dual escape wrappers to stop Nix parsing it as an attribute
    for vendor in "''${!vendors[@]}"; do
      if [[ ''${vendor_id} == *"''${vendor}"* ]]; then
        initGPU="''${vendors[''${vendor}]}"
        break
      fi
    done
    if [[ -n ''${initGPU} ]]; then
      $0 --use "''${initGPU}" --startup
    fi
  }

  query() {
    GPUINFO_NVIDIA_ENABLE=0 GPUINFO_AMD_ENABLE=0 GPUINFO_INTEL_ENABLE=0
    touch "''${gpuinfo_file}"

    if ${pkgs.kmod}/bin/lsmod | ${pkgs.gnugrep}/bin/grep -q 'nouveau'; then
      echo "GPUINFO_NVIDIA_GPU=\"Linux\"" >>"''${gpuinfo_file}"
      echo "GPUINFO_NVIDIA_ENABLE=1 # Using nouveau an open-source nvidia driver" >>"''${gpuinfo_file}"
    elif command -v nvidia-smi &>/dev/null; then
      GPUINFO_NVIDIA_GPU=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | ${pkgs.coreutils}/bin/head -n 1)
      if [[ -n "''${GPUINFO_NVIDIA_GPU}" ]]; then
        if [[ "''${GPUINFO_NVIDIA_GPU}" == *"NVIDIA-SMI has failed"* ]]; then
          echo "GPUINFO_NVIDIA_ENABLE=0 # NVIDIA-SMI has failed" >>"''${gpuinfo_file}"
        else
          NVIDIA_ADDR=$(${pkgs.pciutils}/bin/lspci | ${pkgs.gnugrep}/bin/grep -Ei "VGA|3D" | ${pkgs.gnugrep}/bin/grep -i "''${GPUINFO_NVIDIA_GPU/NVIDIA /}" | ${pkgs.coreutils}/bin/cut -d' ' -f1)
          {
            echo "NVIDIA_ADDR=\"''${NVIDIA_ADDR}\""
            echo "GPUINFO_NVIDIA_GPU=\"''${GPUINFO_NVIDIA_GPU/NVIDIA /}\""
            echo "GPUINFO_NVIDIA_ENABLE=1"
          } >>"''${gpuinfo_file}"
        fi
      fi
    fi

    if ${pkgs.pciutils}/bin/lspci -nn | ${pkgs.gnugrep}/bin/grep -E "(VGA|3D)" | ${pkgs.gnugrep}/bin/grep -iq "1002"; then
      GPUINFO_AMD_GPU="$(${pkgs.pciutils}/bin/lspci -nn | ${pkgs.gnugrep}/bin/grep -Ei "VGA|3D" | ${pkgs.gnugrep}/bin/grep -m 1 "1002" | ${pkgs.gawk}/bin/awk -F'Advanced Micro Devices, Inc. ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
      AMD_ADDR=$(${pkgs.pciutils}/bin/lspci | ${pkgs.gnugrep}/bin/grep -Ei "VGA|3D" | ${pkgs.gnugrep}/bin/grep -i "''${GPUINFO_AMD_GPU}" | ${pkgs.coreutils}/bin/cut -d' ' -f1)
      {
        echo "AMD_ADDR=\"''${AMD_ADDR}\""
        echo "GPUINFO_AMD_ENABLE=1"
        echo "GPUINFO_AMD_GPU=\"''${GPUINFO_AMD_GPU}\""
      } >>"''${gpuinfo_file}"
    fi

    if ${pkgs.pciutils}/bin/lspci -nn | ${pkgs.gnugrep}/bin/grep -E "(VGA|3D)" | ${pkgs.gnugrep}/bin/grep -iq "8086"; then
      GPUINFO_INTEL_GPU="$(${pkgs.pciutils}/bin/lspci -nn | ${pkgs.gnugrep}/bin/grep -Ei "VGA|3D" | ${pkgs.gnugrep}/bin/grep -m 1 "8086" | ${pkgs.gawk}/bin/awk -F'Intel Corporation ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
      INTEL_ADDR=$(${pkgs.pciutils}/bin/lspci | ${pkgs.gnugrep}/bin/grep -Ei "VGA|3D" | ${pkgs.gnugrep}/bin/grep -i "''${GPUINFO_INTEL_GPU}" | ${pkgs.coreutils}/bin/cut -d' ' -f1)
      {
        echo "INTEL_ADDR=\"''${INTEL_ADDR}\""
        echo "GPUINFO_INTEL_ENABLE=1"
        echo "GPUINFO_INTEL_GPU=\"''${GPUINFO_INTEL_GPU}\""
      } >>"''${gpuinfo_file}"
    fi

    if ! ${pkgs.gnugrep}/bin/grep -q "GPUINFO_PRIORITY=" "''${gpuinfo_file}" && [[ -n "''${AQ_DRM_DEVICES}" ]]; then
      trap detect EXIT
    fi
  }

  toggle() {
    if [[ -n "$1" ]]; then
      NEXT_PRIORITY="GPUINFO_''${1^^}_ENABLE"
      if ! ${pkgs.gnugrep}/bin/grep -q "''${NEXT_PRIORITY}=1" "''${gpuinfo_file}"; then
        echo Error: "''${NEXT_PRIORITY}" not found in "''${gpuinfo_file}"
      fi
    else
      if ! ${pkgs.gnugrep}/bin/grep -q "GPUINFO_AVAILABLE=" "''${gpuinfo_file}"; then
        GPUINFO_AVAILABLE=$(${pkgs.gnugrep}/bin/grep "_ENABLE=1" "''${gpuinfo_file}" | ${pkgs.coreutils}/bin/cut -d '=' -f 1 | ${pkgs.coreutils}/bin/tr '\n' ' ' | ${pkgs.coreutils}/bin/tr -d '#')
        echo "" >>"''${gpuinfo_file}"
        echo "GPUINFO_AVAILABLE=\"''${GPUINFO_AVAILABLE[*]}\"" >>"''${gpuinfo_file}"
      fi

      if ! ${pkgs.gnugrep}/bin/grep -q "GPUINFO_PRIORITY=" "''${gpuinfo_file}"; then
        GPUINFO_AVAILABLE=$(${pkgs.gnugrep}/bin/grep "GPUINFO_AVAILABLE=" "''${gpuinfo_file}" | ${pkgs.coreutils}/bin/cut -d'=' -f 2)
        initGPU=$(echo "''${GPUINFO_AVAILABLE}" | ${pkgs.coreutils}/bin/cut -d ' ' -f 1)
        echo "GPUINFO_PRIORITY=''${initGPU}" >>"''${gpuinfo_file}"
      fi
      mapfile -t anchor < <(${pkgs.gnugrep}/bin/grep "_ENABLE=1" "''${gpuinfo_file}" | ${pkgs.coreutils}/bin/cut -d '=' -f 1)
      GPUINFO_PRIORITY=$(${pkgs.gnugrep}/bin/grep "GPUINFO_PRIORITY=" "''${gpuinfo_file}" | ${pkgs.coreutils}/bin/cut -d'=' -f 2)
      
      # Fixed the loop reference formatting for anchor keys expansion inside Nix blocks
      for index in "''${!anchor[@]}"; do
        if [[ "''${anchor[''${index}]}" = "''${GPUINFO_PRIORITY}" ]]; then
          current_index=''${index}
        fi
      done
      next_index=$(((current_index + 1) % ''${#anchor[@]}))
      NEXT_PRIORITY=''${anchor[''${next_index}]#\#}
    fi

    ${pkgs.gnused}/bin/sed -i 's/^\(GPUINFO_NVIDIA_ENABLE=1\|GPUINFO_AMD_ENABLE=1\|GPUINFO_INTEL_ENABLE=1\)/#\1/' "''${gpuinfo_file}"
    ${pkgs.gnused}/bin/sed -i "s/^#''${NEXT_PRIORITY}/''${NEXT_PRIORITY}/" "''${gpuinfo_file}"
    ${pkgs.gnused}/bin/sed -i "s/GPUINFO_PRIORITY=''${GPUINFO_PRIORITY}/GPUINFO_PRIORITY=''${NEXT_PRIORITY}/" "''${gpuinfo_file}"
  }

  map_floor() {
    IFS=', ' read -r -a pairs <<<"$1"
    if [[ ''${pairs[-1]} != *":"* ]]; then
      def_val="''${pairs[-1]}"
      unset 'pairs[''${#pairs[@]}-1]'
    fi
    for pair in "''${pairs[@]}"; do
      IFS=':</span' read -r key value <<<"$pair"
      num="''${2%%.*}"
      if [[ "$num" =~ ^-?[0-9]+$ && "$key" =~ ^-?[0-9]+$ ]]; then
        if ((num > key)); then
          echo "$value"
          return
        fi
      elif [[ -n "$num" && -n "$key" && "$num" > "$key" ]]; then
        echo "$value"
        return
      fi
    done
    [ -n "$def_val" ] && echo $def_val || echo " "
  }

  get_temp_color() {
    local temp=$1
    declare -A temp_colors=(
      [90]="#8b0000"
      [85]="#ad1f2f"
      [80]="#d22f2f"
      [75]="#ff471a"
      [70]="#ff6347"
      [65]="#ff8c00"
      [60]="#ffa500"
      [45]=""
      [40]="#add8e6"
      [35]="#87ceeb"
      [30]="#4682b4"
      [25]="#4169e1"
      [20]="#0000ff"
      [0]="#00008b"
    )

    # Fixed formatting wrapper loop targeting temp_colors key variables
    for threshold in $(echo "''${!temp_colors[@]}" | ${pkgs.coreutils}/bin/tr ' ' '\n' | ${pkgs.coreutils}/bin/sort -nr); do
      if ((temp >= threshold)); then
        color=''${temp_colors[$threshold]}
        if [[ -n $color ]]; then
          echo "<span color='$color'><b>''${temp}°C</b></span>"
        else
          echo "''${temp}°C"
        fi
        return
      fi
    done
  }

  generate_json() {
    if [[ $GPUINFO_EMOJI -ne 1 ]]; then
      temp_lv="85:, 65:, 45:☁, ❄"
    else
      temp_lv="85:🌋, 65:🔥, 45:☁️, ❄️"
    fi
    util_lv="90:, 60:󰓅, 30:󰾅, 󰾆"

    icons="$(map_floor "$util_lv" "$utilization")$(map_floor "$temp_lv" "''${temperature}")"
    speedo=''${icons:0:1}
    thermo=''${icons:1:1}
    emoji=''${icons:2}
    temp_color=$(get_temp_color "''${temperature}")

    local json="{\"text\":\"''${thermo} ''${temperature}°C\", \"tooltip\":\"''${emoji} ''${primary_gpu}\n''${thermo} Temperature: ''${temp_color}"

    declare -A tooltip_parts
    if [[ -n "''${utilization}" ]]; then tooltip_parts["\n$speedo Utilization: "]="''${utilization}%"; fi
    if [[ -n "''${current_clock_speed}" ]] && [[ -n "''${max_clock_speed}" ]]; then tooltip_parts["\n Clock Speed: "]="''${current_clock_speed}/''${max_clock_speed} MHz"; fi
    if [[ -n "''${core_clock}" ]]; then tooltip_parts["\n Clock Speed: "]="''${core_clock} MHz"; fi
    if [[ -n "''${power_usage}" ]]; then
      if [[ -n "''${power_limit}" ]]; then
        tooltip_parts["\n󱪉 Power Usage: "]="''${power_usage}/''${power_limit} W"
      else
        tooltip_parts["\n󱪉 Power Usage: "]="''${power_usage} W"
      fi
    fi
    if [[ -n "''${power_discharge}" ]] && [[ "''${power_discharge}" != "0" ]]; then tooltip_parts["\n Power Discharge: "]="''${power_discharge} W"; fi
    if [[ -n "''${fan_speed}" ]]; then tooltip_parts["\n Fan Speed: "]="''${fan_speed} RPM"; fi

    for key in "''${!tooltip_parts[@]}"; do
      local value="''${tooltip_parts[''${key}]}"
      if [[ -n "''${value}" && "''${value}" =~ [a-zA-Z0-9] ]]; then
        json+="''${key}''${value}"
      fi
    done
    json="''${json}\"}"
    echo "''${json}"
  }

  general_query() {
    filter=""
    sensors_data=$(${pkgs.lm_sensors}/bin/sensors 2>/dev/null)
    temperature=$(echo "''${sensors_data}" | ''${filter} ${pkgs.gnugrep}/bin/grep -m 1 -E "(edge|Package id.*|junction|hotspot)" | ${pkgs.gawk}/bin/awk -F ':' '{print int($2)}')
    fan_speed=$(echo "''${sensors_data}" | ''${filter} ${pkgs.gnugrep}/bin/grep -m 1 -E "fan[1-9]" | ${pkgs.gawk}/bin/awk -F ':' '{print int($2)}')

    for file in /sys/class/power_supply/BAT*/power_now; do
      [[ -f "''${file}" ]] && power_discharge=$(${pkgs.gawk}/bin/awk '{print $1*10^-6 ""}' "''${file}") && break
    done
    [[ -z "''${power_discharge}" ]] && for file in /sys/class/power_supply/BAT*/current_now; do
      [[ -e "''${file}" ]] && power_discharge=$(${pkgs.gawk}/bin/awk -v current="$(cat "''${file}")" -v voltage="$(cat "''${file/current_now/voltage_now}")" 'BEGIN {print (current * voltage) / 10^12 ""}') && break
    done

    get_utilization() {
      statFile=$(${pkgs.coreutils}/bin/head -1 /proc/stat)
      if [[ -z "$GPUINFO_PREV_STAT" ]]; then
        GPUINFO_PREV_STAT=$(${pkgs.gawk}/bin/awk '{print $2+$3+$4+$6+$7+$8 }' <<<"$statFile")
        echo "GPUINFO_PREV_STAT=\"$GPUINFO_PREV_STAT\"" >>"''${gpuinfo_file}"
      fi
      if [[ -z "$GPUINFO_PREV_IDLE" ]]; then
        GPUINFO_PREV_IDLE=$