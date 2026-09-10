# 数据动效（data）

只用于**数据驱动**的区块，动效表达"值变了 / 项增删了"，不做装饰。数据区块不推荐入场类装饰动画。

### dt-01  数字滚动（count-up）

- 区块：首屏 / 卡片 / 列表（统计数字、比分、计数）
- 风格：通用
- 触发：数据变化 / 滚动进入视口
- 端：双端
- 时长/缓动：800–1200ms ease-out
- 性能：合成层（改 textContent，无布局动画；用等宽数字避免抖动）
- 依赖：无（少量 JS）
- 说明：统计数字从 0 或旧值滚到新值。配 `font-variant-numeric: tabular-nums` 防止宽度跳。首屏用 IO 触发一次即可。

```js
function countUp(el, to, dur = 1000) {
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) { el.textContent = to.toLocaleString(); return; }
  const from = Number(el.dataset.from || 0), t0 = performance.now();
  const tick = (t) => {
    const p = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - p, 3);
    el.textContent = Math.round(from + (to - from) * e).toLocaleString();
    if (p < 1) requestAnimationFrame(tick); else el.dataset.from = to;
  };
  requestAnimationFrame(tick);
}
```

```css
.num { font-variant-numeric: tabular-nums; }
```

### dt-02  列表增删过渡（list-enter-leave）

- 区块：列表
- 风格：企业 / 内容
- 触发：数据变化
- 端：双端
- 时长/缓动：进入 250ms ease-out，离开 200ms ease-in
- 性能：合成层（只动 opacity/transform；高度塌陷用 grid-template-rows 或框架 FLIP）
- 依赖：无（框架内用 Vue `<TransitionGroup>` / React motion `AnimatePresence`）
- 说明：新增项淡入 + 轻位移，删除项淡出。纯 CSS 版只处理进入；离开需要框架或 WAAPI 延迟移除节点。

```css
.item-enter { animation: item-in 250ms ease-out both; }
@keyframes item-in { from { opacity: 0; transform: translateY(-8px); } }
.item-leave { animation: item-out 200ms ease-in both; }
@keyframes item-out { to { opacity: 0; transform: translateX(12px); } }
@media (prefers-reduced-motion: reduce) { .item-enter, .item-leave { animation: none; } }
```

### dt-03  进度条填充（progress-fill）

- 区块：卡片 / 表单 / 列表
- 风格：通用
- 触发：数据变化 / 滚动进入视口
- 端：双端
- 时长/缓动：600ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：无
- 说明：进度、完成率、评分条从 0 增长到目标值。用 scaleX 加 `--p` 变量，不动 width。

```css
.bar { height: 6px; background: #eee; border-radius: 3px; overflow: hidden; }
.bar > i { display: block; height: 100%; background: var(--brand); transform-origin: left;
  transform: scaleX(var(--p, 0)); transition: transform 600ms cubic-bezier(0.22,1,0.36,1); }
/* JS 或模板：bar.style.setProperty('--p', 0.72) */
@media (prefers-reduced-motion: reduce) { .bar > i { transition: none; } }
```

### dt-04  数据更新高亮（flash-highlight）

- 区块：列表（表格 / 实时数据）
- 风格：企业
- 触发：数据变化
- 端：双端
- 时长/缓动：800ms ease-out
- 性能：合成层（background-color 过渡有绘制成本，单元格级别可接受）
- 依赖：无（值变化时给单元格加一次 class）
- 说明：后台表格某个值变化时背景闪一下再褪去，涨用绿、跌用红或统一用品牌色。行情、监控类页面标配。

```css
.flash-up   { animation: flash-up 800ms ease-out; }
.flash-down { animation: flash-down 800ms ease-out; }
@keyframes flash-up   { from { background-color: rgba(34,197,94,.25); } }
@keyframes flash-down { from { background-color: rgba(239,68,68,.25); } }
@media (prefers-reduced-motion: reduce) { .flash-up, .flash-down { animation: none; } }
```

### dt-05  图表描线（chart-draw）

- 区块：卡片 / 首屏（数据图）
- 风格：企业 / 内容
- 触发：滚动进入视口 / 数据变化
- 端：双端
- 时长/缓动：1000ms ease-out
- 性能：合成层（SVG stroke-dashoffset）
- 依赖：无（SVG 折线；用图表库时改用库自带的 animation 配置）
- 说明：折线图从左到右画出来。柱状图改用 dt-03 的 scaleY 版本。图表库（ECharts / Chart.js）自带入场动画时不要重复叠加。

```css
.line-path { stroke-dasharray: var(--len, 1000); stroke-dashoffset: var(--len, 1000);
  animation: draw-line 1000ms ease-out forwards; }
@keyframes draw-line { to { stroke-dashoffset: 0; } }
/* JS：path.style.setProperty('--len', path.getTotalLength()) */
@media (prefers-reduced-motion: reduce) { .line-path { animation: none; stroke-dashoffset: 0; } }
```
