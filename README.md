# Li Zhu - Personal Website

Personal academic website for Li Zhu, Staff Research Engineer II at Samsung Research America.

**Live site**: https://zhulivictor.com

## Tech Stack

- [Hugo](https://gohugo.io/) - Static site generator
- Custom "Elegant" theme - Classic professional design
- [Netlify](https://netlify.com/) - Hosting and deployment
- [GoDaddy](https://godaddy.com/) - Domain registration

## Project Structure

```
hugo-site/
├── content/           # Page content (Markdown)
│   ├── _index.md      # Home page
│   ├── cv.md          # Curriculum Vitae
│   ├── publications.md
│   ├── research.md
│   └── contact.md
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

## Documentation

See [WEBSITE_GUIDE.md](WEBSITE_GUIDE.md) for detailed maintenance instructions.

## License

All rights reserved. Content and design are proprietary.
