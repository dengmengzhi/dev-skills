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

### dt-06  超长列表自动滚动（auto-scroll-list）

- 区块：列表（大屏排队板、榜单、公告栏）
- 风格：通用
- 触发：持续（内容超出容器时自动开始，不超出不动）
- 端：双端（大屏首选）
- 时长/缓动：按溢出高度算，约 18px/s，两端各停 12%，ease-in-out 往返
- 性能：合成层（transform）
- 依赖：无（少量 JS 测量溢出）
- 说明：无鼠标的大屏上，队列超过板子高度时靠自动上下滚动把尾部露出来；不溢出的列不动。用 CSS 变量 `--over` 传溢出高度、`--dur` 传时长，JS 只负责测量与在数据变化后重测。列间不同步（时长不同）反而自然。来源：利陞扑克排队板大屏（Figma）· 2026-09-11

```css
.names { overflow: hidden; height: var(--avail); }
.names.scroll .names-in { animation: scrollY var(--dur, 12s) ease-in-out infinite alternate; animation-delay: 3s; }
@keyframes scrollY { 0%, 12% { transform: translateY(0); } 88%, 100% { transform: translateY(calc(-1 * var(--over, 0px))); } }
@media (prefers-reduced-motion: reduce) { .names.scroll .names-in { animation: none; } }
```

```js
function measureScroll(names) {            // names = 容器；子元素 .names-in 是实际列表
  const inner = names.firstElementChild, avail = names.clientHeight, over = inner.scrollHeight - avail;
  names.classList.toggle('scroll', over > 0);
  inner.style.setProperty('--over', `${Math.max(0, over)}px`);
  inner.style.setProperty('--dur', `${Math.max(8, over / 18)}s`);
}
// 数据变化后（加入 / 离开）再调一次 measureScroll
```

### dt-07  中心辐射揭示（radial-wave-reveal）

- 区块：卡片 / 首屏（雷达图、数据图）
- 风格：奢华 / 内容 / 赛事
- 触发：入场 / 滚动进入视口 / 数据变化
- 端：PC
- 时长/缓动：900ms 线性波前；冲击版 1100ms，脉冲错开 14%
- 性能：Canvas 短时绘制；不修改布局
- 依赖：无（Canvas 2D + requestAnimationFrame + IO）
- 说明：数据保持最终几何形状，用从中心向外扩展的圆形裁切揭示，波前离开后恢复静态。变体：circle 单圈、hex 六边形双圈、burst 三道脉冲加短时轴线高亮。只在入场绘制；离开视口、页面隐藏、组件卸载及减少动态设置变化时调用 stop。示例数据、色值和画布尺寸由业务接入时替换；不是持续运行的状态指示。来源：kpc-fe 选手详情雷达图 PC · 2026-10-29。

```html
<div class="demo fx-dt-07 fx-reveal fx-rays" data-kind="burst">
  <canvas width="1176" height="992" style="width:588px;height:496px"></canvas>
</div>
```

```js

const values=[67,56,104,54,100,45],reduce=matchMedia('(prefers-reduced-motion: reduce)'),running=new WeakMap();
const angle=i=>i*Math.PI/3-Math.PI/2;
function polygon(ctx,vs){ctx.beginPath();vs.forEach((v,i)=>{const r=Math.min(125,v)*1.6,x=294+Math.cos(angle(i))*r,y=249+Math.sin(angle(i))*r;i?ctx.lineTo(x,y):ctx.moveTo(x,y)});ctx.closePath()}
function circle(ctx,r){ctx.beginPath();ctx.arc(294,249,Math.max(.01,r),0,Math.PI*2)}
function outline(ctx,kind,r){if(kind==='hex')polygon(ctx,Array(6).fill(r/1.6));else circle(ctx,r)}
function draw(demo,p,active){const canvas=demo.querySelector('canvas'),ctx=canvas.getContext('2d');ctx.setTransform(2,0,0,2,0,0);ctx.clearRect(0,0,588,496);ctx.lineWidth=.7;ctx.strokeStyle='rgba(214,214,214,.16)';[25,50,75,100].forEach(v=>{polygon(ctx,Array(6).fill(v));ctx.stroke()});for(let i=0;i<6;i++){ctx.beginPath();ctx.moveTo(294,249);ctx.lineTo(294+Math.cos(angle(i))*160,249+Math.sin(angle(i))*160);ctx.stroke()}
 const r=240*Math.min(1,p/0.85),kind=demo.dataset.kind;
 // The data never shrinks. A circular wavefront reveals its real geometry as it travels outwards.
 ctx.save();if(active&&demo.classList.contains('fx-reveal')){circle(ctx,r);ctx.clip()}polygon(ctx,values);ctx.fillStyle='rgba(215,70,70,.1)';ctx.fill();ctx.strokeStyle='#d74646';ctx.lineWidth=1.5;ctx.stroke();ctx.restore();
 if(!active||p>=1)return;
 if(demo.classList.contains('fx-grid')){ctx.save();circle(ctx,r);ctx.clip();ctx.strokeStyle=`rgba(214,214,214,${.3*(1-p)})`;ctx.lineWidth=1;[25,50,75,100].forEach(v=>{polygon(ctx,Array(6).fill(v));ctx.stroke()});ctx.restore()}
 if(demo.classList.contains('fx-rays')){ctx.strokeStyle=`rgba(215,70,70,${.35*(1-p)})`;ctx.lineWidth=1.2;for(let i=0;i<6;i++){ctx.beginPath();ctx.moveTo(294,249);ctx.lineTo(294+Math.cos(angle(i))*Math.min(205,r),249+Math.sin(angle(i))*Math.min(205,r));ctx.stroke()}}
 if(demo.classList.contains('fx-dt-07')){const count=kind==='burst'?3:kind==='hex'?2:1;for(let n=0;n<count;n++){const phase=(p-n*.14)/(.85-n*.04);if(phase<=0||phase>=1)continue;const radius=phase*225;const alpha=Math.sin(Math.PI*phase)*(.72-n*.1);ctx.lineWidth=kind==='burst'?1.8:1.3;ctx.strokeStyle=`rgba(215,70,70,${alpha})`;outline(ctx,kind,radius);ctx.stroke();ctx.lineWidth=6;ctx.strokeStyle=`rgba(215,70,70,${alpha*.07})`;outline(ctx,kind,radius);ctx.stroke()}}
}
function stop(demo){cancelAnimationFrame(running.get(demo));running.delete(demo);draw(demo,1,false)}
function play(demo){stop(demo);if(reduce.matches||![...demo.classList].some(x=>x.startsWith('fx-')))return;const start=performance.now(),duration=demo.dataset.kind==='burst'?1100:900;function tick(now){const p=Math.min(1,(now-start)/duration);draw(demo,p,true);if(p<1)running.set(demo,requestAnimationFrame(tick));else{running.delete(demo);draw(demo,1,false)}}running.set(demo,requestAnimationFrame(tick))}

const demo = document.querySelector('.demo');
play(demo);
// IO 离屏、visibilitychange、卸载及开关取消时：stop(demo)。
// 减少动态：play 内检测 prefers-reduced-motion，直接绘制终态。
reduce.addEventListener('change', () => stop(demo));
```

### dt-08  顶点发射后闭合（vertex-launch-close）

- 区块：卡片 / 首屏（雷达图）
- 风格：奢华 / 内容 / 赛事
- 触发：入场 / 滚动进入视口 / 数据变化
- 端：PC
- 时长/缓动：顶点约 600ms ease-out → 连线约 350ms 线性 → 填色约 150ms
- 性能：Canvas 短时绘制；无布局动画
- 依赖：无（Canvas 2D + requestAnimationFrame + IO）
- 说明：六个数据顶点沿各自轴线从中心射出，全部到达真实分数位置后才按周长连线闭合，最后填充淡色。文字与网格保持静止。变体：together 齐发、stagger 顺时针错开 60ms、trail 齐发加短尾迹；结束恢复相同静态图形，零值边长度为零时安全处理。接入时用接口分数替换示例 values，颜色与尺寸映射项目 token。离屏、页面隐藏、卸载及取消效果时 stop；play 检测 prefers-reduced-motion。来源：kpc-fe 选手详情雷达图 PC · 2026-10-29。

```html
<div class="demo fx-dt-08 fx-close fx-trail" data-kind="trail">
  <canvas width="1176" height="992" style="width:588px;height:496px"></canvas>
</div>
```

```js

const values=[67,56,104,54,100,45],reduced=matchMedia('(prefers-reduced-motion: reduce)'),running=new WeakMap();
const targets=values.map((v,i)=>{const a=i*Math.PI/3-Math.PI/2,r=Math.min(125,v)*1.6;return[294+Math.cos(a)*r,249+Math.sin(a)*r]});
const clamp=n=>Math.max(0,Math.min(1,n));
function shape(ctx,points){ctx.beginPath();points.forEach(([x,y],i)=>i?ctx.lineTo(x,y):ctx.moveTo(x,y));ctx.closePath()}
function draw(demo,p,active){
 const ctx=demo.querySelector('canvas').getContext('2d');ctx.setTransform(2,0,0,2,0,0);ctx.clearRect(0,0,588,496);
 ctx.lineWidth=.7;ctx.strokeStyle='rgba(214,214,214,.16)';for(const r of [40,80,120,160]){shape(ctx,Array.from({length:6},(_,i)=>{const a=i*Math.PI/3-Math.PI/2;return[294+Math.cos(a)*r,249+Math.sin(a)*r]}));ctx.stroke()}
 for(let i=0;i<6;i++){const a=i*Math.PI/3-Math.PI/2;ctx.beginPath();ctx.moveTo(294,249);ctx.lineTo(294+Math.cos(a)*160,249+Math.sin(a)*160);ctx.stroke()}
 if(!active||p>=1){shape(ctx,targets);ctx.fillStyle='rgba(215,70,70,.1)';ctx.fill();ctx.strokeStyle='#d74646';ctx.lineWidth=1.5;ctx.stroke();demo.dataset.phase='complete';return}
 const launch=demo.classList.contains('fx-dt-08'),close=demo.classList.contains('fx-close'),tail=demo.classList.contains('fx-trail');
 const arrivals=targets.map((target,i)=>{const delay=demo.dataset.kind==='stagger'?i*.055:0;return launch?clamp((p-delay)/(demo.dataset.kind==='stagger'?.275:.55)):1});
 const allArrived=arrivals.every(v=>v===1),lineProgress=close?clamp((p-.6)/.3):1;
 demo.dataset.phase=!allArrived?'launch':lineProgress<1?'closing':'fill';
 // No connecting line is drawn until every data vertex reaches its actual score position.
 if(allArrived){
  const lengths=targets.map((a,i)=>Math.hypot(a[0]-targets[(i+1)%6][0],a[1]-targets[(i+1)%6][1]));let remaining=lengths.reduce((a,b)=>a+b,0)*lineProgress;
  ctx.beginPath();ctx.moveTo(...targets[0]);for(let i=0;i<6;i++){const a=targets[i],b=targets[(i+1)%6],ratio=lengths[i]?clamp(remaining/lengths[i]):1;ctx.lineTo(a[0]+(b[0]-a[0])*ratio,a[1]+(b[1]-a[1])*ratio);remaining-=lengths[i];if(ratio<1)break}
  ctx.strokeStyle='#d74646';ctx.lineWidth=1.5;ctx.stroke();
  if(lineProgress===1){shape(ctx,targets);ctx.fillStyle=`rgba(215,70,70,${.1*(close?clamp((p-.9)/.1):1)})`;ctx.fill()}
 }
 targets.forEach(([tx,ty],i)=>{const t=arrivals[i],e=1-Math.pow(1-t,2),x=294+(tx-294)*e,y=249+(ty-249)*e;
  if(tail&&t<1){const lag=Math.max(0,e-.2);ctx.beginPath();ctx.moveTo(294+(tx-294)*lag,249+(ty-249)*lag);ctx.lineTo(x,y);ctx.strokeStyle='rgba(215,70,70,.4)';ctx.lineWidth=2;ctx.stroke()}
  ctx.beginPath();ctx.arc(x,y,2.6,0,Math.PI*2);ctx.fillStyle=`rgba(215,70,70,${p>.9?clamp((1-p)/.1):1})`;ctx.fill();
 });
}
function stop(demo){cancelAnimationFrame(running.get(demo));running.delete(demo);draw(demo,1,false)}
function play(demo){stop(demo);if(reduced.matches||![...demo.classList].some(x=>x.startsWith('fx-')))return;const start=performance.now();function tick(now){const p=clamp((now-start)/1100);draw(demo,p,true);if(p<1)running.set(demo,requestAnimationFrame(tick));else{running.delete(demo);draw(demo,1,false)}}running.set(demo,requestAnimationFrame(tick))}

const demo = document.querySelector('.demo');
play(demo);
reduced.addEventListener('change', () => stop(demo));
// IO 离屏、visibilitychange、卸载与取消时调用 stop(demo)。
```
