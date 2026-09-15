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
