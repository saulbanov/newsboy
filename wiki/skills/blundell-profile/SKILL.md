---
name: blundell-profile
description: "Plan or evaluate a profile story using Blundell's profile-specific method: choosing between general, microcosm, collective, and roundup approaches; vetting the subject; writing the facet-based theme statement; and applying the profile variant of the six-part guide. Invoke on: 'I want to profile someone', 'help me plan a profile', 'is this the right subject', 'should this be a profile or a roundup', 'my profile isn't working', 'my profile is too talky', 'this profile is boring'. Do NOT invoke for development stories — use blundell-cause-effect-map or blundell-six-part-guide."
allow_implicit_invocation: false
---

# Blundell Profile

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). Profiles are treacherous. Because they seem narrow by nature, reporters launch into them without adequate forethought and wade into swamps of complexity they didn't anticipate. The profile method exists to prevent this.

## When to use

- Planning a profile and choosing an approach
- Vetting a profile subject before committing to report it
- Writing a profile theme statement (facets, not action chain)
- Diagnosing a profile draft that is talky, unfocused, or boring

## When not to use

- The story is about a development, not a subject → use `blundell-cause-effect-map` or `blundell-six-part-guide`
- The theme statement already exists and the question is structure → use `blundell-narrative-lines`
- The question is specifically the lead → use `blundell-leads`

## First move

Establish which approach the reporter is considering or has defaulted to. Often reporters choose profile reflexively (it's easier to spend three days with one person than to build a roundup). Confirm the approach is right for the development before investing in the subject. See `references/profile-vs-roundup.md`.

Then establish which type of profile: general (subject chosen for its differentness) or microcosm (subject chosen for its typicality). This determines everything about what to look for in reporting. See `references/general-vs-microcosm.md`.

## Non-negotiables

- A profile theme statement names two or three facets, not an action chain. "The life and work of a real cowboy in an age of cowboy hype." Everything in the story must illuminate at least one named facet. Material that doesn't is cut. See `references/profile-theme-statement.md`.
- Subject vetting is half the work. For microcosm profiles especially, the subject must actually represent what the reporter needs it to represent. The lizard-boot farmer failure: a reporter flies to Kansas to find a suffering farmer, arrives at a pillared mansion with a Mercedes and a Cessna in the drive. The story doesn't exist.
- The collective profile as a hedge: instead of betting on one subject, use a town, a small institution, or a community. More reporting room; less catastrophic failure risk.
- The windy bore trap: a charming, garrulous subject who is fascinating in person becomes a talky bore in print without action discipline. See `references/windy-bore.md`.
- Profiles use a different variant of the six-part guide: Qualities replaces Scope; Values/Standards replaces Reasons. The full question set is in `references/general-vs-microcosm.md` and `blundell-six-part-guide`.

## Output format

A profile plan with four components:
1. **Approach choice** — general/microcosm/collective/roundup with rationale
2. **Subject vetting** — what makes this subject right (or what needs to be confirmed before committing)
3. **Facet-based theme statement** — two or three facets in one sentence
4. **Weighted six-part emphasis** — which categories matter most for this specific profile, with key questions for each

## Reference map

- `references/general-vs-microcosm.md` — the distinction, subject selection criteria, vetting questions
- `references/profile-vs-roundup.md` — when profile is right, when roundup is right, the collective as a hedge
- `references/profile-theme-statement.md` — how to write a facet-based theme statement and use it as a filter
- `references/windy-bore.md` — the action discipline problem and how the guide corrects for it
