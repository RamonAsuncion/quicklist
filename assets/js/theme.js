export function setupThemeToggle() {
  const themeToggle = document.getElementById("theme-toggle");
  const themeIcon = document.getElementById("theme-icon");
  const todoApp = document.getElementById("todo-app");
  const itemCount = document.getElementById("item-count");
  const footer = document.getElementById("footer");

  themeToggle.addEventListener("click", () => {
    const isDarkMode = document.body.classList.toggle("dark");
    document.body.classList.toggle("bg-gray-800", isDarkMode);
    document.body.classList.toggle("bg-gray-100", !isDarkMode);
    todoApp.classList.toggle("bg-white", !isDarkMode);
    todoApp.classList.toggle("bg-gray-800", isDarkMode);
    footer.classList.toggle("bg-white", !isDarkMode);
    footer.classList.toggle("bg-gray-800", isDarkMode);
    todoApp.classList.toggle("text-gray-800", !isDarkMode);
    todoApp.classList.toggle("text-white", isDarkMode);

    if (isDarkMode) {
      themeIcon.classList.remove("fa-sun", "text-gray-800");
      themeIcon.classList.add("fa-moon", "text-white");
      itemCount.classList.remove("text-gray-600");
      itemCount.classList.add("text-white");
    } else {
      themeIcon.classList.remove("fa-moon", "text-white");
      themeIcon.classList.add("fa-sun", "text-gray-800");
      itemCount.classList.remove("text-white");
      itemCount.classList.add("text-gray-600");
    }

    document.querySelectorAll(".todo-list label").forEach((label) => {
      label.classList.toggle("text-white", isDarkMode);
      label.classList.toggle("text-gray-800", !isDarkMode);
    });
  });
}
