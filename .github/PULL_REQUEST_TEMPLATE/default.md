## Summary

<!-- What changed and why? -->



## Type of change

- [ ] Bug fix
- [ ] New feature (skill, schema, template addition)
- [ ] Documentation update
- [ ] Repository operational change (CI, scripts, infrastructure)
- [ ] Other (please describe)

## Sanitization checklist

<!-- All items must be checked before requesting review. -->

- [ ] No real LP names, fund names, or commitment amounts
- [ ] No real portfolio company names (anonymized if reference is unavoidable)
- [ ] No real founder names (anonymized as `[Founder]` or role placeholder)
- [ ] No real LtV team member full names beyond public website
- [ ] No specific portfolio metrics
- [ ] `python3 tools/oss_screening_scan.py --mode edit` returned clean

## Tier confirmation

I confirm this PR only contains **Tier 3 (publicly disclosable)** data per `AGENTS.md`.

## Testing

<!-- How did you verify the change works? -->



## Related issues / discussions

<!-- Link any related GitHub Issues or Discussions -->



---

For future-plan stash PRs, use the [future-plan template](?template=future-plan.md) instead.
