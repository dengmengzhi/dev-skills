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
