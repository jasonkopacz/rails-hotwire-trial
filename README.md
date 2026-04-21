# Photo Gallery

A full-stack photo gallery application built with Ruby on Rails and Hotwire (Turbo + Stimulus). Authenticated users can browse photos and like/unlike them — all without a separate API or client-side framework.

## Tech Stack

- **Ruby** 3.2.2 / **Rails** 7.1
- **SQLite3** (development & test)
- **Hotwire** — Turbo Streams for like updates, Stimulus for optimistic UI
- **Importmap** — no Node.js or webpack required
- **RSpec** + FactoryBot + Capybara (tests)

## Setup

```bash
git clone <repo-url>
cd photo-gallery
bundle install
rails db:create db:migrate db:seed
```

## Running the App

```bash
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000)

## Test Accounts

Two users are seeded automatically:

| Email             | Password    |
| ----------------- | ----------- |
| jason@example.com | password123 |
| bob@example.com   | password123 |

## Running Tests

```bash
bundle exec rspec
```

## Architecture Notes

### Authentication

Cookie-based session with `has_secure_password`. There is no sign-up flow — users are seeded via `db/seeds.rb`. The `ApplicationController` enforces `require_login` on every action; `SessionsController` skips it for the login page itself.

### Photo Seeding

Photos are seeded from `photos.csv` at setup time using Ruby's standard `CSV` library. The CSV is **not** read at runtime. `find_or_create_by!` makes seeds idempotent.

### Like Feature (Hotwire)

1. Each like button is wrapped in a `<div id="like-button-{photo_id}">` — a stable Turbo Stream target.
2. Clicking the button submits a `button_to` form (POST or DELETE).
3. Turbo intercepts the request and sends `Accept: text/vnd.turbo-stream.html`.
4. `LikesController` saves/destroys the like, then renders `create.turbo_stream.erb` or `destroy.turbo_stream.erb`.
5. The Turbo Stream response calls `turbo_stream.replace` to patch only the like button DOM node — no full page reload.

### Optimistic UI (Stimulus)

`like_controller.js` immediately flips the star icon and increments/decrements the count on click, before the server responds. If the server returns an error, a `turbo:submit-end` listener reverts the optimistic change.

### N+1 Prevention

`Photo.includes(:likes)` in `PhotosController#index` eager-loads all likes. The `_like_button` partial uses `photo.likes.find { |l| l.user_id == current_user.id }` to locate the current user's like in memory, avoiding any additional queries during collection rendering.

### Security

- Like `destroy` is scoped to `current_user.likes.find(params[:id])`, a user cannot delete another user's like.
- Database-level uniqueness constraint on `[user_id, photo_id]` in the `likes` table, backed by a model validation, prevents duplicate likes.
