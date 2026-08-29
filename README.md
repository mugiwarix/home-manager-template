# Home Manager Flake Template

A small [Home Manager](https://github.com/nix-community/home-manager) template for standalone Linux installations.
Home Manager does not need to be installed globally before the first activation.

The flake pins Nixpkgs and Home Manager to their matching `26.05` release
branches. It supports `x86_64-linux` and `aarch64-linux`, includes a lockfile for
reproducibility, and validates the configured profile in CI.

## Included Defaults

- Git with `main` as the default branch
- The `bc` command-line calculator
- The Home Manager command after first activation
- Repository-wide Nix formatting through `nixfmt-tree`

Shells, editors, desktop software, services, unfree packages, and secret
management are deliberately left to each generated repository.

## Prerequisites

Install [Nix](https://nixos.org/download/) on a Linux system and enable the
`nix-command` and `flakes` experimental features. For example, add this to
`~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:

```text
experimental-features = nix-command flakes
```

## Get Started

1. Select **Use this template**, then **Create a new repository**.
2. Choose an owner, visibility, and name, then create the repository.
3. Clone your generated repository.
4. Open `flake.nix` and review the three values in the customization block:
   `username`, `homeDirectory`, and `system`.
5. Replace `your-username` with your Linux username. The default home directory
   follows that value as `/home/<username>`.
6. On 64-bit ARM Linux, change `system` to `aarch64-linux`. Keep
   `x86_64-linux` on standard 64-bit Intel and AMD systems.

Repositories generated from this template are independent and can be private.

Format and validate the configuration before activating it:

```console
nix fmt
nix fmt -- --ci
nix flake check --print-build-logs
nix flake show
```

For the unmodified placeholder profile, the first activation command is:

```console
nix run github:nix-community/home-manager/release-26.05 -- switch --flake ".#your-username"
```

After replacing the placeholder, use your configured username after `.#`. The
first activation installs the `home-manager` command, so later activations can
use:

```console
home-manager switch --flake ".#your-username"
```

If the repository is at `${XDG_CONFIG_HOME:-$HOME/.config}/home-manager` and the
configured username matches your Linux username, later activations can omit the
flake argument:

```console
home-manager switch
```

## Customize

`flake.nix` defines one Home Manager profile and the flake outputs. The
repository keeps the profile's features in a flat, auto-imported module tree:

```text
.
|-- flake.nix
`-- modules/
    |-- git.nix
    `-- packages.nix
```

- Add or remove packages in `modules/packages.nix`.
- Set your Git name and email using the commented examples in
  `modules/git.nix`.
- Customize the profile identity and architecture in `flake.nix`.

Every `.nix` file under `modules/` is an ordinary Home Manager module and is
auto-imported recursively by `import-tree`, except files in paths containing
`/_`. Adding a feature does not require updating a central import list:

```nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.hello ];
}
```

Do not put secrets directly in Nix expressions. Evaluated values can be copied
to the world-readable Nix store; use a dedicated secret-management tool
instead (e.g. [sops-nix](https://github.com/mic92/sops-nix)).

## Update Inputs

Refresh the pinned inputs, validate the configuration, and then activate the new
generation:

```console
nix flake update
nix flake check --print-build-logs
home-manager switch --flake ".#your-username"
```

`home.stateVersion` in `flake.nix` is a compatibility setting, not the selected
Home Manager release. Do not change it during routine input updates. Review the
Home Manager release notes before changing it deliberately.

The sample check builds the configured architecture. GitHub's standard Ubuntu
runner builds the default `x86_64-linux` profile; generated repositories
targeting `aarch64-linux` should use an ARM runner or adjust their CI validation
strategy.

## License

This template is licensed under the GNU General Public License v3.0. See
[`LICENSE`](LICENSE) for the full terms.
