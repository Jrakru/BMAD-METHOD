#!/usr/bin/env python3

"""
Toy story player generator.
Scans model files for `story` blocks and emits dist/story_player.html with a minimal UI.
This does not render diagrams—just creates a clickable step list with anchors you can wire to your renderer later.
"""

import re, os, pathlib, html

ROOT = pathlib.Path(__file__).resolve().parents[1]
MODEL_DIR = ROOT / "likec4" / "model"
DIST = ROOT / "dist"
DIST.mkdir(exist_ok=True)

def parse_stories(text):
    stories = []
    # crude parsing: story id 'Title' { ... }
    for m in re.finditer(r"story\s+([A-Za-z0-9_]+)\s+'([^']*)'\s*{([\s\S]*?)\n}\n", text):
        sid, title, body = m.group(1), m.group(2), m.group(3)
        steps = []
        for sm in re.finditer(r"step\s+([A-Za-z0-9_]+)\s+'([^']*)'\s*{([^}]*)}", body):
            step_id, step_title, step_body = sm.group(1), sm.group(2), sm.group(3)
            hops = re.findall(r"hops\s+([A-Za-z0-9_.]+)", step_body)
            steps.append({"id": step_id, "title": step_title, "hops": hops})
        stories.append({"id": sid, "title": title, "steps": steps})
    return stories

def main():
    all_text = ""
    for p in MODEL_DIR.glob("*.c4"):
        all_text += p.read_text(encoding="utf-8") + "\n"
    stories = parse_stories(all_text)

    html_head = """<!doctype html><meta charset='utf-8'>
<title>1C4D5 Story Player</title>
<style>
body{font-family:system-ui,Segoe UI,Roboto,Helvetica,Arial,sans-serif;margin:24px;line-height:1.4}
.card{border:1px solid #ddd;border-radius:8px;padding:16px;margin:12px 0}
.story-title{font-weight:600;font-size:18px;margin-bottom:8px}
.step{padding:8px;border-left:4px solid #ccc;margin:8px 0}
.step.active{border-left-color:#000}
.controls button{margin-right:8px}
.hops{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;color:#555}
</style>
<script>
function play(id){
  document.querySelectorAll('.story').forEach(s=>s.style.display='none');
  document.getElementById('story-'+id).style.display='block';
}
function selectStep(storyId, idx){
  const steps = document.querySelectorAll('#story-'+storyId+' .step');
  steps.forEach((el,i)=>{ el.classList.toggle('active', i===idx); });
}
</script>
"""
    body = "<h1>1C4D5 Story Player</h1>\n"
    body += "<p>Select a story to preview the steps and referenced model tokens. Wire these to your renderer URLs later.</p>"

    # Story selector
    body += "<div class='card'><div class='story-title'>Stories</div>"
    for s in stories:
        body += f"<button onclick=\"play('{html.escape(s['id'])}')\">{html.escape(s['title'])}</button> "
    body += "</div>"

    # Story cards
    for s in stories:
        body += f"<div id='story-{html.escape(s['id'])}' class='card story' style='display:none'>"
        body += f"<div class='story-title'>{html.escape(s['title'])}</div>"
        body += "<div class='controls'>"
        body += "".join([f"<button onclick=\"selectStep('{html.escape(s['id'])}', {i})\">Step {i+1}</button>" for i,_ in enumerate(s['steps'])])
        body += "</div>"
        for i, st in enumerate(s["steps"]):
            hops = " ".join(f"<code>{html.escape(h)}</code>" for h in st["hops"])
            body += f"<div class='step'><div><strong>{i+1}. {html.escape(st['title'])}</strong></div><div class='hops'>{hops}</div></div>"
        body += "</div>"

    html_doc = html_head + body
    (DIST / "story_player.html").write_text(html_doc, encoding="utf-8")
    print("Wrote dist/story_player.html")

if __name__ == "__main__":
    main()
