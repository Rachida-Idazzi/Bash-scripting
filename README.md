# Bash Scripting Exercises

This is a hands-on collection of Bash scripts written as progressive exercises — from basic argument parsing up through backups, monitoring, and system reports. Each script is standalone, self-contained, and documented below with what it does, the commands it uses, caveats to watch out for, and a short note on where the pattern shows up in real DevOps work.

**What you'll find here:**

- **Ten small tools**, each solving one focused task (backup rotation, config parsing, disk alerts, directory monitoring, log searching, and more).
- **A command reference table** for each script — every external tool and Bash builtin it relies on, and why.
- **Caveats and gotchas** — the non-obvious things (`set -e` traps, `IFS`, process substitution, portability) that bite people in production.
- **DevOps context** — a one-line note per script on how the pattern is actually used (cron jobs, CI pipelines, incident triage, etc.).

It's aimed at anyone learning Bash who wants examples that go beyond `echo "Hello, world"` — and who wants to understand *why* each line is there, not just copy-paste it.

---

## `back-up.sh` — Backup with Rotation

**What it does:** Backs up a directory to a target location, keeping only the last 5 backups.

| Command | Purpose |
|---|---|
| `tar -czf archive.tar.gz source/` | Create a gzip-compressed tarball |
| `date +"%Y-%m-%d_%H-%M-%S"` | Generate a timestamp for the archive name |
| `ls -t` | List files newest-first by mtime |
| `sed '1,5d'` | Delete first 5 lines (protect the 5 newest) |
| `rm -f` | Delete the remaining (older) backups |
| `set -euo pipefail` | Fail fast on errors, unset vars, failed pipes |

**Caveats:**
- No space allowed after `+` in `date +"..."`.
- `tar` args must expand: `"$backup_dir/$backup_name"` and `"$source_dir"`, not literal strings.
- `ls -t | sed` assumes filenames are safe; names with newlines break it.
- `rm -f` after `cd` is destructive — verify `$backup_dir` first.

**DevOps use:** Nightly DB/config backups with automatic rotation so disk doesn't fill up — standard in cron and CI.

---

## `config-parser.sh` — KEY=VALUE Config Parser

**What it does:** Reads a `KEY=VALUE` file and prints each pair, skipping blanks and comments.

| Command | Purpose |
|---|---|
| `while IFS='=' read -r key value` | Split each line into key/value on first `=` |
| `[[ -z "$key" ]]` | Skip blank lines |
| `[[ "$key" =~ ^[[:space:]]*# ]]` | Skip comment lines |
| `>&2` | Send errors to stderr |
| `"${1:-}"` | Default an unset arg so `set -u` doesn't crash |

**Caveats:**
- Use `read -r`, not `read r` — the latter treats `r` as a variable name.
- Under `set -u`, default `$1` with `"${1:-}"` before checking it.
- `IFS='='` leaves trailing spaces on keys — trim if needed.

**DevOps use:** Parsing `.env` files, CI config, or app settings without a full YAML/JSON parser.

---

## `disk-usage.sh` — Disk Space Report

**What it does:** Checks a directory's size and warns if it exceeds a threshold.

| Command | Purpose |
|---|---|
| `du -ms "$dir"` | Total size of the folder in MB |
| `awk '{print $1}'` | Extract just the numeric size |
| `[ "$x" -gt "$y" ]` | Numeric comparison against threshold |
| `exit 0` / `exit 1` | Signal OK vs. alert (usable by cron/CI) |

**Caveats:**
- `du` walks every file — slow on large trees. Use `df` for partition fullness (instant).
- Under `set -u`, no args crashes — default with `"${1:-}"`.
- `du` and `df` answer *different questions* — pick the right one.

**DevOps use:** Cron-based disk alerts, pre-deploy space checks, log-rotation triggers.

---

## `interactive-menu.sh` — Menu of System Tasks

**What it does:** Shows a menu (disk space / uptime / users / quit) and runs the chosen task.

| Command | Purpose |
|---|---|
| `while true; do ... done` | Loop until user quits |
| `read -rp "prompt" choice` | Read user input with inline prompt |
| `case "$choice" in ... esac` | Dispatch on choice |
| `df -hT` | Disk space with filesystem type |
| `uptime` | System uptime and load average |
| `whoami` | Current user (WSL-safe fallback for `who`) |
| `break` | Exit the menu loop |

**Caveats:**
- `who`/`users` are empty on WSL (no utmp) — `whoami` is the fallback.
- If input is piped (non-interactive), `read` hits EOF and `set -e` kills the loop.
- State isn't persisted — it's a demo, not a tool.

**DevOps use:** Simple ops dashboards for on-call engineers, or scaffolding for interactive runbooks.

---

## `monitor-dir.sh` — Directory Change Monitor

**What it does:** Watches a directory for create/modify/delete events and logs each with a timestamp.

| Command | Purpose |
|---|---|
| `inotifywait -m` | Continuously monitor (don't exit on first event) |
| `-e create,delete,modify` | Watch only these event types |
| `--format '%T %e %w%f'` | Output: timestamp, event, full path |
| `--timefmt '%Y-%m-%d %H:%M:%S'` | Format used by `%T` |
| `while read -r line` | Process each streamed event |
| `>> change_log.txt` | Append to log |

**Caveats:**
- `inotifywait` requires `inotify-tools`; not on macOS (use `fswatch`).
- Inside the function, use `"$directory"`, not `$1` — `$1` breaks if the function is called differently.
- Log path is relative to CWD — use an absolute path or `"$directory/change_log.txt"`.
- `inotifywait` never exits; Ctrl-C stops it.

**DevOps use:** Real-time config-drift detection, trigger CI on file changes, audit trails on shared directories.

---

## `search-logs.sh` — Multi-File Log Searcher

**What it does:** Searches for a phrase across all `.log` files in a directory and lists matching files.

| Command | Purpose |
|---|---|
| `find "$dir" -type f -name "*.log"` | Find all regular `.log` files |
| `-exec grep -l "$phrase" {} +` | Print matching filenames in batches |
| `$(...)` | Capture command output into a variable |
| `[ -n "$matches" ]` | Check whether anything matched |

**Caveats:**
- Under `set -u`, no args crashes — default with `"${1:-}" "${2:-}"`.
- `grep -l` prints filenames only; use `-H` for `file:line` context.
- Split `local matches; matches=$(...)` when you care about exit codes — the `local` swallows them.

**DevOps use:** Incident triage — "which services logged this error?" across a fleet of log files.

---

## `sort-by-size.sh` — Sort .txt Files by Size

**What it does:** Finds all `.txt` files in a directory and lists them smallest → largest.

| Command | Purpose |
|---|---|
| `find "$dir" -type f -name "*.txt"` | Find all `.txt` files |
| `-exec ls -lh {} +` | Human-readable sizes in batches |
| `awk '{print $5, $9}'` | Extract size column and filename column |
| `sort -k 1,1h` | Sort by size with human-readable suffix (K/M/G) |
| `find -printf '%s %p\n' \| sort -n` | Robust alternative: raw bytes, numeric sort |

**Caveats:**
- `sort -k 1,1 -h` is ambiguous — correct form is `sort -k 1,1h` (attach `h` to key).
- Parsing `ls -l` breaks on filenames with spaces or symlinks. Prefer `find -printf` (GNU) or `stat -f '%z %N'` (macOS).
- Under `set -u`, no args crashes — use `"${1:-}"`.

**DevOps use:** Spotting log/config bloat, prioritizing cleanup, size-based retention decisions.

---

## `count-lines.sh` — Per-File Line Counter

**What it does:** Counts lines in each `.txt` file in a directory, printing `File : N`. Optional `v` arg prints a running total.

| Command | Purpose |
|---|---|
| `declare -A file_line_count` | Associative array: filename → line count |
| `while read -r file; done < <(find ...)` | Process substitution — loop runs in current shell |
| `IFS= read -r l \|\| [[ -n "$l" ]]` | Preserve whitespace; catch missing final newline |
| `((count++))` | Increment counter |
| `"${!file_line_count[@]}"` | Iterate over associative array keys |
| `((total += n))` | Accumulate running total (verbose mode) |

**Caveats:**
- `exit1` (no space) silently fails. Must be `exit 1`.
- `((count++))` returns non-zero on `0 → 1` — this is why `set -e` had to be dropped. Use `((count++)) || true` to keep `set -e`.
- `< <(find ...)` is required — piping into `while` runs it in a subshell and the array is lost.
- `"${!arr[@]}"` order is unspecified; pipe through `sort` for determinism.

**DevOps use:** Pre-commit checks, log-size sanity, verifying generated files aren't empty.

---

## `tool.sh` — Subcommand Toolbox

**What it does:** Dispatches on a subcommand (`greet`, `sum`, `reverse`, `help`, `q`) like a real Unix tool.

| Command | Purpose |
|---|---|
| `cmd="$1"; shift` | Grab subcommand; remaining args become `$@` |
| `for name in "$@"` | Loop over remaining args |
| `((total += n))` | Arithmetic accumulation |
| `arr=("$@")` | Capture args into an array |
| `for (( i=-1; i >= -"${#arr[@]}"; i-- ))` | Iterate array backwards |
| `cat << 'EOF' ... EOF` | Heredoc for help text (quoted = no expansion) |
| `case "$cmd" in ... esac` | Dispatch on subcommand |

**Caveats:**
- No `*)` fallback — unknown subcommands exit silently with 0. Add an error branch.
- `shift` with no args returns non-zero; use `shift || true` if adding `set -e`.
- Negative array indexing (`arr[-1]`) needs Bash 4.2+; not portable to macOS Bash 3.
- Usage text has typos (`./tool.sh 3 5 7` missing `sum`; `wnat`, `.tool.sh`).

**DevOps use:** The pattern behind `git`, `kubectl`, `docker` — wrapping related ops (`deploy`, `rollback`, `status`) under one CLI.

---

## Requirements

- Bash 4.0+ (4.2+ for `tool.sh` reverse indexing)
- Linux for `inotifywait` (`monitor-dir.sh`); macOS users: `fswatch`
- Standard tools: `find`, `grep`, `tar`, `awk`, `sed`, `du`, `df`, `inotify-tools`

## Usage

Each script is standalone:

```bash
chmod +x script.sh
./script.sh <args>
```

---

## Repo Layout

```
.
├── README.md
├── back-up.sh
├── config-parser.sh
├── disk-usage.sh
├── interactive-menu.sh
├── monitor-dir.sh
├── search-logs.sh
├── sort-by-size.sh
├── count-lines.sh
└── tool.sh
```
