# nixpkgs

A repo containing my nix system configurations in flake format.


## Quickstart

First, add a host configuration directory under `hosts/darwin/`, `hosts/nixos/`, or
`hosts/home-manager/` named after your system's hostname. The `mkHostConfigs`
auto-discovery in `flake.nix` will pick it up automatically (for more information
see the introduction to nix flakes below).

The next steps make use of a bash script in the bin directory which provides
a set of convenience functions enabling easy nix system administration, named `nixlify`.
Full details of the commands provided by `nixlify` are below.

Second, install nix to the system. Use the
[Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
or your preferred nix distribution (e.g., Lix) directly.

Then, use the `nixlify bootstrap` command to take care of building and applying
the initial system configuration. This uses `nix build` directly (rather than
`darwin-rebuild`/`nixos-rebuild`) so it works before those tools are available.

```
# by default bootstrap will not apply the built config
# use it with the --switch flag to have it do so
❯ ./bin/nixlify bootstrap --switch

```

`bootstrap` will discover the system type automatically, and uses the system hostname
to specify the nix flake output to apply. If for some reason the dicovered values are
not appropriate for a given system, the command accepts options to manually override
them (use `--help` to see more info regarding the supported parameters).


## The `nixlify` tool

Included in the bin dir is a bash tool designed to provide a convenient interface
for administering a nix system with the contained configurations. The tool is
designed to be self-documenting and discoverable, but each supported command is
also listed here for reference:

### `nixlify help`

Get usage information.


### `nixlify bootstrap`

Bootstraps the initial system config from a base system with a
basic nix installation. Uses `nix build` directly so it works
before `darwin-rebuild`/`nixos-rebuild` are available.


### `nixlify build`

Command to build the user/system configuration.
Discovers unspecified build parameters from the system.


### `nixlify switch`

Command to switch (build and apply) the user/system configuration.
Discovers unspecified build parameters from the system.


### `nixlify uninstall`

Uninstall nix and whole configuration from the system.

**NOTE: this operation is currently not implemented due
to instability in the nix installation process.**


### `nixlify update`

Update one or more flake input versions in the lock file.


### `nixlify diff`

Diff system configurations across git refs.


### `nixlify which`

Print the absolute path to the configuration directory.


## Basic intro to nix flakes

### What is a flake?

A nix flake is essentially just a structured json document that describes a set of
inputs that can be used to generate a set of outputs. Most basically, a flake can
be a static configuration file, but in practice the nix language allows the dynamic
generation of that json in a way that provides an exceptional level of control over
building a system configuration.

Using the flake.nix in this project as a reference, we can formualte a simple example
to better understand the flake concept:

```
{
  inputs = {
    # We define all our inputs as keys in the inputs mapping.
    # All inputs are mappings themselves.
    nixpkgs = {
        url = "github:nixos/nixpkgs/nixos-unstable";
    }

  # The outputs are a function of the inputs, which we can
  # name here if we want to refer to them as indentifiers.
  outputs = inputs@{ self, nixpkgs, ... }: {
      # MacOS configurations
      darwinConfigurations = {
        some_host = ...
      }

    # home-manager configurations
    homeConfigurations = {
      some_other_host = ...
    }
  }
}
```

Here we have a flake with one input `nixpkgs`, and two top-level outputs defined:
`darwinConfigurations` and `homeConfigurations`. Each of these outputs is a mapping,
typically of hostname to a configuration definition.

The real flake.nix uses an auto-discovery pattern (`mkHostConfigs`) that scans
directories under `hosts/darwin/`, `hosts/nixos/`, and `hosts/home-manager/` to
automatically generate configuration outputs. Each subdirectory (excluding `_common`)
becomes a configuration entry keyed by its directory name (which should match the
hostname). For example, a host config at `hosts/darwin/toltecal/default.nix` is
automatically available as `darwinConfigurations.toltecal`.

The flake provides the following outputs:

- **`darwinConfigurations`** -- nix-darwin system configs (auto-discovered from `hosts/darwin/`)
- **`nixosConfigurations`** -- NixOS system configs (auto-discovered from `hosts/nixos/`)
- **`homeConfigurations`** -- standalone home-manager configs (auto-discovered from `hosts/home-manager/`)
- **`checks`** -- all of the above as `nix flake check` derivations, grouped by system
- **`overlays.default`** -- nixpkgs overlay with custom packages
- **`packages`** -- `nixlify` and `nixdiff` wrapper scripts
- **`devShells.default`** -- dev shell with `nixfmt`, `statix`, `deadnix`
- **`formatter`** -- `nixfmt` for `nix fmt`
- **`legacyPackages`** -- full nixpkgs for each supported system

While using hostnames for the key in the configuration mapping is not required,
doing so does provide an easy means of automatically mapping a system to a
configuration, a feature relied upon in the `nixlify` convenience script.

But why? Well, to build a nix configuration from the flake, we have to provide
the output from the flake that we specifically want to use. That looks something
a bit like this in `nixlify`:

```
nix build ".#${TARGET}.${HOSTNAME}.config.system.build.toplevel" -v --experimental-features "nix-command flakes"
```

where `$TARGET` is the top-level configuration type, such as `darwinConfigurations`,
and `$HOSTNAME` is the configuration key in that configuration mapping, like `toltecal`.


### How to use the flake.nix for your own systems

If you want to use this repo as a template to get started managing your own system
configurations with nix, the first step is to update the defined system configurations
with your own system(s). Then you can use the provided `nixlify` script to install,
build, and apply the configurations to your systems.

However, system configuration is a deeply personal thing, particualrly given the level
of detail and bredth with which nix allows one to specify a configuration. In that regard,
simply applying my configuration to your own system is likely not going to result in a
satisfactory experience. Unfortunately, nix does have a bit of a learning curve assocaited
with it, and convenying a working knowledge of nix here in this README would not be practical.

Instead, see the list of nix resources below for some documentation I found useful
while adventuring down this nix journey myself.


## A note of encouragment

At this point you might simply think nix is not for you and that's okay!

However, I want to reaffirm that while it is hard to get started with nix, you don't have
to be an expert to reap significant benefits from a small investment in learning. I had
a dotfiles repo before nix and considered my configuration fairly complex and
well-automated, so at first the potential returns we not obivous to me. I really
only managed to stick it out because I was _highly_ motivated to find a way to never
have a conflict in shared library versions again after feeling pain from that at a
particularly unfortunate time.

Yet, as I got further along and realized the full potential of what nix had to offer,
I feel as though I have leveled up many times as a developer through this process.
The tooling I now have at my fingertips is better than I have ever dreamed, blowing
many disparate "wouldn't it be nice if..." ideas right out of the water _with a single
tool_. `nix-shell` is game-changing. If you only learn nix for that, you will do yourself
a grand service.

I don't mean to be too preachy for a README, I merely want to convey that learning nix
really is worth the effort.


## Helpful nix resources

Here is a list of nix resources I personally found quite helpful in getting started with
nix. It is true that good, comprehenive nix documentation is hard to find, but hopefully
this list will provide a decent enough resource to help get people started.


### Concept documents

- https://serokell.io/blog/practical-nix-flakes
- https://ejpcmac.net/blog/about-using-nix-in-my-development-workflow/
- https://wickedchicken.github.io/post/macos-nix-setup/
- https://dev.to/louy2/use-nix-on-macos-as-a-homebrew-user-22d
- https://www.mathiaspolligkeit.de/dev/exploring-nix-on-macos/


### Official documentation

- https://nixos.org/manual/nix/stable/
- https://github.com/LnL7/nix-darwin
- https://nixos.org/manual/nix/unstable/#sect-macos-installation
- https://nixos.wiki/wiki/Python


### Other nix config examples

- https://github.com/kclejeune/system
- https://github.com/malob/nixpkgs
- https://github.com/Brettm12345/nixos-config

Find more of these examples simply by searching for "personal nixos config" or the like.
