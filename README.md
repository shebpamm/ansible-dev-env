Here's my day to day env I use in ROOT. This codebase was originally just a nix flake but I've moved to devenv now.

Should now work on the following architectures:  
- aarch64-darwin
- aarch64-linux
- x86_64-darwin
- x86_64-linux

## Quickstart in docker if ya want to fiddle

1. Clone this repo  
2. `docker run -it -v $(pwd):/environment nixos/nix`  
  
Now inside docker:  
3. Install cachix to speed up installation with prebuilt binaries  
```
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use devenv
```
4. Install devenv  
`nix-env -if https://github.com/cachix/devenv/tarball/v0.5`

5. `cd /environment`  
6. `devenv shell`

You should now be in a shell with all my tools. Gratz. 
