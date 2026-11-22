// RFC 一覧の絞り込み
(function () {
  "use strict";

  const list = document.querySelector(".rfc-list");
  const input = document.getElementById("q");
  const ranges = document.querySelector(".ranges");
  const result = document.querySelector(".result");
  const empty = document.querySelector(".empty");
  const toolbar = document.querySelector(".toolbar");
  const toTop = document.querySelector(".to-top");
  if (!list || !input) return;

  // 全角英数字や大文字小文字の違いを吸収する
  const normalize = (s) => s.normalize("NFKC").toLowerCase().replace(/\s+/g, " ").trim();

  const items = Array.from(list.children, (li) => {
    const href = li.querySelector("a").getAttribute("href");
    const number = parseInt(href.replace(/\D/g, ""), 10);
    return {
      li,
      number,
      bucket: Math.floor(number / 1000) * 1000,
      text: normalize("rfc" + number + " " + li.textContent),
    };
  });

  // 統計
  const total = items.length;
  document.querySelectorAll("[data-stat]").forEach((el) => {
    const stat = el.dataset.stat;
    let value = "";
    if (stat === "total") value = total.toLocaleString("ja-JP");
    if (stat === "latest") value = "RFC " + Math.max(...items.map((i) => i.number));
    el.textContent = value;
  });

  // 番号の範囲（1000 件ごと）
  const counts = new Map();
  for (const item of items) counts.set(item.bucket, (counts.get(item.bucket) || 0) + 1);
  const buckets = Array.from(counts.keys()).sort((a, b) => b - a);
  const makeButton = (value, label, count) => {
    const button = document.createElement("button");
    button.type = "button";
    button.dataset.value = value;
    button.setAttribute("aria-pressed", "false");
    button.textContent = label;
    const span = document.createElement("span");
    span.className = "count";
    span.textContent = count.toLocaleString("ja-JP");
    button.append(span);
    ranges.append(button);
  };
  makeButton("", "すべて", total);
  for (const b of buckets) makeButton(String(b), (b === 0 ? 1 : b) + "–" + (b + 999), counts.get(b));

  let range = "";
  const setRange = (value) => {
    range = value;
    for (const button of ranges.children) {
      button.setAttribute("aria-pressed", String(button.dataset.value === range));
    }
  };

  const apply = () => {
    const query = normalize(input.value);
    // 「RFC 9110」と「rfc9110」を同じように扱う
    const terms = query.replace(/\brfc\s+(?=\d)/g, "rfc").split(" ").filter(Boolean);
    const bucket = range === "" ? null : Number(range);
    let shown = 0;
    for (const item of items) {
      const match =
        (bucket === null || item.bucket === bucket) && terms.every((t) => item.text.includes(t));
      if (item.li.hidden === match) item.li.hidden = !match;
      if (match) shown++;
    }
    list.hidden = shown === 0;
    empty.hidden = shown !== 0;
    result.textContent =
      shown === total
        ? total.toLocaleString("ja-JP") + " 件"
        : shown.toLocaleString("ja-JP") + " / " + total.toLocaleString("ja-JP") + " 件";

    // 検索条件を URL に残して共有できるようにする
    const params = new URLSearchParams();
    if (input.value.trim()) params.set("q", input.value.trim());
    if (range) params.set("range", range);
    const search = params.toString();
    history.replaceState(null, "", search ? "?" + search : location.pathname);
  };

  let pending = 0;
  const schedule = () => {
    cancelAnimationFrame(pending);
    pending = requestAnimationFrame(apply);
  };

  const params = new URLSearchParams(location.search);
  input.value = params.get("q") || "";
  const initialRange = params.get("range");
  setRange(initialRange && counts.has(Number(initialRange)) ? initialRange : "");
  const pressed = ranges.querySelector('[aria-pressed="true"]');
  ranges.scrollLeft = pressed.offsetLeft - ranges.offsetLeft;
  apply();

  input.addEventListener("input", schedule);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      input.value = "";
      schedule();
    } else if (e.key === "Enter") {
      // 1 件に絞れたらそのまま開く
      const visible = items.filter((i) => !i.li.hidden);
      if (visible.length === 1) location.href = visible[0].li.querySelector("a").href;
    }
  });
  ranges.addEventListener("click", (e) => {
    const button = e.target.closest("button");
    if (!button) return;
    setRange(button.dataset.value === range ? "" : button.dataset.value);
    apply();
  });

  // 「/」で検索欄に移動する
  document.addEventListener("keydown", (e) => {
    if (e.key !== "/" || e.ctrlKey || e.metaKey || e.altKey) return;
    const tag = document.activeElement && document.activeElement.tagName;
    if (tag === "INPUT" || tag === "TEXTAREA") return;
    e.preventDefault();
    input.focus();
    input.select();
  });

  // 検索欄が上端に貼り付いたら背景を付ける
  const sentinel = document.createElement("div");
  toolbar.before(sentinel);
  new IntersectionObserver(([entry]) => {
    toolbar.classList.toggle("stuck", !entry.isIntersecting);
    toTop.classList.toggle("show", !entry.isIntersecting);
  }).observe(sentinel);
  toTop.addEventListener("click", () => {
    window.scrollTo({ top: 0 });
    input.focus({ preventScroll: true });
  });
})();
