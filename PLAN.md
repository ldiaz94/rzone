# rzone: the plan

raz's library says what time it is in UTC (`Sys.now`) and nothing of
where the machine is. Nine programs in `~/r` work local time out for
themselves (`~/r/RAZ-GAPS.md`, "No local time"): six read TZif, each
a little differently, and three call C's `localtime_r`. rzone is the
one they could share, seeded from the fullest of them, concha's
`Czone`, and made to read the zone as glibc does.

## What it is, and isn't

`Zone.local(t)` and `Zone.offset(t)` for an instant, `Zone.split` for
an instant at a fixed offset, and `Zone.days` and `Zone.date`, the
calendar the rest stands on, which most of the programs below carry
too. Nothing else, until a program needs it: no formatting (each
program writes dates its own way), no local time back to an instant,
no zone other than the one `TZ` names, no leap seconds.

## Steps

1. **Zone.** The module, its man page, and its test against glibc:
   25 zones and ways of naming one, every change of the clock from
   1800 to 2600 with its neighbours, far years by the footer rule, and
   32-bit time's edges. *Done.*
2. **The programs.** Each moves on its own commit, in its own
   repository, finding rzone as the sibling `../rzone`. *Done
   2026-10-19* for concha, sauce, razzle, notis, alba, cali, arno and
   rat; mosaico stays on libc's `strftime`.

## Which programs could move, and what each would drop

| Program | Now | With rzone | Drops |
|---|---|---|---|
| concha | `Czone` (523 lines), TZif and POSIX rules, used by `Cclock.format` | `Zone.local` in `Cclock` | `Czone` whole, and `Cclock`'s `civilDate` and `floorDiv`; gains `TZDIR`, `TZ` as a rule, `TZ=` as UTC, abbreviations not cut to 7 bytes |
| sauce | `Sbase`: `localTZ`, `posixOffset` and a TZif reader (some 130 lines); Hinnant's algorithms written out twice in `timeText` and `parseTime` | `Zone.offset` for `localTZ`; `Zone.split` and `Zone.days` | the reader and `posixOffset`, and the two calendars (about 160 lines in all); gains summer time in a `TZ` rule, which `posixOffset` ignores |
| razzle | `Rztime` (357 lines): TZif, rules, the calendar | `Zone.local`, its `Civil` becoming `Zone.Time` | `Rztime` whole |
| notis | `Ndates`, lines 229 to 357: `/etc/localtime` read by hand for `today` and `clock` | `Zone.local` | about 130 lines; gains `TZ`, and the footer rule. Its day numbers are rzone's (`dayOf`, `civil` and `weekDay` could be `Zone.days` and `Zone.date`), but its dates' text stays |
| cali | `Cdate`: `be`, `offsetIn`, `loadOffset` (about 80 lines), an offset fixed at start | `Zone.offset` at each instant | those, and `days`/`civil` if it likes; keeps `loadZone`, the zone's name for Google. Gains the footer rule, `TZ` as a rule, and the right offset across a change while it runs |
| alba | `Hora` (161 lines): TZif without the footer | `Zone.offset` | all of `Hora` but `unixNow`; gains slim files and `TZ` as a rule |
| arno | `localtime_r` and C's `struct tm`, for a conversation's id | `Zone.local` | the `extern` and `Tm` (about 15 lines); it keeps C for TLS |
| rat | `localtime_r` and `strftime`, for the log's time | `Zone.local` and a few digits written | the two `extern`s; it keeps C for X |
| mosaico | `localtime_r` and `strftime`, the clock's formats from `Mconfig` | only with a formatter of its own | little: `strftime` needs C's `struct tm`, and mosaico keeps C for X. Leave it |

concha's is the move that pays most, then razzle's and alba's, whose
modules go whole.
