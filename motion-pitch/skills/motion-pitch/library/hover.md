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

### hv-14  自定义光标双层跟随（cursor-dot-ring）

- 区块：通用（页面级）
- 风格：奢华 / 活泼
- 触发：持续
- 端：PC
- 时长/缓动：圆点即时；圆环 lerp 0.15（≈150ms 追尾感）；hover 态放大 250ms ease
- 性能：合成层
- 依赖：无（JS + rAF）
- 说明：小圆点贴着指针走、大圆环延迟追上，指到可点元素时圆环放大并淡底。整站只用一套，是"页面有没有做过动效"最直观的信号。**必须 `(hover:hover) and (pointer:fine)` 才启用**，触屏和触控板笔输入一律不开；隐藏原生光标后要给输入框恢复 `cursor:auto`，键盘焦点环不能一起去掉。变体：圆环 hover 时吸附到目标 bounding box（取 `getBoundingClientRect` 设宽高与圆角）做"框住按钮"效果。来源：通用手法整理（未联网）· 2026-09-15

```js
const fine = matchMedia('(hover: hover) and (pointer: fine)').matches;
const calm = matchMedia('(prefers-reduced-motion: reduce)').matches;
if (fine && !calm) {
  const dot = document.querySelector('.cursor-dot');
  const ring = document.querySelector('.cursor-ring');
  let mx = innerWidth / 2, my = innerHeight / 2, rx = mx, ry = my;
  addEventListener('pointermove', (e) => {
    mx = e.clientX; my = e.clientY;
    dot.style.transform = `translate(${mx}px, ${my}px) translate(-50%, -50%)`;
  });
  (function loop() {
    rx += (mx - rx) * 0.15; ry += (my - ry) * 0.15;
    ring.style.transform = `translate(${rx}px, ${ry}px) translate(-50%, -50%)`;
    requestAnimationFrame(loop);
  })();
  document.querySelectorAll('a, button, .cursor-target').forEach((el) => {
    el.addEventListener('pointerenter', () => ring.classList.add('is-active'));
    el.addEventListener('pointerleave', () => ring.classList.remove('is-active'));
  });
  document.documentElement.classList.add('has-custom-cursor');
}
```

```css
.cursor-dot, .cursor-ring {
  position: fixed; left: 0; top: 0; z-index: 9999; pointer-events: none;
  border-radius: 50%; will-change: transform;
}
.cursor-dot  { width: 6px; height: 6px; background: var(--cursor-color, currentColor); }
.cursor-ring {
  width: 32px; height: 32px; border: 1px solid var(--cursor-color, currentColor);
  transition: width 250ms ease, height 250ms ease, background-color 250ms ease;
}
.cursor-ring.is-active {
  width: 56px; height: 56px;
  background: color-mix(in srgb, var(--cursor-color, currentColor) 12%, transparent);
}
.has-custom-cursor, .has-custom-cursor a, .has-custom-cursor button { cursor: none; }
.has-custom-cursor input, .has-custom-cursor textarea, .has-custom-cursor [contenteditable] { cursor: auto; }
@media (prefers-reduced-motion: reduce) { .cursor-dot, .cursor-ring { display: none; } }
```

### hv-15  光标拖尾（cursor-trail）

- 区块：通用（页面级）
- 风格：奢华 / 活泼
- 触发：持续
- 端：PC
- 时长/缓动：每节 lerp 0.35，节点 6–10 个
- 性能：合成层
- 依赖：无（JS + rAF）
- 说明：一串逐级缩小的光点链式追随指针，尾巴越长越花。比 hv-14 更张扬，**只用在冲击版**，且与 hv-14 二选一，不叠加。节点用 `<span>` 链式 lerp，不要上 canvas 粒子——同样的观感，开销差一个量级。深色页把光点设成品牌金 + `mix-blend-mode: screen` 更通透。来源：通用手法整理（未联网）· 2026-09-15

```js
const fine = matchMedia('(hover: hover) and (pointer: fine)').matches;
const calm = matchMedia('(prefers-reduced-motion: reduce)').matches;
if (fine && !calm) {
  const N = 8;
  const tail = Array.from({ length: N }, () => {
    const s = document.createElement('span');
    s.className = 'cursor-trail';
    document.body.appendChild(s);
    return { el: s, x: innerWidth / 2, y: innerHeight / 2 };
  });
  let px = innerWidth / 2, py = innerHeight / 2;
  addEventListener('pointermove', (e) => { px = e.clientX; py = e.clientY; });
  (function loop() {
    let x = px, y = py;
    tail.forEach((p, i) => {
      p.x += (x - p.x) * 0.35; p.y += (y - p.y) * 0.35;
      const k = 1 - i / N;
      p.el.style.transform = `translate(${p.x}px, ${p.y}px) translate(-50%, -50%) scale(${k})`;
      p.el.style.opacity = String(k * 0.8);
      x = p.x; y = p.y;
    });
    requestAnimationFrame(loop);
  })();
}
```

```css
.cursor-trail {
  position: fixed; left: 0; top: 0; z-index: 9998; pointer-events: none;
  width: 14px; height: 14px; border-radius: 50%;
  background: var(--cursor-color, currentColor);
  mix-blend-mode: screen; will-change: transform, opacity;
}
@media (prefers-reduced-motion: reduce) { .cursor-trail { display: none; } }
```

### hv-16  聚光灯跟随（spotlight-follow）

- 区块：首屏 / 卡片 / 列表（区块级）
- 风格：奢华 / 内容
- 触发：hover
- 端：PC
- 时长/缓动：显隐 300ms ease；位置跟随不加过渡（加了会拖影）
- 性能：绘制（大面积 radial-gradient 重绘）
- 依赖：无（JS 写 CSS 变量，rAF 节流）
- 说明：指针在区块内移动时带一束光照亮周围，深色页上效果最强。**限定在一个区块内用，别整页挂**：光斑半径越大重绘面积越大，1440px 宽的整屏上会掉帧。与 hv-09（单卡光泽）区别在这是跨卡片的区块级照明，两者不同时用。来源：通用手法整理（未联网）· 2026-09-15

```js
document.querySelectorAll('.spotlight').forEach((box) => {
  let raf = 0, x = 0, y = 0;
  box.addEventListener('pointermove', (e) => {
    const r = box.getBoundingClientRect();
    x = e.clientX - r.left; y = e.clientY - r.top;
    if (!raf) raf = requestAnimationFrame(() => {
      box.style.setProperty('--mx', x + 'px');
      box.style.setProperty('--my', y + 'px');
      raf = 0;
    });
  });
});
```

```css
.spotlight { position: relative; isolation: isolate; }
.spotlight::before {
  content: ''; position: absolute; inset: 0; z-index: -1; pointer-events: none;
  background: radial-gradient(240px circle at var(--mx, 50%) var(--my, 50%),
              color-mix(in srgb, var(--cursor-color, currentColor) 18%, transparent), transparent 70%);
  opacity: 0; transition: opacity 300ms ease;
}
@media (hover: hover) { .spotlight:hover::before { opacity: 1; } }
@media (prefers-reduced-motion: reduce) { .spotlight::before { display: none; } }
```

### hv-17  光标文字标签（cursor-label）

- 区块：卡片 / 媒体 / 列表
- 风格：奢华 / 内容 / 活泼
- 触发：hover
- 端：PC
- 时长/缓动：出现 300ms cubic-bezier(0.22,1,0.36,1)，scale 0.6 → 1
- 性能：合成层
- 依赖：无（JS）
- 说明：指针进入卡片/图片时，光标旁浮出"查看详情""拖动查看"这类胶囊标签，代替卡片上常驻的 CTA 文案，版面更干净。文案写在元素的 `data-cursor-label` 上。**不能只靠它传达信息**——触屏和键盘用户看不到，卡片本身仍要是可聚焦的链接。可与 hv-14 共用一套跟随逻辑（标签挂在圆环里）。来源：通用手法整理（未联网）· 2026-09-15

```js
const fine = matchMedia('(hover: hover) and (pointer: fine)').matches;
if (fine) {
  const label = document.querySelector('.cursor-label');
  addEventListener('pointermove', (e) => {
    label.style.transform = `translate(${e.clientX}px, ${e.clientY}px) translate(16px, 16px)`;
  });
  document.querySelectorAll('[data-cursor-label]').forEach((el) => {
    el.addEventListener('pointerenter', () => {
      label.textContent = el.dataset.cursorLabel;
      label.classList.add('is-on');
    });
    el.addEventListener('pointerleave', () => label.classList.remove('is-on'));
  });
}
```

```css
.cursor-label {
  position: fixed; left: 0; top: 0; z-index: 9999; pointer-events: none;
  padding: 6px 14px; border-radius: 999px;
  background: var(--cursor-accent, #111); color: var(--cursor-accent-fg, #fff);
  font-size: 12px; letter-spacing: 0.04em; white-space: nowrap;
  opacity: 0; transform-origin: 0 0; will-change: transform, opacity;
  transition: opacity 300ms ease, scale 300ms cubic-bezier(0.22,1,0.36,1);
  scale: 0.6;
}
.cursor-label.is-on { opacity: 1; scale: 1; }
@media (prefers-reduced-motion: reduce) {
  .cursor-label { transition: none; scale: 1; }
}
```

### hv-18  指针视差分层（pointer-parallax）

- 区块：首屏 / 媒体
- 风格：奢华 / 活泼
- 触发：持续
- 端：PC
- 时长/缓动：600ms cubic-bezier(0.22,1,0.36,1)（过渡兜底，指针停下时缓归位）
- 性能：合成层
- 依赖：无（JS 写两个 CSS 变量）
- 说明：首屏的背景、主视觉、标题按 `--depth` 分层，随指针反向微移，静态 Hero 立刻有纵深。幅度克制：最深一层位移 ≤ 24px，超过就晕。与 sc-03（滚动视差）可同时在一个 Hero 上用，两者驱动源不同不打架；与 hv-08（卡片 3D 倾斜）别叠在同一元素上。H5 无指针，对应端用 sc-03 或入场动效替代。来源：通用手法整理（未联网）· 2026-09-15

```js
const hero = document.querySelector('.parallax-scene');
if (hero && matchMedia('(hover: hover) and (pointer: fine)').matches) {
  let raf = 0, px = 0, py = 0;
  addEventListener('pointermove', (e) => {
    px = e.clientX / innerWidth - 0.5; py = e.clientY / innerHeight - 0.5;
    if (!raf) raf = requestAnimationFrame(() => {
      hero.style.setProperty('--px', px.toFixed(3));
      hero.style.setProperty('--py', py.toFixed(3));
      raf = 0;
    });
  });
}
```

```css
.parallax-scene { position: relative; overflow: hidden; }
.parallax-layer {
  transform: translate3d(calc(var(--px, 0) * var(--depth, 10) * -1px),
                         calc(var(--py, 0) * var(--depth, 10) * -1px), 0);
  transition: transform 600ms cubic-bezier(0.22,1,0.36,1);
  will-change: transform;
}
/* 用法：背景层 --depth: 6；主视觉 --depth: 14；前景装饰 --depth: 24 */
@media (prefers-reduced-motion: reduce) {
  .parallax-layer { transform: none; transition: none; }
}
```

### hv-19  遮罩上滑揭示文案（overlay-caption-reveal）

- 区块：卡片 / 媒体 / 列表
- 风格：奢华 / 内容 / 企业
- 触发：hover
- 端：PC
- 时长/缓动：遮罩 400ms ease；文案 450ms cubic-bezier(0.22,1,0.36,1)，位移 12px
- 性能：合成层
- 依赖：无
- 说明：图片上常驻的标题/CTA 收起来，hover 时渐变遮罩压暗、文案从下方上滑露出，版面立刻干净。**必须同时挂 `:focus-within`**，否则键盘用户永远看不到这段文案；遮罩用从底部起的渐变而不是整块半透明，图片主体不会被闷住。配 hv-04 图片缩放时两者时长对齐。来源：通用手法整理（未联网）· 2026-09-15

```css
.mcard { position: relative; overflow: hidden; }
.mcard__veil {
  position: absolute; inset: 0; pointer-events: none;
  background: linear-gradient(to top, rgba(10,10,10,.88), rgba(10,10,10,0) 62%);
  opacity: 0; transition: opacity 400ms ease;
}
.mcard__cap {
  position: absolute; left: 20px; right: 20px; bottom: 20px;
  opacity: 0; transform: translateY(12px);
  transition: opacity 400ms ease, transform 450ms cubic-bezier(0.22,1,0.36,1);
}
@media (hover: hover) {
  .mcard:hover .mcard__veil, .mcard:focus-within .mcard__veil { opacity: 1; }
  .mcard:hover .mcard__cap,  .mcard:focus-within .mcard__cap  { opacity: 1; transform: none; }
}
@media (prefers-reduced-motion: reduce) {
  .mcard__veil, .mcard__cap { transition: none; }
  .mcard__cap { opacity: 1; transform: none; }   /* 降级成常驻文案 */
}
```

### hv-20  灰度转彩色（grayscale-to-color）

- 区块：列表 / 卡片 / 媒体（赞助商墙、选手墙、图集）
- 风格：内容 / 企业 / 奢华
- 触发：hover
- 端：PC
- 时长/缓动：450ms ease-out
- 性能：绘制（filter 全图重绘）
- 依赖：无
- 说明：整片图默认去色，hover 的那张恢复彩色，是"一眼看出选中了谁"的最省事做法。**大图慎用**：filter 按图片实际像素重绘，单张超过 1200px 宽的多图列表会掉帧，先把列表图切到显示尺寸的 2 倍以内。Safari 上 filter 与 transform 同时过渡会闪，给图加 `translateZ(0)` 提层。与 hv-10 聚焦压暗同属"突出一张压其余"，二选一。来源：通用手法整理（未联网）· 2026-09-15

```css
.gray-grid img {
  filter: grayscale(1);
  transform: translateZ(0);                    /* Safari 抗闪烁 */
  transition: filter 450ms ease-out;
}
@media (hover: hover) {
  .gray-grid img:hover, .gray-grid a:focus-visible img { filter: grayscale(0); }
}
@media (prefers-reduced-motion: reduce) {
  .gray-grid img { transition: none; }
}
```

### hv-21  双图交叉淡出（image-swap）

- 区块：卡片 / 媒体 / 列表
- 风格：通用
- 触发：hover
- 端：PC
- 时长/缓动：420ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：无
- 说明：hover 换成第二张图（商品另一角度、选手牌桌照、前后对比），交叉淡出而不是硬切。只有两张图用这条，三张以上用 hv-12 轮播。第二张图给 `loading="lazy"`，别在首屏一次拉双份资源；两张图尺寸比例必须一致，否则切换会跳。加 `scale(1.03)` 收尾可以和 hv-04 叠出"换图 + 推近"。来源：通用手法整理（未联网）· 2026-09-15

```html
<a class="swap" href="…">
  <img class="swap__a" src="front.jpg" alt="选手正装照">
  <img class="swap__b" src="back.jpg" alt="" aria-hidden="true" loading="lazy">
</a>
```

```css
.swap { position: relative; display: block; overflow: hidden; }
.swap img { display: block; width: 100%; height: 100%; object-fit: cover; }
.swap__b {
  position: absolute; inset: 0;
  opacity: 0; transition: opacity 420ms cubic-bezier(0.22,1,0.36,1);
}
@media (hover: hover) {
  .swap:hover .swap__b, .swap:focus-visible .swap__b { opacity: 1; }
}
@media (prefers-reduced-motion: reduce) { .swap__b { transition: none; } }
```

### hv-22  斜切揭示（clip-reveal）

- 区块：卡片 / 媒体 / 首屏
- 触发：hover
- 风格：奢华 / 活泼
- 端：PC
- 时长/缓动：600ms cubic-bezier(0.22,1,0.36,1)
- 性能：绘制（clip-path 动画触发重绘，单图可接受）
- 依赖：无
- 说明：色块或第二层图以斜角从一侧扫开，露出底下内容，比直上直下的淡入更有"揭幕"感，贴赛事/奢侈品调性。`clip-path` 的两个 polygon **顶点数必须相同**才能插值，顶点数不等会变成瞬时跳变。一屏最多两三处，多了页面像在闪。与 en-06 遮罩擦除是同一手法的入场版，同一元素上别两个都挂。来源：通用手法整理（未联网）· 2026-09-15

```css
.clip-reveal { position: relative; overflow: hidden; }
.clip-reveal__layer {
  position: absolute; inset: 0;
  background: var(--brand, #1a1a1a);
  display: grid; place-items: center; color: var(--brand-fg, #fff);
  clip-path: polygon(0 100%, 100% 100%, 100% 100%, 0 100%);   /* 收在底边，4 顶点 */
  transition: clip-path 600ms cubic-bezier(0.22,1,0.36,1);
}
@media (hover: hover) {
  .clip-reveal:hover .clip-reveal__layer, .clip-reveal:focus-within .clip-reveal__layer {
    clip-path: polygon(0 0, 100% 18%, 100% 100%, 0 100%);      /* 展开，同样 4 顶点，上缘带斜角 */
  }
}
@media (prefers-reduced-motion: reduce) {
  .clip-reveal__layer { transition: none; }
}
```

### hv-23  图内平移跟随指针（image-pan-follow）

- 区块：卡片 / 媒体 / 首屏
- 风格：奢华 / 内容
- 触发：hover
- 端：PC
- 时长/缓动：跟随无过渡，进出场 500ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：无（JS 写 CSS 变量，rAF 节流）
- 说明：图片按 1.12 预放大，随指针反向平移，像隔着窗口看画面别处，横幅和长图最合适。位移上限 = (放大比 - 1) × 容器尺寸 / 2，超过就露白边——代码里的 `--range` 就是这个值，改放大比要一起改。与 hv-04（定点缩放）是两条路线，同一元素二选一；与 hv-08（卡片 3D 倾斜）别叠。来源：通用手法整理（未联网）· 2026-09-15

```js
document.querySelectorAll('.pan').forEach((box) => {
  if (!matchMedia('(hover: hover) and (pointer: fine)').matches) return;
  let raf = 0, x = 0, y = 0;
  box.addEventListener('pointermove', (e) => {
    const r = box.getBoundingClientRect();
    x = (e.clientX - r.left) / r.width - 0.5;
    y = (e.clientY - r.top) / r.height - 0.5;
    if (!raf) raf = requestAnimationFrame(() => {
      box.style.setProperty('--px', x.toFixed(3));
      box.style.setProperty('--py', y.toFixed(3));
      raf = 0;
    });
  });
  box.addEventListener('pointerleave', () => {
    box.style.setProperty('--px', 0); box.style.setProperty('--py', 0);
  });
});
```

```css
.pan { overflow: hidden; --range: 24; }        /* 位移上限 px，与放大比配套 */
.pan img {
  width: 100%; height: 100%; object-fit: cover;
  transform: scale(1.12)
             translate3d(calc(var(--px, 0) * var(--range) * -1px),
                         calc(var(--py, 0) * var(--range) * -1px), 0);
  transition: transform 500ms cubic-bezier(0.22,1,0.36,1);
  will-change: transform;
}
@media (hover: hover) { .pan:hover img { transition: none; } }   /* 跟随时不插值，离开才缓归位 */
@media (prefers-reduced-motion: reduce) {
  .pan img { transform: none; transition: none; }
}
```

### hv-24  hover 视频预览（video-preview）

- 区块：卡片 / 媒体 / 列表（赛事集锦、选手短片）
- 风格：通用
- 触发：hover
- 端：PC
- 时长/缓动：停留 400ms 后起播，封面交叉淡出 350ms ease
- 性能：绘制（视频解码，独立层）
- 依赖：无（少量 JS）
- 说明：hover 停留后静音短片接管封面，离开回到首帧。比任何 CSS 动效都更能留住人，但**规矩最多**：`preload="none"`，hover 才 `load()`；必须 `muted playsinline`，否则移动端 Safari 不给自动播；离开时 `pause()` 且 `currentTime = 0`；同一列表同时只允许一个在播；片源切到 ≤ 6s、≤ 1MB 的 mp4/webm，不要直接挂原片。触屏和 `prefers-reduced-motion` 下一律不启用，只留封面。来源：通用手法整理（未联网）· 2026-09-15

```html
<div class="vprev">
  <img class="vprev__cover" src="cover.jpg" alt="决赛桌集锦">
  <video class="vprev__v" src="clip.mp4" muted loop playsinline preload="none"></video>
</div>
```

```js
let playing = null;
document.querySelectorAll('.vprev').forEach((box) => {
  if (!matchMedia('(hover: hover) and (pointer: fine)').matches) return;
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  const v = box.querySelector('video');
  let timer = null;
  box.addEventListener('pointerenter', () => {
    timer = setTimeout(() => {
      if (playing && playing !== v) { playing.pause(); playing.currentTime = 0; playing.closest('.vprev').classList.remove('is-on'); }
      v.load();
      v.play().then(() => { box.classList.add('is-on'); playing = v; }).catch(() => {});
    }, 400);
  });
  box.addEventListener('pointerleave', () => {
    clearTimeout(timer);
    box.classList.remove('is-on');
    v.pause(); v.currentTime = 0;
    if (playing === v) playing = null;
  });
});
```

```css
.vprev { position: relative; overflow: hidden; }
.vprev__cover, .vprev__v { width: 100%; height: 100%; object-fit: cover; display: block; }
.vprev__v { position: absolute; inset: 0; opacity: 0; transition: opacity 350ms ease; }
.vprev.is-on .vprev__v { opacity: 1; }
@media (prefers-reduced-motion: reduce) { .vprev__v { display: none; } }
```
