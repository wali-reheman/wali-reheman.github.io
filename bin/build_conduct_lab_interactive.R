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

apply_session_hotfixes <- function(lines, session_id) {
  out <- lines

  if (isTRUE(session_id == 2)) {
    out <- gsub(
      'right_join\\s*\\(\\s*mtcars\\s*,\\s*by\\s*=\\s*"model"\\s*\\)',
      'right_join(mtcars_joined, by = "model")',
      out,
      perl = TRUE
    )
  }

  if (isTRUE(session_id == 5)) {
    idx <- grep('^\\s*cross_sectional_data <- gapminder %>%\\s*$', out, perl = TRUE)
    if (length(idx) >= 1L) {
      i <- idx[[1]]
      if (i < length(out) && !grepl('mutate\\(country\\s*=\\s*as\\.character\\(country\\)\\)', out[[i + 1]], perl = TRUE)) {
        out <- append(out, '  mutate(country = as.character(country)) %>%', after = i)
      }
    }

    j <- grep('^\\s*world_map_data <- world_map %>%\\s*$', out, perl = TRUE)
    if (length(j) >= 1L) {
      i <- j[[1]]
      prefix <- c('cross_sectional_data$country <- as.character(cross_sectional_data$country)',
                  'world_map$name <- as.character(world_map$name)')
      out <- append(out, prefix, after = i - 1L)
    }

    out <- gsub(
      'cross_sectional_data\\$country\\s*<-\\s*haven::as_factor\\(cross_sectional_data\\$country\\)',
      'cross_sectional_data$country <- as.character(cross_sectional_data$country)',
      out,
      perl = TRUE
    )
  }

  if (isTRUE(session_id == 6)) {
    out <- gsub(
      '^\\s*system\\("pandoc -s regression_table\\.html -o regression_table\\.pdf"\\)\\s*$',
      'if (nzchar(Sys.which("pandoc"))) system("pandoc -s regression_table.html -o regression_table.pdf") else message("pandoc not available in this runtime; skipping PDF conversion.")',
      out,
      perl = TRUE
    )
  }

  if (isTRUE(session_id == 12)) {
    out <- gsub('^\\s*library\\(devtools\\)\\s*$', 'anes_data <- readRDS("anes_pilot_2020.RDS")', out, perl = TRUE)

    drop <- grepl('^\\s*install_github\\("jamesmartherus/anesr"\\)\\s*$', out, perl = TRUE) |
      grepl('^\\s*library\\(anesr\\)\\s*$', out, perl = TRUE) |
      grepl('^\\s*data\\(package\\s*=\\s*"anesr"\\)\\s*.*$', out, perl = TRUE) |
      grepl('^\\s*data\\(pilot_2020\\)\\s*.*$', out, perl = TRUE) |
      grepl('^\\s*anes_data\\s*<-\\s*pilot_2020\\s*$', out, perl = TRUE)
    out <- out[!drop]

    out <- gsub('haven::write_dta(pilot_2020,', 'haven::write_dta(anes_data,', out, fixed = TRUE)
    out <- gsub('saveRDS(pilot_2020,', 'saveRDS(anes_data,', out, fixed = TRUE)
    out <- gsub('write.csv(pilot_2020,', 'write.csv(anes_data,', out, fixed = TRUE)
  }

  out
}

body_prelude <- function(title) {
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
    '  const state = { webR: null, webRReady: null, installedPkgs: new Set(), failedPkgs: new Set(), loadedFiles: new Set() };',
    '  const sessionMatch = window.location.pathname.match(/session-(\\d+)\\.html/i);',
    '  const sessionNum = sessionMatch ? sessionMatch[1] : null;',
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
    '  function extractPackages(code){',
    '    const pkgs = [];',
    '    const add = (p)=>{ if(p) pkgs.push(p); };',
    '    let m;',
    '    const libPatterns = [',
    '      /(?:library|require)\\s*\\(\\s*(?:package\\s*=\\s*)?["\\\']?([A-Za-z][A-Za-z0-9._]*)["\\\']?/g,',
    '      /requireNamespace\\s*\\(\\s*["\\\']?([A-Za-z][A-Za-z0-9._]*)["\\\']?/g',
    '    ];',
    '    libPatterns.forEach((re)=>{',
    '      while((m = re.exec(code)) !== null){',
    '        add(m[1]);',
    '      }',
    '    });',
    '    const nsRe = /\\b([A-Za-z][A-Za-z0-9._]*)\\s*(?:::|::)\\s*[A-Za-z][A-Za-z0-9._]*/g;',
    '    while((m = nsRe.exec(code)) !== null){',
    '      add(m[1]);',
    '    }',
    '    if(/%>%/.test(code) || /\\|>/.test(code)) pkgs.push("dplyr");',
    '    if(/\\bdrop_na\\s*\\(/.test(code)) pkgs.push("tidyr");',
    '    if(/\\bglimpse\\s*\\(/.test(code)) pkgs.push("dplyr");',
    '    if(/\\bggplot\\s*\\(/.test(code)) pkgs.push("ggplot2");',
    '    if(/\\bread_dta\\s*\\(/.test(code)) pkgs.push("haven");',
    '    if(/\\bNHANES\\b/.test(code)) pkgs.push("NHANES");',
    '    return pkgs;',
    '  }',
    '',
    '  function normalizePackages(pkgs){',
    '    const out = [];',
    '    const blocked = new Set(["package", "character.only", "quietly", "warn.conflicts", "lib.loc"]);',
    '    pkgs.forEach((p)=>{',
    '      if(!p) return;',
      '      const name = String(p).trim();',
      '      if(!name) return;',
    '      if(blocked.has(name.toLowerCase())) return;',
    '      if(name.toLowerCase() === "tidyverse"){',
    '        out.push("tidyverse", "dplyr", "tidyr", "ggplot2", "magrittr");',
    '      } else {',
    '        out.push(name);',
    '      }',
    '    });',
    '    return Array.from(new Set(out.map((p)=>p.replace(/[^A-Za-z0-9._]/g, "")).filter(Boolean)));',
    '  }',
    '',
    '  function extractFileRefs(code){',
    '    const refs = [];',
    '    const re = /[\"\\\']([^\"\\\']+\\.(csv|dta|sav|rda|rdata|rds|xlsx?|txt|tsv|json|png|pdf))[\"\\\']/gi;',
    '    let m;',
    '    while((m = re.exec(code)) !== null){',
    '      if(m[1]) refs.push(m[1]);',
    '    }',
    '    return Array.from(new Set(refs.map((r)=>String(r).trim().replace(/^\\.\\//, \"\")).filter(Boolean)));',
    '  }',
    '',
    '  function encodePath(path){',
    '    return path.split(\"/\").map(encodeURIComponent).join(\"/\");',
    '  }',
    '',
    '  async function fetchAsBytes(url){',
    '    const res = await fetch(url);',
    '    if(!res.ok) throw new Error(`HTTP ${res.status}`);',
    '    return new Uint8Array(await res.arrayBuffer());',
    '  }',
    '',
    '  function ensureDirs(fs, path){',
    '    const parts = String(path || \"\").split(\"/\").filter(Boolean);',
    '    if(parts.length <= 1) return;',
    '    let cur = \"\";',
    '    for(let i = 0; i < parts.length - 1; i++){',
    '      cur += `/${parts[i]}`;',
    '      try { fs.mkdir(cur); } catch(e) {}',
    '    }',
    '  }',
    '',
    '  async function ensureDataFiles(webR, code, out){',
    '    if(!sessionNum) return;',
    '    const files = extractFileRefs(code);',
    '    for(const ref of files){',
    '      const base = ref.split(\"/\").pop();',
    '      const variants = Array.from(new Set([ref, base].filter(Boolean)));',
    '      if(!variants.length) continue;',
    '      if(variants.some((v)=>state.loadedFiles.has(`${sessionNum}:${v}`))) continue;',
    '',
    '      out.textContent = `Loading data file: ${base || ref} ...`;',
    '      let bytes = null;',
    '      for(const v of variants){',
    '        const localUrl = `/assets/course_hub/conduct_inquiry_lab/source/session-${sessionNum}/${encodePath(v)}`;',
    '        try { bytes = await fetchAsBytes(localUrl); break; } catch(e) {}',
    '      }',
    '      if(!bytes){',
    '        for(const v of variants){',
    '          const githubUrl = `https://raw.githubusercontent.com/wali-reheman/Conduct-of-Inquiry-I-Lab---SPA-096/main/Session%20${sessionNum}/${encodePath(v)}`;',
    '          try { bytes = await fetchAsBytes(githubUrl); break; } catch(e) {}',
    '        }',
    '      }',
    '      if(!bytes) continue;',
    '',
    '      for(const v of variants){',
    '        try {',
    '          ensureDirs(webR.FS, v);',
    '          webR.FS.writeFile(v, bytes);',
    '          state.loadedFiles.add(`${sessionNum}:${v}`);',
    '        } catch(e) {}',
    '      }',
    '    }',
    '  }',
    '',
    '  async function ensurePackages(webR, code, out){',
    '    const wanted = normalizePackages(extractPackages(code)).filter((p)=>!state.installedPkgs.has(p) && !state.failedPkgs.has(p));',
    '    if(!wanted.length) return;',
    '    await webR.evalRVoid(\"options(repos = c(CRAN = \'https://repo.r-wasm.org\'))\");',
    '    for(const pkg of wanted){',
    '      out.textContent = `Preparing package: ${pkg} (first run may take 10-60s)...`;',
    '      const setup = [',
    '        `if (!suppressWarnings(requireNamespace(\'${pkg}\', quietly = TRUE))) {` ,',
    '        `  tryCatch(webr::install(\'${pkg}\'), error = function(e) NULL)` ,',
    '        `}`,',
    '        `suppressPackageStartupMessages(try(library(\'${pkg}\', character.only = TRUE), silent = TRUE))`',
    '      ].join(\"\\n\");',
    '      await webR.evalRVoid(setup);',
    '      try {',
    '        await webR.evalRVoid(`if (!suppressWarnings(requireNamespace(\'${pkg}\', quietly = TRUE))) stop(\'missing\')`);',
    '        state.installedPkgs.add(pkg);',
    '      } catch(e) {',
    '        state.failedPkgs.add(pkg);',
    '        out.textContent = `Package ${pkg} is unavailable in this browser runtime.`;',
    '      }',
    '    }',
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
    '            await ensureDataFiles(webR, code, out);',
    '            await ensurePackages(webR, code, out);',
    '            out.textContent = "Running...";',
    '            const runner = "paste(capture.output({\\n" +',
    '              ".__coursehub_res <- ({\\n" + code + "\\n})\\n" +',
    '              "if (exists(\'.__coursehub_res\', inherits = FALSE)) print(.__coursehub_res)\\n" +',
    '              "}, type = \'output\'), collapse = \'\\\\n\')";',
    '            const result = await webR.evalR(runner);',
    '            let text = "";',
    '            try { text = await result.toString(); } catch(e) { text = ""; }',
    '            const clean = (text || "").trim();',
    '            out.textContent = clean && !/^\\[object RObject:/.test(clean) ? clean : "Code executed.";',
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

stage_session_sources <- function(specs) {
  ref_pattern <- "['\"]([^'\"]+\\.(csv|dta|sav|rda|rdata|rds|xlsx?|txt|tsv|json|png|pdf|do))['\"]"

  extract_refs <- function(file) {
    if (!file.exists(file)) return(character())
    txt <- paste(readLines(file, warn = FALSE, encoding = 'UTF-8'), collapse = "\n")
    m <- gregexpr(ref_pattern, txt, perl = TRUE, ignore.case = TRUE)
    hits <- regmatches(txt, m)[[1]]
    if (!length(hits) || identical(hits, character(1)) && hits[[1]] == "-1") return(character())
    refs <- sub("^['\"]", "", hits)
    refs <- sub("['\"]$", "", refs)
    refs
  }

  for (spec in specs) {
    src_dir <- file.path(course_tmp, spec$workdir)
    if (!dir.exists(src_dir)) next

    out_dir <- file.path(source_root, sprintf('session-%d', spec$id))
    if (dir.exists(out_dir)) unlink(out_dir, recursive = TRUE, force = TRUE)
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

    refs <- character()
    refs <- c(refs, basename(unlist(spec$files)))
    for (f in spec$files) refs <- c(refs, extract_refs(file.path(course_tmp, f)))

    if (spec$id == 3) refs <- c(refs, 'auto_data.csv')
    if (spec$id == 9) refs <- c(refs, 'Graph.png', 'NHANES_Graphs.pdf')

    refs <- unique(gsub('^\\./', '', refs))
    refs <- refs[nzchar(refs)]

    for (ref in refs) {
      ref <- gsub('\\\\', '/', ref)
      candidates <- unique(c(
        file.path(src_dir, ref),
        file.path(src_dir, basename(ref)),
        file.path(course_tmp, ref),
        file.path(course_tmp, basename(ref))
      ))
      src <- candidates[file.exists(candidates)][1]
      if (is.na(src) || !nzchar(src)) next

      to <- file.path(out_dir, ref)
      dir.create(dirname(to), recursive = TRUE, showWarnings = FALSE)
      if (grepl('\\.rmd$', src, ignore.case = TRUE, perl = TRUE)) {
        txt <- readLines(src, warn = FALSE, encoding = 'UTF-8')
        txt <- apply_session_hotfixes(txt, spec$id)
        writeLines(txt, to, useBytes = TRUE)
      } else {
        file.copy(src, to, overwrite = TRUE)
      }
    }
  }
}

stage_session_sources(session_specs)

if (dir.exists(page_root)) unlink(page_root, recursive = TRUE, force = TRUE)
dir.create(page_root, recursive = TRUE, showWarnings = FALSE)

for (spec in session_specs) {
  message('Building session-', spec$id, ' ...')

	  lines <- body_prelude(spec$title)

  if (identical(spec$type, 'rmd')) {
    for (f in spec$files) {
      full <- file.path(course_tmp, f)
      if (!file.exists(full)) next
      body <- readLines(full, warn = FALSE, encoding = 'UTF-8')
      body <- apply_session_hotfixes(body, spec$id)
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
    knit_root_dir = file.path(course_tmp, spec$workdir)
  )

  html <- paste(readLines(out_file, warn = FALSE), collapse = '\n')
  if (isTRUE(spec$id == 9)) {
    html <- gsub('src="Graph.png"', 'src="/assets/course_hub/conduct_inquiry_lab/source/session-9/Graph.png"', html, fixed = TRUE)
  }
  html <- inject_interactivity(html)
  writeLines(strsplit(html, '\n', fixed = TRUE)[[1]], out_file)
}

message('All interactive long-form pages rebuilt in: ', out_root)
