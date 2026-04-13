---
name: r-package-methods-check
description: Review R package method changes for statistical correctness, numerical robustness, API stability, tests, and docs.
disable-model-invocation: true
---

Review the changed R package code with emphasis on **methodological correctness**, not style.

Use this for method changes, bug fixes that may affect inference, numerical refactors, API changes, or pre-PR review of an R package.

Focus on these questions:

1. Statistical correctness
- Are the assumptions in the code consistent with the stated method?
- Are parameterizations clear and internally consistent?
- Are transformations, offsets, scales, and links handled correctly?
- Are quantities on the correct scale when returned, printed, or plotted?
- Are defaults scientifically reasonable?
- Are estimated quantities distinguishable from inputs, hyperparameters, and diagnostics?
- Are uncertainty-related quantities labeled clearly and computed on the intended scale?
- Are implicit assumptions hidden in preprocessing, normalization, filtering, or pseudocounts?

2. Numerical stability and edge-case handling
- unstable subtraction, division, exponentiation, or log operations
- underflow/overflow risk
- division by zero or near-zero quantities
- unguarded `log`, `exp`, `softmax`, or likelihood calculations
- singular or near-singular matrix operations
- poor behavior for very small sample sizes
- problems induced by extreme counts, sparsity, or heavy skew
- failure to handle ties, all-zero rows, empty groups, or one-level factors
- silent recycling, coercion, or factor conversion issues
- missing handling for `NA`, `NaN`, `Inf`, `-Inf`

3. Package behavior
- Are exported vs internal functions appropriate?
- Are function names, arguments, and defaults coherent?
- Are argument checks informative and early?
- Are return values stable and documented?
- Is backward compatibility preserved where reasonable?
- Are S3/S4 methods registered correctly if relevant?
- Are dependencies necessary and minimal?
- Are examples safe, fast, and reproducible?

4. Tests
- Propose the **smallest** regression and edge-case tests that would catch real breakage.
- Prefer one minimal regression test over broad test-suite rewrites unless clearly needed.

5. Documentation
- Flag roxygen, examples, README, vignettes, and NEWS items that no longer match behavior.

Return exactly these sections:

## Summary
2-4 sentences on what changed and the main risk.

## Major issues
For each issue, give:
- Issue
- Why it matters
- Smallest fix

## Suggested tests
List the minimal tests to add or update.

## Documentation updates
List docs or examples that should be updated.

## Nice-to-have improvements
Optional cleanup that is not required for correctness.

Behavior:
- Be skeptical about scientific correctness, not just syntax.
- Prefer the smallest correct patch.
- Distinguish correctness issues from maintainability issues.
- If uncertain, say exactly what is uncertain.
- Review first; do not start editing unless explicitly asked.
