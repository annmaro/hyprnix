#   
My NixOS Configuration   
   




  


## Screenshots

Screenshot
Screenshot
Screenshot

More screenshots

Screenshot
Screenshot
Screenshot
Screenshot



## Table of Contents

- [Screenshots](#screenshots)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Installation Steps](#installation-steps)
- [Usage](#usage)
  - [Managing Hosts](#managing-hosts)
  - [Rebuilding](#rebuilding)
  - [Rollbacks](#rollbacks)
  - [Keybindings](#keybindings)
- [Credits/Inspiration](#creditsinspiration)

## Installation

> [!Note]
> Before proceeding with the installation, check these files and adjust them for your system:
>
> - `hosts/default/variables.nix`: Contains host-specific variables.
> - `hosts/default/host-packages.nix`: Lists installed packages for the host.
> - `hosts/default/configuration.nix`: Module imports for the host and extra configuration.
> - `modules/hardware/drives/`: Optional fstab-style mounts for extra volumes (e.g. games/work).



You can install on a running system or from the NixOS live installer. Get the minimal ISO from the [NixOS website](https://nixos.org/download/#nixos-iso).

### Installation Steps

1. Clone the Repository:

```bash
git clone https://github.com/annmaro/hyprnix.git ~/hyprnix
```



1. Change Directory:

```bash
cd ~/hyprnix
```

1. Run the Installer:

```bash
./install.sh
```



The install and rebuild scripts automate the setup process, including hosts, username, and applying the configuration. It also automatically generates the hardware-configuration.nix file based on your system's detected hardware, eliminating the need to manually generate it.

## Usage

### Managing Hosts

**Method 1: Automatic** - run the installer again to select or create another host:

```bash
./install.sh
```

**Method 2: Manual:**

1. Copy `hosts/default` to a new directory (e.g., `hosts/Laptop`)
2. Edit the new host's `variables.nix` and `host-packages.nix`
3. Add the host to `flake.nix`:



1. Rebuild with the new hostname using either `nixos-rebuild` or `nh` (see [Rebuilding](#rebuilding) below). Once rebuilt, any rebuilding method can be used, as the host name will be implicitly recognised.

### Rebuilding

Apply configuration changes:

- **Keyboard shortcut:** `Super + U`
- **rebuild script:** `rebuild`
- **nixos-rebuild:** `sudo nixos-rebuild switch --flake ~/hyprnix#<HOST>`
- **nh:** `nh os switch --hostname <HOST>`

Replace `<HOST>` with the name of your host (e.g., `Laptop`).

> [!Note]
>
> - If you face any error during the rebuilding phase, kindly uncomment the neovim config from the configuration.nix file. Once you have successfully booted into NixOS, you can add neovim.
> - For the weather info, I have used [waybar-weather](https://gitlab.com/baconisaveg/waybar-weather). Use the installation steps mentioned there.

### Rollbacks

List generations:

```bash
list-gens
```

Rollback to generation N:

```bash
rollback N
```

Replace `N` with the generation number (e.g., `69`).

### Keybindings

View all keybindings with `Super + ?` or `Super + Ctrl + K`.

## Credits/Inspiration


| Credit                                      | Reason                                      |
| ------------------------------------------- | ------------------------------------------- |
| [Sly-Harvey](//github.com/Sly-Harvey/NixOS) | Thanks for creating such a wonderful config |
| [Nixy](https://github.com/anotherhadi/nixy) | Amazing Neovim config                       |


