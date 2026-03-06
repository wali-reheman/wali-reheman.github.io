#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(rmarkdown)
})

site_root <- normalizePath('.', winslash = '/', mustWork = TRUE)
course_root <- '/Users/wali/Documents/GitHub/Conduct-of-Inquiry-I-Lab---SPA-096'

tmp_root <- file.path(site_root, '.tmp', 'conduct_lab_interactive')
course_tmp <- file.path(tmp_root, 'course')
page_root <- file.path(tmp_root, 'pages')
out_root <- file.path(site_root, 'assets/course_hub/conduct_inquiry_lab/interactive')
source_root <- file.path(site_root, 'assets/course_hub/conduct_inquiry_lab/source')

if (!dir.exists(course_root)) stop('Course source repo not found at: ', course_root)

dir.create(tmp_root, recursive = TRUE, showWarnings = FALSE)
dir.create(course_tmp, recursive = TRUE, showWarnings = FALSE)
dir.create(page_root, recursive = TRUE, showWarnings = FALSE)
dir.create(out_root, recursive = TRUE, showWarnings = FALSE)
dir.create(source_root, recursive = TRUE, showWarnings = FALSE)

sync_cmd <- sprintf(
  "rsync -a --delete --exclude='.git' --exclude='.DS_Store' --exclude='.Rhistory' --exclude='~$*' %s/ %s/",
  shQuote(course_root),
  shQuote(course_tmp)
)
if (system(sync_cmd) != 0L) stop('Failed to sync course materials with rsync')

# Keep Stata source artifacts available on website.
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

strip_yaml <- function(lines) {
  idx <- which(trimws(lines) == '---')
  if (length(idx) >= 2 && idx[1] == 1 && idx[2] <= 80) return(lines[(idx[2] + 1):length(lines)])
  lines
}

remove_setup_chunks <- function(lines) {
  out <- c(); in_skip <- FALSE
  for (line in lines) {
    if (!in_skip && grepl('^```\\{r\\s*setup\\b', trimws(line), perl = TRUE)) {
      in_skip <- TRUE
      next
    }
    if (in_skip && grepl('^```\\s*$', trimws(line), perl = TRUE)) {
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
  if (grepl('^\\s*-{3,}\\s*$', out)) out <- ''
  out
}

body_prelude <- function(title, workdir_rel) {
  c(
    '---',
    sprintf('title: "%s"', title),
    'output:',
    '  html_document:',
    '    self_contained: true',
    '    toc: true',
    '    toc_float: true',
    '    code_folding: show',
    '    df_print: paged',
    '---',
    '',
    '```{r setup_coursehub, include=FALSE}',
    'knitr::opts_chunk$set(',
    '  echo = TRUE,',
    '  error = TRUE,',
    '  warning = FALSE,',
    '  message = FALSE,',
    '  fig.width = 7.2,',
    '  fig.height = 4.2,',
    '  dpi = 120',
    ')',
    'options(width = 100)',
    sprintf('setwd("%s")', workdir_rel),
    '```',
    '',
    '<div class="interactive-note">',
    '<strong>Interactive mode:</strong> click a code block or <em>Show Plot</em> button to reveal/hide its corresponding plot.',
    '</div>',
    ''
  )
}

inject_interactivity <- function(html) {
  css <- c(
    '<style id="coursehub-interactive-style">',
    '.main-container { max-width: 1180px; }',
    '.interactive-note {',
    '  border: 1px solid #c9ddf6;',
    '  background: #f5f9ff;',
    '  border-radius: 8px;',
    '  padding: 0.55rem 0.7rem;',
    '  margin: 0.7rem 0 1rem;',
    '  font-size: 0.92rem;',
    '}',
    '.sourceCode, pre[class] {',
    '  cursor: pointer;',
    '}',
    '.sourceCode, pre[class] {',
    '  border-left: 3px solid #d7e6fb;',
    '}',
    '.code-toolbar {',
    '  display: flex;',
    '  flex-wrap: wrap;',
    '  gap: 0.36rem;',
    '  margin: 0.28rem 0 0.55rem;',
    '}',
    '.code-btn {',
    '  padding: 0.22rem 0.56rem;',
    '  border: 1px solid #0f4d92;',
    '  border-radius: 6px;',
    '  background: #f0f6ff;',
    '  color: #0f4d92;',
    '  font-size: 0.74rem;',
    '  font-weight: 700;',
    '  cursor: pointer;',
    '}',
    '.code-btn:hover { background: #e2efff; }',
    '.code-editor {',
    '  width: 100%;',
    '  min-height: 150px;',
    '  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;',
    '  font-size: 0.82rem;',
    '  line-height: 1.35;',
    '  border: 1px solid #c8d9f0;',
    '  border-radius: 8px;',
    '  padding: 0.55rem;',
    '  margin: 0.3rem 0 0.55rem;',
    '  box-sizing: border-box;',
    '}',
    '.code-output {',
    '  border: 1px solid #d3e1f4;',
    '  background: #f8fbff;',
    '  border-radius: 8px;',
    '  padding: 0.45rem 0.58rem;',
    '  margin: 0.3rem 0 0.7rem;',
    '  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;',
    '  font-size: 0.78rem;',
    '  white-space: pre-wrap;',
    '}',
    '.code-output.error {',
    '  border-color: #f0c4c4;',
    '  background: #fff7f7;',
    '  color: #7b2020;',
    '}',
    '.plot-toggle-btn {',
    '  margin: 0.3rem 0 0.85rem;',
    '  padding: 0.26rem 0.62rem;',
    '  border: 1px solid #0f4d92;',
    '  border-radius: 7px;',
    '  background: #f0f6ff;',
    '  color: #0f4d92;',
    '  font-size: 0.78rem;',
    '  font-weight: 700;',
    '  cursor: pointer;',
    '}',
    '.plot-toggle-btn:hover { background: #e2efff; }',
    '.plot-hidden { display: none !important; }',
    '.figure, .figure img, p > img, img {',
    '  max-width: 100% !important;',
    '  height: auto !important;',
    '}',
    '.figure img, p > img {',
    '  max-height: 62vh !important;',
    '  width: auto !important;',
    '  object-fit: contain;',
    '  display: block;',
    '  margin: 0.4rem auto;',
    '}',
    'pre, .sourceCode { overflow-x: auto; }',
    '@media (max-width: 900px) {',
    '  .main-container { max-width: 100%; padding-left: 0.7rem; padding-right: 0.7rem; }',
    '  .figure img, p > img { max-height: 52vh !important; }',
    '}',
    '</style>'
  )

  js <- c(
    '<script id="coursehub-interactive-script">',
    '(function(){',
    '  const state = { webR: null, webRReady: null };',
    '',
    '  function codeText(block){',
    '    const codeEl = block.querySelector("code");',
    '    return (codeEl ? codeEl.textContent : block.textContent || "").trim();',
    '  }',
    '',
    '  function langOf(block){',
    '    const cls = ((block.className || "") + " " + ((block.querySelector("code")||{}).className || "")).toLowerCase();',
    '    if(/(^|\\s)r(\\s|$)|language-r/.test(cls)) return "r";',
    '    if(/stata|language-stata/.test(cls)) return "stata";',
    '    if(/python|language-python/.test(cls)) return "python";',
    '    return "code";',
    '  }',
    '',
    '  async function ensureWebR(){',
    '    if(state.webR) return state.webR;',
    '    if(state.webRReady) return state.webRReady;',
    '    state.webRReady = (async ()=>{',
    '      const mod = await import("https://webr.r-wasm.org/latest/webr.mjs");',
    '      state.webR = new mod.WebR({ interactive: false });',
    '      await state.webR.init();',
    '      return state.webR;',
    '    })();',
    '    return state.webRReady;',
    '  }',
    '',
    '  function isSourceBlock(el){',
    '    if(!el) return false;',
    '    if(el.matches && el.matches("div.sourceCode, pre.sourceCode, pre[class]")) return true;',
    '    if(el.tagName === "PRE" && el.classList && el.classList.length > 0 && el.querySelector("code")) return true;',
    '    return false;',
    '  }',
    '  function findPlotTarget(source){',
    '    let el = source.nextElementSibling;',
    '    while(el){',
    '      if(el.matches && el.matches("h1,h2,h3,h4")) return null;',
    '      if(isSourceBlock(el)) return null;',
    '      if(el.matches && el.matches("div.figure, figure, img")) return el;',
    '      if(el.querySelector){',
    '        const img = el.querySelector("img");',
    '        if(img) return el;',
    '      }',
    '      el = el.nextElementSibling;',
    '    }',
    '    return null;',
    '  }',
    '  function wire(){',
    '    const blocks = Array.from(document.querySelectorAll("div.sourceCode, pre.sourceCode, pre[class]"));',
    '    blocks.forEach((block)=>{',
    '      if(block.dataset.interactiveWired === "1") return;',
    '',
    '      const lang = langOf(block);',
    '      const toolbar = document.createElement("div");',
    '      toolbar.className = "code-toolbar";',
    '',
    '      const copyBtn = document.createElement("button");',
    '      copyBtn.type = "button";',
    '      copyBtn.className = "code-btn";',
    '      copyBtn.textContent = "Copy Code";',
    '      copyBtn.addEventListener("click", async (ev)=>{',
    '        ev.stopPropagation();',
    '        const txt = block.dataset.editing === "1" && block._editor ? block._editor.value : codeText(block);',
    '        try { await navigator.clipboard.writeText(txt); copyBtn.textContent = "Copied"; setTimeout(()=>copyBtn.textContent="Copy Code", 900); }',
    '        catch { copyBtn.textContent = "Copy Failed"; setTimeout(()=>copyBtn.textContent="Copy Code", 1200); }',
    '      });',
    '      toolbar.appendChild(copyBtn);',
    '',
    '      const editBtn = document.createElement("button");',
    '      editBtn.type = "button";',
    '      editBtn.className = "code-btn";',
    '      editBtn.textContent = "Edit";',
    '      editBtn.addEventListener("click", (ev)=>{',
    '        ev.stopPropagation();',
    '        if(!block._editor){',
    '          const ta = document.createElement("textarea");',
    '          ta.className = "code-editor";',
    '          ta.value = codeText(block);',
    '          block.insertAdjacentElement("afterend", ta);',
    '          block._editor = ta;',
    '          block.dataset.editing = "1";',
    '          editBtn.textContent = "Hide Editor";',
    '        } else {',
    '          const on = block._editor.style.display !== "none";',
    '          block._editor.style.display = on ? "none" : "block";',
    '          block.dataset.editing = on ? "0" : "1";',
    '          editBtn.textContent = on ? "Edit" : "Hide Editor";',
    '        }',
    '      });',
    '      toolbar.appendChild(editBtn);',
    '',
    '      const runBtn = document.createElement("button");',
    '      runBtn.type = "button";',
    '      runBtn.className = "code-btn";',
    '      runBtn.textContent = lang === "r" ? "Run R Code" : "Run";',
    '',
    '      const out = document.createElement("div");',
    '      out.className = "code-output plot-hidden";',
    '',
    '      if(lang !== "r"){',
    '        runBtn.disabled = true;',
    '        runBtn.textContent = "Run (R only)";',
    '        runBtn.title = "In-browser execution is enabled for R code blocks.";',
    '      } else {',
    '        runBtn.addEventListener("click", async (ev)=>{',
    '          ev.stopPropagation();',
    '          out.classList.remove("plot-hidden", "error");',
    '          out.textContent = "Initializing R runtime...";',
    '          try {',
    '            const webR = await ensureWebR();',
    '            const code = (block.dataset.editing === "1" && block._editor) ? block._editor.value : codeText(block);',
    '            out.textContent = "Running...";',
    '            const result = await webR.evalR(code);',
    '            let text = "";',
    '            try { text = await result.toString(); } catch(e) { text = ""; }',
    '            out.textContent = text && text.trim() ? text : "Code executed. (For plots, use the Show Plot toggle below.)";',
    '          } catch (err) {',
    '            out.classList.add("error");',
    '            out.textContent = "Run failed: " + (err && err.message ? err.message : String(err));',
    '          }',
    '        });',
    '      }',
    '      toolbar.appendChild(runBtn);',
    '',
    '      block.insertAdjacentElement("afterend", toolbar);',
    '      toolbar.insertAdjacentElement("afterend", out);',
    '',
    '      const target = findPlotTarget(block);',
    '      if(target){',
    '        target.classList.add("plot-hidden");',
    '        const btn = document.createElement("button");',
    '        btn.type = "button";',
    '        btn.className = "plot-toggle-btn";',
    '        btn.textContent = "Show Plot";',
    '        const toggle = ()=>{',
    '          const hidden = target.classList.toggle("plot-hidden");',
    '          btn.textContent = hidden ? "Show Plot" : "Hide Plot";',
    '        };',
    '        btn.addEventListener("click", toggle);',
    '        block.addEventListener("click", (ev)=>{',
    '          if(ev.target && ev.target.closest("button, textarea")) return;',
    '          toggle();',
    '        });',
    '        out.insertAdjacentElement("afterend", btn);',
    '      }',
    '',
    '      block.dataset.interactiveWired = "1";',
    '    });',
    '  }',
    '  if(document.readyState === "loading") document.addEventListener("DOMContentLoaded", wire);',
    '  else wire();',
    '  setTimeout(wire, 300);',
    '})();',
    '</script>'
  )

  html <- gsub('<style id="coursehub-interactive-style">[\\s\\S]*?</style>\\s*', '', html, perl = TRUE)
  html <- gsub('<script id="coursehub-interactive-script">[\\s\\S]*?</script>\\s*', '', html, perl = TRUE)
  html <- sub('</head>', paste0(paste(css, collapse='\n'), '\n</head>'), html, fixed = TRUE)
  html <- sub('</body>', paste0(paste(js, collapse='\n'), '\n</body>'), html, fixed = TRUE)
  html
}

session_specs <- list(
  list(id = 0, title = 'Session 0: Setup and R/RStudio', type = 'rmd', files = c('Session 0/R and R studio.Rmd'), workdir = 'Session 0'),
  list(id = 1, title = 'Session 1: Basic R Operations', type = 'rmd', files = c('Session 1/Session 1.Rmd'), workdir = 'Session 1'),
  list(id = 2, title = 'Session 2: Introduction to dplyr', type = 'rmd', files = c('Session 2/Session 2 Intro to dplyr.Rmd'), workdir = 'Session 2'),
  list(id = 3, title = 'Session 3: Basic Stata Operations and Data Manipulation', type = 'do', files = c('Session 3/Stata Basic and Data Manipulation.do'), workdir = 'Session 3'),
  list(id = 4, title = 'Session 4: R Practice', type = 'rmd', files = c('Session 4/Practice 1.Rmd'), workdir = 'Session 4'),
  list(id = 5, title = 'Session 5: Aggregating and Reshaping Data', type = 'rmd', files = c('Session 5/Week 6 Data Aggregation in R.Rmd'), workdir = 'Session 5'),
  list(id = 6, title = 'Session 6: Reporting Tables and Results', type = 'rmd', files = c('Session 6/Week 7 Reporting Tables and Results.Rmd'), workdir = 'Session 6'),
  list(id = 7, title = 'Session 7: Review Exercises', type = 'rmd', files = c('Session 7/Review 1.Rmd', 'Session 7/Review 2.Rmd'), workdir = 'Session 7'),
  list(id = 8, title = 'Session 8: Plots in R with ggplot2', type = 'rmd', files = c('Session 8/Week 8 Plots in R - ggplot2.Rmd'), workdir = 'Session 8'),
  list(id = 9, title = 'Session 9: Graphing in Stata', type = 'do', files = c('Session 9/Week 10.do'), workdir = 'Session 9'),
  list(id = 10, title = 'Session 10: Exploratory Data Analysis', type = 'rmd', files = c('Session 10/Week 11 EDA Exercise 1.Rmd', 'Session 10/Week 12 EDA Exercise 1.Rmd'), workdir = 'Session 10'),
  list(id = 11, title = 'Session 11: Prediction', type = 'rmd', files = c('Session 11/Week 12 Prediction.Rmd'), workdir = 'Session 11'),
  list(id = 12, title = 'Session 12: Semester Review', type = 'rmd', files = c('Session 12/semester_review.Rmd'), workdir = 'Session 12')
)

if (dir.exists(page_root)) unlink(page_root, recursive = TRUE, force = TRUE)
dir.create(page_root, recursive = TRUE, showWarnings = FALSE)

for (spec in session_specs) {
  message('Building session-', spec$id, ' ...')

  lines <- body_prelude(spec$title, spec$workdir)

  if (identical(spec$type, 'rmd')) {
    for (f in spec$files) {
      full <- file.path(course_tmp, f)
      if (!file.exists(full)) next
      body <- readLines(full, warn = FALSE, encoding = 'UTF-8')
      body <- strip_yaml(body)
      body <- remove_setup_chunks(body)
      body <- vapply(body, sanitize_line, FUN.VALUE = character(1), USE.NAMES = FALSE)
      doc_title <- sub('\\.Rmd$', '', basename(f), ignore.case = TRUE)
      lines <- c(lines, '', paste0('## ', doc_title), '', body, '')
    }
  } else {
    do_full <- file.path(course_tmp, spec$files[[1]])
    do_lines <- if (file.exists(do_full)) readLines(do_full, warn = FALSE, encoding = 'UTF-8') else c('* source missing')
    do_lines <- vapply(do_lines, sanitize_line, FUN.VALUE = character(1), USE.NAMES = FALSE)

    lines <- c(lines,
               '## Script Walkthrough',
               '',
               '```stata',
               do_lines,
               '```',
               '')

    if (spec$id == 3) {
      lines <- c(lines,
                 '## Output Preview: `auto_data.csv`',
                 '',
                 '```{r}',
                 'df <- read.csv("auto_data.csv")',
                 'knitr::kable(head(df, 20))',
                 '```',
                 '')
    }

    if (spec$id == 9) {
      lines <- c(lines,
                 '## Plot Preview',
                 '',
                 '```{r echo=FALSE, out.width="95%"}',
                 'knitr::include_graphics("Graph.png")',
                 '```',
                 '',
                 '## Full Graph PDF',
                 '',
                 '[Open NHANES Graph Report (PDF)](/assets/course_hub/conduct_inquiry_lab/source/session-9/NHANES_Graphs.pdf)',
                 '')
    }
  }

  page_file <- file.path(page_root, sprintf('session-%d.Rmd', spec$id))
  out_file <- file.path(out_root, sprintf('session-%d.html', spec$id))
  writeLines(lines, page_file, useBytes = TRUE)

  render(
    input = page_file,
    output_file = out_file,
    quiet = TRUE,
    envir = new.env(parent = globalenv()),
    knit_root_dir = course_tmp
  )

  html <- paste(readLines(out_file, warn = FALSE), collapse = '\n')
  html <- inject_interactivity(html)
  writeLines(strsplit(html, '\n', fixed = TRUE)[[1]], out_file)
}

message('All interactive long-form pages rebuilt in: ', out_root)
