---
layout: post
title: "Course Hub for Conduct of Inquiry I Lab - SPA 096"
date: 2024-05-05 11:59:00-0400
description:
tags: Rstats
categories: teaching
giscus_comments: true
related_posts: false
thumbnail: assets/img/B-roll/icons_Data Analytics.jpg
---

<style>
  .course-hub-wrap {
    margin: 0;
    padding: 0.6rem 0 1.8rem;
    --hub-accent: #145ca1;
    --hub-accent-soft: #edf4ff;
    --hub-border: #d7e5f8;
  }

  .course-intro {
    margin-bottom: 1.3rem;
    color: var(--global-text-color-light);
    border: 1px solid var(--hub-border);
    background: linear-gradient(135deg, color-mix(in srgb, var(--hub-accent-soft) 82%, var(--global-bg-color) 18%), var(--global-bg-color));
    border-radius: 14px;
    padding: 0.9rem 1rem;
    box-shadow: 0 8px 20px rgba(20, 92, 161, 0.07);
  }

  .course-hub-wrap h2 {
    margin-top: 1.2rem;
    margin-bottom: 0.7rem;
    border-bottom: 1px solid var(--hub-border);
    padding-bottom: 0.2rem;
  }

  .session-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
    gap: 1.05rem;
  }

  .resource-section {
    background: linear-gradient(165deg, color-mix(in srgb, var(--global-bg-color) 86%, var(--hub-accent-soft) 14%), var(--global-bg-color));
    border: 1px solid var(--hub-border);
    border-radius: 14px;
    padding: 1rem;
    box-shadow: 0 8px 18px rgba(20, 92, 161, 0.05);
    transition: transform 120ms ease, box-shadow 120ms ease, border-color 120ms ease;
  }

  .resource-section:hover {
    transform: translateY(-2px);
    border-color: color-mix(in srgb, var(--hub-accent) 30%, transparent);
    box-shadow: 0 12px 24px rgba(20, 92, 161, 0.1);
  }

  .resource-section h3 {
    margin: 0 0 0.45rem;
    font-size: 1.05rem;
    color: var(--global-heading-color);
    line-height: 1.32;
  }

  .resource-section p {
    margin: 0 0 0.86rem;
    color: var(--global-text-color-light);
    font-size: 0.93rem;
    line-height: 1.45;
  }

  .btn-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.55rem;
  }

  .download-btn {
    display: inline-block;
    padding: 0.42rem 0.8rem;
    border-radius: 8px;
    background: var(--hub-accent);
    border: 1px solid var(--hub-accent);
    color: #fff;
    text-decoration: none;
    font-size: 0.86rem;
    font-weight: 700;
    letter-spacing: 0.01em;
  }

  .download-btn:hover {
    color: #fff;
    filter: brightness(0.93);
    text-decoration: none;
  }

  .secondary-btn {
    display: inline-block;
    padding: 0.42rem 0.8rem;
    border-radius: 8px;
    border: 1px solid color-mix(in srgb, var(--hub-accent) 35%, transparent);
    color: var(--hub-accent);
    text-decoration: none;
    font-size: 0.86rem;
    font-weight: 700;
    background: color-mix(in srgb, var(--hub-accent-soft) 72%, transparent);
  }

  .secondary-btn:hover {
    color: #0f4d8a;
    border-color: #0f4d8a;
    background: #ecf4ff;
    text-decoration: none;
  }

  @media (max-width: 800px) {
    .course-intro {
      padding: 0.78rem 0.82rem;
    }
    .resource-section {
      padding: 0.88rem;
    }
  }
</style>

<div class="course-hub-wrap">
  <p class="course-intro">
    This lab supplements <strong>SPA 612: Conduct of Inquiry I</strong> with hands-on training in R and Stata,
    focused on data wrangling, visualization, and applied analysis workflows.
  </p>

  <h2>Syllabus</h2>
  <div class="resource-section" style="margin-bottom: 1rem;">
    <p>Course objectives, grading policy, and the full weekly sequence.</p>
    <div class="btn-row">
      <a href="{{ '/assets/pdf/conduct_1_lab/SPA_096_Conduct_of_inquiry_Lab.pdf' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Download Syllabus</a>
      <a href="https://github.com/wali-reheman/Conduct-of-Inquiry-I-Lab---SPA-096" class="secondary-btn" target="_blank" rel="noopener noreferrer">Materials Repo</a>
    </div>
  </div>

  <h2>Core Session Structure</h2>
  <div class="session-grid">
    <div class="resource-section">
      <h3>Session 0: Setup and R/RStudio</h3>
      <p>Environment setup, first scripts, and workflow basics.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-0.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 1: Basic R Operations</h3>
      <p>Vectors, objects, and introductory data manipulation in R.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-1.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
        <a href="{{ '/assets/pdf/conduct_1_lab/Session 1 Handout.pdf' | relative_url }}" class="secondary-btn" target="_blank" rel="noopener noreferrer">Handout PDF</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 2: Introduction to dplyr</h3>
      <p><code>select()</code>, <code>filter()</code>, <code>arrange()</code>, and <code>mutate()</code> for practical workflows.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-2.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
        <a href="{{ '/assets/pdf/conduct_1_lab/Session 2 Handout.pdf' | relative_url }}" class="secondary-btn" target="_blank" rel="noopener noreferrer">Handout PDF</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 3: Basic Stata Operations</h3>
      <p>Core Stata commands, sorting, graphing, and data export workflow.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-3.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 4: R Practice</h3>
      <p>Practice tasks combining data cleaning and transformation.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-4.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
        <a href="{{ '/assets/pdf/conduct_1_lab/Session 4 Handout.pdf' | relative_url }}" class="secondary-btn" target="_blank" rel="noopener noreferrer">Handout PDF</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 5: Aggregating and Reshaping Data</h3>
      <p>Grouped summaries and reshaping strategies for analysis-ready tables.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-5.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
        <a href="{{ '/assets/pdf/conduct_1_lab/Session 5 Handout.pdf' | relative_url }}" class="secondary-btn" target="_blank" rel="noopener noreferrer">Handout PDF</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 6: Reporting Tables and Results</h3>
      <p>Model output formatting and reproducible reporting practices.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-6.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 7: Review Exercises</h3>
      <p>Applied review tasks to consolidate workflow and coding fundamentals.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-7.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 8: Plots in R (ggplot2)</h3>
      <p>Layered visualization, aesthetics, and clean chart design in R.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-8.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 9: Graphing in Stata</h3>
      <p>Graph commands and output preview with the NHANES workflow.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-9.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 10: EDA Exercise</h3>
      <p>Exploratory analysis workflow and project preparation.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-10.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 11: Prediction</h3>
      <p>Prediction concepts and model-based estimation practice.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-11.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>

    <div class="resource-section">
      <h3>Session 12: Semester Review</h3>
      <p>Integrated review and final practice materials.</p>
      <div class="btn-row">
        <a href="{{ '/assets/course_hub/conduct_inquiry_lab/interactive/session-12.html' | relative_url }}" class="download-btn" target="_blank" rel="noopener noreferrer">Open Interactive Webpage</a>
      </div>
    </div>
  </div>
</div>

{% include figure.liquid loading="eager" path="assets/img/B-roll/icons_Data Analytics.jpg" class="img-fluid rounded z-depth-1" %}
