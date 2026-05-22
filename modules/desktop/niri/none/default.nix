# Messing with the default module to make it a safe landing for 'bar = "none"' in variables.nix. This way, if someone selects 'none' for the bar, they won't encounter errors due to missing modules.
{ ... }: {
  # This file is intentionally left blank.
  # It acts as a safe landing module when 'bar = "none"' is selected in variables.nix.
}