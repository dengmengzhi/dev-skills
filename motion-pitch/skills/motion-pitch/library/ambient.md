# 氛围动效（ambient）

持续运行的背景层动效，不绑定具体交互，用来定调气质。**只在冲击版里用**，每页最多一处；必须离开视口暂停、`prefers-reduced-motion` 下关闭；放在独立层（canvas 或绝对定位容器），不与内容元素抢 transform。

### am-01  金色光尘（gold-dust）

- 区块：首屏 / 通用（模块背景）
- 风格：奢华
- 触发：持续（进入视口开始，离开暂停）
- 端：双端（H5 粒子数减半）
- 时长/缓动：持续；粒子上升 0.12–0.4px/帧，闪烁周期随机
- 性能：canvas 每帧重绘，70 个粒子在 1440×720 下开销可忽略；离开视口必须停 rAF
- 依赖：无（canvas 2D）
- 说明：几十粒微小的金色光点在深色背景里缓慢升腾、明暗呼吸，像会所里的浮尘或舞台的光屑。深色底专用，浅色底不成立。颜色跟品牌金，透明度 0.18–0.5。
  变体：银色光尘 + 约 12% 朱红点缀（银色/朱红主题站），粒子 `fillStyle` 银用 `rgba(230,230,230,a)`、朱红用 `rgba(229,57,53,a)`，`shadowBlur 6` 同色发光；约 70 粒，IntersectionObserver 离开视口停 rAF，配方开关取消时 cancelAnimationFrame 并清画布。来源：kpc-fe 首页首屏（PC）· 2026-10-05

```html
<canvas class="dust" width="1440" height="720" aria-hidden="true"></canvas>
<!-- 绝对定位铺满模块，z-index 低于内容，pointer-events: none -->
```

```js
function goldDust(canvas, { count = 70, color = '212,168,83' } = {}) {
  if (matchMedia('(prefers-reduced-motion: reduce)').matches) return () => {};
  const ctx = canvas.getContext('2d'), W = canvas.width, H = canvas.height;
  const P = Array.from({ length: count }, () => ({ x: Math.random() * W, y: Math.random() * H, r: .8 + Math.random() * 1.8, v: .12 + Math.random() * .28, a: Math.random() * Math.PI * 2, s: .004 + Math.random() * .008 }));
  let visible = false, raf = null;
  const draw = () => {
    raf = null; ctx.clearRect(0, 0, W, H);
    if (!visible) return;
    for (const d of P) {
      d.y -= d.v; d.a += d.s; if (d.y < -4) { d.y = H + 4; d.x = Math.random() * W; }
      ctx.beginPath(); ctx.arc(d.x, d.y, d.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${color},${(.18 + .32 * (Math.sin(d.a) + 1) / 2).toFixed(3)})`; ctx.fill();
    }
    raf = requestAnimationFrame(draw);
  };
  const io = new IntersectionObserver(([e]) => { visible = e.isIntersecting; if (!raf) raf = requestAnimationFrame(draw); }, { threshold: .05 });
  io.observe(canvas);
  return () => { io.disconnect(); visible = false; };
}
```


### am-02  视点缓移（view-drift）

- 区块：首屏 / 通用（任何 3D 透视容器：卡片轮播、倾斜阵列）
- 风格：奢华
- 触发：持续（进入视口开始，离开暂停）
- 端：PC（H5 视口小，位移比例要减半，否则边缘卡会进出画面）
- 时长/缓动：9s ease-in-out 循环，偏移幅度 ±3%
- 性能：合成层（只改 perspective-origin，不触发布局）
- 依赖：无（纯 CSS）
- 说明：让 3D 容器的**观察点**极缓漂移，整片阵列像被一台缓慢移动的摄影机拍着，静止画面也有呼吸感。
  关键是**不要用容器 rotateY 做呼吸**：复合矩阵 Rx·Ry 存在 x→y 的耦合项，阵列会整体变成一侧高一侧低
  （实测 rotateY -10° 时最左与最右卡中心相差 40.2px），而且这个偏差没法只靠平移补偿。
  改 perspective-origin 没有这个耦合，观感接近但几何保持对称。幅度超过 ±5% 会让边缘元素明显进出画面。
  来源：kpc-fe 首页选手风采 3D 轮播 · 2026-09-15

```css
.scene { perspective: 1300px; perspective-origin: 50% 50%; }
.scene.drift { animation: view-drift 9s ease-in-out infinite; }
@keyframes view-drift {
  0%, 100% { perspective-origin: 50% 50%; }
  33%      { perspective-origin: 53.5% 47%; }
  66%      { perspective-origin: 47% 52.5%; }
}
@media (prefers-reduced-motion: reduce) { .scene.drift { animation: none; } }
```

```js
// 离开视口暂停，不空耗
new IntersectionObserver(([e]) => {
  e.target.style.animationPlayState = e.isIntersecting ? 'running' : 'paused';
}, { threshold: .05 }).observe(document.querySelector('.scene'));
```

### am-03  中心背光呼吸（backlight-breathe）

- 区块：卡片 / 列表（轮播中心卡、主推卡）/ 首屏
- 风格：奢华
- 触发：持续
- 端：双端
- 时长/缓动：4s ease-in-out 循环（opacity 0.55↔1 + scale 0.94↔1.06）
- 性能：合成层（单个模糊圆只动 transform / opacity；blur 只在首帧栅格化）
- 依赖：无（IO 离开视口暂停）
- 说明：在中心卡背后放一团模糊的径向光，缓慢呼吸，把视线锁在主推卡上，深色底专用。光的颜色取品牌双色：核心用主色（银 rgba(230,230,230,.24)），外晕用强调色（朱红 rgba(180,30,35,.2)）。中心卡位置固定的轮播（切换时卡在动、中心位不动）直接把光挂在舞台正中，不用跟随卡片；卡片层级要高于光（光 z-index 0，卡片 ≥1）。每页最多一处持续氛围动效，和 am-01 光尘不要同屏。来源：kpc-fe 首页赛事日历（PC）· 2026-10-05
```css
.stage { position: relative; }
.backlight {
  position: absolute; left: 50%; top: 50%; width: 620px; height: 680px; margin: -340px 0 0 -310px;
  z-index: 0; pointer-events: none; border-radius: 50%;
  background: radial-gradient(closest-side, rgba(230,230,230,.24), rgba(180,30,35,.2) 55%, transparent 100%);
  filter: blur(24px);
  animation: backlight-breathe 4s ease-in-out infinite;
}
.stage.paused .backlight { animation-play-state: paused; }
@keyframes backlight-breathe { 0%, 100% { opacity: .55; transform: scale(.94); } 50% { opacity: 1; transform: scale(1.06); } }
@media (prefers-reduced-motion: reduce) { .backlight { animation: none; display: none; } }
```
```js
// 离开视口暂停
new IntersectionObserver(([e]) => e.target.classList.toggle('paused', !e.isIntersecting), { threshold: .3 })
  .observe(document.querySelector('.stage'));
```
