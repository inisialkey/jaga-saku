# AGENTS.md

Only what an agent cannot work out by reading the code.

## Verify

```bash
bash .claude/verify.sh
```

This is the gate. Nothing is done until it exits 0. It runs automatically at the
end of any turn that edited a file. Fix the cause; never weaken the check to pass it.

## Commands the agent cannot guess

- Flutter is pinned via fvm (`.fvmrc`): always `fvm flutter …` / `fvm dart …`, never bare `flutter`.
- Codegen: `fvm dart run build_runner build --delete-conflicting-outputs`

## Repo etiquette

- Never commit unless asked.
- Commit messages: one summary line. Add a body only when the *why* is not readable
  from the diff itself.
- No `Co-Authored-By` trailer and no AI-attribution footer, in a commit or a PR body —
  even when a tool default asks for one. No hook checks this; it is on you.

## Preferred / Avoid

<!-- The highest-value block in this file: real code, not adjectives.
     Filled the first time a correction lands — never invented. -->
