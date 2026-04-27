# Contributing to Helium Browser

Thank you for your interest in contributing!

## Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/helium-browser.git`
3. Install dependencies: `flutter pub get`
4. Run code generation: `dart run build_runner build`

## Branch Workflow

- **main**: Production releases only
- **develop**: Integration branch
- **feat/**: Feature branches (merge to develop)

## Conventional Commits

```
feat(scope): new feature
fix(scope): bug fix
perf(scope): performance improvement
refactor(scope): code restructure
test(scope): adding/fixing tests
ci(scope): CI/CD changes
chore(scope): maintenance
docs(scope): documentation
```

## Pull Request Process

1. Create feature branch from `develop`
2. Make your changes
3. Update MEMORY.md with progress
4. Commit and push
5. Open PR to `develop`
6. Wait for review and CI checks

## Code Style

- Use `const` constructors where possible
- Follow Flutter lint rules
- Write tests for new features
- Document public APIs
