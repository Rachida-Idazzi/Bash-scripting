<div align="center">

<h1>
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=32&pause=1000&color=0B5ED7&center=true&vCenter=true&width=700&lines=%F0%9F%A7%A0+Bash+Concepts+Quiz;Arrays+%7C+IFS+%7C+Subshells+%7C+shift;Think+first.+Toggle+to+reveal." alt="Animated header" />
</h1>

<p><b>Three short quizzes. No coding required. Click a question to reveal the answer.</b></p>

</div>

---

<div align="center">

### 🧠 Quiz 1 — Arrays, `declare`, Associative Arrays

*Indexed arrays, associative arrays, quoting rules, and `declare` options.*

</div>

<details>
<summary><b>1.</b> Given <code>arr=("a" "b c" "d")</code>, what does <code>"${arr[@]}"</code> expand to? How many arguments?</summary>

<span style="color:#0b5ed7">Three separate arguments: `a`, `b c`, `d`. The quotes preserve each element as one word, even with spaces.</span>
</details>

<details>
<summary><b>2.</b> Same array. What does <code>"${arr[*]}"</code> expand to? How many arguments?</summary>

<span style="color:#0b5ed7">One argument: `a b c d`. `"${arr[*]}"` joins all elements with the first char of `IFS` (default: space).</span>
</details>

<details>
<summary><b>3.</b> What does <code>${#arr[@]}</code> return?</summary>

<span style="color:#0b5ed7">The number of elements in the array (here: `3`). Not the length of any single element.</span>
</details>

<details>
<summary><b>4.</b> What does <code>${!arr[@]}</code> return?</summary>

<span style="color:#0b5ed7">The list of **indices** (for indexed arrays) or **keys** (for associative arrays). Here: `0 1 2`.</span>
</details>

<details>
<summary><b>5.</b> How do you add <code>"new"</code> to the end of <code>arr</code>?</summary>

<span style="color:#0b5ed7">`arr+=("new")`. The parentheses + quotes keep it as a single element even if it contains spaces.</span>
</details>

<details>
<summary><b>6.</b> How do you copy <code>arr</code> to <code>copy</code> safely? Why do quotes matter?</summary>

<span style="color:#0b5ed7">`copy=("${arr[@]}")`. Without quotes, elements with spaces get split into multiple elements.</span>
</details>

<details>
<summary><b>7.</b> What is a sparse array? Give an example.</summary>

<span style="color:#0b5ed7">An indexed array with gaps in the indices. E.g. `a[0]=x; a[5]=y` — indices 1–4 are unset. `${#a[@]}` is 2, not 6.</span>
</details>

<details>
<summary><b>8.</b> What does <code>declare -A map</code> do? Why is it required for associative arrays?</summary>

<span style="color:#0b5ed7">Declares `map` as an associative (string-keyed) array. Without `-A`, Bash treats it as an indexed array and silently coerces string keys to `0`.</span>
</details>

<details>
<summary><b>9.</b> Given <code>declare -A users; users[alice]=admin; users[bob]=user</code>, how do you iterate over <b>keys</b>? Over <b>values</b>?</summary>

<span style="color:#0b5ed7">Keys: `for k in "${!users[@]}"`. Values: `for v in "${users[@]}"`. Both need quotes to preserve spaces.</span>
</details>

<details>
<summary><b>10.</b> What does <code>${users[alice]}</code> return?</summary>

<span style="color:#0b5ed7">The value for key `alice`, i.e. `admin`. An unset key returns empty (silently, unless `set -u`).</span>
</details>

<details>
<summary><b>11.</b> Why is <code>declare -i x=5+3</code> different from <code>x=5+3</code>?</summary>

<span style="color:#0b5ed7">`declare -i` marks `x` as an integer, so `5+3` is evaluated → `8`. Plain `x=5+3` stores the literal string `"5+3"`.</span>
</details>

<details>
<summary><b>12.</b> True or false: in Bash, indexed arrays start at index 1.</summary>

<span style="color:#0b5ed7">False. Indexed arrays start at `0`. `${arr[0]}` is the first element.</span>
</details>

<br>

---

<div align="center">

### 🔀 Quiz 2 — IFS, Subshells, Command Substitution, Here Strings, Pipelines

*Word splitting, execution environments, and how output flows between commands.*

</div>

<details>
<summary><b>1.</b> What does <code>IFS</code> stand for? What does it control?</summary>

<span style="color:#0b5ed7">Internal Field Separator. It controls how `read`, unquoted expansions, and `for` split strings into words. Default: space, tab, newline.</span>
</details>

<details>
<summary><b>2.</b> Why is <code>IFS=, read -r a b c <<< "x,y,z"</code> useful?</summary>

<span style="color:#0b5ed7">Splits the input on commas instead of whitespace, so `a=x`, `b=y`, `c=z`. Common for parsing CSV-ish data.</span>
</details>

<details>
<summary><b>3.</b> What's the difference between <code>( cmd )</code> and <code>{ cmd; }</code>?</summary>

<span style="color:#0b5ed7">`( cmd )` runs in a **subshell** (vars lost afterwards). `{ cmd; }` runs in the **current shell** (vars persist). Note the mandatory space and `;` in `{ ...; }`.</span>
</details>

<details>
<summary><b>4.</b> If you set <code>x=10</code> inside a subshell, does <code>x</code> change in the parent? Why?</summary>

<span style="color:#0b5ed7">No. The subshell is a forked copy; changes to variables don't propagate back to the parent.</span>
</details>

<details>
<summary><b>5.</b> What does <code>result=$(date)</code> do? What type is <code>result</code>?</summary>

<span style="color:#0b5ed7">Runs `date` in a subshell and captures its stdout into `result`. `result` is always a **string** — never an array or number.</span>
</details>

<details>
<summary><b>6.</b> Which is preferred: <code>`cmd`</code> or <code>$(cmd)</code>? Why?</summary>

<span style="color:#0b5ed7">`$(cmd)`. Backticks don't nest cleanly, and inside them backslashes behave inconsistently. `$()` nests and quotes predictably.</span>
</details>

<details>
<summary><b>7.</b> What does <code>read name <<< "Alice"</code> do?</summary>

<span style="color:#0b5ed7">Feeds the string `Alice` as stdin to `read`, which assigns it to `name`. The `<<<` is a "here string."</span>
</details>

<details>
<summary><b>8.</b> What is <code><(cmd)</code> called? How is it different from <code>cmd | ...</code>?</summary>

<span style="color:#0b5ed7">Process substitution. It exposes `cmd`'s output as a file path (e.g. `/dev/fd/63`), so it can be passed as an argument. A pipe streams output to another command's stdin.</span>
</details>

<details>
<summary><b>9.</b> In <code>printf 'a\nb\n' | while read -r x; do ((n++)); done</code>, why is <code>n</code> unchanged after the loop?</summary>

<span style="color:#0b5ed7">The `while` runs in a subshell (right side of the pipe), so `n` increments in a copy that's discarded when the loop exits.</span>
</details>

<details>
<summary><b>10.</b> What is the fix from question 9 so <code>n</code> <i>does</i> persist?</summary>

<span style="color:#0b5ed7">Use process substitution: `while read -r x; do ((n++)); done < <(printf 'a\nb\n')`. The loop then runs in the current shell.</span>
</details>

<details>
<summary><b>11.</b> When does <code>${ ...; }</code> (newer command substitution) help?</summary>

<span style="color:#0b5ed7">When you need to run a block of commands and capture combined output — including trailing-newline preservation in some shells, and cleaner quoting vs `$( ... )`.</span>
</details>

<details>
<summary><b>12.</b> True or false: every pipeline stage runs in the current shell.</summary>

<span style="color:#0b5ed7">False. Every pipeline stage runs in a subshell by default (unless `lastpipe` is enabled). That's why side effects like variable increments can be lost.</span>
</details>

<br>

---

<div align="center">

### 🧩 Quiz 3 — `shift`, Subcommands, Dedup, `for item`, Gotchas

*Positional parameters, argument dispatch, set-like deduplication, and the classic traps.*

</div>

<details>
<summary><b>1.</b> Given <code>./s.sh a b c</code>, what is <code>$1</code> after <code>shift</code>? After <code>shift 2</code>?</summary>

<span style="color:#0b5ed7">After `shift`: `$1` is `b`. After another `shift 2` (total), `$1` is `c`. Each `shift n` drops `n` args from the front.</span>
</details>

<details>
<summary><b>2.</b> After <code>shift</code>, what does <code>"$@"</code> contain?</summary>

<span style="color:#0b5ed7">The remaining positional parameters — everything except the ones already shifted off. Quoting preserves each arg as a separate word.</span>
</details>

<details>
<summary><b>3.</b> What is <code>$#</code> after <code>shift 2</code> in the above example?</summary>

<span style="color:#0b5ed7">`1`. Started with 3 args, dropped 2, one remains (`c`).</span>
</details>

<details>
<summary><b>4.</b> What's the idiomatic construct for handling subcommands like <code>start</code>/<code>stop</code>/<code>status</code>?</summary>

<span style="color:#0b5ed7">`case "$1" in start) ... ;; stop) ... ;; esac`, often after `shift` so the rest of `$@` is the subcommand's args.</span>
</details>

<details>
<summary><b>5.</b> What variable do you inspect to determine the subcommand?</summary>

<span style="color:#0b5ed7">Usually `$1`. Idiom: `cmd="$1"; shift` so `$@` afterwards is the payload.</span>
</details>

<details>
<summary><b>6.</b> How would you use an associative array to deduplicate a list of words?</summary>

<span style="color:#0b5ed7">`declare -A seen; for w in "$@"; do [[ -n "${seen[$w]:-}" ]] && continue; seen[$w]=1; echo "$w"; done`. Keys act as a set.</span>
</details>

<details>
<summary><b>7.</b> What does <code>for item; do ...; done</code> iterate over? (No <code>in</code> clause.)</summary>

<span style="color:#0b5ed7">The positional parameters `"$@"`. Equivalent to `for item in "$@"`. Handy inside functions that take args.</span>
</details>

<details>
<summary><b>8.</b> Which create a <b>separate</b> execution environment? (a) subshell (b) pipeline stage (c) command substitution (d) all of the above.</summary>

<span style="color:#0b5ed7">**(d) all of the above.** Subshells fork; pipeline stages are subshells; command substitution forks too. Variable changes don't escape any of them.</span>
</details>

<details>
<summary><b>9.</b> Why is <code>set -e</code> dangerous with <code>(( x++ ))</code> when <code>x</code> is 0?</summary>

<span style="color:#0b5ed7">`(( x++ ))` returns the **old** value as its exit status. When `x=0`, that's `0` → non-zero exit → `set -e` kills the script on the first increment.</span>
</details>

<details>
<summary><b>10.</b> What is the recommended alternative for arithmetic safety under <code>set -e</code>?</summary>

<span style="color:#0b5ed7">Use `(( x++ )) || true`, or `x=$(( x + 1 ))`, or drop `set -e` for that block. The `|| true` neutralizes the false failure.</span>
</details>

<details>
<summary><b>11.</b> If you run <code>FOO=bar; bash -c 'echo "$FOO"'</code>, what prints? Why?</summary>

<span style="color:#0b5ed7">A blank line (or nothing). The single quotes prevent the parent from expanding `$FOO`, and the child `bash` doesn't inherit non-exported variables. Use `export FOO=bar` to fix.</span>
</details>

<details>
<summary><b>12.</b> Difference between <code>$@</code> and <code>$*</code> when <b>quoted</b> vs <b>unquoted</b>?</summary>

<span style="color:#0b5ed7">Quoted: `"$@"` = one arg per parameter (correct); `"$*"` = one joined arg. Unquoted: both split on IFS and are best avoided — `"$@"` is the safe default.</span>
</details>

---

<div align="center">

*Come back, click a few, see what stuck.*

</div>
