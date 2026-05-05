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
  <section class="owl-content-section">
    <h2>Job Market Paper</h2>

    {% bibliography --group_by none --query @*[job_market_paper=true]* %}
  </section>

  <section class="owl-content-section">
    <h2>Work in Progress</h2>

    {% bibliography --query @*[work_in_progress=true]* %}
  </section>
</div>
