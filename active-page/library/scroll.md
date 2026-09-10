# 滚动动效（scroll）

滚动进入视口触发一次，或随滚动进度连续驱动。视口触发统一用 `IntersectionObserver`，阈值 0.15–0.25，触发后 `unobserve`，只播一次。

通用观察器（配 sc-01 / sc-02 使用）：

```js
const io = new IntersectionObserver((entries) => {
  for (const e of entries) {
    if (e.isIntersecting) { e.target.classList.add('in-view'); io.unobserve(e.target); }
  }
}, { threshold: 0.2 });
document.querySelectorAll('[data-reveal]').forEach((el) => io.observe(el));
```

### sc-01  滚动进入渐显（io-reveal）

- 区块：通用
- 风格：通用
- 触发：滚动进入视口
- 端：双端
- 时长/缓动：500ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：IO
- 说明：首屏以下区块的默认入场。位移 16–24px 即可，别超过 40px。

```css
[data-reveal] { opacity: 0; transform: translateY(20px);
  transition: opacity 500ms cubic-bezier(0.22,1,0.36,1), transform 500ms cubic-bezier(0.22,1,0.36,1); }
[data-reveal].in-view { opacity: 1; transform: none; }
@media (prefers-reduced-motion: reduce) {
  [data-reveal] { opacity: 1; transform: none; transition: none; }
}
```

### sc-02  滚动错落渐显（io-stagger）

- 区块：列表 / 卡片
- 风格：通用
- 触发：滚动进入视口
- 端：双端
- 时长/缓动：每项 500ms，间隔 80ms
- 性能：合成层
- 依赖：IO
- 说明：卡片网格进入视口时依次出现。观察父容器而不是每个子项，一次触发整组。

```css
[data-reveal-group] > * { opacity: 0; transform: translateY(20px);
  transition: opacity 500ms cubic-bezier(0.22,1,0.36,1), transform 500ms cubic-bezier(0.22,1,0.36,1);
  transition-delay: calc(var(--i, 0) * 80ms); }
[data-reveal-group].in-view > * { opacity: 1; transform: none; }
@media (prefers-reduced-motion: reduce) {
  [data-reveal-group] > * { opacity: 1; transform: none; transition: none; }
}
```

### sc-03  背景视差（parallax）

- 区块：首屏 / 媒体
- 风格：奢华 / 内容
- 触发：滚动驱动
- 端：PC（H5 慎用，低端机掉帧且 iOS 有惯性滚动抖动）
- 时长/缓动：跟随滚动，无固定时长
- 性能：合成层
- 依赖：无（CSS 滚动驱动动画，Chrome 115+ / Safari 26+；不支持时静态）
- 说明：背景比前景滚得慢，产生纵深。位移幅度 10–20% 即可。用 `@supports` 兜底，不支持的浏览器就是普通静态背景。

```css
@supports (animation-timeline: scroll()) {
  .parallax-bg {
    animation: parallax linear both;
    animation-timeline: scroll(root);
  }
  @keyframes parallax {
    from { transform: translateY(0); }
    to   { transform: translateY(-15%); }
  }
}
@media (prefers-reduced-motion: reduce) {
  .parallax-bg { animation: none; }
}
```

### sc-04  阅读进度条（scroll-progress）

- 区块：导航
- 风格：内容
- 触发：滚动驱动
- 端：双端
- 时长/缓动：跟随滚动
- 性能：合成层
- 依赖：无（CSS 滚动驱动动画；不支持时隐藏或用 JS 兜底）
- 说明：长文顶部一条随滚动增长的细线。高度 2–3px，用品牌主色。

```css
.scroll-progress {
  position: fixed; top: 0; left: 0; height: 3px; width: 100%;
  background: var(--brand); transform-origin: left; transform: scaleX(0);
}
@supports (animation-timeline: scroll()) {
  .scroll-progress { animation: grow linear both; animation-timeline: scroll(root); }
  @keyframes grow { to { transform: scaleX(1); } }
}
@media (prefers-reduced-motion: reduce) {
  .scroll-progress { display: none; }
}
```

### sc-05  图片渐进加载（blur-up）

- 区块：媒体 / 卡片 / 列表
- 风格：内容 / 奢华
- 触发：滚动进入视口
- 端：双端
- 时长/缓动：600ms ease-out
- 性能：合成层（filter 在大图上开销偏高，H5 控制在卡片尺寸）
- 依赖：无（配 `loading="lazy"` 与 `onload`）
- 说明：先显示模糊小图或纯色底，大图 load 完从模糊过渡到清晰。适合图片多的资讯流、作品集。

```css
.blur-up { filter: blur(12px); transform: scale(1.02); transition: filter 600ms ease-out, transform 600ms ease-out; }
.blur-up.loaded { filter: blur(0); transform: none; }
@media (prefers-reduced-motion: reduce) {
  .blur-up { filter: none; transform: none; transition: none; }
}
```

```js
document.querySelectorAll('img.blur-up').forEach((img) => {
  if (img.complete) img.classList.add('loaded');
  else img.addEventListener('load', () => img.classList.add('loaded'), { once: true });
});
```

### sc-06  导航滚动收缩（nav-shrink）

- 区块：导航
- 风格：企业 / 内容 / 奢华
- 触发：滚动驱动
- 端：双端
- 时长/缓动：250ms ease-in-out
- 性能：合成层（用 transform 缩 logo、改背景透明度；不改 height）
- 依赖：无（监听 scroll 加 class，或 IO 观察一个哨兵元素）
- 说明：滚过首屏后导航变紧凑、加毛玻璃底。用哨兵元素 + IO 比监听 scroll 省电。

```css
.nav { transition: background-color 250ms ease-in-out, box-shadow 250ms ease-in-out; }
.nav .logo { transition: transform 250ms ease-in-out; transform-origin: left center; }
.nav.compact { background: rgba(255,255,255,.85); backdrop-filter: blur(12px); box-shadow: 0 1px 0 rgba(0,0,0,.06); }
.nav.compact .logo { transform: scale(.85); }
@media (prefers-reduced-motion: reduce) {
  .nav, .nav .logo { transition: none; }
}
```

```js
// 页面顶部放一个 1px 高的 <div class="nav-sentinel">，离开视口即收缩
new IntersectionObserver(([e]) => {
  document.querySelector('.nav').classList.toggle('compact', !e.isIntersecting);
}).observe(document.querySelector('.nav-sentinel'));
```
