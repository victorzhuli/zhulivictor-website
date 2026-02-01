# CLAUDE.md - Project Intelligence

## Project Overview
Personal academic website for Li Zhu using Hugo static site generator, deployed on Netlify.

## Key Commands
```bash
# Preview locally
hugo server

# Build
hugo --minify

# Deploy (auto-deploys on push)
git add -A && git commit -m "message" && git push
```

## Project Structure
- `content/` - English markdown pages (_index.md, cv.md, publications.md, etc.)
- `content/zh/` - Chinese markdown pages (translated versions)
- `i18n/` - UI translation strings (en.yaml, zh.yaml)
- `themes/elegant/` - Custom theme
  - `assets/css/main.css` - All styling
  - `layouts/` - HTML templates
  - `layouts/_default/` - Default templates (single.html, baseof.html)
  - `layouts/partials/` - Reusable components (NOT `_partials`)

## Multilingual Support
- **English** (default): `/`, `/cv`, `/publications`, etc.
- **Chinese**: `/zh/`, `/zh/cv`, `/zh/publications`, etc.
- Language switcher in header navigation
- When updating content, **update both English and Chinese versions**
- Translation files in `i18n/` for UI strings

## Critical Gotchas

### Hugo Partials Directory
- Must be named `partials/` NOT `_partials/`
- Error: "partial head.html not found" means wrong directory name

### Netlify Build
- `public/` folder must be in `.gitignore` - Netlify builds fresh
- Hugo version specified in `netlify.toml` (currently 0.121.0)
- Local Hugo version may differ from Netlify's

### Raw HTML in Markdown
- Enabled via `[markup.goldmark.renderer] unsafe = true` in hugo.toml
- Required for CV page timeline HTML structure

### Fixed Header
- Uses `position: fixed` with `margin-top: 70px` on main (130px on mobile)
- Header class is `.site-header` (not generic `header` selector)
- `scroll-margin-top: 80px` on headings prevents anchor overlap

### Hugo Page Templates
- Page templates must be in `layouts/_default/single.html`
- `layouts/page.html` at root level won't work for regular pages
- Error: pages return 404 but home works = missing `_default/single.html`

### Mobile Responsive
- Profile image needs `display: block` for `margin: 0 auto` centering
- Header wraps on mobile, so main needs larger margin-top (130px)

## URLs
- Live: https://zhulivictor.com
- Netlify: https://coruscating-pudding-876c7a.netlify.app
- GitHub: https://github.com/victorzhuli/zhulivictor-website (private)

## DNS (GoDaddy)
- A record: @ → 75.2.60.5
- CNAME: www → coruscating-pudding-876c7a.netlify.app
