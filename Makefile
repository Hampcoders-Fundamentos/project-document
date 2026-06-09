# =============================================================================
# Uso: make pdf | make clean | make watch | make help
# =============================================================================
PDF_OUTPUT = dist/glottia-report.pdf
CONFIG     = config/build.yaml
PYTHON     ?= python

ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    MKDIR_P = powershell -NoProfile -Command "if (!(Test-Path 'dist')) { New-Item -ItemType Directory -Force -Path 'dist' | Out-Null }"
    RM_RF = powershell -NoProfile -Command "if (Test-Path 'dist') { Remove-Item -Recurse -Force 'dist' }; if (Test-Path 'tectonic.exe') { Remove-Item -Force 'tectonic.exe' }"
    TECTONIC_EXE = $(shell powershell -NoProfile -Command "if (Get-Command 'tectonic' -ErrorAction SilentlyContinue) { 'tectonic' } elseif (Test-Path 'tectonic.exe') { 'tectonic.exe' } else { 'tectonic.exe' }")
    # Regla nativa de descarga automatizada para Windows sin dependencias globales
    DOWNLOAD_TECTONIC = powershell -NoProfile -Command "if (!(Get-Command 'tectonic' -ErrorAction SilentlyContinue) -and !(Test-Path 'tectonic.exe')) { Write-Host 'Descargando Tectonic local para Windows...'; Invoke-WebRequest -Uri 'https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-pc-windows-msvc.zip' -OutFile 'tectonic.zip'; Expand-Archive 'tectonic.zip' -DestinationPath '.'; Remove-Item 'tectonic.zip'; Remove-Item -Force 'LICENSE', 'README.md' -ErrorAction SilentlyContinue }"
    SETUP_TECTONIC_CMD = powershell -NoProfile -Command "if (Get-Command 'tectonic' -ErrorAction SilentlyContinue) { Write-Host 'Usando Tectonic disponible en PATH...' } elseif (Test-Path 'tectonic.exe') { Write-Host 'Usando Tectonic local...' } else { Write-Host 'Descargando Tectonic local para Windows...'; Invoke-WebRequest -Uri 'https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-pc-windows-msvc.zip' -OutFile 'tectonic.zip'; Expand-Archive 'tectonic.zip' -DestinationPath '.'; Remove-Item 'tectonic.zip'; Remove-Item -Force 'LICENSE', 'README.md' -ErrorAction SilentlyContinue }"
    WATCH_CMD = powershell -NoProfile -Command "$$watcher = New-Object IO.FileSystemWatcher (Resolve-Path 'report'), '*.md'; $$watcher.IncludeSubdirectories = $$true; $$watcher.EnableRaisingEvents = $$true; $$action = { make pdf }; Register-ObjectEvent $$watcher Changed -Action $$action | Out-Null; Register-ObjectEvent $$watcher Created -Action $$action | Out-Null; Register-ObjectEvent $$watcher Deleted -Action $$action | Out-Null; Register-ObjectEvent $$watcher Renamed -Action $$action | Out-Null; while ($$true) { Wait-Event -Timeout 1 | Out-Null }"
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Darwin)
        DETECTED_OS := macOS
        URL_TECTONIC = https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-apple-darwin.tar.gz
    else
        DETECTED_OS := Linux
        URL_TECTONIC = https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%400.15.0/tectonic-0.15.0-x86_64-unknown-linux-gnu.tar.gz
    endif
    MKDIR_P = mkdir -p
    RM_RF = rm -rf dist tectonic
    TECTONIC_EXE = $(shell command -v tectonic 2>/dev/null || echo ./tectonic)
    DOWNLOAD_TECTONIC = if ! command -v tectonic >/dev/null 2>&1 && [ ! -x ./tectonic ]; then echo "Descargando Tectonic local para $(DETECTED_OS)..."; curl -L $(URL_TECTONIC) | tar -xzf -; fi
    SETUP_TECTONIC_CMD = if command -v tectonic >/dev/null 2>&1; then echo "Usando Tectonic disponible en PATH..."; elif [ -x ./tectonic ]; then echo "Usando Tectonic local..."; else echo "Descargando Tectonic local para $(DETECTED_OS)..."; curl -L $(URL_TECTONIC) | tar -xzf -; fi
    WATCH_CMD = find report/ -name "*.md" | entr -c make pdf
endif

.PHONY: pdf clean watch help setup-tectonic

## Muestra la ayuda de comandos
help:
	@echo ""
	@echo "  Comandos disponibles:"
	@echo "  ---------------------"
	@echo "  make pdf     → Descarga Tectonic local (si falta) y compila el PDF"
	@echo "  make clean   → Elimina la carpeta dist/ y el binario de Tectonic"
	@echo "  make watch   → Recompila al detectar cambios en report/"
	@echo "  make help    → Muestra esta ayuda"
	@echo ""

# Regla para optimizar imágenes antes de la compilación
optimize:
	@echo "Ejecutando optimización automatizada de imágenes..."
	$(PYTHON) config/optimize_images.py

## Descarga el motor Tectonic de forma aislada en la raíz del proyecto
setup-tectonic:
	@$(SETUP_TECTONIC_CMD)

## Compila el informe completo a PDF usando Pandoc y el binario local de Tectonic
pdf: setup-tectonic
	@$(MKDIR_P)
	pandoc --defaults=$(CONFIG) --pdf-engine=$(TECTONIC_EXE)
	@echo "✅ PDF generado exitosamente: $(PDF_OUTPUT)"

## Elimina archivos generados y binarios locales
clean:
	$(RM_RF)
	@echo "🧹 Limpieza completada: dist/ y binarios locales removidos"

## Recompila automáticamente al guardar cambios
watch: setup-tectonic
	@echo "👀 Observando cambios en report/ ... ($(DETECTED_OS))"
	@$(WATCH_CMD)