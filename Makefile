# =============================================================================
# Makefile — Docs-as-Code Pipeline (UPC SI657)
# Uso: make pdf | make clean | make watch | make help
# =============================================================================

PDF_OUTPUT = dist/project-report.pdf
CONFIG     = config/build.yaml

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
	@mkdir -p dist
	pandoc --defaults=$(CONFIG)
	@echo "✅ PDF generado: $(PDF_OUTPUT)"

## Elimina archivos generados
clean:
	rm -rf dist/
	@echo "🧹 Carpeta dist/ eliminada"

## Recompila automáticamente al guardar cambios (requiere: entr o watchman)
watch:
	@echo "👀 Observando cambios en report/ ..."
	@find report/ -name "*.md" | entr -c make pdf