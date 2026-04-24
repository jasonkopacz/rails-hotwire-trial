# Clever's Rails + Hotwire Coding Interview

Welcome to Clever's full-stack coding challenge. You'll build a small but complete web application using **Ruby on Rails** and **Hotwire** (Turbo + Stimulus). The goal is to assess how you think about Rails conventions, server-rendered interactivity, and clean UI without a heavy JavaScript framework.

---

## The Challenge

Build a photo gallery application where authenticated users can browse and "like" photos — all without writing a separate API or client-side SPA.

---

## Requirements

### 1. Authentication

- A sign-in page that gates access to the rest of the app
- Users who are not signed in should be redirected to sign in
- You may use any approach you prefer: `has_secure_password`, Devise, or a simple session-based system
- No sign-up flow is needed — seed one or more users directly in `db/seeds.rb`

### 2. Photo Gallery

- Display all 10 photos from the provided `photos.csv` on a single "All Photos" page
- Seed the photos into your database from the CSV — do not read the CSV at runtime
- Each photo card should show:
  - The photo image (use the `src.medium` URL)
  - The photographer's name
  - A link icon + the photo's source URL (use `links.svg`)
  - A like button with the current like count (use `star-fill.svg` and `star-line.svg`)

### 3. Like Functionality (Hotwire)

- Signed-in users can like and unlike any photo
- **Likes must update without a full page reload** — use Turbo Streams or Turbo Frames
- Like counts must persist in the database
- Each user can like a photo only once

### 4. No JavaScript Frameworks

The interactivity must be implemented with **Hotwire** (Turbo + optionally Stimulus). Do not use React, Vue, or any other JS framework.

---

## Bonus

- Mobile-responsive layout
- A Stimulus controller for any client-side behavior (e.g. optimistic UI, toggling state)
- Meaningful test coverage (RSpec or Minitest)

---

## Assets Provided

| File | Purpose |
|------|---------|
| `photos.csv` | Photo data — seed this into your database |
| `logo.svg` | Clever "Ci" logo for the nav/header |
| `links.svg` | Link icon for each photo card |
| `star-fill.svg` | Filled star — shown when a photo is liked |
| `star-line.svg` | Outline star — shown when a photo is not liked |

---

## Getting Started

There is no starter application. Create a new Rails app from scratch:

```bash
rails new photo-gallery --database=sqlite3
cd photo-gallery
```

Hotwire (Turbo + Stimulus) ships with Rails 7+ by default. If you're on Rails 6, add:

```ruby
# Gemfile
gem "hotwire-rails"
```

---

## What We're Looking For

| Area | What to demonstrate |
|------|-------------------|
| **Rails conventions** | Resourceful routing, skinny controllers, proper use of models |
| **Hotwire / Turbo** | Turbo Streams or Frames for the like feature — not polling, not custom fetch |
| **Database design** | Appropriate models, associations, and constraints |
| **HTML/CSS** | Clean, readable markup; reasonable styling without a heavy framework |
| **Code quality** | Clear naming, no unnecessary complexity, code you'd be comfortable reviewing |

---

## Time

Most candidates complete the core requirements in 2–4 hours. If you run out of time, leave notes in your README describing what you'd do next rather than rushing.

---

## Submission

1. Fork this repository
2. Build your application in the fork (the Rails app can live at the repo root or in a subdirectory)
3. Include setup instructions in your README so we can run it locally
4. Open a pull request back to this repository
5. Email your recruiter point of contact

Questions? Reach out to nick.clucas@movewithclever.com

---

## Design Reference

The UI doesn't need to be pixel-perfect, but aim for something clean and usable. A photo card should convey the image, photographer credit, source link, and like action clearly. Use the Clever brand color `#0075EB` where appropriate.
