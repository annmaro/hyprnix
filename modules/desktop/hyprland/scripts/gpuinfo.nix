{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "gpuinfo";

  # Nix automatically adds these binaries to the script's run path,
  # keeping the Bash code clean and easy to maintain.
  runtimeInputs = with pkgs; [
    coreutils
    gnugrep
    gawk
    pciutils
    kmod
    gnused
    lm_sensors
    jq
  ];

  text = ''
    gpuinfo_file="/tmp/$UID-gpuinfo"

    AQ_DRM_DEVICES="''${AQ_DRM_DEVICES:-WLR_DRM_DEVICES}"

    tired=false
    if [[ " $* " =~ " --tired " ]]; then
      if ! grep -q "tired" "''${gpuinfo_file}"; then
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
      if ! grep -q "GPUINFO_EMOJI" "''${gpuinfo_file}"; then
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
      card=$(echo "''${AQ_DRM_DEVICES}" | cut -d':' -f1 | cut -d'/' -f4)
      slot_number=$(ls -l /dev/dri/by-path/ | grep "''${card}" | awk -F'pci-0000:|-card' '{print $2}')
      vendor_id=$(lspci -nn -s "''${slot_number}")
      declare -A vendors=(["10de"]="nvidia" ["8086"]="intel" ["1002"]="amd")
      
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

      if lsmod | grep -q 'nouveau'; then
        echo "GPUINFO_NVIDIA_GPU=\"Linux\"" >>"''${gpuinfo_file}"
        echo "GPUINFO_NVIDIA_ENABLE=1 # Using nouveau an open-source nvidia driver" >>"''${gpuinfo_file}"
      elif command -v nvidia-smi &>/dev/null; then
        GPUINFO_NVIDIA_GPU=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)
        if [[ -n "''${GPUINFO_NVIDIA_GPU}" ]]; then
          if [[ "''${GPUINFO_NVIDIA_GPU}" == *"NVIDIA-SMI has failed"* ]]; then
            echo "GPUINFO_NVIDIA_ENABLE=0 # NVIDIA-SMI has failed" >>"''${gpuinfo_file}"
          else
            NVIDIA_ADDR=$(lspci | grep -Ei "VGA|3D" | grep -i "''${GPUINFO_NVIDIA_GPU/NVIDIA /}" | cut -d' ' -f1)
            {
              echo "NVIDIA_ADDR=\"''${NVIDIA_ADDR}\""
              echo "GPUINFO_NVIDIA_GPU=\"''${GPUINFO_NVIDIA_GPU/NVIDIA /}\""
              echo "GPUINFO_NVIDIA_ENABLE=1"
            } >>"''${gpuinfo_file}"
          fi
        fi
      fi

      if lspci -nn | grep -E "(VGA|3D)" | grep -iq "1002"; then
        GPUINFO_AMD_GPU="$(lspci -nn | grep -Ei "VGA|3D" | grep -m 1 "1002" | awk -F'Advanced Micro Devices, Inc. ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
        AMD_ADDR=$(lspci | grep -Ei "VGA|3D" | grep -i "''${GPUINFO_AMD_GPU}" | cut -d' ' -f1)
        {
          echo "AMD_ADDR=\"''${AMD_ADDR}\""
          echo "GPUINFO_AMD_ENABLE=1"
          echo "GPUINFO_AMD_GPU=\"''${GPUINFO_AMD_GPU}\""
        } >>"''${gpuinfo_file}"
      fi

      if lspci -nn | grep -E "(VGA|3D)" | grep -iq "8086"; then
        GPUINFO_INTEL_GPU="$(lspci -nn | grep -Ei "VGA|3D" | grep -m 1 "8086" | awk -F'Intel Corporation ' '{gsub(/ *\[[^\]]*\]/,""); gsub(/ *\([^)]*\)/,""); print $2}')"
        INTEL_ADDR=$(lspci | grep -Ei "VGA|3D" | grep -i "''${GPUINFO_INTEL_GPU}" | cut -d' ' -f1)
        {
          echo "INTEL_ADDR=\"''${INTEL_ADDR}\""
          echo "GPUINFO_INTEL_ENABLE=1"
          echo "GPUINFO_INTEL_GPU=\"''${GPUINFO_INTEL_GPU}\""
        } >>"''${gpuinfo_file}"
      fi

      if ! grep -q "GPUINFO_PRIORITY=" "''${gpuinfo_file}" && [[ -n "''${AQ_DRM_DEVICES}" ]]; then
        trap detect EXIT
      fi
    }

    toggle() {
      if [[ -n "$1" ]]; then
        NEXT_PRIORITY="GPUINFO_''${1^^}_ENABLE"
        if ! grep -q "''${NEXT_PRIORITY}=1" "''${gpuinfo_file}"; then
          echo Error: "''${NEXT_PRIORITY}" not found in "''${gpuinfo_file}"
        fi
      else
        if ! grep -q "GPUINFO_AVAILABLE=" "''${gpuinfo_file}"; then
          GPUINFO_AVAILABLE=$(grep "_ENABLE=1" "''${gpuinfo_file}" | cut -d '=' -f 1 | tr '\n' ' ' | tr -d '#')
          echo "" >>"''${gpuinfo_file}"
          echo "GPUINFO_AVAILABLE=\"''${GPUINFO_AVAILABLE[*]}\"" >>"''${gpuinfo_file}"
        fi

        if ! grep -q "GPUINFO_PRIORITY=" "''${gpuinfo_file}"; then
          GPUINFO_AVAILABLE=$(grep "GPUINFO_AVAILABLE=" "''${gpuinfo_file}" | cut -d'=' -f 2)
          initGPU=$(echo "''${GPUINFO_AVAILABLE}" | cut -d ' ' -f 1)
          echo "GPUINFO_PRIORITY=''${initGPU}" >>"''${gpuinfo_file}"
        fi
        mapfile -t anchor < <(grep "_ENABLE=1" "''${gpuinfo_file}" | cut -d '=' -f 1)
        GPUINFO_PRIORITY=$(grep "GPUINFO_PRIORITY=" "''${gpuinfo_file}" | cut -d'=' -f 2)
        
        for index in "''${!anchor[@]}"; do
          if [[ "''${anchor[''${index}]}" = "''${GPUINFO_PRIORITY}" ]]; then
            current_index=''${index}
          fi
        done
        next_index=$(((current_index + 1) % ''${#anchor[@]}))
        NEXT_PRIORITY=''${anchor[''${next_index}]#\#}
      fi

      sed -i 's/^\(GPUINFO_NVIDIA_ENABLE=1\|GPUINFO_AMD_ENABLE=1\|GPUINFO_INTEL_ENABLE=1\)/#\1/' "''${gpuinfo_file}"
      sed -i "s/^#''${NEXT_PRIORITY}/''${NEXT_PRIORITY}/" "''${gpuinfo_file}"
      sed -i "s/GPUINFO_PRIORITY=''${GPUINFO_PRIORITY}/GPUINFO_PRIORITY=''${NEXT_PRIORITY}/" "''${gpuinfo_file}"
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
        elif