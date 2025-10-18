# Epic Context Validation Checklist

- [ ] Lock file removed after workflow completes
- [ ] XML written to `{story_dir}/epic-context-{{epic_id}}.xml`
- [ ] Markdown summary written to `{story_dir}/epic-context-{{epic_id}}.md`
- [ ] All required source docs listed in doc index with sha256 + mtime
- [ ] Constraints section populated (no placeholder text)
- [ ] Story coverage includes every Epic {{epic_id}} story with correct consulted flag
- [ ] Tests section lists standards, locations, and at least one shared idea
- [ ] Dependencies include runtime + test packages (if available)
- [ ] Code baseline references only project-relative paths
- [ ] Output summary displayed to user
