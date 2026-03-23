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
  <p class="page-lead">
    My research examines religion and politics, ethnic identity, political socialization, and public opinion.
    For the latest job market paper draft or related questions, please
    <a href="mailto:rw8143a@american.edu">reach out by email</a>.
  </p>

  <div class="page-actions">
    <a href="{{ '/research/state-vs-faith/' | relative_url }}" class="btn btn-sm z-depth-0 pub-action" role="button">Project Summary</a>
    <a href="{{ '/cv/' | relative_url }}" class="btn btn-sm z-depth-0 pub-action" role="button">View CV</a>
  </div>

  <h2>Job Market Paper</h2>

  {% bibliography --group_by none --query @*[job_market_paper=true]* %}

  <h2>Work in Progress</h2>

  {% bibliography --query @*[work_in_progress=true]* %}
</div>
