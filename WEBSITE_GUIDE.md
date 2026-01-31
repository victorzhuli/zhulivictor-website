# Website Maintenance Guide

## Quick Reference

- **Local site folder**: `/Users/lizhu/.../personal website/hugo-site/`
- **Live site**: https://zhulivictor.com (or https://coruscating-pudding-876c7a.netlify.app)
- **GitHub repo**: https://github.com/victorzhuli/zhulivictor-website (private)
- **Netlify dashboard**: https://app.netlify.com

## How to Make Changes

### 1. Edit Content

Content files are in the `content/` folder:

| File | Purpose |
|------|---------|
| `_index.md` | Home page bio |
| `cv.md` | Full CV/resume |
| `publications.md` | Publications list |
| `research.md` | Research interests |
| `teaching.md` | Teaching & service |
| `contact.md` | Contact information |

Files use Markdown format with TOML frontmatter (the `+++` section at top).

### 2. Edit Design/Styling

- **CSS**: `themes/elegant/assets/css/main.css`
- **Layouts**: `themes/elegant/layouts/`
  - `baseof.html` - Base template
  - `home.html` - Home page layout
  - `page.html` - Standard page layout
- **Partials**: `themes/elegant/layouts/partials/`
  - `head.html` - HTML head section
  - `header.html` - Site navigation
  - `footer.html` - Site footer

### 3. Preview Locally

```bash
cd "/Users/lizhu/Library/CloudStorage/GoogleDrive-zhulivictor@gmail.com/My Drive/projects/personal/personal website/hugo-site"
hugo server
```

Then open http://localhost:1313 in your browser.

### 4. Deploy Changes

After making changes, run these commands:

```bash
cd "/Users/lizhu/Library/CloudStorage/GoogleDrive-zhulivictor@gmail.com/My Drive/projects/personal/personal website/hugo-site"

# Check what changed
git status

# Add all changes
git add -A

# Commit with a message
git commit -m "Your description of changes"

# Push to deploy
git push
```

Netlify automatically builds and deploys when you push to GitHub. Changes go live within 1-2 minutes.

## Key Colors (in main.css)

```css
--color-bg: #fdfbf7;          /* Page background */
--color-accent: #8b5a2b;       /* Brown accent color */
--color-link: #4a6fa5;         /* Link color */
--color-heading: #1a1a1a;      /* Heading color */
```

## Adding a New Page

1. Create a new file in `content/`, e.g., `content/newpage.md`
2. Add frontmatter:
   ```
   +++
   title = "Page Title"
   +++

   Your content here...
   ```
3. Add to navigation in `hugo.toml` under `[menus]` section

## Troubleshooting

- **Build fails on Netlify**: Check the deploy log for errors
- **Changes not showing**: Clear browser cache or wait a few minutes
- **Local preview not working**: Make sure you're in the hugo-site directory

## Tech Stack

- **Static site generator**: Hugo
- **Hosting**: Netlify (free tier)
- **Domain**: GoDaddy (DNS points to Netlify)
- **Theme**: Custom "elegant" theme
