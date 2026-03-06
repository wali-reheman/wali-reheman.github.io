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

<style>
  .research-preview .preview-note {
    margin-top: 0.5rem;
    margin-bottom: 1rem;
    padding: 0.8rem 1rem;
    border-left: 4px solid var(--global-theme-color);
    background: var(--global-code-bg-color);
  }
  .research-preview .preview-heading {
    margin-top: 1.4rem;
  }
  .research-preview .featured-grid {
    display: grid;
    gap: 0.9rem;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  }
  .research-preview .featured-card,
  .research-preview .mini-card {
    border: 1px solid var(--global-divider-color);
    border-radius: 12px;
    padding: 0.9rem;
    background: var(--global-card-bg-color);
  }
  .research-preview .featured-card h3 {
    font-size: 1.02rem;
    margin-top: 0.5rem;
    margin-bottom: 0.4rem;
  }
  .research-preview .featured-card p {
    margin-bottom: 0.55rem;
    color: var(--global-text-color-light);
  }
  .research-preview .badge {
    display: inline-block;
    border-radius: 999px;
    padding: 0.18rem 0.55rem;
    font-size: 0.7rem;
    color: #fff;
    font-weight: 700;
    text-transform: uppercase;
  }
  .research-preview .status-working {
    background: #245d9b;
  }
  .research-preview .card-links a {
    display: inline-block;
    margin-right: 0.35rem;
    margin-top: 0.2rem;
    padding: 0.12rem 0.45rem;
    border-radius: 999px;
    border: 1px solid var(--global-theme-color);
    font-size: 0.72rem;
    text-transform: uppercase;
  }
  .research-preview .filter-bar {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
    margin-bottom: 0.8rem;
  }
  .research-preview .filter-btn {
    border: 1px solid var(--global-divider-color);
    border-radius: 999px;
    background: var(--global-card-bg-color);
    color: var(--global-text-color);
    padding: 0.22rem 0.6rem;
    font-size: 0.74rem;
    text-transform: uppercase;
  }
  .research-preview .filter-btn.is-active {
    border-color: var(--global-theme-color);
    color: var(--global-theme-color);
    font-weight: 700;
  }
  .research-preview .mini-results {
    display: grid;
    gap: 0.7rem;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  }
  .research-preview .mini-card h4 {
    margin-bottom: 0.25rem;
    font-size: 0.96rem;
  }
  .research-preview .mini-card p {
    margin-bottom: 0;
    color: var(--global-text-color-light);
    font-size: 0.84rem;
  }
</style>

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
