build: ## build the image!
	podman build . -t daylinbox

-include .task.mk
$(if $(filter help,$(MAKECMDGOALS)),$(if $(wildcard .task.mk),,.task.mk: ; curl -fsSL https://raw.githubusercontent.com/daylinmorgan/task.mk/v2024.1001/task.mk -o .task.mk))
