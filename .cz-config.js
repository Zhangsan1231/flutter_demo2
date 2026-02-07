module.exports = {
  types: [
    { value: '✨ feat',     name: '✨ feat:     新功能' },
    { value: '🐛 fix',      name: '🐛 fix:      修复Bug' },
    { value: '📝 docs',     name: '📝 docs:     文档变更' },
    { value: '💄 style',    name: '💄 style:    代码格式（不影响功能）' },
    { value: '♻️ refactor', name: '♻️ refactor: 代码重构' },
    { value: '⚡️ perf',     name: '⚡️ perf:     性能优化' },
    { value: '✅ test',     name: '✅ test:     增加测试' },
    { value: '⏪ revert',   name: '⏪ revert:   回退代码' },
    { value: '🔧 chore',    name: '🔧 chore:    构建/工程依赖/工具变动' }
  ],
  messages: {
    type: "请选择提交类型:",
    subject: "请简要描述提交(必填):",
    body: '请输入详细描述(可选):',
    breaking: '列出任何BREAKING CHANGES(可选):',
    footer: '关联关闭的issue(可选):',
    confirmCommit: '确认提交？'
  }
};