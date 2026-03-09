---
layout: page
permalink: /research-preview/
title: Research Preview
description: Prototype of featured cards and filters for the research page.
nav: false
---

<div class="research-preview">
  <p class="preview-note">Prototype view for <strong>Featured Cards + Filters</strong>. This is a visual demo and does not replace your live Research page yet.</p>

  <h2 class="preview-heading">Featured Work</h2>
  <div class="featured-grid">
    <article class="featured-card">
      <span class="badge status-working">Working Paper</span>
      <h3>Seeking the American Dream: Immigrants' Belief in Meritocracy across Generations</h3>
      <p>How meritocratic beliefs shift across immigrant generations and what drives optimism or pessimism about opportunity.</p>
      <div class="card-links">
        <a href="/publications/#APSA2023">Details</a>
        <a href="/publications/">Research Page</a>
      </div>
    </article>
    <article class="featured-card">
      <span class="badge status-working">Working Paper</span>
      <h3>State vs. Faith: State-led Secularization and Political Islamism</h3>
      <p>Examines political backlash dynamics among Muslim populations under varying secularization regimes.</p>
      <div class="card-links">
        <a href="/publications/#MPSA2024">Details</a>
        <a href="/publications/">Research Page</a>
      </div>
    </article>
    <article class="featured-card">
      <span class="badge status-working">Working Paper</span>
      <h3>Ingroup Support for Ethnic Parties</h3>
      <p>Investigates institutional explanations of ethnic-party support using ecological Bayesian inference.</p>
      <div class="card-links">
        <a href="/publications/#MPSA2025">Details</a>
        <a href="/publications/">Research Page</a>
      </div>
    </article>
  </div>

  <h2 class="preview-heading">Filter Demo</h2>
  <div class="filter-bar" role="toolbar" aria-label="Research filters">
    <button class="filter-btn is-active" data-filter="all" type="button">All</button>
    <button class="filter-btn" data-filter="working" type="button">Working Paper</button>
    <button class="filter-btn" data-filter="rr" type="button">R&amp;R</button>
    <button class="filter-btn" data-filter="published" type="button">Published</button>
  </div>

  <div class="mini-results">
    <article class="mini-card" data-status="working">
      <h4>Seeking the American Dream</h4>
      <p>Status: Working Paper</p>
    </article>
    <article class="mini-card" data-status="working">
      <h4>State vs. Faith</h4>
      <p>Status: Working Paper</p>
    </article>
    <article class="mini-card" data-status="published">
      <h4>Example Published Piece (Mock)</h4>
      <p>Status: Published</p>
    </article>
    <article class="mini-card" data-status="rr">
      <h4>Example R&amp;R Piece (Mock)</h4>
      <p>Status: R&amp;R</p>
    </article>
  </div>
</div>

<script>
  (function () {
    const scope = document.querySelector(".research-preview");
    if (!scope) return;
    const buttons = scope.querySelectorAll(".filter-btn");
    const cards = scope.querySelectorAll(".mini-card");
    buttons.forEach((button) => {
      button.addEventListener("click", () => {
        const filter = button.getAttribute("data-filter");
        buttons.forEach((b) => b.classList.remove("is-active"));
        button.classList.add("is-active");
        cards.forEach((card) => {
          const status = card.getAttribute("data-status");
          card.style.display = filter === "all" || status === filter ? "" : "none";
        });
      });
    });
  })();
</script>
