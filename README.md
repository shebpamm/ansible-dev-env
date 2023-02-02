Here's my day to day env I use in ROOT. This codebase was originally just a nix flake but I've moved to devenv now.

Right now probably only x64-linux works because it's using the package github:shebpamm/ansible-mitogen (made by me) and I don't think I've made the package support other platforms out of lazyness yet. I should fix that.

## Quickstart in docker if ya want to fiddle

1. Clone this repo  
2. `docker run -it -v $(pwd):/data nixos/nix`  
  
Now inside docker:  
3. `cd /data`  
4. Install cachix to speed up installation with prebuilt binaries
```
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use devenv
```
5. `nix-env -if https://github.com/cachix/devenv/tarball/v0.5`
6. `devenv shell`

You should now be in a shell with all my tools. Gratz. 
