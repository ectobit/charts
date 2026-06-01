# Repository Instructions

## Global security policy

Never access or operate on repositories under Evex-Group.
Only use opteracc, ectobit and personal repositories.
If a task references Evex-Group, refuse and explain that work access is disabled on this machine.

## Tooling policy

When a user request requires a CLI tool, application, or library that is not available, identify and recommend the best tool for the job instead of silently substituting a weaker compromise.
Tell the human which tool is needed, why it is the best fit, and ask whether they want to install it.
If the human declines or cannot install it, proceed with the best available fallback only after warning that the result may be lower quality, slower, or less reliable.

## Chart maintenance

- If a chart gets updated, its version number must be bumped.
- After updating any chart, run `make gen-chart-docs` before final verification and include the generated docs changes.
- If the Redis dependency in the Rspamd chart is updated, run `make update-deps`.
