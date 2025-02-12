.DEFAULT_GOAL := help

BASE_BRANCH=main
# ghコマンドで対話式でPRを作るので良いでしょう
# https://github.com/semantic-release/semantic-release のprefix docsを付与しています。空commit用の適切なprefixが無いんだよね・・
pr: ## Create PR. マージ先のブランチを明示的に指定する場合: make pr BASE_BRANCH={to branch name}
	git commit --allow-empty -m "docs: create pr"
	gh pr create --base ${BASE_BRANCH}
.PHONY: pr

generate: ## Generate code
	dart run build_runner build --delete-conflicting-outputs
.PHONY: generate


simulator: ## iOS Simulatorを起動 エラーが出たら https://zenn.dev/blendthink/articles/111dfa86265a34
	open -a Simulator
.PHONY: simulator

# https://postd.cc/auto-documented-makefile/
help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help
