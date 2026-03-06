---
layout: page
permalink: /teaching/
title: Teaching
nav: true
nav_order: 6
---

<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Source+Serif+4:opsz,wght@8..60,500;8..60,700&display=swap">

<div class="teaching-page">
  <section class="teaching-hero">
    <h2>Teaching</h2>
    <p>I teach courses that combine substantive political questions with practical research skills, with a focus on analytical rigor and reproducible workflows.</p>
  </section>

  <section class="teaching-block">
    <h3>Teaching Interests</h3>
    <div class="interest-chips">
      <span>Chinese Politics</span>
      <span>R for Social Science</span>
      <span>Social Science Research Design</span>
    </div>
  </section>

  <section class="teaching-block">
    <h3>Teaching Experience</h3>

    <article class="institution">
      <header>
        <h4 id="american-university">American University</h4>
      </header>
      <div class="course-card">
        <div class="course-top">
          <div>
            <h5>Conduct of Inquiry Lab</h5>
            <p class="term">Fall 2024; Fall 2025</p>
          </div>
          <div class="badges">
            <span class="role">Instructor of Record</span>
            <span class="code">SPA-096</span>
          </div>
        </div>
        <p class="course-note">Lab supplement for first-year methods training in R and Stata, including data wrangling, visualization, and introductory quantitative analysis.</p>
        <div class="course-links">
          <a href="{{ '/blog/2024/Teaching_Conduct_I_Lab/' | relative_url }}" target="_blank" rel="noopener noreferrer">Syllabus + Handouts</a>
          <a href="https://github.com/wali-reheman/Conduct-of-Inquiry-I-Lab---SPA-612" target="_blank" rel="noopener noreferrer">Interactive Tutorials</a>
        </div>
      </div>
    </article>

    <article class="institution">
      <header>
        <h4 id="columbia-university">Columbia University</h4>
      </header>
      <div class="course-card">
        <div class="course-top">
          <div>
            <h5>Chinese Politics</h5>
            <p class="term">Spring 2023; Spring 2024</p>
          </div>
          <div class="badges">
            <span class="role role-guest">Guest Lecturer</span>
            <span class="code">GU4471</span>
          </div>
        </div>
        <p class="course-note">Lecture 12: State and Society - Minority Policies in China.</p>
      </div>
    </article>
  </section>
</div>

<style>
  .teaching-page {
    font-family: "Manrope", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  }
  .teaching-page h2,
  .teaching-page h3,
  .teaching-page h4,
  .teaching-page h5 {
    border-bottom: none;
    font-family: "Source Serif 4", Georgia, serif;
  }
  .teaching-hero {
    border: 1px solid var(--global-divider-color);
    border-radius: 14px;
    padding: 1.1rem 1.15rem;
    background: linear-gradient(135deg, rgba(20, 92, 161, 0.12), transparent 55%);
    margin-bottom: 1.3rem;
  }
  .teaching-hero h2 {
    margin-bottom: 0.35rem;
  }
  .teaching-hero p {
    margin-bottom: 0;
    color: var(--global-text-color-light);
  }
  .teaching-block {
    margin-top: 1.2rem;
  }
  .interest-chips {
    display: flex;
    flex-wrap: wrap;
    gap: 0.45rem;
  }
  .interest-chips span {
    display: inline-block;
    border: 1px solid var(--global-theme-color);
    color: var(--global-theme-color);
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 700;
    letter-spacing: 0.02em;
    text-transform: uppercase;
    padding: 0.2rem 0.58rem;
  }
  .institution {
    margin-bottom: 1.2rem;
  }
  .institution h4 {
    margin-bottom: 0.45rem;
  }
  .course-card {
    border: 1px solid var(--global-divider-color);
    border-radius: 12px;
    padding: 0.95rem;
    background: var(--global-card-bg-color);
  }
  .course-top {
    display: flex;
    justify-content: space-between;
    gap: 0.7rem;
    align-items: flex-start;
    flex-wrap: wrap;
  }
  .course-top h5 {
    margin-bottom: 0.12rem;
    font-size: 1.1rem;
  }
  .term {
    margin-bottom: 0;
    color: var(--global-text-color-light);
    font-size: 0.88rem;
  }
  .badges {
    display: flex;
    gap: 0.35rem;
    align-items: center;
    flex-wrap: wrap;
  }
  .badges span {
    display: inline-block;
    border-radius: 999px;
    padding: 0.18rem 0.55rem;
    font-size: 0.7rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.03em;
  }
  .role {
    background: #145ca1;
    color: #fff;
  }
  .role-guest {
    background: #6f4a0f;
  }
  .code {
    border: 1px solid var(--global-divider-color);
    color: var(--global-text-color);
  }
  .course-note {
    margin-top: 0.58rem;
    margin-bottom: 0.58rem;
    color: var(--global-text-color-light);
  }
  .course-links {
    display: flex;
    flex-wrap: wrap;
    gap: 0.42rem;
  }
  .course-links a {
    display: inline-block;
    border: 1px solid var(--global-theme-color);
    border-radius: 999px;
    padding: 0.16rem 0.55rem;
    font-size: 0.76rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.03em;
    text-decoration: none;
  }
  .course-links a:hover {
    text-decoration: none;
    background: rgba(20, 92, 161, 0.12);
  }
</style>
