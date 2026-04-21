import { Controller } from "@hotwired/stimulus"

// Provides optimistic UI for like/unlike: updates the count and icon immediately
// on click, then lets the Turbo Stream response replace the element with server truth.
export default class extends Controller {
  static targets = ["count"]

  optimisticToggle(event) {
    const btn       = this.element.querySelector(".like-btn")
    const countEl   = this.countTarget
    const isLiked   = btn.classList.contains("like-btn--active")
    const delta     = isLiked ? -1 : 1

    // Optimistically update count and visual state
    countEl.textContent = Math.max(0, parseInt(countEl.textContent, 10) + delta)
    btn.classList.toggle("like-btn--active", !isLiked)
    btn.setAttribute("aria-pressed", String(!isLiked))

    // Listen for failure so we can revert
    this.element.addEventListener("turbo:submit-end", this.handleResponse.bind(this), { once: true })
  }

  handleResponse(event) {
    if (!event.detail.success) {
      // Server rejected — revert the optimistic change
      const btn     = this.element.querySelector(".like-btn")
      const countEl = this.countTarget
      const isLiked = btn.classList.contains("like-btn--active")
      const delta   = isLiked ? -1 : 1

      countEl.textContent = Math.max(0, parseInt(countEl.textContent, 10) + delta)
      btn.classList.toggle("like-btn--active", !isLiked)
      btn.setAttribute("aria-pressed", String(!isLiked))
    }
  }
}
