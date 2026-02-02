# CLAUDE.md - Project Intelligence

## Project Overview
Personal academic website for Li Zhu (朱立) using Hugo static site generator, deployed on GitHub Pages.

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
    - `head.html` - Contains Google Analytics tracking code

## Multilingual Support
- **English** (default): `/`, `/cv`, `/publications`, etc.
- **Chinese**: `/zh/`, `/zh/cv`, `/zh/publications`, etc.
- Chinese name: 朱立 (not 朱礼)
- Language switcher in header navigation
- When updating content, **update both English and Chinese versions**
- Translation files in `i18n/` for UI strings

## Content Guidelines
- Site branding: "Digital Health Researcher & AI Innovator" (no employer in tagline)
- CV employment history: Keep formal titles with employer names
- Chinese job titles: Use 硬件工程师 (not 电气工程师) for hardware roles

## Analytics
- Google Analytics 4: Measurement ID `G-NTFWW409R9`
- Tracking code in `themes/elegant/layouts/partials/head.html`
- Dashboard: https://analytics.google.com

## Critical Gotchas

### Hugo Partials Directory
- Must be named `partials/` NOT `_partials/`
- Error: "partial head.html not found" means wrong directory name

### GitHub Pages Build
- `public/` folder must be in `.gitignore` - GitHub Actions builds fresh
- Hugo version specified in `.github/workflows/hugo.yml` (currently 0.121.0)
- Auto-deploys on push to `master` branch

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
- Live: https://zhulivictor.com and https://www.zhulivictor.com
- GitHub: https://github.com/victorzhuli/zhulivictor-website (public)
- GitHub Pages: victorzhuli.github.io/zhulivictor-website

## DNS (GoDaddy)
- A records: @ → GitHub Pages IPs (185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153)
- CNAME: www → victorzhuli.github.io

## Deployment
- Hosted on GitHub Pages (migrated from Netlify Jan 2026)
- Custom domain configured via `static/CNAME` file
- GitHub Actions workflow: `.github/workflows/hugo.yml`
- SSL/HTTPS provided by GitHub (Let's Encrypt)
