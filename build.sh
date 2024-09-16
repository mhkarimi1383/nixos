sudo nix flake update
sudo nixos-rebuild switch --flake /etc/nixos?submodules=1#default --recreate-lock-file --upgrade --upgrade-all
