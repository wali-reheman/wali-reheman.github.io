#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(rmarkdown)
})

site_root <- normalizePath('.', winslash = '/', mustWork = TRUE)
course_root <- '/Users/wali/Documents/GitHub/Conduct-of-Inquiry-I-Lab---SPA-096'

tmp_root <- file.path(site_root, '.tmp', 'conduct_lab_interactive')
course_tmp <- file.path(tmp_root, 'course')
deck_root <- file.path(tmp_root, 'decks')
out_root <- file.path(site_root, 'assets/course_hub/conduct_inquiry_lab/interactive')
source_root <- file.path(site_root, 'assets/course_hub/conduct_inquiry_lab/source')
remark_file <- file.path(out_root, 'remark-latest.min.js')

if (!dir.exists(course_root)) {
  stop('Course source repo not found at: ', course_root)
}

# Fresh sync of teaching materials into a writable build area.
dir.create(tmp_root, recursive = TRUE, showWarnings = FALSE)
dir.create(out_root, recursive = TRUE, showWarnings = FALSE)
dir.create(source_root, recursive = TRUE, showWarnings = FALSE)

if (!dir.exists(course_tmp)) dir.create(course_tmp, recursive = TRUE, showWarnings = FALSE)

sync_cmd <- sprintf(
  "rsync -a --delete --exclude='.git' --exclude='.DS_Store' --exclude='.Rhistory' --exclude='~$*' %s/ %s/",
  shQuote(course_root),
  shQuote(course_tmp)
)
status <- system(sync_cmd)
if (!identical(status, 0L)) {
  stop('Failed to sync course materials with rsync')
}

# Keep Stata source artifacts available on the website.
dir.create(file.path(source_root, 'session-3'), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(source_root, 'session-9'), recursive = TRUE, showWarnings = FALSE)
file.copy(file.path(course_tmp, 'Session 3', 'Stata Basic and Data Manipulation.do'),
          file.path(source_root, 'session-3', 'Stata Basic and Data Manipulation.do'), overwrite = TRUE)
file.copy(file.path(course_tmp, 'Session 3', 'auto_data.csv'),
          file.path(source_root, 'session-3', 'auto_data.csv'), overwrite = TRUE)
file.copy(file.path(course_tmp, 'Session 9', 'Week 10.do'),
          file.path(source_root, 'session-9', 'Week 10.do'), overwrite = TRUE)
file.copy(file.path(course_tmp, 'Session 9', 'Graph.png'),
          file.path(source_root, 'session-9', 'Graph.png'), overwrite = TRUE)
file.copy(file.path(course_tmp, 'Session 9', 'NHANES_Graphs.pdf'),
          file.path(source_root, 'session-9', 'NHANES_Graphs.pdf'), overwrite = TRUE)

if (!file.exists(remark_file)) {
  stop('Local remark.js missing: ', remark_file)
}

strip_yaml <- function(lines) {
  idx <- which(trimws(lines) == '---')
  if (length(idx) >= 2 && idx[1] == 1 && idx[2] <= 80) {
    return(lines[(idx[2] + 1):length(lines)])
  }
  lines
}

remove_setup_chunks <- function(lines) {
  out <- c()
  in_skip <- FALSE

  for (line in lines) {
    if (!in_skip && grepl("^```\\{r\\s*setup\\b", trimws(line), perl = TRUE)) {
      in_skip <- TRUE
      next
    }

    if (in_skip && grepl("^```\\s*$", trimws(line), perl = TRUE)) {
      in_skip <- FALSE
      next
    }

    if (!in_skip) out <- c(out, line)
  }

  out
}

sanitize_line <- function(line) {
  out <- line
  out <- gsub('install\\.packages\\s*\\(', 'if (FALSE) install.packages(', out, perl = TRUE)
  out <- gsub('pak::pkg_install\\s*\\(', 'if (FALSE) pak::pkg_install(', out, perl = TRUE)
  out <- gsub('^\\s*setwd\\s*\\(', '# setwd(', out, perl = TRUE)
  out <- gsub('^\\s*View\\s*\\(', '# View(', out, perl = TRUE)
  out
}

extract_sections <- function(lines) {
  in_code <- FALSE
  sections <- c()
  for (line in lines) {
    if (grepl('^```', line)) {
      in_code <- !in_code
      next
    }
    if (!in_code && grepl('^##\\s+', line)) {
      sections <- c(sections, sub('^##\\s+', '', line))
    }
  }
  unique(sections)
}

last_non_empty <- function(lines) {
  vals <- trimws(lines[nzchar(trimws(lines))])
  if (length(vals) == 0) return('')
  tail(vals, 1)
}

to_slide_lines <- function(lines) {
  in_code <- FALSE
  out <- c()
  for (line in lines) {
    line <- sanitize_line(line)

    if (grepl('^```', line)) {
      in_code <- !in_code
      out <- c(out, line)
      next
    }

    if (!in_code && grepl('^#{1,3}\\s+', line)) {
      marker <- last_non_empty(out)
      if (length(out) > 0 && marker != '---') {
        out <- c(out, '', '---', '')
      }
    }

    out <- c(out, line)
  }

  # Remove leading slide separator if present.
  while (length(out) > 0 && trimws(out[1]) == '') out <- out[-1]
  if (length(out) > 0 && trimws(out[1]) == '---') out <- out[-1]
  out
}

build_header <- function(title, roadmap, workdir_rel) {
  c(
    '---',
    sprintf('title: "%s"', title),
    'subtitle: "Conduct of Inquiry I Lab (SPA 096)"',
    'author: "Wali Reheman"',
    'output:',
    '  xaringan::moon_reader:',
    '    self_contained: true',
    '    seal: false',
    '    nature:',
    '      ratio: "16:10"',
    '      highlightStyle: github',
    '      highlightLines: true',
    '      countIncrementalSlides: false',
    '---',
    '',
    '<style>',
    '.remark-slide-content {',
    '  font-family: "Avenir Next", "Segoe UI", Arial, sans-serif;',
    '  font-size: 22px;',
    '  line-height: 1.35;',
    '  padding: 1em 1.35em;',
    '  overflow-y: auto;',
    '}',
    '.remark-slide-content h1, .remark-slide-content h2, .remark-slide-content h3 {',
    '  color: #123a70;',
    '}',
    '.remark-code, .remark-inline-code {',
    '  font-size: 0.78em;',
    '}',
    '.remark-slide-number {',
    '  color: #6b7280;',
    '}',
    '.muted { color: #6b7280; }',
    '</style>',
    '',
    'class: center, middle',
    '',
    sprintf('# %s', title),
    '### Interactive Session Deck',
    '',
    '<div class="muted">Use arrow keys to navigate slides.</div>',
    '',
    '---',
    '',
    '## Session Roadmap',
    ''
  ) |> c(
    if (length(roadmap)) paste0('- ', roadmap) else '- Hands-on code and examples',
    '',
    '---',
    '',
    '```{r setup_coursehub, include=FALSE}',
    'knitr::opts_chunk$set(',
    '  echo = TRUE,',
    '  error = TRUE,',
    '  warning = FALSE,',
    '  message = FALSE,',
    '  fig.width = 8,',
    '  fig.height = 4.8,',
    '  dpi = 120',
    ')',
    'options(width = 100)',
    sprintf('setwd("%s")', workdir_rel),
    '```',
    ''
  )
}

render_and_patch <- function(deck_file, output_html) {
  render(
    input = deck_file,
    output_file = output_html,
    quiet = TRUE,
    envir = new.env(parent = globalenv()),
    knit_root_dir = course_tmp
  )

  html <- paste(readLines(output_html, warn = FALSE), collapse = '\n')
  html <- gsub(
    '<script src="https://remarkjs.com/downloads/remark-latest.min.js"></script>',
    '<script src="/assets/course_hub/conduct_inquiry_lab/interactive/remark-latest.min.js"></script>',
    html,
    fixed = TRUE
  )
  html <- gsub('@import url\\(https://fonts.googleapis.com[^;]+;\\s*', '', html, perl = TRUE)
  writeLines(strsplit(html, '\n', fixed = TRUE)[[1]], output_html)
}

session_specs <- list(
  list(id = 0, title = 'Session 0: Setup and R/RStudio', type = 'rmd',
       files = c('Session 0/R and R studio.Rmd'), workdir = 'Session 0'),
  list(id = 1, title = 'Session 1: Basic R Operations', type = 'rmd',
       files = c('Session 1/Session 1.Rmd'), workdir = 'Session 1'),
  list(id = 2, title = 'Session 2: Introduction to dplyr', type = 'rmd',
       files = c('Session 2/Session 2 Intro to dplyr.Rmd'), workdir = 'Session 2'),
  list(id = 3, title = 'Session 3: Basic Stata Operations and Data Manipulation', type = 'do',
       files = c('Session 3/Stata Basic and Data Manipulation.do'), workdir = 'Session 3'),
  list(id = 4, title = 'Session 4: R Practice', type = 'rmd',
       files = c('Session 4/Practice 1.Rmd'), workdir = 'Session 4'),
  list(id = 5, title = 'Session 5: Aggregating and Reshaping Data', type = 'rmd',
       files = c('Session 5/Week 6 Data Aggregation in R.Rmd'), workdir = 'Session 5'),
  list(id = 6, title = 'Session 6: Reporting Tables and Results', type = 'rmd',
       files = c('Session 6/Week 7 Reporting Tables and Results.Rmd'), workdir = 'Session 6'),
  list(id = 7, title = 'Session 7: Review Exercises', type = 'rmd',
       files = c('Session 7/Review 1.Rmd', 'Session 7/Review 2.Rmd'), workdir = 'Session 7'),
  list(id = 8, title = 'Session 8: Plots in R with ggplot2', type = 'rmd',
       files = c('Session 8/Week 8 Plots in R - ggplot2.Rmd'), workdir = 'Session 8'),
  list(id = 9, title = 'Session 9: Graphing in Stata', type = 'do',
       files = c('Session 9/Week 10.do'), workdir = 'Session 9'),
  list(id = 10, title = 'Session 10: Exploratory Data Analysis', type = 'rmd',
       files = c('Session 10/Week 11 EDA Exercise 1.Rmd', 'Session 10/Week 12 EDA Exercise 1.Rmd'), workdir = 'Session 10'),
  list(id = 11, title = 'Session 11: Prediction', type = 'rmd',
       files = c('Session 11/Week 12 Prediction.Rmd'), workdir = 'Session 11'),
  list(id = 12, title = 'Session 12: Semester Review', type = 'rmd',
       files = c('Session 12/semester_review.Rmd'), workdir = 'Session 12')
)

if (dir.exists(deck_root)) unlink(deck_root, recursive = TRUE, force = TRUE)
dir.create(deck_root, recursive = TRUE, showWarnings = FALSE)

for (spec in session_specs) {
  session_id <- spec$id
  message('Building session-', session_id, ' ...')

  deck_lines <- c()

  if (identical(spec$type, 'rmd')) {
    all_sections <- c()
    body_accum <- c()

    for (f in spec$files) {
      full <- file.path(course_tmp, f)
      if (!file.exists(full)) next
      lines <- readLines(full, warn = FALSE, encoding = 'UTF-8')
      body <- strip_yaml(lines)
      body <- remove_setup_chunks(body)
      all_sections <- c(all_sections, extract_sections(body))

      doc_title <- sub('\\.Rmd$', '', basename(f), ignore.case = TRUE)
      body_accum <- c(
        body_accum,
        '---',
        '',
        paste0('## ', doc_title),
        '',
        to_slide_lines(body),
        ''
      )
    }

    deck_lines <- c(
      build_header(spec$title, unique(all_sections), spec$workdir),
      body_accum
    )
  } else {
    do_full <- file.path(course_tmp, spec$files[[1]])
    do_lines <- if (file.exists(do_full)) readLines(do_full, warn = FALSE, encoding = 'UTF-8') else c('* source missing')
    do_lines <- vapply(do_lines, sanitize_line, FUN.VALUE = character(1), USE.NAMES = FALSE)

    chunk_size <- 85
    starts <- seq(1, max(1, length(do_lines)), by = chunk_size)

    do_slides <- c(
      '---',
      '',
      '## Learning Goals',
      '',
      '- Understand the script workflow line-by-line.',
      '- Connect each command block to expected output.',
      '- Reuse the script for your own data tasks.',
      ''
    )

    for (i in seq_along(starts)) {
      a <- starts[[i]]
      b <- min(length(do_lines), a + chunk_size - 1)
      do_slides <- c(
        do_slides,
        '---',
        '',
        sprintf('## Script Walkthrough (Part %d)', i),
        '',
        '```stata',
        do_lines[a:b],
        '```',
        ''
      )
    }

    if (session_id == 3) {
      do_slides <- c(
        do_slides,
        '---',
        '',
        '## Output Preview: `auto_data.csv`',
        '',
        '```{r}',
        'df <- read.csv("auto_data.csv")',
        'knitr::kable(head(df, 15))',
        '```',
        ''
      )
    }

    if (session_id == 9) {
      do_slides <- c(
        do_slides,
        '---',
        '',
        '## Graph Output Preview',
        '',
        '```{r echo=FALSE, out.width="90%"}',
        'knitr::include_graphics("Graph.png")',
        '```',
        '',
        '---',
        '',
        '## Full Graph Report',
        '',
        '[Open NHANES Graph Report (PDF)](/assets/course_hub/conduct_inquiry_lab/source/session-9/NHANES_Graphs.pdf)',
        ''
      )
    }

    deck_lines <- c(
      build_header(spec$title, c('Code walkthrough', 'Output preview', 'Applied interpretation'), spec$workdir),
      do_slides
    )
  }

  deck_file <- file.path(deck_root, sprintf('session-%d.Rmd', session_id))
  out_file <- file.path(out_root, sprintf('session-%d.html', session_id))

  writeLines(deck_lines, deck_file, useBytes = TRUE)
  render_and_patch(deck_file, out_file)
}

message('All session decks rebuilt in: ', out_root)
