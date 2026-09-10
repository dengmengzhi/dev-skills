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
