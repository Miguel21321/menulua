const app = document.getElementById("app");
const root = document.getElementById("root");

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function escapeHtml(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function px(value) {
  return `${Math.round(Number(value) || 0)}px`;
}

function rectStyle(rect) {
  if (!rect) {
    return "";
  }
  return `left:${px(rect.x)};top:${px(rect.y)};width:${px(rect.w)};height:${px(rect.h)};`;
}

function relRectStyle(rect, parentRect) {
  if (!rect || !parentRect) {
    return "";
  }
  return `left:${px((rect.x || 0) - (parentRect.x || 0))};top:${px((rect.y || 0) - (parentRect.y || 0))};width:${px(rect.w)};height:${px(rect.h)};`;
}

function setAccent(accent) {
  const r = clamp(Number(accent?.r) || 0, 0, 255);
  const g = clamp(Number(accent?.g) || 221, 0, 255);
  const b = clamp(Number(accent?.b) || 255, 0, 255);
  document.documentElement.style.setProperty("--accent-rgb", `${r}, ${g}, ${b}`);
}

function renderPill(text, className, style) {
  return `<div class="dui-pill ${className || ""}" style="${style || ""}">${escapeHtml(text)}</div>`;
}

function renderToggle(rect, enabled, parentRect) {
  if (!rect) {
    return "";
  }
  const knobSize = Math.max(10, (rect.h || 0) - 4);
  const knobLeft = enabled ? ((rect.w || 0) - knobSize - 2) : 2;
  return `
    <div class="dui-toggle ${enabled ? "is-on" : ""}" style="${relRectStyle(rect, parentRect)}">
      <div class="dui-toggle-knob" style="left:${px(knobLeft)};width:${px(knobSize)};height:${px(knobSize)};"></div>
    </div>
  `;
}

function renderSlider(rect, percent, parentRect) {
  if (!rect) {
    return "";
  }
  const pct = clamp(Number(percent) || 0, 0, 1);
  return `
    <div class="dui-slider-track" style="${relRectStyle(rect, parentRect)}">
      <div class="dui-slider-fill" style="width:${pct * 100}%;"></div>
      <div class="dui-slider-knob" style="left:${pct * 100}%;top:${px((rect.h || 0) / 2)};"></div>
    </div>
  `;
}

function renderSelector(row, parentRect) {
  if (!row.selectorRect) {
    return "";
  }
  const width = Number(row.selectorRect.w) || 0;
  return `
    <div class="dui-selector" style="${relRectStyle(row.selectorRect, parentRect)}">
      <div class="dui-selector-arrow" style="left:0;top:0;width:28px;height:100%;">&lt;</div>
      <div class="dui-selector-value" style="left:28px;top:0;width:${px(Math.max(0, width - 56))};height:100%;">${escapeHtml(row.displayValue ?? "")}</div>
      <div class="dui-selector-arrow" style="right:0;top:0;width:28px;height:100%;">&gt;</div>
    </div>
  `;
}

function renderAction(row, parentRect) {
  if (!row.buttonRect) {
    return "";
  }
  return `
    <div class="dui-action" style="${relRectStyle(row.buttonRect, parentRect)}">
      <div class="dui-button-label" style="inset:0;">${escapeHtml(row.buttonLabel || "Execute")}</div>
    </div>
  `;
}

function renderValuePill(row, parentRect) {
  if (!row.valueRect || row.valueText == null) {
    return "";
  }
  return renderPill(row.valueText, "", relRectStyle({
    x: row.valueRect.x - 6,
    y: row.valueRect.y - 4,
    w: row.valueRect.w + 18,
    h: 28
  }, parentRect));
}

function renderRow(row, sectionRect) {
  if (!row?.rowRect || row.visible === false) {
    return "";
  }

  const labelTop = row.kind === "slider" || (row.kind === "toggle" && row.sliderRect) ? 5 : 10;
  const bindHtml = row.bindLabel
    ? renderPill(`[${row.bindLabel}]`, "", relRectStyle({
        x: row.rowRect.x + 14 + Math.max(42, row.label.length * 7),
        y: row.rowRect.y + 4,
        w: Math.max(54, row.bindLabel.length * 8 + 16),
        h: 24
      }, sectionRect)).replace("dui-pill ", "dui-pill dui-bind ")
    : "";

  let controlsHtml = "";
  if (row.kind === "toggle") {
    controlsHtml += renderToggle(row.toggleRect, row.enabled, sectionRect);
    controlsHtml += renderSlider(row.sliderRect, row.sliderPercent, sectionRect);
    controlsHtml += renderValuePill(row, sectionRect);
  } else if (row.kind === "slider") {
    controlsHtml += renderSlider(row.sliderRect, row.sliderPercent, sectionRect);
    controlsHtml += renderValuePill(row, sectionRect);
  } else if (row.kind === "selector" || row.kind === "toggle_selector") {
    controlsHtml += renderSelector(row, sectionRect);
    controlsHtml += renderToggle(row.toggleRect, row.enabled, sectionRect);
  } else if (row.kind === "action") {
    controlsHtml += renderAction(row, sectionRect);
  }

  return `
    <div class="dui-row ${row.selected ? "is-selected" : ""} ${row.hover ? "is-hover" : ""}" style="${relRectStyle(row.rowRect, sectionRect)}">
      ${row.selected ? '<div class="dui-row-accent"></div>' : ""}
      <div class="dui-row-label" style="left:${px(12)};top:${px(labelTop)};">${escapeHtml(row.label)}</div>
      ${bindHtml}
      ${controlsHtml}
    </div>
  `;
}

function renderSection(section) {
  if (!section?.rect || section.visible === false) {
    return "";
  }

  const countWidth = Math.max(32, String(section.count || 0).length * 9 + 18);
  return `
    <section class="dui-section" style="${rectStyle(section.rect)}">
      <div class="dui-section-line"></div>
      <div class="dui-section-title" style="left:18px;top:16px;">${escapeHtml(section.title)}</div>
      ${renderPill(section.count || 0, "dui-section-count", `right:14px;top:11px;width:${px(countWidth)};`)}
      ${(section.rows || []).map((row) => renderRow(row, section.rect)).join("")}
    </section>
  `;
}

function renderSummary(summary) {
  if (!summary?.rect) {
    return "";
  }

  const infoLines = (summary.info || []).map((entry, index) => {
    const top = 74 + (index * 46);
    return `
      <div class="dui-summary-label" style="left:18px;top:${px(top)};">${escapeHtml(entry.label)}</div>
      <div class="dui-summary-value" style="left:18px;top:${px(top + 15)};">${escapeHtml(entry.value)}</div>
    `;
  }).join("");

  const helpBase = Math.max(170, (summary.rect.h || 0) - 114);
  const helpLines = (summary.help || []).map((line, index) => `
    <div class="dui-help-line" style="left:14px;top:${px(34 + (index * 18))};">${escapeHtml(line)}</div>
  `).join("");

  return `
    <section class="dui-summary-card" style="${rectStyle(summary.rect)}">
      <div class="dui-section-line"></div>
      <div class="dui-summary-title" style="left:18px;top:16px;">Overview</div>
      <div class="dui-summary-subtitle" style="left:18px;top:38px;">Shortcuts and state for this module.</div>
      ${infoLines}
      <div class="dui-help-box" style="left:18px;top:${px(helpBase)};width:${px((summary.rect.w || 0) - 36)};height:84px;">
        <div class="dui-help-title" style="left:14px;top:14px;">Controls</div>
        ${helpLines}
      </div>
    </section>
  `;
}

function renderCategory(button) {
  if (!button?.rect) {
    return "";
  }
  return `
    <div class="dui-category ${button.active ? "is-active" : ""} ${button.hover ? "is-hover" : ""}" style="${rectStyle(button.rect)}">
      <div class="dui-category-mono">${escapeHtml(button.mono || "AR")}</div>
      <div class="dui-category-main">
        <div class="dui-category-label">${escapeHtml(button.label)}</div>
        <div class="dui-category-meta">${button.active ? "module active" : "module"}</div>
      </div>
    </div>
  `;
}

function renderTab(button) {
  if (!button?.rect) {
    return "";
  }
  return `<div class="dui-tab ${button.active ? "is-active" : ""} ${button.hover ? "is-hover" : ""}" style="${rectStyle(button.rect)}">${escapeHtml(button.label)}</div>`;
}

function renderState(data) {
  if (!data?.visible) {
    app.classList.add("is-hidden");
    root.innerHTML = "";
    return;
  }

  setAccent(data.accentColor);
  app.classList.remove("is-hidden");

  const layout = data.layout || {};
  const panel = layout.panel || { x: 0, y: 0, w: 1280, h: 720 };
  const searchRect = layout.searchRect || { x: panel.x + 16, y: panel.y + 72, w: 220, h: 58 };
  const heroRect = layout.heroRect || { x: panel.x + 280, y: panel.y + 120, w: 800, h: 58 };
  const sidebarWidth = Number(layout.sidebarWidth) || 250;
  const mainX = Number(layout.mainX) || (panel.x + sidebarWidth);
  const mainWidth = Number(layout.mainWidth) || (panel.w - sidebarWidth);
  const padding = Number(layout.padding) || 18;
  const footerHeight = Number(layout.footerHeight) || 34;
  const footerY = panel.y + panel.h - footerHeight;
  const bandRect = {
    x: mainX + padding,
    y: panel.y + 18,
    w: Math.max(120, mainWidth - (padding * 2)),
    h: 72
  };
  const brandRect = {
    x: panel.x + padding,
    y: panel.y + 20,
    w: sidebarWidth - (padding * 2),
    h: 48
  };
  const headerTitleX = mainX + padding;
  const keyText = data.header?.keyText || "";
  const themeText = data.header?.themeText || "";
  const keyWidth = Math.max(92, keyText.length * 7 + 22);
  const themeWidth = Math.max(92, themeText.length * 7 + 22);
  const keyPillRect = {
    x: panel.x + panel.w - padding - keyWidth,
    y: panel.y + 20,
    w: keyWidth,
    h: 28
  };
  const themePillRect = {
    x: keyPillRect.x - 10 - themeWidth,
    y: panel.y + 20,
    w: themeWidth,
    h: 28
  };
  const searchPillWidth = Math.max(92, (data.sidebarBadge?.pill || "").length * 7 + 18);
  const searchPillRect = {
    x: searchRect.x + searchRect.w - searchPillWidth - 16,
    y: searchRect.y + 12,
    w: searchPillWidth,
    h: 24
  };
  const contentArea = layout.contentArea || heroRect;
  const footerLeftWidth = Math.max(160, (data.footer?.left || "").length * 7);
  const footerCenterWidth = Math.max(170, (data.footer?.center || "").length * 7);
  const footerRightWidth = Math.max(70, (data.footer?.right || "").length * 7);

  root.innerHTML = `
    <div class="dui-backdrop"></div>
    <div class="dui-panel-shadow" style="${rectStyle({ x: panel.x + 12, y: panel.y + 18, w: panel.w, h: panel.h })}"></div>
    <div class="dui-panel" style="${rectStyle(panel)}"></div>
    <div class="dui-sidebar" style="${rectStyle({ x: panel.x, y: panel.y, w: sidebarWidth, h: panel.h })}"></div>
    <div class="dui-main" style="${rectStyle({ x: mainX, y: panel.y, w: mainWidth, h: panel.h })}"></div>
    <div class="dui-top-band" style="${rectStyle(bandRect)}"></div>
    <div class="dui-footer" style="${rectStyle({ x: panel.x, y: footerY, w: panel.w, h: footerHeight })}"></div>

    <div class="dui-brand" style="${rectStyle(brandRect)}">
      <div class="dui-brand-mark">A</div>
      <div>
        <div class="dui-brand-title">${escapeHtml(data.brand?.title || "arcane")}</div>
        <div class="dui-brand-subtitle">${escapeHtml(data.brand?.subtitle || "display menu")}</div>
      </div>
    </div>

    <div class="dui-search" style="${rectStyle(searchRect)}">
      <div class="dui-search-title">${escapeHtml(data.sidebarBadge?.title || "")}</div>
      ${renderPill(data.sidebarBadge?.pill || "", "", rectStyle(searchPillRect))}
      <div class="dui-search-subtitle">${escapeHtml(data.sidebarBadge?.subtitle || "")}</div>
    </div>

    ${(data.map?.categoryButtons || []).map(renderCategory).join("")}

    <div class="dui-header-title" style="left:${px(headerTitleX)};top:${px(panel.y + 18)};">${escapeHtml(data.header?.title || "Arcane")}</div>
    <div class="dui-header-subtitle" style="left:${px(headerTitleX)};top:${px(panel.y + 48)};">${escapeHtml(data.header?.subtitle || "")}</div>
    ${renderPill(themeText, "is-accent", rectStyle(themePillRect))}
    ${renderPill(keyText, "", rectStyle(keyPillRect))}

    ${(data.map?.tabButtons || []).map(renderTab).join("")}

    <div class="dui-hero-card" style="${rectStyle({ x: contentArea.x, y: contentArea.y, w: contentArea.w, h: Math.max(58, heroRect.h || 58) })}"></div>
    <div class="dui-hero-title" style="left:${px(heroRect.x + 16)};top:${px(heroRect.y + 12)};">${escapeHtml(data.hero?.title || "")}</div>
    <div class="dui-hero-subtitle" style="left:${px(heroRect.x + 16)};top:${px(heroRect.y + 33)};">${escapeHtml(data.hero?.subtitle || "")}</div>

    ${(data.map?.sections || []).map(renderSection).join("")}
    ${renderSummary(data.map?.summary)}

    ${layout.scrollbarTrack ? `<div class="dui-scroll-track" style="${rectStyle(layout.scrollbarTrack)}"></div>` : ""}
    ${layout.scrollbarThumb ? `<div class="dui-scroll-thumb" style="${rectStyle(layout.scrollbarThumb)}"></div>` : ""}

    <div class="dui-footer-left" style="left:${px(panel.x + 16)};top:${px(footerY + 10)};width:${px(footerLeftWidth)};">${escapeHtml(data.footer?.left || "")}</div>
    <div class="dui-footer-center" style="left:${px(panel.x + Math.max(0, (panel.w - footerCenterWidth) / 2))};top:${px(footerY + 10)};width:${px(footerCenterWidth)};text-align:center;">${escapeHtml(data.footer?.center || "")}</div>
    <div class="dui-footer-right" style="left:${px(panel.x + panel.w - footerRightWidth - 16)};top:${px(footerY + 10)};width:${px(footerRightWidth)};text-align:right;">${escapeHtml(data.footer?.right || "")}</div>
  `;
}

window.addEventListener("message", (event) => {
  const data = event.data;
  if (!data || typeof data !== "object") {
    return;
  }

  if (data.action === "arcane:duiState") {
    renderState(data);
  }
});
