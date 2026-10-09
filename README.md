# companion: the book's /etc/nixos, commit after commit

This repository is the `/etc/nixos` you build while following *NixOS: The
Declarative System*, from the chapter "Structuring Your Configuration", where
it goes under git, to the last page. Each commit is a commit printed in the
book, with the book's message to the character: nothing more, nothing less.

It serves two purposes:

- **comparing** your repository with ours, at any point in the book;
- **recovering** a file that went astray along the way.

It is not meant to be deployed as is: its keys, its vaults and its hardware
observations are those of our machines, not yours (see "What differs on your
side").

## The checkpoints

One tag per chapter marks its last commit: `13-structuring`, `14-services`,
and so on up to `32-contributing`, plus `end-of-story`. "Channels and Their
Limits" commits nothing: there is no `18-` tag.

```console
$ git log --oneline 20-packaging..21-overlays    # a chapter's commits
$ git diff 20-packaging 21-overlays               # everything it changed
$ git show 22-secrets:modules/users.nix           # a file, as it stood then
```

The `git diff` between two tags restates, file by file, the lines the chapter
marks `[+]` and `[-]` in the margin.

## The branches

- `main`: the story, from "Structuring Your Configuration" to "Contributing to
  nixpkgs";
- `runner`: Appendix F, "The Forge Runner" (tag `F-runner`);
- `real-machine`: Appendix G, "The Workstation on Real Hardware" (tag
  `G-workstation`).

Both appendices start from `end-of-story` and ignore each other: the real
workstation gets along perfectly well without the runner.

## Before git

Chapters 4 to 12 (the laboratory, then the workstation up to "Breaking and
Repairing") come before the first commit. Their states live as folders in the
[snippets](https://github.com/nixos-the-declarative-system/snippets)
repository, along with each chapter's command sheet.

## What differs on your side

Your repository will never be identical to ours, and that is as it should be.
Expect these differences, and only these:

- **commit hashes and dates**: they belong to your own history;
- **identities**: the age keys in `.sops.yaml`, the SSH keys (`authorizedKeys`,
  `knownHosts`), the `workshop-1:…` signing key in `remote-access.nix`. This
  repository carries the ones the book prints; where the page abridges one
  (`AAAAIB7fq…`), it keeps the printed beginning. Every machine and every
  person draws their own at random: yours will be different;
- **the vaults** `secrets/*.yaml`: encrypted for the book's keys, so unreadable
  to you, and they hold nothing but placeholders in place of the values. They
  show their shape (the names of the secrets, the recipients); yours are
  encrypted for your keys;
- **the hardware observations** (`hardware-configuration.nix`): those of our
  machines; on the `real-machine` branch, those of a real machine, which is
  not yours;
- **`certificates/`**: our house's authority; yours will be your own;
- **the lock** `flake.lock`: it pins nixpkgs to the commit the book pinned,
  `b3fe958`. The input follows the `nixos-26.05` branch, as in the book;
  `flake.nix` carries the exact pin as a comment, for whoever wants our
  versions byte for byte (the box "pinning exactly the water from your
  channel" in the chapter "Flakes: The Migration");
- **the `site` input** of the flake points to `https://forge/camille/carnet.git`,
  your private forge (chapter "The Private Forge"): it only resolves on your
  side. The original notebook is
  [here](https://github.com/nixos-the-declarative-system/carnet);
- **the addresses** `192.168.122.x`: those of our hypervisor; the book teaches
  you to find yours.

One step in the book is conditional and does not enter this history: "the
address book corrects itself" (chapter "Birth of the Server"), if your
showcase's address differs from ours.

Two lines, finally, are not in the book: the commented pin in `flake.nix`, and
the reminder, above `trusted-public-keys`, that the signing key is the one of
*your* workshop. This `README.md` and the `LICENSE` are the only other
intruders.

## Found a typo?

Open an *issue* on this repository: your report will help the readers who
come after you.

## License

[CC0 1.0](LICENSE): copy, adapt, no strings attached.

---

**This project is independent.** It is neither affiliated with nor endorsed by
the NixOS Foundation or the NixOS community project; "NixOS" is used here only
to name the operating system the book is about. Official site of the community
project: [nixos.org](https://nixos.org).
