# 切换动效（transition）

弹层、抽屉、Toast、路由切换。原则：出现比消失慢（进 250ms / 出 180ms），遮罩与内容分开动，H5 弹层从底部来、PC 弹层居中缩放。

### tr-01  弹层缩放淡入（modal-scale）

- 区块：弹层
- 风格：通用
- 触发：路由切换 / 状态过渡
- 端：双端（H5 小弹窗；全屏面板用 tr-02）
- 时长/缓动：进 250ms cubic-bezier(0.22,1,0.36,1)，出 180ms ease-in
- 性能：合成层
- 依赖：无
- 说明：遮罩淡入，内容从 0.96 缩到 1。活泼风可用 0.9 + 弹性曲线；企业风保持 0.96。

```css
.mask { opacity: 0; transition: opacity 250ms ease-out; }
.modal { opacity: 0; transform: scale(0.96); transition: opacity 250ms cubic-bezier(0.22,1,0.36,1), transform 250ms cubic-bezier(0.22,1,0.36,1); }
.open .mask { opacity: 1; }
.open .modal { opacity: 1; transform: none; }
.closing .mask, .closing .modal { transition-duration: 180ms; transition-timing-function: ease-in; }
@media (prefers-reduced-motion: reduce) { .mask, .modal { transition: none; transform: none; } }
```

### tr-02  底部抽屉上滑（bottom-sheet）

- 区块：弹层
- 风格：通用
- 触发：状态过渡
- 端：H5
- 时长/缓动：进 300ms cubic-bezier(0.32,0.72,0,1)，出 220ms ease-in
- 性能：合成层
- 依赖：无
- 说明：H5 选择器、筛选、详情面板的标准出场。顶部留一条拖动指示条。iOS 上注意 safe-area 底部内边距。

```css
.sheet { position: fixed; left: 0; right: 0; bottom: 0; border-radius: 16px 16px 0 0;
  padding-bottom: env(safe-area-inset-bottom);
  transform: translateY(100%); transition: transform 300ms cubic-bezier(0.32,0.72,0,1); }
.open .sheet { transform: none; }
.closing .sheet { transition: transform 220ms ease-in; }
@media (prefers-reduced-motion: reduce) { .sheet { transition: none; } }
```

### tr-03  路由切换淡入（page-fade）

- 区块：通用
- 风格：企业 / 内容 / 奢华
- 触发：路由切换
- 端：双端
- 时长/缓动：进 250ms ease-out，出 150ms ease-in
- 性能：合成层
- 依赖：View Transitions（Chrome 111+ / Safari 18+；不支持时直接切换）
- 说明：SPA 路由切换时旧页淡出新页淡入。用 `document.startViewTransition` 包裹路由更新即可，框架路由器（Next / Nuxt / Astro）多有内建开关。

```js
function navigate(update) {
  if (!document.startViewTransition || matchMedia('(prefers-reduced-motion: reduce)').matches) return update();
  document.startViewTransition(update);
}
```

```css
::view-transition-old(root) { animation: 150ms ease-in both fade-out; }
::view-transition-new(root) { animation: 250ms ease-out both fade-in; }
@keyframes fade-out { to { opacity: 0; } }
@keyframes fade-in  { from { opacity: 0; } }
```

### tr-04  共享元素过渡（shared-element）

- 区块：列表 → 详情（卡片 / 媒体）
- 风格：活泼 / 内容 / 奢华
- 触发：路由切换
- 端：PC 优先（H5 支持时同样可用）
- 时长/缓动：350ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：View Transitions
- 说明：列表里的封面图"飞"到详情页位置。给同一实体在两页里的元素设同一个 `view-transition-name`。每个 name 在同一页只能出现一次。

```css
.card-cover { view-transition-name: var(--vt-name); } /* 模板里写 style="--vt-name: cover-123" */
.detail-cover { view-transition-name: var(--vt-name); }
::view-transition-group(*) { animation-duration: 350ms; animation-timing-function: cubic-bezier(0.22,1,0.36,1); }
@media (prefers-reduced-motion: reduce) { ::view-transition-group(*), ::view-transition-old(*), ::view-transition-new(*) { animation: none; } }
```

### tr-05  Toast 滑入（toast-slide）

- 区块：弹层
- 风格：通用
- 触发：状态过渡
- 端：双端（PC 右上角，H5 顶部居中）
- 时长/缓动：进 250ms cubic-bezier(0.22,1,0.36,1)，出 200ms ease-in
- 性能：合成层
- 依赖：无
- 说明：提示条从边缘滑入，停留 2–3s 后滑出。多条堆叠时用 dt-02 的列表过渡。

```css
.toast { opacity: 0; transform: translateY(-12px); transition: opacity 250ms cubic-bezier(0.22,1,0.36,1), transform 250ms cubic-bezier(0.22,1,0.36,1); }
.toast.show { opacity: 1; transform: none; }
.toast.hide { opacity: 0; transform: translateY(-12px); transition-duration: 200ms; transition-timing-function: ease-in; }
@media (prefers-reduced-motion: reduce) { .toast { transition: none; transform: none; } }
```

### tr-06  牌堆发牌切换（deck-swap）

- 区块：媒体 / 首屏（banner 轮播、图集）
- 风格：奢华 / 活泼 / 赛事
- 触发：状态过渡（自动轮播 / 手动切帧）
- 端：双端（H5 把飞出距离与旋转角减半）
- 时长/缓动：640ms cubic-bezier(.36,0,.62,1)
- 性能：合成层
- 依赖：无
- 说明：多帧像一叠牌堆着，后面几张按层级 `--k` 依次下移、缩小、微旋并降不透明度；切换时最上面那张甩向右上飞出，整叠升一层，飞出的那张用无动画瞬移回牌堆最底（和无缝轮播的「克隆首尾 + 瞬移」同一路数，恢复 transition 必须用**双 rAF**，单个 rAF 时浏览器可能尚未应用新位置，会把瞬移本身也动画掉）。露出边缘的层数控制在 2–3 层，再多只是糊成一片。牌类 / 赛事品牌语义契合度最高。与 tr-07、tr-08 同为轮播切换手法，同一轮播只能选一种。来源：Codrops「Effects for Card Stacks」+ 本项目 KPC 商城 banner · 2026-09-17

```css
.deck { position: relative; perspective: 1800px; }
.deck .card {
  position: absolute; inset: 0; border-radius: 12px; overflow: hidden;
  transform-origin: 50% 120%;
  transform: translateY(calc(var(--k, 0) * 16px)) scale(calc(1 - var(--k, 0) * .045)) rotate(calc(var(--k, 0) * -1.1deg));
  box-shadow: 0 18px 50px rgba(0,0,0, calc(.5 - var(--k, 0) * .12));
  z-index: calc(10 - var(--k, 0));
  transition: transform 640ms cubic-bezier(0.22,1,0.36,1), opacity 640ms cubic-bezier(0.22,1,0.36,1);
}
.deck .card[data-k="3"], .deck .card[data-k="4"] { opacity: 0; }   /* 只露前三层 */
.deck .card.dealt {                                                 /* 发出去的那张 */
  transform: translate(88%, -34%) rotate(17deg) scale(.96); opacity: 0; z-index: 30;
  transition: transform 620ms cubic-bezier(.36,0,.62,1), opacity 620ms ease-in;
}
.deck .card.snap { transition: none !important; }                   /* 归位到牌堆底，不要动画 */
@media (prefers-reduced-motion: reduce) {
  .deck .card { transition: none; }
  .deck .card.dealt { transform: none; opacity: 0; }
}
```

```js
let order = [0, 1, 2, 3, 4];                       // order[0] = 最上面那张
const layout = () => order.forEach((f, k) => cards[f].dataset.k = k);
function dealTo(to) {
  while (order[1] !== to) order.push(order.splice(1, 1)[0]);   // 把目标转到第 2 层
  layout();
  const top = cards[order[0]];
  top.classList.add('dealt');
  setTimeout(() => {
    order.push(order.shift());
    top.classList.add('snap'); top.classList.remove('dealt');
    layout();
    requestAnimationFrame(() => requestAnimationFrame(() => top.classList.remove('snap')));
  }, 620);
}
```

### tr-07  竖切翻牌切换（slat-flip）

- 区块：媒体 / 首屏（banner 轮播、大图切换）
- 风格：奢华 / 活泼 / 赛事
- 触发：状态过渡（自动轮播 / 手动切帧）
- 端：PC 优先（H5 片数降到 5–6）
- 时长/缓动：每片 620ms cubic-bezier(0.22,1,0.36,1)，逐片错峰 45ms
- 性能：合成层（N 个 preserve-3d 层同时动）
- 依赖：无
- 说明：整幅图切成 N 条竖片，每片正面是当前帧、背面是下一帧（`backface-visibility: hidden`），从左到右错峰翻 180°，像机场翻牌显示屏。视觉冲击是三种轮播切换里最强的。两个要点：① 每片的背景用 `background-size` 锁成整图尺寸、`background-position` 按片序左移 `-i * 片宽`，拼起来才是完整一张图；② 全部翻完后把正面换成新帧、无动画复位（双 rAF），否则下次翻转会从背面开始。**片数别超过 20**，层数翻倍后中端机掉帧。与 tr-06、tr-08 同为轮播切换手法，同一轮播只能选一种。来源：Codrops「Slice Revealer」思路改造 + 本项目 KPC 商城 banner · 2026-09-17

```css
.board { position: relative; display: flex; overflow: hidden; border-radius: 12px; }
.board .slat { position: relative; flex: 1 1 0; height: 100%; transform-style: preserve-3d;
  transition: transform 620ms cubic-bezier(0.22,1,0.36,1); }
.board .slat.flip { transform: rotateY(180deg); }
.board .slat.snap { transition: none; }
.board .face { position: absolute; inset: 0; overflow: hidden;
  backface-visibility: hidden; -webkit-backface-visibility: hidden; }
.board .face.back { transform: rotateY(180deg); }
.board .face .pic { position: absolute; inset: 0;
  background-size: var(--w) var(--h);             /* 整图尺寸，不是单片尺寸 */
  background-position: var(--bx) center; }        /* --bx = -i * 片宽 */
@media (prefers-reduced-motion: reduce) { .board .slat { transition: none; } }
```

```js
const N = 10, STEP = 45, FLIP = 620;
function flipTo(to) {
  backs.forEach((b) => b.dataset.f = to);
  slats.forEach((s, i) => setTimeout(() => s.classList.add('flip'), i * STEP));
  setTimeout(() => {
    fronts.forEach((f) => f.dataset.f = to);
    slats.forEach((s) => { s.classList.add('snap'); s.classList.remove('flip'); });
    requestAnimationFrame(() => requestAnimationFrame(() => slats.forEach((s) => s.classList.remove('snap'))));
  }, (N - 1) * STEP + FLIP);
}
```

### tr-08  斜切开幕切换（slit-split）

- 区块：媒体 / 首屏（banner 轮播、大图切换）
- 风格：奢华 / 内容 / 赛事
- 触发：状态过渡（自动轮播 / 手动切帧）
- 端：双端
- 时长/缓动：700ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层（clip-path 静态不插值，只动 transform）
- 依赖：无
- 说明：当前帧用两个**互补的静态** `clip-path` 切成上下两片，沿一道斜缝分别向左上 / 右下滑出，露出垫在底层的下一帧；裂开瞬间缝上掠过一道品牌色高光。关键在 clip-path 只用来切形状、全程不做形状插值（动的是 transform），所以重绘只发生在两片各自的合成层里，比真正的 clip-path 动画便宜得多——想做形状插值的话两个 polygon 顶点数必须相同，见 hv-22。三种轮播切换里最克制、奢华感最足。收尾同样是「换帧 + 无动画归位 + 双 rAF」。与 tr-06、tr-07 同为轮播切换手法，同一轮播只能选一种。来源：Codrops「Fullscreen Slit Slider」改斜缝 + 品牌金 · 2026-09-17

```css
.slit { position: relative; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.slit .frame { position: absolute; width: var(--fw); height: var(--fh); border-radius: 12px; overflow: hidden; }
.slit .frame.next { z-index: 5; }                                    /* 下一帧垫在底层 */
.slit .frame.top, .slit .frame.bot { z-index: 12;
  transition: transform 700ms cubic-bezier(0.22,1,0.36,1), opacity 700ms cubic-bezier(0.22,1,0.36,1); }
.slit .frame.top { clip-path: polygon(0 0, 100% 0, 100% 40%, 0 60%); }
.slit .frame.bot { clip-path: polygon(0 60%, 100% 40%, 100% 100%, 0 100%); }
.slit .frame.top.go { transform: translate(-14%, -62%) rotate(-1.5deg); opacity: 0; }
.slit .frame.bot.go { transform: translate(14%,  62%) rotate(-1.5deg); opacity: 0; }
.slit .frame.snap { transition: none !important; }
.slit .seam {                                                        /* 裂缝金光 */
  position: absolute; left: 0; right: 0; top: 50%; height: 2px; z-index: 14; pointer-events: none;
  transform: translateY(-1px) rotate(-4.5deg); opacity: 0; transition: opacity 260ms ease;
  background: linear-gradient(90deg, transparent, var(--brand) 20%, #fff 50%, var(--brand) 80%, transparent);
}
.slit .seam.on { opacity: 1; }
@media (prefers-reduced-motion: reduce) {
  .slit .frame.top, .slit .frame.bot { transition: none; }
  .slit .seam { display: none; }
}
```

```js
function slitTo(to) {
  setF(next, to);
  seam.classList.add('on');
  top.classList.add('go'); bot.classList.add('go');
  setTimeout(() => seam.classList.remove('on'), 420);
  setTimeout(() => {
    setF(top, to); setF(bot, to);
    top.classList.add('snap'); bot.classList.add('snap');
    top.classList.remove('go'); bot.classList.remove('go');
    requestAnimationFrame(() => requestAnimationFrame(() => {
      top.classList.remove('snap'); bot.classList.remove('snap');
    }));
  }, 700);
}
```
