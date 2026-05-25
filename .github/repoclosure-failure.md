---
title: "Repoclosure failing on Fedora {{ env.FEDORA }}"
labels: repoclosure, automated
---
The daily `repoclosure` workflow failed on Fedora {{ env.FEDORA }}.

- Run: {{ env.RUN_URL }}
- Triggered: {{ date }}

Likely cause: Fedora pushed a soname bump or mass rebuild that one or more COPR packages link against. Trigger `Mass rebuild` workflow (or wait for next Sunday cron) to pick up the new ABI.

This issue auto-updates on subsequent failures and should be closed manually once the rebuild lands and the workflow goes green.
