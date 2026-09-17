# motion-pitch

给**已有页面**加动效的技能：先分析页面结构与风格，再从本地配方库组出三套整体方案（两套常规 + 一套冲击版），发预览页给你看，你选了才动项目代码。

不负责视觉设计——配色、字体、版式一律保持页面现状。想重做视觉找别的技能，本技能只管"怎么动"。

## 安装

**方式一：插件市场（推荐）**

```
/plugin marketplace add dengmengzhi/dev-skills
/plugin install motion-pitch@dev-skills
```

**方式二：软链（想改技能内容、想让配方库跟着自己长的用这个）**

```bash
git clone https://github.com/dengmengzhi/dev-skills.git
ln -s "$PWD/dev-skills/motion-pitch/skills/motion-pitch" ~/.claude/skills/motion-pitch
```

**方式三：塞进单个项目**：把 `skills/motion-pitch/` 整个目录拷到项目的 `.claude/skills/` 下。

`library/` 必须与 `SKILL.md` 同级，技能靠相对路径找它。

## 前置依赖

| | 用途 | 没有会怎样 |
| --- | --- | --- |
| bash / git / python3 | `check.sh`、`contribute.sh`、本地预览服务 | 自检与回流用不了，主流程不受影响 |
| **playwright**（强烈建议） | 抓线上页截图与源码、落地后逐个触发验证 | 退化成要你自己提供截图 |
| Artifact 工具（可选） | 把预览页发布成链接 | 退化成本地 http 服务打开 |
| Figma MCP（可选） | 从设计稿直接生成页面 + 动效 | 需要你导出整页截图，按截图走常规流程 |
| ImageMagick 或 Pillow（可选，非 macOS） | 压缩 Figma 导出的资产 | macOS 用自带 `sips`；都没有则跳过压缩，预览页会偏大 |
| gh（可选） | 把新配方贡献回上游 | 改为生成预填好的 issue 链接，点开确认即可 |

## 怎么用

不用记命令，直接说需求就会触发：

- 「给活动页 H5 加动效」
- 「首页太静态了，看着不高级」
- 「这个 Figma 稿生成页面，带上动效」（需 Figma MCP）
- 「不满意，换一批」

流程是固定的，每步都停下来等你确认，不会闷头改代码：

```
摸页面（截图/源码/设计稿）
  → 区块结构表 + 视觉权重 + 风格判定
  → 三套方案（两常规 + 一冲击，冲击版写清成本）
  → 预览页（整模块复刻，挂上各套动效）
  → 列实现方式对比，你选
  → 落地 + 截图验证 + 报告
```

**单次只做一端**（PC 或 H5），另一端另起一次。不满意说「换一批」，换三轮仍不满意会主动给一版越出风格档的激进版。

## 配方库

`library/` 是 60 来条可直接粘贴的动效配方，分 entrance / scroll / hover / feedback / data / transition / ambient 七类，每条自带默认时长、缓动、性能标记和 `prefers-reduced-motion` 降级代码。推荐时**先查库，库够用就不联网**——省 token，也保证手法可复用。

你随时可以说「这个效果入库」，它会按 `library/_template.md` 提炼成配方写进对应分类文件。库的成长与回流规矩见 [`library/README.md`](skills/motion-pitch/library/README.md)，联网找新手法前先读 [`library/sources.md`](skills/motion-pitch/library/sources.md) 的站点清单。

自检：

```bash
bash skills/motion-pitch/library/check.sh
```

## 想改口味改哪里

技能里有几条是作者的偏好，不是普适规则。不认同就改 `skills/motion-pitch/SKILL.md` 对应段落：

| 默认行为 | 改哪 |
| --- | --- |
| 动效默认给到**肉眼可见的强度**，宁可先给足再由你减 | 开头「核心原则」段 + 「红线」表里"怕过头"那行 |
| 预览页**只展示方案本身**，不放线上现状对照栏、不放对比开关 | 第 4 步「生成 demo 预览」 |
| 单次只做一端 | 「输入」第 2 条 + 「红线」首行 |
| 三套方案固定是两常规 + 一冲击 | 第 3 步末尾 |
| 库变更只列出来，**从不主动 git commit** | 「配方库」→「库的成长与提交」 |
| 每次发预览后报 token 消耗 | 第 4 步最后一条 |

## 许可

MIT
