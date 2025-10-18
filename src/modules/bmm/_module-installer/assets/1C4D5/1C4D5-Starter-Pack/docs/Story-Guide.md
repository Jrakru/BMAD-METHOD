# Story Guide (IcePanel-like flows in LikeC4)

**Stories** are overlays that narrate a journey across infra and data. They do not change the model—they reference it.

## Anatomy
```likec4
story checkout 'Checkout – happy path' {
  step s1 'Web → API' { hops web_app -> api_gateway }
  step s2 'Normalize' { hops dataflow.customer_ingest_v1.wanStandardize.NORMALIZE_NAMES }
  step s3 'Write silver' { hops product.silver_customers }
  s1 -[follows]-> s2; s2 -[follows]-> s3
}
```

- `hops` target real nodes/edges. Use fully qualified names for stages (`flow.group.STAGE`).
- Use `goto` to branch into other stories for alternates/failures.

## Authoring tips
- Keep ≤ 20 steps.
- Use consistent step verbs (Read, Validate, Transform, Write).
- When a step touches both infra and data, include **both** in `hops` (e.g., `containerA -> containerB` *and* `product.x`).

## Generating a player
Run: `python3 scripts/build_story_player.py` → `dist/story_player.html`.
- This toy player lists steps and links back to model files/anchors (adjust anchors to your renderer’s URLs).
