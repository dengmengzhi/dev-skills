# hover 动效（hover）

**仅 PC 端。** H5 没有 hover，对应场景换 `feedback.md` 里的点击反馈或 `entrance.md` 的入场提示。所有 hover 都要写在 `@media (hover: hover)` 内，避免触屏设备误触发粘滞态。

### hv-01  卡片抬升（card-lift）

- 区块：卡片 / 列表
- 风格：内容 / 企业 / 活泼
- 触发：hover
- 端：PC
- 时长/缓动：200ms ease-out
- 性能：合成层（box-shadow 过渡有绘制成本，卡片数量多时改用伪元素阴影 opacity 过渡）
- 依赖：无
- 说明：最常见的卡片 hover。上移 4px + 阴影加深。奢华风改为只加深阴影不位移。

```css
@media (hover: hover) {
  .card { transition: transform 200ms ease-out, box-shadow 200ms ease-out; }
  .card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,.12); }
}
@media (prefers-reduced-motion: reduce) {
  .card { transition: none; }
  .card:hover { transform: none; }
}
```

### hv-02  按钮辉光（button-glow）

- 区块：CTA
- 风格：奢华
- 触发：hover
- 端：PC
- 时长/缓动：300ms ease-out
- 性能：合成层（用伪元素 opacity 过渡，不直接过渡 box-shadow）
- 依赖：无
- 说明：主按钮周围浮起一层柔光。伪元素预先画好阴影，hover 只改 opacity，零重绘。

```css
.glow-btn { position: relative; isolation: isolate; }
.glow-btn::after {
  content: ''; position: absolute; inset: -2px; border-radius: inherit; z-index: -1;
  box-shadow: 0 0 24px 4px var(--brand-glow, rgba(201,169,98,.55));
  opacity: 0; transition: opacity 300ms ease-out;
}
@media (hover: hover) { .glow-btn:hover::after { opacity: 1; } }
@media (prefers-reduced-motion: reduce) { .glow-btn::after { transition: none; } }
```

### hv-03  边框流光（border-sweep）

- 区块：卡片 / CTA
- 风格：奢华
- 触发：hover
- 端：PC
- 时长/缓动：1200ms linear
- 性能：合成层
- 依赖：无
- 说明：hover 时一道高光沿卡片边缘绕一圈。用 conic-gradient + mask 实现，只在深色底上好看。
- 变体：状态触发绕行一圈——不用 hover，由 JS 加 `.alert` 类触发 `animation: sweep 1400ms linear 1`，用于"被叫 / 更新 / 中奖"这类要把整块面板点亮一次的场景（排队板大屏 · 2026-09-11）。

```css
.sweep { position: relative; border-radius: 12px; }
.sweep::before {
  content: ''; position: absolute; inset: 0; border-radius: inherit; padding: 1px;
  background: conic-gradient(from var(--a, 0deg), transparent 70%, #fff2c7 85%, transparent 100%);
  -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
  -webkit-mask-composite: xor; mask-composite: exclude;
  opacity: 0; transition: opacity 200ms;
}
@property --a { syntax: '<angle>'; inherits: false; initial-value: 0deg; }
@media (hover: hover) {
  .sweep:hover::before { opacity: 1; animation: sweep 1200ms linear infinite; }
}
@keyframes sweep { to { --a: 360deg; } }
@media (prefers-reduced-motion: reduce) { .sweep:hover::before { animation: none; } }
```

### hv-04  图片缩放（image-zoom）

- 区块：卡片 / 媒体
- 风格：内容 / 活泼
- 触发：hover
- 端：PC
- 时长/缓动：400ms ease-out
- 性能：合成层
- 依赖：无
- 说明：容器 overflow hidden，图片放大到 1.05。配合 hv-01 使用时两者时长要一致。

```css
.media { overflow: hidden; }
.media img { transition: transform 400ms ease-out; }
@media (hover: hover) { .media:hover img { transform: scale(1.05); } }
@media (prefers-reduced-motion: reduce) { .media img { transition: none; } }
```

### hv-05  下划线滑入（underline-slide）

- 区块：导航 / 页脚
- 风格：通用
- 触发：hover
- 端：PC
- 时长/缓动：200ms ease-out
- 性能：合成层
- 依赖：无
- 说明：链接下方一条线从左滑出。用 scaleX 而不是 width。

```css
.link { position: relative; }
.link::after {
  content: ''; position: absolute; left: 0; right: 0; bottom: -2px; height: 1px;
  background: currentColor; transform: scaleX(0); transform-origin: left;
  transition: transform 200ms ease-out;
}
@media (hover: hover) { .link:hover::after { transform: scaleX(1); } }
@media (prefers-reduced-motion: reduce) { .link::after { transition: none; } }
```

### hv-06  图标微动（icon-nudge）

- 区块：CTA / 列表
- 风格：活泼 / 企业
- 触发：hover
- 端：PC
- 时长/缓动：200ms ease-out
- 性能：合成层
- 依赖：无
- 说明：按钮里的箭头 hover 时右移 4px，暗示"前往"。幅度小、时长短，是最克制的微交互。

```css
.btn .icon { transition: transform 200ms ease-out; }
@media (hover: hover) { .btn:hover .icon { transform: translateX(4px); } }
@media (prefers-reduced-motion: reduce) { .btn .icon { transition: none; } }
```

### hv-07  磁吸按钮（magnetic）

- 区块：CTA
- 风格：活泼 / 奢华
- 触发：hover
- 端：PC
- 时长/缓动：跟随指针，离开时 400ms 回弹
- 性能：合成层
- 依赖：无（少量 JS）
- 说明：按钮轻微跟随鼠标偏移，离开时弹回。只用在一两个主 CTA 上，幅度 ≤ 12px。

```js
document.querySelectorAll('.magnetic').forEach((el) => {
  el.addEventListener('pointermove', (e) => {
    const r = el.getBoundingClientRect();
    const x = ((e.clientX - r.left) / r.width - 0.5) * 12;
    const y = ((e.clientY - r.top) / r.height - 0.5) * 12;
    el.style.transform = `translate(${x}px, ${y}px)`;
  });
  el.addEventListener('pointerleave', () => { el.style.transform = ''; });
});
```

```css
.magnetic { transition: transform 400ms cubic-bezier(0.34,1.56,0.64,1); }
.magnetic:hover { transition: none; }
@media (prefers-reduced-motion: reduce) { .magnetic { transition: none; transform: none !important; } }
```

### hv-08  3D 倾斜跟随（tilt-follow）

- 区块：卡片 / 首屏 / 媒体
- 风格：奢华 / 活泼
- 触发：hover
- 端：PC
- 时长/缓动：跟随指针 160ms ease-out，离开 300ms 回正
- 性能：合成层
- 依赖：无（少量 JS）
- 说明：卡片随指针位置绕 X/Y 轴倾斜 ±6–7°，像捧在手里的实物。只给一屏内的焦点卡片（如轮播中心卡）或 hover 中的那一张，不要全屏一起倾斜。父级需要 `perspective`，卡片上不要再挂其他 transform 动画（入场放外层包裹）。常与 hv-09 光泽跟随配合。

```css
.tilt-host { perspective: 900px; }
.tilt { transform: rotateX(var(--rx, 0deg)) rotateY(var(--ry, 0deg)); transition: transform 160ms ease-out; will-change: transform; transform-style: preserve-3d; }
.tilt-host:not(:hover) .tilt { transition-duration: 300ms; }
@media (prefers-reduced-motion: reduce) { .tilt { transform: none !important; } }
```

```js
// max 为最大倾角，默认 7°
function bindTilt(host, max = 7) {
  const el = host.querySelector('.tilt');
  host.addEventListener('pointermove', (e) => {
    const r = el.getBoundingClientRect();
    const px = (e.clientX - r.left) / r.width - .5, py = (e.clientY - r.top) / r.height - .5;
    el.style.setProperty('--ry', `${(px * max * 2).toFixed(2)}deg`);
    el.style.setProperty('--rx', `${(-py * max * 2).toFixed(2)}deg`);
  });
  host.addEventListener('pointerleave', () => { el.style.setProperty('--rx', '0deg'); el.style.setProperty('--ry', '0deg'); });
}
```

### hv-09  光泽跟随指针（glare）

- 区块：卡片 / 媒体
- 风格：奢华 / 活泼
- 触发：hover
- 端：PC
- 时长/缓动：跟随指针，出现 / 消失 200ms
- 性能：合成层（伪元素 opacity；渐变位置由变量驱动，重绘范围仅该卡片）
- 依赖：无（复用 hv-08 的 pointermove 写两个变量）
- 说明：一团柔和高光跟着指针在图片表面移动，模拟实物反光。强度 0.4–0.6 之间，深色底可略高。通常与 hv-08 一起用，单独用也成立。

```css
.glare { position: relative; overflow: hidden; }
.glare::before {
  content: ''; position: absolute; inset: 0; z-index: 2; pointer-events: none; opacity: 0; transition: opacity 200ms;
  background: radial-gradient(circle at var(--gx, 50%) var(--gy, 50%), rgba(255,255,255,.55) 0%, rgba(255,255,255,0) 45%);
}
@media (hover: hover) { .glare:hover::before { opacity: 1; } }
@media (prefers-reduced-motion: reduce) { .glare::before { display: none; } }
```

```js
// 在 pointermove 里追加：
el.style.setProperty('--gx', `${(px + .5) * 100}%`); el.style.setProperty('--gy', `${(py + .5) * 100}%`);
```

### hv-10  聚焦压暗（spotlight-dim）

- 区块：列表 / 卡片（网格）
- 风格：奢华 / 内容
- 触发：hover
- 端：PC
- 时长/缓动：320ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层（opacity）+ 绘制（filter；网格超过约 24 张一屏时只对可视行启用）
- 依赖：无
- 说明：hover 某一张时，同组其他卡片降饱和、压暗、略透明，视线自然聚到当前这张。商品网格、作品集、卡片墙很适合。不要和 hv-01 抬升以外的位移动效叠太多。

```css
.grid > .card { transition: opacity 320ms cubic-bezier(0.22,1,0.36,1), filter 320ms cubic-bezier(0.22,1,0.36,1); }
@media (hover: hover) {
  .grid:hover > .card:not(:hover) { opacity: .72; filter: saturate(.6) brightness(.92); }
}
@media (prefers-reduced-motion: reduce) { .grid > .card { transition: none; } .grid:hover > .card:not(:hover) { opacity: 1; filter: none; } }
```


### hv-12  hover 图集自动轮播（hover-gallery-cycle）

- 区块：卡片 / 列表（多图商品、多图作品）
- 风格：奢华 / 活泼 / 内容
- 触发：hover
- 端：PC
- 时长/缓动：停留 500ms 后开始，每 1100ms 切一张，交叉淡入 420ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层（多层 opacity）
- 依赖：无（少量 JS）
- 说明：商品有多张图但列表只露第一张时，hover 停留后自动依次展示全部图，底部条状圆点同步高亮，离开回到第一张。比"hover 换到第二张"信息量更大，适合冲击版；图层预渲染在卡片内，图片要 lazy。

```html
<div class="pimg multi" data-idx="0">
  <img class="layer l0" src="…" alt=""><img class="layer l1" src="…" alt=""><img class="layer l2" src="…" alt="">
</div>
<div class="dots"><i class="on"></i><i></i><i></i></div>
```

```css
.pimg { position: relative; overflow: hidden; }
.pimg .layer { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0; transition: opacity 420ms cubic-bezier(0.22,1,0.36,1); }
.pimg .layer.l0, .pimg[data-idx="1"] .layer.l1, .pimg[data-idx="2"] .layer.l2 { opacity: 1; }
.pimg[data-idx="1"] .layer.l0, .pimg[data-idx="2"] .layer.l0 { opacity: 0; }
.dots { display: flex; justify-content: center; gap: 6px; position: absolute; left: 0; right: 0; bottom: 10px; pointer-events: none; }
.dots i { width: 14px; height: 4px; border-radius: 2px; background: rgba(0,0,0,.22); transition: background 300ms; }
.dots i.on { background: var(--brand); }
@media (prefers-reduced-motion: reduce) { .pimg .layer { transition: none; } }
```

```js
function bindGalleryCycle(card, { delay = 500, step = 1100 } = {}) {
  const img = card.querySelector('.pimg'), dots = card.querySelectorAll('.dots i'), n = img.querySelectorAll('.layer').length;
  if (n < 2 || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  const set = (k) => { img.dataset.idx = k; dots.forEach((d, j) => d.classList.toggle('on', j === k)); };
  let timer = null, k = 0;
  card.addEventListener('pointerenter', () => { timer = setTimeout(function tick() { k = (k + 1) % n; set(k); timer = setTimeout(tick, step); }, delay); });
  card.addEventListener('pointerleave', () => { clearTimeout(timer); k = 0; set(0); });
}
```

### hv-13  弧形填充扫入（curved-fill-wipe）

- 区块：CTA
- 风格：奢华 / 企业
- 触发：hover
- 端：PC
- 时长/缓动：填充 900ms ease；文字变色 500ms ease（文字比填充快，先于填充完成翻色）
- 性能：绘制（过渡 width，作用域限于按钮本身）
- 依赖：无
- 说明：填充层从按钮左侧扫过，前缘是**上半段直、下半段向左收**的弧线，扫满后按钮整体换色、文字反色。弧形来自「只圆右下角 + 元素高于按钮、超出部分被裁掉」这个组合，不是对称椭圆——这点是该手法的辨识度所在，做成椭圆或直边就泄气了。三个关键量：`height:120%`（撑出被裁掉的那段，弧线才有斜度）、`left:-5px`（左侧不留缝）、宽度终值 `150%`（超过按钮宽，让弧线完整走出右边缘，否则停在一半像没扫完）。按钮需 `overflow:hidden`；轮廓不是矩形时（切角、异形）把 `overflow` 换成同形的 `clip-path`。刻意没用 `transform:scaleX()` 上合成层——横向缩放会把弧线拉扁。来源：maserati.com CTA · 2026-09-14

```html
<button class="wipe-btn">
  <span class="wipe-fill" aria-hidden="true"></span>
  <span class="wipe-label">赛事详情</span>
</button>
```

```css
.wipe-btn {
  position: relative; overflow: hidden;
  background: var(--btn-bg, #cfa457); border: 0; cursor: pointer;
  /* 异形轮廓把 overflow 换成 clip-path，例如 45° 切角：
     clip-path: polygon(8px 0, 100% 0, 100% calc(100% - 8px), calc(100% - 8px) 100%, 0 100%, 0 8px); */
}
.wipe-fill {
  position: absolute; left: -5px; top: 0; width: 0; height: 120%;
  background: var(--btn-fill, #813472);
  border-radius: 0 0 50px 0;                 /* 只圆右下角 = 弧形前缘 */
  transition: width 900ms ease;
}
.wipe-label {
  position: relative;                        /* 压在填充层之上 */
  color: var(--btn-text, #000);
  transition: color 500ms ease;
}
@media (hover: hover) {
  .wipe-btn:hover .wipe-fill { width: 150%; }
  .wipe-btn:hover .wipe-label { color: var(--btn-text-hover, #fff); }
}
@media (prefers-reduced-motion: reduce) {
  .wipe-fill, .wipe-label { transition: none; }   /* 降级成瞬时换色 */
}
```
