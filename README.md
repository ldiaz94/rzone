# rzone

rzone is local time for [raz](https://raz.lucela.org)
programs: a module, `Zone`, that says, for an instant, how far the
local clock is ahead of UTC, what the zone calls that clock, and the
date and time the clock shows, as C's `localtime_r` does, without C.

- The zone as the GNU C library finds it: `TZ` unset is
  `/etc/localtime`, empty is UTC; a name is a file under `TZDIR` or
  `/usr/share/zoneinfo`, a leading `:` dropped, or a path; a POSIX
  rule, `EST5EDT,M3.2.0,M11.1.0`, where no file has the name; and UTC
  for anything broken.
- TZif (RFC 8536) of every version, and the rule at the end of a file
  from version 2, for the years after its table: a slim file, which
  zic writes by default, is as good as a fat one.
- Read once, then each answer is a search of the table.
- Tested against glibc's `localtime_r` in 25 zones and ways of naming
  one, some 30,000 instants each: every change of the clock from 1800
  to 2600 and the seconds either side of it, far years where only the
  rule answers, and the edges of 32-bit time.

A program finds rzone as a sibling checkout, `../rzone`, as it finds
rnet and rjson, and builds with its own raz:

    RZONE ?= ../rzone
    $ raz -I $(RZONE)/src -o build/prog src/Prog.raz

Or `make install` puts the modules in `~/.raz/lib` (`RAZ_PATH`), and a program imports them with no `-I`.

and asks:

    tm := Zone.local(Sys.now() div 1000000000);
    Fmt.print("{}:{} {}\n", [Fmt.int(tm.hour), Fmt.int(tm.minute), Fmt.str(tm.abbr)]);
    off, abbr := Zone.offset(t);           (* seconds east of UTC, and BST *)
    today := Zone.days(tm.year, tm.month, tm.day);
    y, m, d := Zone.date(today + 7);

`doc/rzone.3` describes every procedure, and where rzone and glibc
part; `PLAN.md` says which programs in `~/r` could take it, and what
each would drop.

    $ make check            # the module's test, and glibc against it (needs cc and zic)
    $ make install          # rzone.3 into ~/.local/share/man/man3

Defect reports are welcome; [CONTRIBUTING.md](CONTRIBUTING.md) says how.

rzone is under the ISC licence, in `LICENSE`.
