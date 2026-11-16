# Working on rzone

rzone is local time for [raz](https://raz.lucela.org) programs: the
module `Zone`. Read `CONTRIBUTING.md` first: defects and documentation
fixes are offered as GitHub issues, not pull requests; a fix comes only
after the defect is agreed, you sign off (DCO), and a tool such as an AI
model only helps you, you answer for every line.

## What defines behaviour

`doc/rzone.3` and `README.md`. Where glibc and rzone part, the page's
CAVEATS says so and `test/Glibc.raz` says why its case differs;
otherwise glibc is right. A defect is rzone doing other than they say.

## Build and check

    make check      # the module's own main (its test), then test/Glibc.raz: Zone against glibc's localtime_r
    make fmt        # src/ and test/*.raz are laid out as raz's formatter lays them out

`make check` needs `cc` and `zic`. It builds with `-Werror` against the
raz named by `RAZVERSION` in the `Makefile` (0.25.0); `make` warns of any
other. `make check` and `make fmt` must pass. The formatter is
`Pretty.raz` from that raz's `tools/`.

## Layout

- `src/Zone.raz`: the whole module; its `main` is its unit test.
- `test/`: `Glibc.raz` compares Zone with glibc zone by zone, using
  `glibc.c` and the zones in `slim.zi`. A fix adds a case there or to
  `main`.
- `doc/rzone.3`: the manual page.

## Conventions

- Small on purpose: the instant's offset, abbreviation and date, and
  the calendar's days.
- Readability first: the module opens with a comment saying what it is,
  what it depends on and what it leaves out; every procedure, type and
  field has a short plain comment; comments say why. Documentation in
  plain, short prose. A comment must not hold `*)`.
- Follow raz's `STANDARDS.md`.
- A change to behaviour updates `doc/rzone.3` and `README.md` in the
  same patch.
