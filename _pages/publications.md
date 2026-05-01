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
  <section class="research-block">
    <h3>Research Interests</h3>
    <div class="interest-chips">
      <span>Religion and Politics</span>
      <span>Ethnic Identity</span>
      <span>Public Opinion</span>
      <span>Political Behavior</span>
      <span>Secularization</span>
    </div>
  </section>

  <h2>Job Market Paper</h2>

  {% bibliography --group_by none --query @*[job_market_paper=true]* %}

  <h2>Work in Progress</h2>

  {% bibliography --query @*[work_in_progress=true]* %}
</div>
