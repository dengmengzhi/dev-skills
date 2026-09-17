# 配方贡献 issue 格式

没有 gh 命令、也不想用 `contribute.sh` 生成的链接时，按下面格式到上游仓库手动开 issue，标题写 `recipe: <id> <名称>`。

## 配方贡献

- 目标文件：`library/<entrance|scroll|hover|feedback|data|transition|ambient>.md`
- 索引行（照 `library/index.md` 的列）：

```
| <id> | <名称> | <区块> | <风格> | <触发> | <端> | <性能> | <文件> |
```

- 来自：<站点或项目 · 日期>，是否已在预览里跑通：是 / 否

### 配方正文

（照 `library/_template.md` 的段落格式粘贴，含 reduced-motion 降级）
