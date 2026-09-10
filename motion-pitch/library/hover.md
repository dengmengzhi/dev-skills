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
