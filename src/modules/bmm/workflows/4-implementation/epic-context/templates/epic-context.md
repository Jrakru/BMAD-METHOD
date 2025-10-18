# Epic {{epicId}} Context Summary

**Title:** {{epicTitle}}  
**Last Refreshed:** {{updatedAt}}  
**Sources Indexed:** {{sourceCount}}

---

## Story Coverage
{{#coverage}}
- [{{#consulted}}x{{/consulted}}{{^consulted}} {{/consulted}}] **{{story_id}}** — {{title}}{{#consulted_at}} _(consulted {{consulted_at}})_{{/consulted_at}}
{{/coverage}}

> _Run `workflow story-context` for any unchecked stories to generate a fresh implementation packet._

---

## Key Documents
{{#docs}}
- **{{section}}** — `{{path}}`  
  {{snippet}}
{{/docs}}

---

## Architectural & Delivery Constraints
{{#constraints}}
- {{.}}
{{/constraints}}

---

## Testing Standards
**Approach:** {{tests.standards}}

**Locations:** {{#tests.locations}}`{{.}}` {{/tests.locations}}

**Shared Ideas:**  
{{#tests.shared_ideas}}- {{.}}
{{/tests.shared_ideas}}

---

## Dependencies & Tooling
{{#dependencies}}
- **{{ecosystem}}**: {{#packages}}{{name}} ({{version}}) {{/packages}}
{{/dependencies}}

---

## Shared Code Touchpoints
{{#code_baseline}}
- `{{path}}` → **{{symbol}}** — {{reason}}
{{/code_baseline}}

---

_Generated for Epic {{epicId}} via `workflow epic-context`. Story-context will block if these sources become stale._
