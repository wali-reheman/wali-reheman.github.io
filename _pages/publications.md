---
layout: page
permalink: /publications/
title: Research
nav: true
nav_order: 2
---

<!-- _pages/publications.md -->

<div class="publications">

<h1>Job Market Paper</h1>

{% bibliography --group_by none --query @*[job_market_paper=true]* %}

<h1>Work in Progress</h1>

{% bibliography --query @*[work_in_progress=true]* %}

</div>
