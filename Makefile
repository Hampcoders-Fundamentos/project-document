# =============================================================================
# Makefile — Docs-as-Code Pipeline (UPC SI657)
# Uso: make pdf | make clean | make watch | make help
# =============================================================================

PDF_OUTPUT = dist/glottia-report.pdf
CONFIG     = config/build.yaml

ifeq ($(OS),Windows_NT)
	DETECTED_OS := Windows
	MKDIR_P = powershell -NoProfile -Command "New-Item -ItemType Directory -Force -Path 'dist' | Out-Null"
	RM_RF = powershell -NoProfile -Command "if (Test-Path 'dist') { Remove-Item -Recurse -Force 'dist' }"
	WATCH_CMD = powershell -NoProfile -Command "$$watcher = New-Object IO.FileSystemWatcher (Resolve-Path 'report'), '*.md'; $$watcher.IncludeSubdirectories = $$true; $$watcher.EnableRaisingEvents = $$true; $$action = { make pdf }; Register-ObjectEvent $$watcher Changed -Action $$action | Out-Null; Register-ObjectEvent $$watcher Created -Action $$action | Out-Null; Register-ObjectEvent $$watcher Deleted -Action $$action | Out-Null; Register-ObjectEvent $$watcher Renamed -Action $$action | Out-Null; while ($$true) { Wait-Event -Timeout 1 | Out-Null }"
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		DETECTED_OS := macOS
	else
		DETECTED_OS := Linux
	endif
	MKDIR_P = mkdir -p
		RM_RF = rm -rf dist
	WATCH_CMD = find report/ -name "*.md" | entr -c make pdf
endif

.PHONY: pdf clean watch help

## Muestra esta ayuda
help:
	@echo ""
	@echo "  Comandos disponibles:"
	@echo "  ---------------------"
	@echo "  make pdf     → Compila el informe completo a PDF"
	@echo "  make clean   → Elimina la carpeta dist/"
	@echo "  make watch   → Recompila al detectar cambios en report/"
	@echo "  make help    → Muestra esta ayuda"
	@echo ""

## Compila el informe completo a PDF usando Pandoc
pdf:
	@$(MKDIR_P)
	pandoc --defaults=$(CONFIG)
	@echo "✅ PDF generado: $(PDF_OUTPUT)"

## Elimina archivos generados
clean:
	$(RM_RF)
	@echo "🧹 Carpeta dist/ eliminada"

## Recompila automáticamente al guardar cambios (requiere: entr, watchman o PowerShell)
watch:
	@echo "👀 Observando cambios en report/ ... ($(DETECTED_OS))"
	@$(WATCH_CMD)