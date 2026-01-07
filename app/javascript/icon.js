// include only the icons you need.
import { createIcons, icons } from "lucide";

function renderLucideIcons() {
  // gunakan setTimeout agar DOM sudah siap sepenuhnya
  setTimeout(() => createIcons({ icons }), 0);
}

document.addEventListener("turbo:load", renderLucideIcons);
document.addEventListener("turbo:render", renderLucideIcons);
document.addEventListener("turbo:frame-load", renderLucideIcons);
document.addEventListener("turbo:submit-end", renderLucideIcons);

// Tambahan penting: untuk Turbo Stream (replace, update, prepend, dll)
document.addEventListener("turbo:before-stream-render", (event) => {
  // tangkap target yang akan diganti
  const target = event.target;

  // setelah diganti, render ulang ikon lucide
  event.detail.render = (streamElement) => {
    streamElement.performAction();
    renderLucideIcons();
  };
});
