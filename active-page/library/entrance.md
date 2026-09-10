# 入场动效（entrance）

首屏加载或组件挂载时的出现方式。原则：首屏入场不阻塞 LCP，动画元素初始 `opacity:0` 只加在非 LCP 元素上。

### en-01  淡入上浮（fade-up）

- 区块：通用
- 风格：企业 / 内容 / 活泼
- 触发：入场
- 端：双端
- 时长/缓动：400ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：无
- 说明：最通用的入场，几乎所有风格可用。奢华风把时长拉到 600–800ms、位移减到 12px。不要给 LCP 元素加。

```css
.fade-up {
  animation: fade-up var(--dur, 400ms) cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes fade-up {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: none; }
}
@media (prefers-reduced-motion: reduce) {
  .fade-up { animation: none; }
}
```

### en-02  错落入场（stagger）

- 区块：列表 / 卡片 / 导航
- 风格：通用
- 触发：入场
- 端：双端
- 时长/缓动：每项 400ms，间隔 60–100ms
- 性能：合成层
- 依赖：无
- 说明：同类元素依次出现，配合 en-01 使用。超过 8 项后间隔递减或只给前 8 项错落，避免尾部等太久。

```css
.stagger > * {
  animation: fade-up 400ms cubic-bezier(0.22, 1, 0.36, 1) both;
  animation-delay: calc(var(--i, 0) * 80ms);
}
/* 模板里给每个子项写 style="--i: 0/1/2..."，或用 :nth-child 枚举前 8 项 */
@media (prefers-reduced-motion: reduce) {
  .stagger > * { animation: none; }
}
```

### en-03  慢速渐显微缩放（slow-reveal）

- 区块：首屏
- 风格：奢华
- 触发：入场
- 端：双端
- 时长/缓动：900ms cubic-bezier(0.22,1,0.36,1)
- 性能：合成层
- 依赖：无
- 说明：首屏大图或标题从 1.04 缩到 1 同时渐显，营造沉静高级感。缩放幅度不超过 1.06，否则像放大镜。

```css
.slow-reveal {
  animation: slow-reveal 900ms cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes slow-reveal {
  from { opacity: 0; transform: scale(1.04); }
  to   { opacity: 1; transform: scale(1); }
}
@media (prefers-reduced-motion: reduce) {
  .slow-reveal { animation: none; }
}
```

### en-04  标题流光（shimmer-text）

- 区块：首屏 / CTA
- 风格：奢华
- 触发：入场
- 端：双端
- 时长/缓动：1800ms linear，播放一次或每 6s 一次
- 性能：合成层（background-position 在渐变文字上开销小，但大面积慎用）
- 依赖：无
- 说明：金属质感标题上扫过一道高光。只用在一处主标题上，多处流光显廉价。持续循环时间隔 ≥ 5s。

```css
.shimmer-text {
  background: linear-gradient(110deg, #c9a962 40%, #fff2c7 50%, #c9a962 60%);
  background-size: 200% 100%;
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: shimmer 1800ms linear 1;
}
@keyframes shimmer {
  from { background-position: 200% 0; }
  to   { background-position: -200% 0; }
}
@media (prefers-reduced-motion: reduce) {
  .shimmer-text { animation: none; background-position: 0 0; }
}
```

### en-05  弹性缩放入场（spring-pop）

- 区块：CTA / 卡片 / 图标
- 风格：活泼
- 触发：入场
- 端：双端
- 时长/缓动：450ms cubic-bezier(0.34,1.56,0.64,1)
- 性能：合成层
- 依赖：无
- 说明：带一点过冲的弹出，适合消费类、年轻向。金融/企业类禁用。

```css
.spring-pop {
  animation: spring-pop 450ms cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes spring-pop {
  from { opacity: 0; transform: scale(0.8); }
  to   { opacity: 1; transform: scale(1); }
}
@media (prefers-reduced-motion: reduce) {
  .spring-pop { animation: none; }
}
```

### en-06  遮罩擦除揭示（clip-reveal）

- 区块：首屏 / 媒体
- 风格：奢华 / 内容
- 触发：入场
- 端：双端
- 时长/缓动：700ms cubic-bezier(0.77,0,0.18,1)
- 性能：合成层（clip-path 可加速，部分旧安卓掉帧）
- 依赖：无
- 说明：图片或色块从一侧擦出来，比淡入更有"揭幕"感。H5 低端机注意测帧率。

```css
.clip-reveal {
  animation: clip-reveal 700ms cubic-bezier(0.77, 0, 0.18, 1) both;
}
@keyframes clip-reveal {
  from { clip-path: inset(0 100% 0 0); }
  to   { clip-path: inset(0 0 0 0); }
}
@media (prefers-reduced-motion: reduce) {
  .clip-reveal { animation: none; }
}
```

### en-07  骨架屏交叉淡入（skeleton-crossfade）

- 区块：列表 / 卡片 / 表单
- 风格：企业 / 内容
- 触发：入场
- 端：双端
- 时长/缓动：骨架 1.2s 循环；切换 250ms ease-out
- 性能：合成层
- 依赖：无
- 说明：数据驱动区块的标准做法：先骨架，数据到了淡入真实内容。骨架闪烁用渐变位移，不用 opacity 闪。

```css
.skeleton {
  background: linear-gradient(90deg, #eee 25%, #f5f5f5 37%, #eee 63%);
  background-size: 400% 100%;
  animation: skeleton-shine 1.2s ease-in-out infinite;
}
@keyframes skeleton-shine {
  from { background-position: 100% 0; }
  to   { background-position: 0 0; }
}
.content-enter { animation: fade-in 250ms ease-out both; }
@keyframes fade-in { from { opacity: 0; } to { opacity: 1; } }
@media (prefers-reduced-motion: reduce) {
  .skeleton, .content-enter { animation: none; }
}
```
