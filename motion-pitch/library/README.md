# 动效配方库

`motion-pitch` 技能的本地知识储备。推荐动效时**先查这里，库够用就不联网**，省 token 也保证手法可复用。

## 文件

| 文件 | 内容 |
| --- | --- |
| `index.md` | 紧凑索引，一行一个配方。技能检索时**只读这一份**，命中后再按 id 去分类文件取正文 |
| `entrance.md` | 入场动效（首屏加载、组件挂载） |
| `scroll.md` | 滚动进入视口、滚动驱动 |
| `hover.md` | hover 动效（仅 PC） |
| `feedback.md` | 点击/触摸反馈、状态过渡 |
| `data.md` | 数据变化（数字滚动、列表增删、进度） |
| `transition.md` | 弹层、抽屉、路由切换 |
| `_template.md` | 新配方模板 |

## 如何新增一个配方

1. 复制 `_template.md` 里的段落，填好每个字段，追加到对应分类文件末尾。
2. 在 `index.md` 末尾加一行，字段与正文保持一致。
3. 不需要改 `SKILL.md`。

id 规则：分类前缀 + 两位序号，前缀固定为 `en`（entrance）/ `sc`（scroll）/ `hv`（hover）/ `fb`（feedback）/ `dt`（data）/ `tr`（transition）。同一分类内不重复即可。

## 字段取值

| 字段 | 可选值 |
| --- | --- |
| 区块 | 导航 / 首屏 / 列表 / 卡片 / CTA / 表单 / 弹层 / 页脚 / 通用 |
| 风格 | 奢华 / 活泼 / 企业 / 内容 / 通用（对应 SKILL.md 第 2 步四行风格表） |
| 触发 | 入场 / 滚动进入视口 / 滚动驱动 / hover / 点击反馈 / 数据变化 / 路由切换 / 状态过渡 |
| 端 | PC / H5 / 双端 |
| 性能 | 合成层（只动 transform/opacity/filter）/ 重排（动了布局属性，用时要说明） |
| 依赖 | 无 / IO（IntersectionObserver）/ WAAPI / View Transitions / motion / gsap / 其他库名 |

## 约定

- 代码段必须自带 `prefers-reduced-motion` 降级。
- 时长与缓动写默认值，实际使用时按 SKILL.md 第 2 步判定的风格档调整。
- 一个配方只做一件事，组合手法拆成多个配方。
- 从联网搜索沉淀进来的配方，`说明` 末尾注明来源站点或作者，便于日后核对。
