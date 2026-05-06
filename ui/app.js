const state = {
  visible: false,
  categories: [],
  currentCategoryIndex: 2,
  currentTabIndex: 1,
  currentItemIndex: 1,
  playerName: "display menu",
  menuKeyLabel: "1",
  themeName: "Blue",
  selectingKey: false,
  selectingBind: false,
  inputOpen: false
};

const app = document.getElementById("app");
const playerName = document.getElementById("playerName");
const menuKey = document.getElementById("menuKey");
const themeName = document.getElementById("themeName");
const panelTitle = document.getElementById("panelTitle");
const contentTitle = document.getElementById("contentTitle");
const contentMeta = document.getElementById("contentMeta");
const categoryList = document.getElementById("categoryList");
const tabList = document.getElementById("tabList");
const sectionGrid = document.getElementById("sectionGrid");
const statusPills = document.getElementById("statusPills");
const closeButton = document.getElementById("closeButton");

const resourceName = typeof GetParentResourceName === "function" ? GetParentResourceName() : "arcane-menu";

function post(eventName, payload = {}) {
  return fetch(`https://${resourceName}/${eventName}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  }).catch(() => null);
}

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function formatValue(value) {
  if (typeof value === "number") {
    if (Math.abs(value - Math.round(value)) < 0.001) {
      return String(Math.round(value));
    }
    return value.toFixed(2).replace(/0+$/, "").replace(/\.$/, "");
  }
  if (typeof value === "boolean") {
    return value ? "On" : "Off";
  }
  return value == null ? "" : String(value);
}

function getCategoryMonogram(label) {
  const clean = String(label || "").trim();
  if (!clean) {
    return "AR";
  }
  return clean
    .split(/\s+/)
    .slice(0, 2)
    .map((chunk) => chunk[0])
    .join("")
    .toUpperCase();
}

function getCurrentCategory() {
  return state.categories.find((category) => category.categoryIndex === state.currentCategoryIndex) || state.categories[0] || null;
}

function getCurrentTab(category) {
  if (!category || !Array.isArray(category.tabs) || category.tabs.length === 0) {
    return null;
  }
  return category.tabs.find((tab) => tab.tabIndex === state.currentTabIndex) || category.tabs[0];
}

function buildSections(items) {
  const rows = Array.isArray(items) ? items : [];
  const sections = [];
  let currentSection = {
    title: "General",
    items: []
  };

  rows.forEach((item) => {
    if (item.kind === "separator") {
      if (currentSection.items.length > 0) {
        sections.push(currentSection);
      }
      currentSection = {
        title: item.label || "Section",
        items: []
      };
      return;
    }
    currentSection.items.push(item);
  });

  if (currentSection.items.length > 0) {
    sections.push(currentSection);
  }

  if (sections.length === 0) {
    return [{
      title: "Items",
      items: rows.filter((item) => item.kind !== "separator")
    }];
  }

  return sections;
}

function setVisible(visible) {
  state.visible = !!visible;
  app.classList.toggle("is-hidden", !state.visible);
}

function setAccent(accentColor) {
  if (!accentColor || typeof accentColor !== "object") {
    return;
  }
  const r = clamp(Number(accentColor.r) || 0, 0, 255);
  const g = clamp(Number(accentColor.g) || 0, 0, 255);
  const b = clamp(Number(accentColor.b) || 0, 0, 255);
  document.documentElement.style.setProperty("--accent-rgb", `${r}, ${g}, ${b}`);
}

function renderStatus() {
  const pills = [];

  pills.push(`<span class="status-pill is-accent">${state.themeName || "Theme"}</span>`);

  if (state.selectingKey) {
    pills.push('<span class="status-pill">Capturing menu key</span>');
  }
  if (state.selectingBind) {
    pills.push('<span class="status-pill">Capturing bind</span>');
  }
  if (state.inputOpen) {
    pills.push('<span class="status-pill">Text input active</span>');
  }

  statusPills.innerHTML = pills.join("");
}

function renderCategories() {
  categoryList.innerHTML = state.categories.map((category) => {
    const active = category.categoryIndex === state.currentCategoryIndex ? " is-active" : "";
    return `
      <button class="category-button${active}" type="button" data-category-index="${category.categoryIndex}">
        <span class="category-button__mono">${getCategoryMonogram(category.label)}</span>
        <span class="category-button__text">${category.label}</span>
      </button>
    `;
  }).join("");
}

function renderTabs(category) {
  const tabs = category && Array.isArray(category.tabs) ? category.tabs : [];
  tabList.innerHTML = tabs.map((tab) => {
    const active = tab.tabIndex === state.currentTabIndex ? " is-active" : "";
    return `<button class="tab-button${active}" type="button" data-tab-index="${tab.tabIndex}">${tab.label}</button>`;
  }).join("");
}

function renderActionControls(categoryIndex, tabIndex, item) {
  const bind = item.bindLabel ? `<span class="bind-chip">${item.bindLabel}</span>` : "";

  if (item.kind === "toggle") {
    const sliderStack = item.sliderValue !== undefined ? `
      <div class="slider-stack">
        <span class="slider-readout">${formatValue(item.sliderValue)}</span>
        <input
          class="slider-input"
          type="range"
          min="${Number(item.sliderMin ?? 0)}"
          max="${Number(item.sliderMax ?? 100)}"
          step="${Number(item.sliderStep ?? 0.1)}"
          value="${Number(item.sliderValue ?? item.sliderMin ?? 0)}"
          data-slider-item="${item.itemIndex}"
          data-category-index="${categoryIndex}"
          data-tab-index="${tabIndex}"
          data-mode="toggle-slider"
        >
      </div>
    ` : "";

    return `
      <div class="option-row__stack">
        <div class="option-row__controls">
          ${bind}
          <button
            class="toggle-button${item.enabled ? " is-on" : ""}"
            type="button"
            data-primary-item="${item.itemIndex}"
            data-category-index="${categoryIndex}"
            data-tab-index="${tabIndex}"
          ></button>
        </div>
        ${sliderStack}
      </div>
    `;
  }

  if (item.kind === "slider") {
    return `
      <div class="slider-stack">
        <span class="slider-readout">${formatValue(item.value)}</span>
        <input
          class="slider-input"
          type="range"
          min="${Number(item.min ?? 0)}"
          max="${Number(item.max ?? 100)}"
          step="${Number(item.step ?? 1)}"
          value="${Number(item.value ?? item.min ?? 0)}"
          data-slider-item="${item.itemIndex}"
          data-category-index="${categoryIndex}"
          data-tab-index="${tabIndex}"
          data-mode="slider"
        >
      </div>
    `;
  }

  if (item.kind === "selector" || item.kind === "toggle_selector") {
    const toggle = item.kind === "toggle_selector" ? `
      <button
        class="toggle-button${item.enabled ? " is-on" : ""}"
        type="button"
        data-primary-item="${item.itemIndex}"
        data-category-index="${categoryIndex}"
        data-tab-index="${tabIndex}"
      ></button>
    ` : "";

    return `
      <div class="option-row__controls">
        ${bind}
        <div class="selector">
          <button
            class="selector-button"
            type="button"
            data-adjust-item="${item.itemIndex}"
            data-direction="-1"
            data-category-index="${categoryIndex}"
            data-tab-index="${tabIndex}"
          >-</button>
          <div class="selector-value">${formatValue(item.displayValue)}</div>
          <button
            class="selector-button"
            type="button"
            data-adjust-item="${item.itemIndex}"
            data-direction="1"
            data-category-index="${categoryIndex}"
            data-tab-index="${tabIndex}"
          >+</button>
        </div>
        ${toggle}
      </div>
    `;
  }

  return `
    <div class="option-row__controls">
      ${bind}
      <button
        class="control-button"
        type="button"
        data-primary-item="${item.itemIndex}"
        data-category-index="${categoryIndex}"
        data-tab-index="${tabIndex}"
      >
        ${item.kind === "action" ? "Run" : "Select"}
      </button>
    </div>
  `;
}

function renderSections(category, tab) {
  if (!category || !tab) {
    sectionGrid.innerHTML = '<div class="empty-card">No content available.</div>';
    contentMeta.textContent = "0 options";
    return;
  }

  const sections = buildSections(tab.items || []);
  const flatCount = (tab.items || []).filter((item) => item.kind !== "separator").length;
  contentMeta.textContent = `${flatCount} option${flatCount === 1 ? "" : "s"}`;

  sectionGrid.innerHTML = sections.map((section) => `
    <article class="section-card">
      <header class="section-card__header">
        <span class="section-card__title">${section.title}</span>
      </header>
      <div class="section-card__body">
        ${section.items.map((item) => `
          <div class="option-row">
            <div class="option-row__main">
              <span class="option-row__label">${item.label}</span>
              <span class="option-row__meta">${item.kind.replace(/_/g, " ")}</span>
            </div>
            ${renderActionControls(category.categoryIndex, tab.tabIndex, item)}
          </div>
        `).join("")}
      </div>
    </article>
  `).join("");
}

function render() {
  setVisible(state.visible);
  playerName.textContent = state.playerName || "display menu";
  menuKey.textContent = state.menuKeyLabel || "1";
  themeName.textContent = `${state.themeName || "Blue"} theme`;
  renderStatus();
  renderCategories();

  const category = getCurrentCategory();
  const tab = getCurrentTab(category);

  panelTitle.textContent = category ? category.label : "Arcane";
  contentTitle.textContent = tab ? tab.label : "Overview";

  renderTabs(category);
  renderSections(category, tab);
}

function handleMessage(data) {
  if (!data || typeof data !== "object") {
    return;
  }

  if (data.action !== "arcane:setState") {
    return;
  }

  if (data.visible === false) {
    state.visible = false;
    render();
    return;
  }

  state.visible = !!data.visible;
  state.categories = Array.isArray(data.categories) ? data.categories : [];
  state.currentCategoryIndex = Number(data.currentCategoryIndex) || 2;
  state.currentTabIndex = Number(data.currentTabIndex) || 1;
  state.currentItemIndex = Number(data.currentItemIndex) || 1;
  state.playerName = data.playerName || "display menu";
  state.menuKeyLabel = data.menuKeyLabel || "1";
  state.themeName = data.themeName || "Blue";
  state.selectingKey = !!data.selectingKey;
  state.selectingBind = !!data.selectingBind;
  state.inputOpen = !!data.inputOpen;
  setAccent(data.accentColor);
  render();
}

closeButton.addEventListener("click", () => {
  post("arcaneClose");
});

document.addEventListener("click", (event) => {
  const categoryButton = event.target.closest(".category-button");
  if (categoryButton) {
    const categoryIndex = Number(categoryButton.dataset.categoryIndex);
    post("arcaneSelectCategory", { categoryIndex });
    return;
  }

  const tabButton = event.target.closest(".tab-button");
  if (tabButton) {
    const tabIndex = Number(tabButton.dataset.tabIndex);
    post("arcaneSelectTab", { tabIndex });
    return;
  }

  const primaryButton = event.target.closest("[data-primary-item]");
  if (primaryButton) {
    post("arcaneItemPrimary", {
      categoryIndex: Number(primaryButton.dataset.categoryIndex),
      tabIndex: Number(primaryButton.dataset.tabIndex),
      itemIndex: Number(primaryButton.dataset.primaryItem)
    });
    return;
  }

  const adjustButton = event.target.closest("[data-adjust-item]");
  if (adjustButton) {
    post("arcaneItemAdjust", {
      categoryIndex: Number(adjustButton.dataset.categoryIndex),
      tabIndex: Number(adjustButton.dataset.tabIndex),
      itemIndex: Number(adjustButton.dataset.adjustItem),
      direction: Number(adjustButton.dataset.direction)
    });
  }
});

document.addEventListener("input", (event) => {
  const slider = event.target.closest("[data-slider-item]");
  if (!slider) {
    return;
  }

  const min = Number(slider.min || 0);
  const max = Number(slider.max || 100);
  const value = Number(slider.value || min);
  const percent = max === min ? 0 : (value - min) / (max - min);

  post("arcaneItemSlider", {
    categoryIndex: Number(slider.dataset.categoryIndex),
    tabIndex: Number(slider.dataset.tabIndex),
    itemIndex: Number(slider.dataset.sliderItem),
    percent
  });
});

window.addEventListener("keydown", (event) => {
  if (!state.visible) {
    return;
  }

  if (event.key === "Escape" || event.key === "Backspace") {
    event.preventDefault();
    post("arcaneClose");
  }
});

window.addEventListener("message", (event) => {
  handleMessage(event.data);
});

post("arcaneReady");
render();
