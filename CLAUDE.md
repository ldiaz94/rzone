# Working on rzone

rzone is local time for raz programs: the module `Zone`. Read
`PLAN.md` first, then `doc/rzone.3`. The language is defined by raz's
report (`man raz`, and the website's); the tests build with the raz on
PATH, of the version `RAZVERSION` in the Makefile says.

## Setup and checks

    make check      # the module's main, its test; then test/Glibc.raz, Zone against glibc's localtime_r
    make fmt        # src/ and test/ are laid out as raz's formatter lays them out
    make loc        # lines, a measure only
    make install    # rzone.3 on MANPATH via ~/.local (PREFIX=...)

`make check` needs `cc` and `zic`. `make check` and `make fmt` must
pass before every commit.

## How we work

- Small on purpose: the instant's offset, abbreviation and date, and
  the calendar's days. A feature comes in only when programs need it.
- Where glibc and rzone part, `doc/rzone.3`'s CAVEATS says so, and
  `test/Glibc.raz` says why its case differs; otherwise glibc is right.
- Readability first. Each module opens with what it is, what it
  depends on and what it leaves out; comments say why. Documentation in
  the plain, short prose of raz's report. A comment must not hold `*)`.
- raz moves only by changing `RAZVERSION` (and installing that raz),
  on its own commit, with `make check` passing. What rzone needs of
  raz that raz lacks goes in `~/r/RAZ-GAPS.md`.
- Commits: author `Luis <42945842+ldiaz94@users.noreply.github.com>`,
  unsigned (`--no-gpg-sign`), no attribution trailer. Push to `main`
  of `ldiaz94/rzone`. No pull requests unless asked. No CI for now.
