---
name: emacs-maintenance
description: Maintain and improve a modular Emacs configuration without breaking startup, silently changing workflow-critical behavior, or drifting from the user's conventions.
---

# Emacs Maintenance Skill

You are maintaining a real, heavily used Emacs configuration. Prioritize reliability, reversibility, maintainability, and consistency over cleverness or large refactors. Startup failures are highly disruptive.

Larger or riskier changes must be confirmed with the user and recorded in `plan.org`. 

## Core rules

1. **Do not break startup**
   - Treat startup safety as a hard constraint. 
   - Suggest edits that could break startup but do not automatically apply them. Use `plan.org` (see below). 
   - Prefer small, guarded changes over broad rewrites.
   - After edits, validate syntax, loading, and obvious dependency or load-order issues.

2. **Use `plan.org` as the maintenance ledger**
   - Read `plan.org` at the start if it exists; create it if it does not.
   - Update it at the end with:
     - newly discovered issues
     - suggested improvements
     - risky or brittle areas worth revisiting
   - Remove completed items.
   - Put useful but risky or deferred ideas in `plan.org` instead of applying them automatically. 

3. **Be conservative with user-facing behavior**
   - Do not silently change workflow-critical behavior.
   - Do not automatically change keybindings unless explicitly asked.
   - You may suggest more maintainable keybinding schemes, but proposals belong in `plan.org` unless requested.

4. **Prefer maintainability**
   - Prefer established Emacs patterns, including `use-package`, when they improve clarity or reliability.
   - Prefer public APIs over internal package functions.
   - Reduce brittleness to upstream changes.
   - Reduce unnecessary dependencies when reasonable, but only replace them with local code if the replacement is stable, easy to maintain, and does not add significant complexity or bloat. 

5. **Respect the user's module structure**
   - High-level entry points are files like `email.el`, `ai.el`, and `completing-read.el`.
   - One-off helpers may belong in `*-autoloads.el`.
   - Cohesive custom functionality should live in dedicated modules like `email-foo.el`.
   - Larger subsystems may live in subdirectories like `email-foo/`.
   - Supporting files should normally be loaded from the parent module, not directly from `init.el`.
   - New code should fit this structure rather than bypass it. 

## Maintenance areas

### 1. Backend and maintainability
Look for:

- missing guards around executables, optional packages, and external tools
- repeated defensive patterns that should be unified
- brittle cross-module coupling
- use of unstable, internal, or undocumented package interfaces
- opportunities to simplify configuration using existing tools or patterns
- low-value dependencies that could reasonably become local helpers
- edge cases involving OS assumptions, missing tools, load order, or optional features
- startup or early-load issues affecting critical workflow features, especially leader keys and Org access

When external tools or optional dependencies are unavailable, the config should degrade gracefully with an informative message rather than fail at startup. 

### 2. Documentation
Document enough for the user to maintain the config by hand.

Document:

- non-trivial options that meaningfully affect behavior
- settings the user may want to revert later
- why a workaround, compatibility shim, or fork-specific patch exists
- how to restore prior behavior when practical

Do not over-document obvious code, trivial assignments, or things the user explicitly wanted removed. Use judgment. 

### 3. Front-end, UI, and consistency
Look for consistency across similar contexts while respecting mode-specific constraints.

Pay particular attention to:

- consistent REPL-related behavior across R, Python, shell, C++, and similar modes
- Evil ergonomics, especially in awkward special modes like Ediff
- consistency across reading interfaces such as Mu4e and Elfeed
- consistency across Org interfaces where practical, without breaking agenda-specific behavior
- custom keybinding schemes that create maintenance burden or depend too heavily on upstream command details

Do not automatically rewrite keybindings, but do flag fragile patterns and suggest more maintainable alternatives in `plan.org`. 

## Forks and upstream maintenance

The user maintains some package forks.

- Prefer removing unnecessary forks when upstream already supports the needed customization through hooks, overrides, or extension points.
- Preserve forks that contain meaningful local changes or patch unmaintained software.
- For explicitly maintained forks, check upstream when relevant and note useful fixes, API changes, or growing divergence.

Document why a fork exists when that is not obvious. 

## Edit workflow

Before changes:

1. Identify the relevant high-level module(s).
2. Read `plan.org` if present.
3. Prefer small, local edits.
4. Preserve module boundaries.
5. Avoid changing user-facing behavior unless explicitly asked.

After changes:

1. Validate syntax and loading where possible.
2. Check for missing requires, undefined symbols, and load-order issues.
3. Update `plan.org`.
4. Suggest a Conventional Commit message.

If a change is useful but risky, do not apply it automatically; record it in `plan.org`. 

## Commit style

Use Conventional Commit style with module scope when appropriate, for example:

- `feat(email): improve mu4e action consistency`
- `fix(ai): guard external tool lookup at startup`
- `refactor(org): isolate agenda helpers`
- `docs(completing-read): explain fallback behavior`
- `chore(forks): reduce evil-collection divergence`

Prefer commits that are scoped, understandable later, and limited to one conceptual change. 

## Default behavior

Prefer:

- graceful degradation over hard failure
- public APIs over internals
- isolated compatibility shims over scattered brittle code
- local modules over tiny low-value dependencies
- consistency across similar modes
- comments that explain why
- small, reversible refactors

Avoid:

- startup-risky rewrites
- silent keybinding churn
- unnecessary cross-module coupling
- over-documentation
- maintaining forks when supported extension points would suffice
- complexity added only for style

This is a working personal system, not a demo config. Improve it in ways that make it safer to load, easier to understand, and easier to maintain over time. 
