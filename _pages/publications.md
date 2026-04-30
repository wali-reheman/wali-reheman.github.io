---
layout: page
permalink: /publications/
title: Research
nav: true
nav_order: 1
description: Job market paper and current working papers on religion and politics, ethnic identity, and public opinion.
---

<!-- _pages/publications.md -->

<div class="publications research-page">
  <div class="page-actions">
    <a href="mailto:rw8143a@american.edu" class="btn btn-sm z-depth-0 pub-action" role="button">Request Draft</a>
    <a href="{{ '/cv/' | relative_url }}" class="btn btn-sm z-depth-0 pub-action" role="button">View CV</a>
  </div>

  <h2>Job Market Paper</h2>

  {% bibliography --group_by none --query @*[job_market_paper=true]* %}

  <h2>Work in Progress</h2>

  {% bibliography --query @*[work_in_progress=true]* %}
</div>
