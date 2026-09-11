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
| `ambient.md` | 氛围类持续动效（光尘、辉光呼吸等），只用于冲击版 |
| `_template.md` | 新配方模板 |
| `check.sh` | 自检脚本：索引一致性、reduced-motion、重复 id、未提交改动 |
| `contribute.sh` | 把一条本地配方贡献回上游（建 issue 或生成预填链接） |
| `UPSTREAM` | 上游仓库 `owner/repo`，contribute.sh 与身份判定用 |
| `issue-template.md` | 手动开 issue 贡献配方时的格式参考 |

## 如何新增一个配方

1. 复制 `_template.md` 里的段落，填好每个字段，追加到对应分类文件末尾。
2. 在 `index.md` 末尾加一行，字段与正文保持一致。
3. 不需要改 `SKILL.md`。

id 规则：分类前缀 + 两位序号，前缀固定为 `en`（entrance）/ `sc`（scroll）/ `hv`（hover）/ `fb`（feedback）/ `dt`（data）/ `tr`（transition）/ `am`（ambient）。同一分类内不重复即可。

## 字段取值

| 字段 | 可选值 |
| --- | --- |
| 区块 | 导航 / 首屏 / 列表 / 卡片 / CTA / 表单 / 弹层 / 页脚 / 通用 |
| 风格 | 奢华 / 活泼 / 企业 / 内容 / 通用（对应 SKILL.md 第 2 步四行风格表） |
| 触发 | 入场 / 滚动进入视口 / 滚动驱动 / hover / 点击反馈 / 数据变化 / 路由切换 / 状态过渡 / 持续 |
| 端 | PC / H5 / 双端 |
| 性能 | 合成层（只动 transform/opacity）/ 绘制（filter、背景色等）/ 重排（动了布局属性）/ canvas（独立层持续绘制），非合成层的用时要说明 |
| 依赖 | 无 / IO（IntersectionObserver）/ WAAPI / View Transitions / motion / gsap / 其他库名 |

## 库怎么变强

配方有三个入口：冲击版里用到的新手法自动入库；常规版或联网搜到的新手法问过你再入库；你在任何项目里指着一个效果说"入库"，我按模板提炼后写进来。技能目录软链到本仓库，所以在别的项目里用 motion-pitch，配方也写到这里。

我不做 git 提交。每次用完我会在对话里列出"本次库变更（未提交）"，你 review 后自己 commit。提交前可以跑一次自检：

```bash
bash motion-pitch/library/check.sh
```

它会校验索引与正文一致、每条配方带 reduced-motion 降级、无重复 id，并列出未提交的改动和新增配方。

### 从 GitHub 拿走用的人，怎么把新配方贡献回来

上游仓库写在 `UPSTREAM`。你在自己机器上入库后，跑：

```bash
bash motion-pitch/library/contribute.sh <配方id>
```

有 `gh` 且已登录会直接在上游建一个 `recipe: <id> <名称>` 的 issue；没有 `gh` 会生成 `outbox/<id>.md` 并打印一个预填好标题和正文的 New issue 链接，点开确认就行。也可以照 `issue-template.md` 的格式手动开 issue。想走 PR 也可以：fork 后把配方段追加到分类文件、索引加一行、跑 `check.sh`，提 PR。

### 维护者收件

看标题 `recipe:` 开头的 issue，把正文追加到对应分类文件、索引加一行，跑 `check.sh`，commit，关 issue。或者对 motion-pitch 说"处理配方收件箱"，由它逐条落库，你只负责 review 和 commit。

## 约定

- 代码段必须自带 `prefers-reduced-motion` 降级。
- 时长与缓动写默认值，实际使用时按 SKILL.md 第 2 步判定的风格档调整。
- 一个配方只做一件事，组合手法拆成多个配方。
- 每条配方的 `说明` 末尾注明来源：`来源：<站点或项目> <模块> · <日期>`；联网搜到的写站点或作者。
- 相近手法不开新 id，在原配方 `说明` 末尾加一行"变体：…"。
