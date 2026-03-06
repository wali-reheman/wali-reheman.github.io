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
    padding: 0.5rem 0 1.5rem;
  }

  .course-intro {
    margin-bottom: 1.25rem;
    color: var(--global-text-color);
  }

  .session-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1rem;
  }

  .resource-section {
    background: color-mix(in srgb, var(--global-bg-color) 88%, var(--global-theme-color) 12%);
    border: 1px solid color-mix(in srgb, var(--global-theme-color) 24%, transparent);
    border-radius: 12px;
    padding: 1rem;
  }

  .resource-section h3 {
    margin: 0 0 0.5rem;
    font-size: 1.05rem;
    color: var(--global-heading-color);
  }

  .resource-section p {
    margin: 0 0 0.8rem;
    color: var(--global-text-color-light);
    font-size: 0.96rem;
  }

  .btn-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.55rem;
  }

  .download-btn {
    display: inline-block;
    padding: 0.42rem 0.75rem;
    border-radius: 8px;
    background: var(--global-theme-color);
    color: #fff;
    text-decoration: none;
    font-size: 0.86rem;
    font-weight: 600;
  }

  .download-btn:hover {
    color: #fff;
    filter: brightness(0.92);
  }

  .secondary-btn {
    display: inline-block;
    padding: 0.42rem 0.75rem;
    border-radius: 8px;
    border: 1px solid color-mix(in srgb, var(--global-theme-color) 30%, transparent);
    color: var(--global-theme-color);
    text-decoration: none;
    font-size: 0.86rem;
    font-weight: 600;
    background: transparent;
  }

  .secondary-btn:hover {
    color: var(--global-hover-color);
    border-color: var(--global-hover-color);
    text-decoration: none;
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
