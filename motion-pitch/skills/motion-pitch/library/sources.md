# 取材站点清单

联网找新手法时**按这份清单逛，不用泛搜索引擎**。顺序即优先级：先"可直接抄代码"，再"整站气质"，最后灵感类。找到手法后按 `_template.md` 提炼入库，`说明` 末尾的来源写站点 + 模块 + 日期。

## 一、可直接抄代码（首选，命中率最高）

| 站点 | 看什么 | 备注 |
| --- | --- | --- |
| tympanus.net/codrops | Demos 区几百个独立 demo：文字揭示、图片遮罩、滚动叙事、网格转场 | 每个都带源码，提炼成配方最省事 |
| codepen.io/trending | 单点效果，搜 `scroll reveal` / `marquee` / `number counter` | 质量参差，挑 fork 数高的 |
| uiverse.io | 纯 CSS 的按钮 / loader / 卡片 | 补 `feedback.md`、`hover.md` |
| animista.net | CSS keyframe 生成器 | 校准时长与缓动手感，不直接入库 |
| motion.dev/examples | motion(framer-motion) 官方示例 | React 栈落地时对得上 |
| ui.aceternity.com、magicui.design、reactbits.dev | 组件级动效合集 | 偏重型，多数属冲击版素材 |

## 二、整站气质（判风格、找整页节奏）

| 站点 | 看什么 | 备注 |
| --- | --- | --- |
| awwwards.com | Sites of the Day，可按 Animation / Transitions 筛 | 获奖站基本动效驱动 |
| thefwa.com | 更偏实验性的重型动效 | 激进版参考 |
| godly.website | 策展质量高，有 Dark / Luxury / 3D 标签 | 深色 / 奢华向的首选 |
| gsap.com/showcase | 重动效商业站 | 能反查它们用的是什么实现 |
| land-book.com、lapa.ninja | 落地页为主 | 找首屏 Hero 的入场节奏 |

## 三、移动端 / H5（库里 H5 专属配方最少，缺口在这）

| 站点 | 看什么 | 备注 |
| --- | --- | --- |
| mobbin.com | 真实 App 的流程截屏与录屏：抽屉、Tab 切换、下拉刷新、列表转场 | freemium，H5 手势反馈主要来源 |
| screenlane.com | 移动 UI 动效卡片，更新快 | |
| dribbble.com（筛 Motion） | 概念稿 | 当灵感看，别当实现参考 |

## 四、素材与工具

| 站点 | 用途 |
| --- | --- |
| lottiefiles.com | 插画 / 品牌动画 |
| rive.app/community | 带状态机的交互动画 |
| easings.net、cubic-bezier.com | 缓动曲线 |

## 当前缺口（逛的时候优先盯这几样）

- **文字类动效**：逐字/逐词揭示、split-text、数字翻牌 —— 库里为零，赛事页标题最常用
- **滚动叙事**：sticky 卡片堆叠、横向滚动区、滚动驱动的图片序列 —— `scroll.md` 只有 6 条且偏轻
- **ambient**：只有 am-01、am-02 两条，冲击版方案很快重样
- **H5 手势**：下拉刷新、左滑操作、吸底 CTA 的出现/隐藏
- **图片类补充**：滚动驱动的裁切扩张、拖动对比滑块
