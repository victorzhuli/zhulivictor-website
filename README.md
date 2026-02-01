# Li Zhu - Personal Website

Personal academic website for Li Zhu (朱立), Digital Health Researcher & AI Innovator.

**Live site**: https://zhulivictor.com

## Features

- Bilingual support (English / 中文)
- Google Analytics tracking
- Responsive design
- Auto-deployment via Netlify

## Tech Stack

- [Hugo](https://gohugo.io/) - Static site generator
- Custom "Elegant" theme - Classic professional design
- [Netlify](https://netlify.com/) - Hosting and deployment
- [GoDaddy](https://godaddy.com/) - Domain registration

## Project Structure

```
hugo-site/
├── content/           # English content (Markdown)
│   ├── _index.md      # Home page
│   ├── cv.md          # Curriculum Vitae
│   ├── publications.md
│   ├── research.md
│   ├── teaching.md
│   └── contact.md
├── content/zh/        # Chinese content
│   ├── _index.md
│   ├── cv.md
│   └── ...
├── i18n/              # UI translations
│   ├── en.yaml
│   └── zh.yaml
├── themes/elegant/    # Custom theme
│   ├── assets/css/    # Stylesheets
│   ├── layouts/       # HTML templates
│   └── static/        # Static files (images, favicon)
├── hugo.toml          # Site configuration
└── netlify.toml       # Deployment configuration
```

## Local Development

```bash
# Preview site locally
hugo server

# Build site
hugo --minify
```

Visit http://localhost:1313 to preview.

## Deployment

Push to `master` branch to trigger automatic deployment via Netlify.

```bash
git add -A
git commit -m "Description of changes"
git push
```

## Updating Content

When editing pages, update both language versions:
- English: `content/<page>.md`
- Chinese: `content/zh/<page>.md`

## License

All rights reserved. Content and design are proprietary.
