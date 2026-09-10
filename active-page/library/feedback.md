# 反馈动效（feedback）

点击 / 触摸 / 状态切换的即时响应。H5 端 hover 缺位，靠这一类补足"有反应"的感觉。反馈类时长普遍短（100–250ms）。

### fb-01  按压缩放（press-scale）

- 区块：CTA / 卡片 / 列表
- 风格：通用
- 触发：点击反馈
- 端：双端（H5 首选）
- 时长/缓动：120ms ease-out
- 性能：合成层
- 依赖：无
- 说明：按下缩到 0.96，松开弹回。H5 上替代 hover 的最基本反馈。列表项用 0.98 更含蓄。

```css
.pressable { transition: transform 120ms ease-out; -webkit-tap-highlight-color: transparent; }
.pressable:active { transform: scale(0.96); }
@media (prefers-reduced-motion: reduce) { .pressable { transition: none; } .pressable:active { transform: none; } }
```

### fb-02  涟漪（ripple）

- 区块：CTA / 列表
- 风格：活泼 / 企业
- 触发：点击反馈
- 端：双端
- 时长/缓动：500ms ease-out
- 性能：合成层
- 依赖：无（少量 JS）
- 说明：Material 式点击扩散。从点击位置出发，颜色用前景色 20% 透明度。奢华风不用。

```css
.ripple-host { position: relative; overflow: hidden; }
.ripple { position: absolute; border-radius: 50%; pointer-events: none; width: 20px; height: 20px;
  background: currentColor; opacity: .2; transform: translate(-50%,-50%) scale(0);
  animation: ripple 500ms ease-out forwards; }
@keyframes ripple { to { transform: translate(-50%,-50%) scale(15); opacity: 0; } }
@media (prefers-reduced-motion: reduce) { .ripple { display: none; } }
```

```js
document.querySelectorAll('.ripple-host').forEach((el) => {
  el.addEventListener('pointerdown', (e) => {
    const r = el.getBoundingClientRect(), s = document.createElement('span');
    s.className = 'ripple'; s.style.left = `${e.clientX - r.left}px`; s.style.top = `${e.clientY - r.top}px`;
    el.appendChild(s); s.addEventListener('animationend', () => s.remove(), { once: true });
  });
});
```

### fb-03  Tab 指示器滑动（sliding-indicator）

- 区块：导航 / 表单
- 风格：企业 / 内容 / 活泼
- 触发：状态过渡
- 端：双端
- 时长/缓动：250ms cubic-bezier(0.4,0,0.2,1)
- 性能：合成层
- 依赖：无（JS 读目标 tab 的 offsetLeft/offsetWidth 设到变量）
- 说明：Tab 切换时下划线或底块滑到新位置，而不是跳变。用 transform 而不是改 left/width。

```css
.tabs { position: relative; }
.tabs .indicator { position: absolute; bottom: 0; left: 0; height: 2px; width: 1px; background: var(--brand);
  transform: translateX(var(--x, 0)) scaleX(var(--w, 1)); transform-origin: left;
  transition: transform 250ms cubic-bezier(0.4,0,0.2,1); }
@media (prefers-reduced-motion: reduce) { .tabs .indicator { transition: none; } }
```

```js
function moveIndicator(tab) {
  const ind = tab.parentElement.querySelector('.indicator');
  ind.style.setProperty('--x', `${tab.offsetLeft}px`);
  ind.style.setProperty('--w', tab.offsetWidth);
}
```

### fb-04  校验失败抖动（shake）

- 区块：表单
- 风格：通用
- 触发：状态过渡
- 端：双端
- 时长/缓动：400ms ease-in-out
- 性能：合成层
- 依赖：无
- 说明：输入框校验不通过时左右抖 3 次，幅度 4px。只在提交/失焦校验时触发，不要边输入边抖。

```css
.shake { animation: shake 400ms ease-in-out; }
@keyframes shake {
  10%, 90% { transform: translateX(-1px); } 20%, 80% { transform: translateX(2px); }
  30%, 50%, 70% { transform: translateX(-4px); } 40%, 60% { transform: translateX(4px); }
}
@media (prefers-reduced-motion: reduce) { .shake { animation: none; outline: 2px solid var(--danger); } }
```

### fb-05  成功勾选描边（check-draw）

- 区块：表单 / 弹层
- 风格：通用
- 触发：状态过渡
- 端：双端
- 时长/缓动：400ms ease-out，圆圈先 300ms、勾 200ms 延后
- 性能：合成层（SVG stroke-dashoffset）
- 依赖：无
- 说明：提交成功后一个圆圈被画出来、再画出勾。比直接显示图标有"完成"感。

```html
<svg class="check" viewBox="0 0 52 52" width="52" height="52" fill="none" stroke="currentColor" stroke-width="3">
  <circle class="check-circle" cx="26" cy="26" r="24" />
  <path class="check-mark" d="M14 27l8 8 16-16" />
</svg>
```

```css
.check-circle { stroke-dasharray: 151; stroke-dashoffset: 151; animation: draw 300ms ease-out forwards; }
.check-mark   { stroke-dasharray: 36;  stroke-dashoffset: 36;  animation: draw 200ms ease-out 250ms forwards; }
@keyframes draw { to { stroke-dashoffset: 0; } }
@media (prefers-reduced-motion: reduce) { .check-circle, .check-mark { animation: none; stroke-dashoffset: 0; } }
```

### fb-06  按钮加载态过渡（button-loading）

- 区块：CTA / 表单
- 风格：企业 / 内容
- 触发：状态过渡
- 端：双端
- 时长/缓动：文字 150ms 淡出，spinner 150ms 淡入
- 性能：合成层
- 依赖：无
- 说明：点击后按钮宽度不变、文字淡出、spinner 淡入，避免布局跳动。按钮要有 min-width 或固定宽。

```css
.btn { position: relative; }
.btn .label, .btn .spinner { transition: opacity 150ms ease-out; }
.btn .spinner { position: absolute; inset: 0; margin: auto; width: 18px; height: 18px; opacity: 0;
  border: 2px solid currentColor; border-right-color: transparent; border-radius: 50%; animation: spin 700ms linear infinite; }
.btn.loading .label { opacity: 0; }
.btn.loading .spinner { opacity: 1; }
@keyframes spin { to { transform: rotate(360deg); } }
@media (prefers-reduced-motion: reduce) { .btn .spinner { animation-duration: 1.5s; } }
```

### fb-07  环绕描边进度环（ring-progress）

- 区块：卡片 / 弹层 / 首屏（轮播中心卡、倒计时卡片、Toast 停留时长）
- 风格：奢华 / 活泼 / 内容
- 触发：状态过渡（自动轮播倒计时、定时关闭、限时状态）
- 端：双端
- 时长/缓动：等于倒计时时长（如 4000ms）linear
- 性能：合成层（SVG stroke-dashoffset）
- 依赖：无（少量 JS 取周长；元素随目标切换时把 svg 移到新目标）
- 说明：一条描边沿元素边缘从左上角顺时针走一周，走满即触发切换。比横向进度条更贴合卡片形态，且挂在目标内部时会跟随目标的 transform（含 3D 倾斜）。hover 暂停时重置；目标切换后把同一个 svg 移到新目标再重跑。圆角 rx 与目标 border-radius 一致，viewBox 比目标各边多 2px 留给描边。

```html
<!-- 追加到目标元素内部，目标需 position: relative -->
<svg class="ring" viewBox="0 0 386 482"><rect x="1" y="1" width="384" height="480" rx="5" ry="5" /></svg>
```

```css
.ring { position: absolute; inset: -1px; width: calc(100% + 2px); height: calc(100% + 2px); pointer-events: none; z-index: 5; overflow: visible; }
.ring rect { fill: none; stroke: var(--brand); stroke-width: 2; stroke-linecap: round;
  stroke-dasharray: var(--len, 1721); stroke-dashoffset: var(--len, 1721); }
.ring.run rect { transition: stroke-dashoffset var(--ring-dur, 4000ms) linear; stroke-dashoffset: 0; }
@media (prefers-reduced-motion: reduce) { .ring { display: none; } }
```

```js
// 每次（重新）开始倒计时调用；target 为当前中心卡等目标元素
function armRing(ring, target, dur = 4000, onDone) {
  if (ring.parentElement !== target) target.appendChild(ring);
  const rect = ring.firstElementChild;
  ring.classList.remove('run');
  rect.style.setProperty('--len', rect.getTotalLength().toFixed(1));
  void ring.getBoundingClientRect(); // 强制重排，保证从头开始
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  ring.style.setProperty('--ring-dur', `${dur}ms`);
  ring.classList.add('run');
  return setTimeout(onDone, dur);
}
```
