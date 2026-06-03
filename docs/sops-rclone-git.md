---
layout: default
title: "Technical Report: Secure Infrastructure Deployment"
---

## 💻 1. Cryptographic Security Foundations

### 🔑 Local Identity Decoupling

To enforce pure evaluation execution within sandboxed Nix Flakes, local system references to absolute cryptographic keys must be completely removed. 
Identity paths are initialized dynamically as unprivileged symlinks managed at runtime.

| Identification Asset   | Target Mount Path       | Functional Role                    | Access Scope               |
| :--------------------- | :---------------------- | :--------------------------------- | :------------------------- |
| User Public Key        | `~/.ssh/id_ed25519.pub` | Upstream host validation (VCS)     | Global / Unrestricted      |
| User Private Key       | `~/.ssh/id_ed25519`     | Secure host entry validation       | Cryptographically Sealed   |
| GPG Signing Identifier | `xxxyyyzzz12345`        | Cryptographic signature validation | Public Configuration Token |

### 🔒 GPG Code Auditing Infrastructure

* A local 4096-bit RSA master identity key pair was instantiated to sign VCS code changes natively.
* The system uses a persistent, non-expiring cryptographic block configuration.
* **Passphrase Escrow:** Decoupled from persistent memory blocks using an active user-level loop service (`services.gpg-agent`).
* **Visual Modals:** Passphrase prompt routing is handled dynamically via `pkgs.pinentry-gnome3`.

---

## 🛠️ 2. Automated Secret Management Engine (sops-nix)

The host environment implements symmetric file sealing via age key wrappers to prevent hardcoded authentication variables from leaking into public code repositories.

```text
[ Local age Key ]
│ (Passes Master Identity)
▼
┌─────────────────────────────┐
│ secrets/secrets.yaml        │ ──► Sealed with AES256-GCM Encryption
└─────────────────────────────┘
│
▼ (Dynamic Decryption at Boot)
┌─────────────────────────────┐
│ $XDG_RUNTIME_DIR/           │ ──► Secure Volatile RAM Only
└─────────────────────────────┘
```

### ⚙️ Master Rule Layout (.sops.yaml)

Placed strictly at the physical root of your repository structure to process matching file patterns securely:

```yaml
keys:
  - &primary age1edeyqhmqyl2yzr927f04nptnpueatmxnkrvtxj4yca4yaaavecksw54mdp
creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
        - *primary
```

---

## 📂 3. Modular System Architecture Specification

The system configuration is split into independent, decoupled components under the unified `home-manager.sharedModules` abstraction layer.

### 🛡️ Core Infrastructure Module

**File System Path:** `modules/core/git-sops/default.nix`  
Imports the core sops-nix engine and establishes dynamic volatile memory mappings for all decrypted user-space credentials.

### 📚 Cloud Mount Optimization Module

**File System Path:** `modules/programs/media/rclone/default.nix`  
Establishes an automated user Systemd daemon (`rclone-gdrive-mount.service`) to mount cloud assets on boot.
It features optimized read-ahead and block-caching configurations designed to strip streaming latency from compressed digital archives (.cbz, .cbr).

```nix
# Architectural Performance Variables Highlight:
--vfs-cache-mode full      # Simulates local hard drive responses for archives
--vfs-cache-max-size 15G   # Restricts dynamic local cache bloat
--vfs-read-chunk-size 32M  # On-demand paging optimization
--read-only                # Immutable mounting to ensure zero remote cloud corruption
```

### 💻 Signed Git & Development Tooling Module

**File System Path:** `modules/core/git-sops/git.nix`  
Deploys a complete git environment. It dynamically resolves unencrypted keys straight out of memory objects, configures persistent system variables, handles automated historical storage pruning, and loads custom workflow helper utilities.

**🧰 Integrated Core Aliases Ecosystem:**

* `git c` / `git ca`: Streamlined commit workflows (`commit -m` / `commit -am`).
* `git forgor`: Rapid patch adjustments (`commit --amend --no-edit`).
* `git hist` / `git llog`: Dense, multi-color interactive graph visualizations directly inside the terminal window.
* `git af`: Fuzzy-find file picker interface mapped via `pkgs.skim`.
* `git df`: Multi-commit target selector interface mapped via `pkgs.peco`.

---

## 🚀 4. Deployment & Maintenance Checklist

Execute these operations in order within your terminal window to securely compile and apply your system updates:

```bash
# 1. Register all structural configuration paths into the active Git index
git add .sops.yaml modules/core/sops/default.nix modules/core/rclone/default.nix modules/core/git/default.nix secrets/secrets.yaml

# 2. Compile system derivations and activate the new software generation
sudo nixos-rebuild boot --flake .#default

# 3. Monitor active connection statuses and cloud storage mount tracking logs
systemctl --user status rclone-gdrive-mount.service

# 4. Confirm the integrity of your cryptographic GPG signature hooks
git commit --allow-empty -m "Test: Validating production code signature paths"
git log --show-signature -n 1

<!-- cache flush trigger -->

```
