---
layout: page
permalink: /code/
title: Code
nav: true
nav_order: 5
description: Selected teaching and research repositories hosted on GitHub.
---

<div class="code-page">
  <section class="code-section code-section--profile">
    <h2>GitHub Profile</h2>

    {% if site.data.repositories.github_users %}

    <div class="github-profile-grid">
      <div class="github-profile-grid__stats repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
        {% for user in site.data.repositories.github_users %}
          {% include repository/repo_user.liquid username=user %}
        {% endfor %}
      </div>

      {% if site.repo_trophies.enabled %}
      <div class="github-profile-grid__trophies repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
        {% for user in site.data.repositories.github_users %}
          {% include repository/repo_trophies.liquid username=user %}
        {% endfor %}
      </div>
      {% endif %}
    </div>

    {% endif %}

  </section>

  <section class="code-section code-section--repos">
    <h2>Selected Repositories</h2>

    {% if site.data.repositories.github_repos %}

    <div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
      {% for repo in site.data.repositories.github_repos %}
        {% include repository/repo.liquid repository=repo %}
      {% endfor %}
    </div>

    <script>
      // GitHub's stargazers page requires a login, so the Stars button links to the repo page and shows the live count.
      document.querySelectorAll(".repo-stars-link[data-repo]").forEach(function (link) {
        fetch(["https://api.github.com", "repos", link.dataset.repo].join("/"))
          .then(function (response) {
            return response.ok ? response.json() : null;
          })
          .then(function (repo) {
            if (repo && typeof repo.stargazers_count === "number") {
              var count = repo.stargazers_count;
              var label = count + (count === 1 ? " star" : " stars") + " on GitHub";
              link.textContent = "\u2605 " + count;
              link.setAttribute("aria-label", label);
              link.setAttribute("title", label);
            }
          })
          .catch(function () {});
      });
    </script>
    {% endif %}

  </section>
</div>
